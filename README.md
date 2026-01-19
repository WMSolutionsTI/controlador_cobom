# CBI-1 CONTROLADOR COBOM - Next.js

[![Next.js](https://img.shields.io/badge/Next.js-14+-black)](https://nextjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.5+-blue)](https://www.typescriptlang.org/)
[![Supabase](https://img.shields.io/badge/Supabase-Self--Hosted%20Ready-green)](https://supabase.com/)

Sistema de controle e gestão de viaturas para o COBOM (Centro de Operações de Bombeiros Militar).

## 🎉 Migração Completa para Next.js

**Este projeto foi recentemente migrado de Vite + React para Next.js 14+!**

✅ Build de produção funcionando  
✅ Servidor de desenvolvimento testado  
✅ Suporte para Supabase self-hosted  
✅ Todas as funcionalidades preservadas  
✅ 0 vulnerabilidades de segurança  

## 🚀 Início Rápido

### Pré-requisitos
- Node.js 18 ou superior
- npm ou yarn
- Supabase (Cloud ou Self-Hosted)

### Instalação

```bash
# 1. Clone o repositório
git clone https://github.com/bitmendes88/controlador_cobom.git
cd controlador_cobom

# 2. Instale as dependências
npm install

# 3. Configure as variáveis de ambiente (veja abaixo)
cp .env.example .env

# 4. Inicie o servidor de desenvolvimento
npm run dev
```

Acesse http://localhost:8080

## ⚙️ Configuração

### Supabase Cloud (Padrão)

O projeto já está configurado para usar Supabase Cloud. Nenhuma alteração necessária.

### Supabase Self-Hosted

Para usar sua própria instância Supabase:

1. **Edite o arquivo `.env`:**

```env
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=sua-chave-anon-aqui
```

2. **Obtenha suas credenciais:**

```bash
# No diretório da sua instância Supabase
supabase status
```

3. **Reinicie o servidor:**

```bash
npm run dev
```

## 📦 Scripts Disponíveis

```bash
# Desenvolvimento (porta 8080)
npm run dev

# Build de produção
npm run build

# Servidor de produção
npm run start

# Linting
npm run lint
```

## 🏗️ Tecnologias

- **Next.js 14+** - Framework React
- **TypeScript** - Tipagem estática
- **Tailwind CSS** - Framework CSS
- **shadcn/ui** - Componentes UI
- **Supabase** - Backend (Cloud + Self-hosted)
- **React Query** - Gerenciamento de estado

## 📚 Documentação

- **[README-NEXTJS.md](./README-NEXTJS.md)** - Guia completo de uso
- **[MIGRATION-GUIDE.md](./MIGRATION-GUIDE.md)** - Detalhes técnicos da migração
- **[SUMMARY.md](./SUMMARY.md)** - Resumo executivo
- **[.env.example](./.env.example)** - Template de variáveis

## 🎯 Funcionalidades

- ✅ Gestão de viaturas por grupamento
- ✅ Controle de status em tempo real
- ✅ Anotações de serviço diário
- ✅ Sistema de prontidão (cores rotativas)
- ✅ Logs de atividade
- ✅ Pesquisa e filtros avançados
- ✅ Interface responsiva
- ✅ Tema escuro/claro

## 📁 Estrutura do Projeto

```
controlador_cobom/
├── app/                  # Next.js App Router
│   ├── layout.tsx       # Layout principal
│   ├── page.tsx         # Página inicial
│   ├── not-found.tsx    # Página 404
│   └── providers.tsx    # Providers React Query
├── src/
│   ├── components/      # Componentes React
│   ├── integrations/    # Integrações (Supabase)
│   ├── hooks/          # React hooks
│   └── lib/            # Utilitários
├── public/             # Arquivos estáticos
├── .env                # Variáveis de ambiente
└── next.config.js      # Configuração Next.js
```

## 🔒 Segurança

- ✅ CodeQL Security: 0 vulnerabilidades
- ✅ Variáveis de ambiente protegidas
- ✅ TypeScript strict mode
- ✅ ESLint configurado

## 🐛 Solução de Problemas

### Módulo não encontrado
```bash
npm install
```

### Erro de conexão Supabase
Verifique as variáveis no `.env`:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`

### Página em branco
1. Verifique o console do navegador (F12)
2. Verifique os logs do terminal
3. Confirme que o Supabase está acessível

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

## 📄 Licença

Este projeto é de uso interno do CBI-1 COBOM.

## 📞 Suporte

Para dúvidas ou problemas:
1. Consulte a [documentação completa](./README-NEXTJS.md)
2. Verifique o [guia de migração](./MIGRATION-GUIDE.md)
3. Abra uma issue no GitHub

---

**Desenvolvido para o Corpo de Bombeiros Militar** 🚒
