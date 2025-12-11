FROM node:20-slim AS base

# Install pnpm
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy package files from the entire monorepo
COPY strudel/package.json strudel/pnpm-lock.yaml strudel/pnpm-workspace.yaml ./
COPY strudel/packages ./packages
COPY strudel/website ./website

# Install ALL dependencies for the entire workspace
FROM base AS deps
RUN pnpm install --frozen-lockfile

# Production stage
FROM node:20-slim AS runner
WORKDIR /app

# Install pnpm in final image
RUN npm install -g pnpm

# Copy everything from builder including node_modules
COPY --from=deps /app ./

# Expose the port Strudel runs on
EXPOSE 4321

# Set environment variables
ENV NODE_ENV=development
ENV HOST=0.0.0.0

# Start the application
CMD ["pnpm", "dev", "--host", "0.0.0.0"]