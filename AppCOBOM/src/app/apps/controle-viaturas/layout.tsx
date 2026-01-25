import { redirect } from "next/navigation"
import { getServerSession } from "next-auth"
import { authOptions } from "@/lib/auth/options"
import { Header } from "@/components/shared/header"

export default async function ControleViaturasLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const session = await getServerSession(authOptions)

  if (!session) {
    redirect("/login")
  }

  // Verificar permissão
  const allowedApps = session.user.allowedApps || []
  if (!allowedApps.includes("controle-viaturas")) {
    redirect("/workspace")
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <Header />
      <main className="w-full">{children}</main>
    </div>
  )
}
