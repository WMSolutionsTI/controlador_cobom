# Multi-stage build for Next.js application optimization

# Stage 1: Install dependencies
FROM node:20-alpine AS deps
WORKDIR /app

# Copy package files
COPY package*.json ./

# Note: Dependencies installation handled locally before Docker build
# This approach avoids npm networking issues in Docker build environment

# Stage 2: Build the application
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package files and node_modules from host
COPY package*.json ./
COPY node_modules ./node_modules

# Copy source files
COPY . .

# Build Next.js application
# The output: 'standalone' option in next.config.js creates an optimized production build
RUN npm run build

# Stage 3: Production runner
FROM node:20-alpine AS runner
WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Create non-root user for security
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# Copy built application from builder
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

# Switch to non-root user
USER nextjs

# Expose port
EXPOSE 8080

# Set port environment variable
ENV PORT=8080
ENV HOSTNAME="0.0.0.0"

# Start the application
CMD ["node", "server.js"]
