FROM node:24

# Set working directory
WORKDIR /app

# Install pnpm
RUN npm install pnpm --global

# Create needed directories
RUN mkdir -p website/public

# Copy package files
COPY ./strudel ./
#COPY ./strudel/package.json ./strudel/pnpm-lock.yaml ./
#COPY ./strudel/packages/ ./packages/
#COPY ./strudel/examples/ ./examples/
#COPY ./strudel/website/package.json ./website/

# Install
RUN pnpm install

COPY . .

# Expose the port Strudel runs on
EXPOSE 4321

# Start the application
CMD ["pnpm", "dev"]