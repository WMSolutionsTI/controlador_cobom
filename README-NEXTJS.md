# CBI-1 CONTROLADOR COBOM - Next.js

Este projeto foi migrado do Vite + React para Next.js, com suporte para Supabase self-hosted.

## 🚀 Tecnologias Utilizadas

- **Next.js 14+** - Framework React com App Router
- **TypeScript** - Tipagem estática
- **Tailwind CSS** - Framework CSS utilitário
- **shadcn/ui** - Componentes UI
- **Supabase** - Backend (suporta cloud e self-hosted)
- **React Query** - Gerenciamento de estado assíncrono

## 📋 Pré-requisitos

- Node.js 18+ e npm
- Supabase Cloud ou Self-Hosted

## 🔧 Instalação

1. Clone o repositório:
```bash
git clone <SUA_URL_DO_GIT>
cd controlador_cobom
```

2. Instale as dependências:
```bash
npm install
```

3. Configure as variáveis de ambiente (veja seção abaixo)

4. Inicie o servidor de desenvolvimento:
```bash
npm run dev
```

O aplicativo estará disponível em `http://localhost:8080`

## ⚙️ Configuração do Supabase

### Opção 1: Usar Supabase Cloud (padrão)

As configurações padrão no arquivo `.env` já apontam para uma instância Supabase Cloud. Nenhuma alteração é necessária.

### Opção 2: Usar Supabase Self-Hosted

Para usar sua própria instância Supabase self-hosted:

1. Copie o arquivo `.env.example` para `.env`:
```bash
cp .env.example .env
```

2. Edite o arquivo `.env` e atualize as seguintes variáveis:

```env
# Substitua com a URL da sua instância self-hosted
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321

# Substitua com a chave anon da sua instância
NEXT_PUBLIC_SUPABASE_ANON_KEY=sua-chave-anon-aqui
```

3. Reinicie o servidor de desenvolvimento:
```bash
npm run dev
```

### Como obter as credenciais do Supabase Self-Hosted

1. **URL**: Geralmente é `http://localhost:54321` para desenvolvimento local
2. **Anon Key**: Você pode encontrar no arquivo `.env` da sua instância Supabase, ou executar:
```bash
# Na pasta da sua instância Supabase
supabase status
```

## 📦 Scripts Disponíveis

- `npm run dev` - Inicia o servidor de desenvolvimento na porta 8080
- `npm run build` - Cria a build de produção
- `npm run start` - Inicia o servidor de produção
- `npm run lint` - Executa o linter

## 🏗️ Estrutura do Projeto

```
controlador_cobom/
├── app/                      # Next.js App Router
│   ├── layout.tsx           # Layout principal
│   ├── page.tsx             # Página inicial
│   ├── providers.tsx        # Providers React Query, etc.
│   └── not-found.tsx        # Página 404
├── src/
│   ├── components/          # Componentes React
│   │   ├── ui/             # Componentes shadcn/ui
│   │   └── ...             # Outros componentes
│   ├── integrations/
│   │   └── supabase/       # Cliente Supabase
│   ├── pages/              # Páginas antigas (Index, NotFound)
│   ├── hooks/              # React hooks customizados
│   └── lib/                # Utilitários
├── public/                 # Arquivos estáticos
├── .env                    # Variáveis de ambiente
├── .env.example           # Exemplo de variáveis de ambiente
├── next.config.js         # Configuração Next.js
├── tailwind.config.ts     # Configuração Tailwind
└── tsconfig.json          # Configuração TypeScript
```

## 🔄 Migração de Vite para Next.js

### Principais Mudanças

1. **Roteamento**: Migrado de React Router DOM para Next.js App Router
2. **Variáveis de Ambiente**: 
   - Antes: `VITE_*`
   - Agora: `NEXT_PUBLIC_*`
3. **Client Components**: Componentes que usam hooks do React precisam da diretiva `'use client'`
4. **Build**: Comandos atualizados de `vite build` para `next build`

### Componentes Principais

Todos os componentes foram mantidos com mínimas alterações:
- `PainelFrota` - Painel principal de viaturas
- `AnotacoesServicoDaily` - Anotações do serviço diário
- `VehicleTable` - Tabela de viaturas
- `FormularioAdicionarViatura` - Formulário de adição de viaturas
- E outros componentes UI do shadcn/ui

## 🔒 Segurança

- Nunca commite o arquivo `.env` com credenciais reais
- Use variáveis de ambiente para todas as configurações sensíveis
- Para produção, configure as variáveis de ambiente no seu provedor de hosting

## 📝 Notas de Migração

- O projeto agora usa Next.js 14+ com App Router
- Suporte completo para Supabase self-hosted via variáveis de ambiente
- Todos os componentes e funcionalidades foram preservados
- TypeScript configurado com as melhores práticas Next.js

## 🐛 Solução de Problemas

### Erro: "Module not found"
Certifique-se de que todas as dependências foram instaladas:
```bash
npm install
```

### Erro de conexão com Supabase
Verifique se as variáveis `NEXT_PUBLIC_SUPABASE_URL` e `NEXT_PUBLIC_SUPABASE_ANON_KEY` estão configuradas corretamente no arquivo `.env`.

### Página em branco
1. Verifique o console do navegador para erros
2. Verifique os logs do terminal
3. Certifique-se de que o servidor está rodando na porta 8080

## 📚 Recursos Adicionais

- [Documentação Next.js](https://nextjs.org/docs)
- [Documentação Supabase](https://supabase.com/docs)
- [Documentação Self-Hosted Supabase](https://supabase.com/docs/guides/self-hosting)
- [shadcn/ui](https://ui.shadcn.com)

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto é de uso interno do CBI-1 COBOM.
