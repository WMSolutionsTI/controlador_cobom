import { NextAuthOptions } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import bcrypt from "bcryptjs";
import { createAdminSupabaseClient } from "@/lib/supabase/server";
import { generateToken } from "@/lib/utils";

export const authOptions: NextAuthOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        username: { label: "Nome de usuário", type: "text" },
        password: { label: "Senha", type: "password" },
      },
      async authorize(credentials) {
        if (!credentials?.username || !credentials?.password) {
          return null;
        }

        try {
          const supabase = createAdminSupabaseClient();

          // Fetch user from Supabase
          const { data: user, error } = await supabase
            .from('users')
            .select('*')
            .eq('username', credentials.username)
            .single();

          if (error || !user || !user.active) {
            return null;
          }

          // Compare password using bcrypt
          const isValidPassword = await bcrypt.compare(credentials.password, user.password);
          if (!isValidPassword) {
            return null;
          }

          // Generate a new session token and store it in the database
          // This invalidates any previous sessions for this user
          const newSessionToken = generateToken(32);
          
          // Update session token
          await supabase
            .from('users')
            .update({
              session_token: newSessionToken,
              updated_at: new Date().toISOString(),
            })
            .eq('id', user.id);

          return {
            id: String(user.id),
            name: user.name,
            role: user.role,
            pa: user.pa || "",
            allowedApps: (user.allowed_apps as string[]) || [],
            sessionToken: newSessionToken,
          };
        } catch (error) {
          console.error("Auth error:", error);
          return null;
        }
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.role = user.role;
        token.pa = user.pa;
        token.allowedApps = user.allowedApps || [];
        token.sessionToken = user.sessionToken;
      }
      return token;
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as string;
        session.user.role = token.role as string;
        session.user.pa = token.pa as string;
        session.user.allowedApps = (token.allowedApps as string[]) || [];
        
        // Validate session token is still valid (single session enforcement)
        try {
          const supabase = createAdminSupabaseClient();
          
          const { data: dbUser, error } = await supabase
            .from('users')
            .select('*')
            .eq('id', parseInt(token.id as string, 10))
            .single();
          
          if (error || !dbUser || dbUser.session_token !== token.sessionToken) {
            // Session is no longer valid (user logged in elsewhere)
            throw new Error("Session expired");
          }
        } catch (error) {
          // Session validation failed - log and invalidate session
          console.error("Session validation error:", error);
          return { ...session, user: undefined, expires: new Date(0).toISOString() };
        }
      }
      return session;
    },
  },
  pages: {
    signIn: "/login",
    error: "/login",
  },
  session: {
    strategy: "jwt",
    maxAge: 8 * 60 * 60, // 8 hours
  },
  secret: process.env.NEXTAUTH_SECRET,
};