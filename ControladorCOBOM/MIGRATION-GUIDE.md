# Guia de Migração: Vite + React → Next.js

Este documento descreve as mudanças realizadas na conversão do projeto de Vite + React para Next.js.

## 📋 Resumo das Mudanças

O projeto foi **completamente migrado** de Vite + React para **Next.js 14+** mantendo toda a funcionalidade existente e adicionando suporte para **Supabase self-hosted**.

## 🎯 Objetivos Alcançados

✅ Conversão completa para Next.js com App Router  
✅ Suporte para Supabase self-hosted via variáveis de ambiente  
✅ Preservação de todos os componentes e funcionalidades  
✅ Build de produção funcionando  
✅ Servidor de desenvolvimento operacional  
✅ TypeScript configurado corretamente  

## 🔄 Mudanças Técnicas Principais

### 1. Framework e Build System

**ANTES (Vite):**
- Build tool: Vite
- Entry point: `src/main.tsx` + `index.html`
- Roteamento: React Router DOM (client-side)
- Variáveis de ambiente: `VITE_*`

**AGORA (Next.js):**
- Build tool: Next.js (Turbopack)
- Entry point: `app/layout.tsx` + `app/page.tsx`
- Roteamento: Next.js App Router (file-based)
- Variáveis de ambiente: `NEXT_PUBLIC_*`

### 2. Estrutura de Pastas

```
ANTES:
├── index.html
├── src/
│   ├── main.tsx         # Entry point
│   ├── App.tsx          # Router config
│   └── pages/           # Route components
│       ├── Index.tsx
│       └── NotFound.tsx

AGORA:
├── app/                 # Next.js App Router
│   ├── layout.tsx       # Root layout
│   ├── page.tsx         # Home page
│   ├── not-found.tsx    # 404 page
│   └── providers.tsx    # Client providers
├── src/
│   ├── legacy-pages/    # Components originais (ainda usados)
│   │   ├── Index.tsx
│   │   └── NotFound.tsx
│   └── _legacy/         # Arquivos Vite antigos (não usados)
└── _vite_legacy/        # Configs Vite antigas (backup)
```

### 3. Configuração do Supabase

**Novo arquivo:** `src/integrations/supabase/client.ts`

```typescript
// ANTES: URLs hardcoded
const SUPABASE_URL = "https://sbuzgixzapwenlvnsuyw.supabase.co";
const SUPABASE_PUBLISHABLE_KEY = "ey...";

// AGORA: Suporte a self-hosted
const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || "fallback-url";
const SUPABASE_PUBLISHABLE_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "fallback-key";
```

### 4. Scripts NPM

```json
// ANTES:
{
  "dev": "vite",
  "build": "vite build",
  "preview": "vite preview"
}

// AGORA:
{
  "dev": "next dev -p 8080",
  "build": "next build",
  "start": "next start -p 8080"
}
```

## 🔧 Como Usar Supabase Self-Hosted

### Opção 1: Cloud (Padrão)

Nenhuma alteração necessária. As configurações padrão no `.env` já apontam para a instância cloud existente.

### Opção 2: Self-Hosted

1. **Copie o arquivo de exemplo:**
   ```bash
   cp .env.example .env
   ```

2. **Edite `.env` com suas credenciais self-hosted:**
   ```env
   NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
   NEXT_PUBLIC_SUPABASE_ANON_KEY=sua-chave-anon-aqui
   ```

3. **Inicie sua instância Supabase local:**
   ```bash
   # No diretório do Supabase
   supabase start
   ```

4. **Obtenha as credenciais:**
   ```bash
   supabase status
   ```
   
   Exemplo de saída:
   ```
   API URL: http://localhost:54321
   anon key: eyJhbGci...
   ```

5. **Reinicie o servidor de desenvolvimento:**
   ```bash
   npm run dev
   ```

## 📦 Dependências Adicionadas

