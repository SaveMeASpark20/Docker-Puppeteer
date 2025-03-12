

# Use an official Node.js image with a Chromium-compatible environment
FROM ghcr.io/puppeteer/puppeteer:latest

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if available) to install dependencies
COPY package*.json ./

# Install only production dependencies
RUN npm install --omit=dev

# Copy the rest of the application files
COPY . .

# Expose the port (Render will auto-detect it if using Express)
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
