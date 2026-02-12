#---------- Stage 1: Build Frontend ----------
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy full project
COPY . .

# Build Vite project
RUN npm run build


# ---------- Stage 2: Production ----------
FROM node:18-alpine

WORKDIR /app

# Copy backend server folder
COPY server ./server

# Copy package files again
COPY package*.json ./

# Install only production dependencies
RUN npm install --omit=dev

# Copy built frontend from stage 1
COPY --from=build /app/dist ./dist

# Expose backend port
EXPOSE 5000

# Start backend server
CMD ["node", "server/index.js"]

