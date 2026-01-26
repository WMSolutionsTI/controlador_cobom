# ControladorCOBOM Integration Guide

## Overview
This document describes the integration of the ControladorCOBOM module into the AppCOBOM system using Supabase self-hosted as the database backend.

## What Changed

### 1. New Module: Controle de Viaturas
- **Route**: `/apps/controle-viaturas`
- **Bundle Size**: 73.8 kB
- **Components**: 13+ React components for vehicle fleet management
- **Location**: `src/app/apps/controle-viaturas/`

### 2. Supabase Infrastructure
Added Supabase support alongside existing Drizzle ORM:
- `src/lib/supabase/client.ts` - Client-side Supabase configuration
- `src/lib/supabase/server.ts` - Server-side Supabase configuration
- `src/lib/supabase/types.ts` - Database types for Supabase tables

### 3. Authentication Updates
- Modified NextAuth to validate against Supabase database
- Added `users` table to Supabase types
- Maintained backward compatibility with existing auth flow

### 4. UI Components
Added missing Radix UI components:
- `collapsible` - For expandable sections
- `scroll-area` - For custom scrollbars
- `separator` - For visual dividers
- `switch` - For toggle controls
- `textarea` - For multi-line text input
- `toaster` - For toast notifications

### 5. Dependencies Added
```json
{
  "@supabase/ssr": "^0.8.0",
  "@supabase/supabase-js": "^2.91.1",
  "@radix-ui/react-collapsible": "latest",
  "@radix-ui/react-scroll-area": "latest",
  "@radix-ui/react-switch": "latest",
  "date-fns": "latest",
  "drizzle-orm": "^0.36.4" (kept for existing API routes)
}
```

## Configuration Required

### Environment Variables (.env.local)
```bash
# Supabase Self-Hosted Configuration
NEXT_PUBLIC_SUPABASE_URL=https://supabase-cobom.cbi1.org
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# NextAuth (existing)
NEXTAUTH_SECRET=your_nextauth_secret_here
NEXTAUTH_URL=http://localhost:3000

# PostgreSQL (for existing API routes - will be removed in Q2 2026)
DATABASE_URL=postgresql://user:password@host:port/database
```

### Database Schema
The Supabase database should include the following tables:
- `users` - User accounts and authentication
- `grupamentos` - Fire department groups
- `subgrupamentos` - Sub-groups
- `estacoes` - Fire stations
- `modalidades_viatura` - Vehicle types/categories
- `viaturas` - Vehicles/apparatus
- `controladores` - Controllers
- `anotacoes_servico` - Service notes
- `integrantes_equipe` - Team members
- `logs_atividade` - Activity logs
- `observacoes_viatura` - Vehicle observations

## User Permissions

To grant access to the Controle de Viaturas module:

### SQL
```sql
INSERT INTO user_app_permissions (user_id, app_slug)
VALUES (1, 'controle-viaturas');
```

### Using AppCOBOM Admin Interface
1. Navigate to `/admin/usuarios`
2. Edit the desired user
3. Check "Controle de Viaturas COBOM"
4. Save changes

## Architecture Decisions

### Why Keep Drizzle?
While the new controle-viaturas module uses Supabase exclusively, we kept Drizzle ORM temporarily for these reasons:
1. **Existing API Routes**: Many API routes (`/api/solicitacoes/*`, `/api/users/*`, etc.) still use Drizzle
2. **Minimal Risk**: Avoids breaking existing functionality during integration
3. **Phased Migration**: Allows gradual migration of API routes to Supabase
4. **Timeline**: Target Q2 2026 for complete Drizzle removal

### Type Casting in Auth
The authentication code uses `as never` and `as unknown` type assertions due to:
1. Supabase's generated types don't always match runtime data structure
2. NextAuth expects specific type shapes
3. Alternative would require significant refactoring of Supabase types

This is acceptable as a pragmatic solution, but should be improved in future iterations.

## Testing the Integration

### Build
```bash
cd AppCOBOM
npm run build
```

Expected result: Build succeeds with minor ESLint warnings about useEffect dependencies.

### Development
```bash
npm run dev
```

Access the module at: `http://localhost:3000/apps/controle-viaturas`

### Checklist
- [ ] Configure Supabase credentials in `.env.local`
- [ ] Configure PostgreSQL DATABASE_URL in `.env.local`  
- [ ] Verify build completes successfully
- [ ] Test login functionality
- [ ] Grant controle-viaturas permission to test user
- [ ] Verify module appears in workspace
- [ ] Test accessing the controle-viaturas module
- [ ] Verify vehicle data loads from Supabase

## Known Issues and Limitations

### ESLint Warnings
Multiple `react-hooks/exhaustive-deps` warnings exist in the controle-viaturas components. These are intentional to prevent unnecessary re-renders and can be addressed in future optimization work.

### Demo Data
`LinhaViaturaEstacao.tsx` contains hardcoded demo data for team members. This should be replaced with actual database queries when that feature is implemented.

### Type Assertions
The authentication code uses type assertions (`as never`, `as unknown`) to work around Supabase type generation issues. While functional, this should be improved in future refactoring.

## Migration Path

### Phase 1 (Completed)
- ✅ Integrate controle-viaturas module with Supabase
- ✅ Maintain Drizzle for existing API routes
- ✅ Build and deploy successfully

### Phase 2 (Target: Q2 2026)
- [ ] Migrate `/api/solicitacoes/*` routes to Supabase
- [ ] Migrate `/api/users/*` routes to Supabase
- [ ] Migrate other API routes to Supabase
- [ ] Remove Drizzle ORM completely
- [ ] Update documentation

## Support

For questions or issues:
1. Check this README first
2. Review the problem statement in the PR
3. Contact the development team

## References
- [Supabase Documentation](https://supabase.com/docs)
- [NextAuth.js Documentation](https://next-auth.js.org/)
- [Next.js App Router](https://nextjs.org/docs/app)
