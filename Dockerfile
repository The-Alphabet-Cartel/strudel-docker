FROM node:24-slim AS base

# Install pnpm
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy package files
COPY strudel/package.json strudel/pnpm-lock.yaml* strudel/pnpm-workspace.yaml* ./

# Install dependencies
FROM base AS deps
RUN pnpm install --frozen-lockfile

# Build stage
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY strudel/ ./

# Build the application (if needed for production)
# RUN pnpm build

# Production stage
FROM node:24-slim AS runner
WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Copy necessary files
COPY --from=builder /app ./

# Expose the port Strudel runs on
EXPOSE 4321

# Set environment variables
ENV NODE_ENV=production
ENV HOST=0.0.0.0

# Start the application
CMD ["pnpm", "dev", "--host", "0.0.0.0"]
