# 🐳 Docker Containerization Guide - Controlador COBOM

This guide explains how to run Controlador COBOM using Docker with a self-hosted Supabase stack.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Deployment Options](#deployment-options)
- [Database Migrations](#database-migrations)
- [Troubleshooting](#troubleshooting)
- [Production Deployment](#production-deployment)

## 🔧 Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- 4GB+ RAM available for containers
- Port availability: 8080, 3000, 5432, 8000, 9999, 54323

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/WMSolutionsTI/controlador_cobom.git
cd controlador_cobom

# Copy environment file
cp .env.example .env

# Edit .env and set your passwords and secrets
nano .env
```

### 2. Start the Full Stack

```bash
# Start all services (Next.js + Full Supabase)
docker-compose up -d

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

### 3. Access the Application

- **Application**: http://localhost:8080
- **Supabase Studio**: http://localhost:54323
- **PostgREST API**: http://localhost:3000
- **PostgreSQL**: localhost:5432

## ⚙️ Configuration

### Environment Variables

Edit `.env` file with your configuration:

```bash
# Database Password (change this!)
POSTGRES_PASSWORD=your-super-secret-password

# JWT Secret (generate with: openssl rand -base64 32)
JWT_SECRET=your-super-secret-jwt-token-with-at-least-32-characters

# Application URL
SITE_URL=http://localhost:8080

# Supabase API URL
NEXT_PUBLIC_SUPABASE_URL=http://localhost:8000

# Supabase Anonymous Key (public key)
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

### Generate JWT Keys

For production, generate new JWT keys:

```bash
# Generate JWT secret
openssl rand -base64 32

# Then use https://jwt.io to generate anon and service_role keys
# Payload for anon key:
{
  "iss": "supabase",
  "ref": "local",
  "role": "anon",
  "iat": 1689856000,
  "exp": 1847622400
}

# Payload for service_role key:
{
  "iss": "supabase",
  "ref": "local",
  "role": "service_role",
  "iat": 1689856000,
  "exp": 1847622400
}
```

## 🏗️ Architecture

### Full Stack (docker-compose.yml)

```
┌─────────────────────────────────────────────┐
│                                             │
│  Browser/Client                             │
│                                             │
└──────────────┬──────────────────────────────┘
               │
               │ Port 8080
               ▼
┌─────────────────────────────────────────────┐
│                                             │
│  Next.js Application (app)                  │
│                                             │
└──────────────┬──────────────────────────────┘
               │
               │ API Calls
               ▼
┌─────────────────────────────────────────────┐
│                                             │
│  Kong API Gateway (supabase-kong)           │
│  Port 8000                                  │
│                                             │
└──────┬──────────────┬───────────────────────┘
       │              │
       │              │
       ▼              ▼
┌─────────────┐  ┌──────────────┐
│             │  │              │
│  PostgREST  │  │  GoTrue      │
│  (REST API) │  │  (Auth)      │
│  Port 3000  │  │  Port 9999   │
│             │  │              │
└──────┬──────┘  └──────┬───────┘
       │                │
       │                │
       ▼                ▼
┌─────────────────────────────────┐
│                                 │
│  PostgreSQL Database            │
│  (supabase-db)                  │
│  Port 5432                      │
│                                 │
└─────────────────────────────────┘
```

### Services Included

1. **supabase-db**: PostgreSQL 15 database
2. **supabase-rest**: PostgREST API server
3. **supabase-auth**: GoTrue authentication service
4. **supabase-kong**: Kong API gateway
5. **supabase-meta**: Database management API
6. **supabase-studio**: Web UI for database management
7. **app**: Next.js application

## 🎯 Deployment Options

### Option 1: Full Stack (Recommended for Production)

Complete Supabase stack with all services:

```bash
docker-compose up -d
```

**Includes**: Database, PostgREST, Auth, Kong, Studio, Meta, Application

### Option 2: Simplified Stack (Development)

Minimal setup with just database and API:

```bash
docker-compose -f docker-compose.simple.yml up -d
```

**Includes**: PostgreSQL, PostgREST, Application

### Option 3: Build and Run Separately

```bash
# Build the application image
docker build -t controlador-cobom .

# Start infrastructure only
docker-compose up -d supabase-db supabase-rest supabase-kong

# Run application separately
docker run -p 8080:8080 \
  -e NEXT_PUBLIC_SUPABASE_URL=http://localhost:8000 \
  -e NEXT_PUBLIC_SUPABASE_ANON_KEY=your-key \
  controlador-cobom
```

## 🗄️ Database Migrations

### Automatic Migrations

Migrations run automatically on first database start using files in `supabase/migrations/`:

- `00001_initial_schema.sql`: Creates all tables, indexes, functions
- `00002_seed_data.sql`: Populates initial data

### Manual Migration

To run migrations manually:

```bash
# Using the init script
./scripts/init-db.sh

# Or directly with psql
docker-compose exec supabase-db psql -U postgres -d postgres -f /docker-entrypoint-initdb.d/00001_initial_schema.sql
```

### Database Schema

The database includes these tables:

- **grupamentos**: Fire brigade groupings
- **subgrupamentos**: Sub-groupings
- **estacoes**: Fire stations
- **controladores**: System operators
- **modalidades_viatura**: Vehicle types
- **viaturas**: Vehicles
- **observacoes_viatura**: Vehicle observations
- **anotacoes_servico**: Service annotations
- **logs_atividade**: Activity logs

## 🔍 Troubleshooting

### Port Already in Use

```bash
# Check what's using a port
sudo lsof -i :8080

# Change port in docker-compose.yml
ports:
  - "8081:8080"  # Use 8081 instead
```

### Database Connection Issues

```bash
# Check database health
docker-compose exec supabase-db pg_isready -U postgres

# View database logs
docker-compose logs supabase-db

# Reset database
docker-compose down -v
docker-compose up -d
```

### Application Won't Start

```bash
# Check application logs
docker-compose logs app

# Rebuild application
docker-compose up -d --build app

# Check environment variables
docker-compose exec app env | grep SUPABASE
```

### Clear Everything and Restart

```bash
# Stop and remove all containers, volumes, and networks
docker-compose down -v

# Remove built images
docker-compose down --rmi all

# Start fresh
docker-compose up -d --build
```

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f app
docker-compose logs -f supabase-db

# Last 100 lines
docker-compose logs --tail=100 app
```

## 🏭 Production Deployment

### Security Checklist

- [ ] Change `POSTGRES_PASSWORD` to a strong password
- [ ] Generate new `JWT_SECRET` (32+ characters)
- [ ] Generate new JWT tokens for anon and service_role
- [ ] Update `SITE_URL` to your production domain
- [ ] Use HTTPS for `NEXT_PUBLIC_SUPABASE_URL`
- [ ] Set appropriate CORS policies in Kong
- [ ] Enable GoTrue email verification (`GOTRUE_MAILER_AUTOCONFIRM=false`)
- [ ] Use proper email provider for GoTrue
- [ ] Set up database backups
- [ ] Configure SSL/TLS for PostgreSQL

### Production docker-compose.yml Adjustments

```yaml
services:
  supabase-db:
    volumes:
      - /var/lib/postgresql/data:/var/lib/postgresql/data  # Use host path
    restart: always  # Always restart on failure
    
  app:
    environment:
      NEXT_PUBLIC_SUPABASE_URL: https://api.yourdomain.com
      SITE_URL: https://yourdomain.com
    restart: always
```

### Backup Database

```bash
# Create backup
docker-compose exec supabase-db pg_dump -U postgres postgres > backup.sql

# Restore backup
docker-compose exec -T supabase-db psql -U postgres postgres < backup.sql
```

### Update Application

```bash
# Pull latest code
git pull origin main

# Rebuild and restart
docker-compose up -d --build app

# Check status
docker-compose ps
```

## 📊 Monitoring

### Health Checks

```bash
# Check all services
docker-compose ps

# Check specific service health
docker-compose exec supabase-db pg_isready -U postgres

# API health check
curl http://localhost:3000/
```

### Resource Usage

```bash
# View container stats
docker stats

# View specific container
docker stats controlador-cobom-app
```

## 🛠️ Development

### Run Locally Without Docker

```bash
# Install dependencies
npm install --legacy-peer-deps

# Set up local Supabase
docker-compose up -d supabase-db supabase-rest supabase-kong

# Run development server
npm run dev
```

### Hot Reload in Docker

For development with hot reload, use a volume mount:

```yaml
services:
  app:
    volumes:
      - ./src:/app/src
      - ./app:/app/app
    command: npm run dev
```

## 📚 Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [PostgREST Documentation](https://postgrest.org/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🆘 Support

If you encounter issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. View logs: `docker-compose logs`
3. Open an issue on GitHub
4. Check existing issues for solutions

## 📝 License

This project follows the license specified in the main repository.