- `next` - Framework Next.js
- `eslint-config-next` - ESLint config para Next.js

## 🗑️ Dependências Removidas

Nenhuma dependência foi removida. Todas as bibliotecas do projeto original foram mantidas:
- `@supabase/supabase-js` ✅
- `@tanstack/react-query` ✅
- `shadcn/ui components` ✅
- `tailwindcss` ✅
- etc.

## 🚀 Comandos Disponíveis

### Desenvolvimento
```bash
npm run dev
# Servidor: http://localhost:8080
```

### Build de Produção
```bash
npm run build
```

### Servidor de Produção
```bash
npm run start
```

### Linting
```bash
npm run lint
```

## ⚠️ Considerações Importantes

### 1. Componentes Client-Side

Todos os componentes que usam hooks React precisam da diretiva `'use client'`:

```tsx
'use client'

import { useState } from 'react'

export default function MeuComponente() {
  const [estado, setEstado] = useState(false)
  // ...
}
```

### 2. Variáveis de Ambiente

**Importante:** Todas as variáveis de ambiente acessíveis no browser devem começar com `NEXT_PUBLIC_`:

```env
# ❌ Não funciona no browser
SUPABASE_URL=http://localhost:54321

# ✅ Funciona no browser
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
```

### 3. Imports de Arquivos

Next.js não requer extensões `.tsx` nos imports:

```typescript
// ❌ Vite (pode usar extensão)
import App from './App.tsx'

// ✅ Next.js (sem extensão)
import App from './App'
```

### 4. Arquivos Públicos

Arquivos estáticos continuam na pasta `public/` e são servidos na raiz:

```tsx
// Imagem em public/logo.png
<img src="/logo.png" alt="Logo" />
```

## 🔍 Solução de Problemas

### Erro: "Module not found"
**Solução:** Execute `npm install` para garantir que todas as dependências estão instaladas.

### Erro: "Failed to fetch from Google Fonts"
**Solução:** Já resolvido. O layout não usa Google Fonts via `next/font`.

### Página em branco após build
**Solução:** 
1. Verifique o console do browser (F12)
2. Verifique as variáveis de ambiente no `.env`
3. Confirme que o Supabase está acessível

### Erro de TypeScript
**Solução:** O projeto está configurado com `strict: false` para manter compatibilidade. Se necessário, ajuste no `tsconfig.json`.

## 📚 Recursos e Documentação

- **Next.js Docs:** https://nextjs.org/docs
- **Next.js App Router:** https://nextjs.org/docs/app
- **Supabase Self-Hosted:** https://supabase.com/docs/guides/self-hosting
- **Migração para Next.js:** https://nextjs.org/docs/app/building-your-application/upgrading/app-router-migration

## 🎓 Próximos Passos

1. **Testar todas as funcionalidades** em desenvolvimento
2. **Executar testes** (se houver)
3. **Configurar CI/CD** para Next.js
4. **Atualizar deploy** (Vercel, AWS, etc.)
5. **Monitorar performance** após deploy

## 📝 Notas Adicionais

- Os arquivos Vite originais foram preservados em `_vite_legacy/` para referência
- Os componentes originais foram mantidos em `src/legacy-pages/` e ainda são utilizados
- O projeto mantém compatibilidade com as variáveis `VITE_*` no `.env` para transição suave
- Nenhuma funcionalidade foi removida ou alterada, apenas a estrutura do framework

## ✅ Checklist de Migração Completa

- [x] Next.js instalado e configurado
- [x] Build de produção funcionando
- [x] Servidor de desenvolvimento funcionando
- [x] Supabase client atualizado para self-hosted
- [x] Variáveis de ambiente migradas
- [x] Componentes preservados
- [x] Rotas migradas
- [x] TypeScript configurado
- [x] ESLint configurado
- [x] Documentação criada

---

**Migração concluída com sucesso! 🎉**

O projeto agora usa Next.js com suporte completo para Supabase self-hosted.
