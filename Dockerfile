FROM node:24

# Set working directory
WORKDIR /app

# Install pnpm
RUN npm install pnpm --global

# Copy package files
COPY pnpm-workspace.yaml ./
COPY package.json pnpm-lock.yaml ./
COPY packages/ ./packages/
COPY examples/ ./examples/
RUN mkdir -p website/public
COPY website/package.json ./website/

# Install
RUN pnpm install

# Copy everything
COPY . .

# Expose the port Strudel runs on
EXPOSE 4321

# Start the application
CMD ["pnpm", "dev"]