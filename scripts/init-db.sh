#!/bin/bash

# Database initialization script for Controlador COBOM
# This script initializes the database and runs migrations

set -e

echo "================================================"
echo "Controlador COBOM - Database Initialization"
echo "================================================"

# Configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-postgres}"
DB_USER="${DB_USER:-postgres}"

# Password handling with security check
if [ -z "$DB_PASSWORD" ]; then
    echo -e "${RED}✗ ERROR: DB_PASSWORD environment variable is not set!${NC}"
    echo ""
    echo "For security reasons, you must explicitly set the database password."
    echo "Please set DB_PASSWORD environment variable and try again:"
    echo ""
    echo "  export DB_PASSWORD='your-secure-password'"
    echo "  ./scripts/init-db.sh"
    echo ""
    echo "Or generate a secure password:"
    echo "  export DB_PASSWORD=\$(openssl rand -base64 24)"
    echo ""
    exit 1
fi

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Checking database connection...${NC}"

# Wait for database to be ready
MAX_RETRIES=30
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT 1" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Database is ready${NC}"
        break
    fi
    
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo -e "${YELLOW}Waiting for database... (attempt $RETRY_COUNT/$MAX_RETRIES)${NC}"
    sleep 2
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo -e "${RED}✗ Failed to connect to database after $MAX_RETRIES attempts${NC}"
    exit 1
fi

# Run migrations
echo -e "${YELLOW}Running database migrations...${NC}"

MIGRATION_DIR="$(dirname "$0")/../supabase/migrations"

if [ ! -d "$MIGRATION_DIR" ]; then
    echo -e "${RED}✗ Migration directory not found: $MIGRATION_DIR${NC}"
    exit 1
fi

for migration_file in "$MIGRATION_DIR"/*.sql; do
    if [ -f "$migration_file" ]; then
        echo -e "${YELLOW}Applying migration: $(basename "$migration_file")${NC}"
        PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$migration_file"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Migration applied successfully${NC}"
        else
            echo -e "${RED}✗ Migration failed: $(basename "$migration_file")${NC}"
            exit 1
        fi
    fi
done

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}Database initialization completed successfully!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo "You can now access:"
echo "  - Application: http://localhost:8080"
echo "  - PostgREST API: http://localhost:3000"
echo "  - Supabase Studio: http://localhost:54323"
echo "  - PostgreSQL: localhost:5432"
