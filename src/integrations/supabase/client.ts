// Supabase client configuration
// Supports both cloud and self-hosted instances
import { createClient } from '@supabase/supabase-js';
import type { Database } from './types';

// Environment variables for Supabase configuration
// For self-hosted: Set NEXT_PUBLIC_SUPABASE_URL to your self-hosted instance URL
// For self-hosted: Set NEXT_PUBLIC_SUPABASE_ANON_KEY to your self-hosted anon key
const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || "https://sbuzgixzapwenlvnsuyw.supabase.co";
const SUPABASE_PUBLISHABLE_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNidXpnaXh6YXB3ZW5sdm5zdXl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1NTUxNjAsImV4cCI6MjA2NDEzMTE2MH0.HKu9IeH8bLPQ37BlldYICVQybCnw6_ENEAkkvcDt54w";

// Import the supabase client like this:
// import { supabase } from "@/integrations/supabase/client";

export const supabase = createClient<Database>(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);