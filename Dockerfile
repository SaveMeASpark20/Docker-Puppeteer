# Use Puppeteer's official image
FROM ghcr.io/puppeteer/puppeteer:latest

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first (for better caching)
COPY package.json package-lock.json ./

# Fix permissions for the /app directory
RUN chown -R pptruser:pptruser /app

# Switch to the Puppeteer user (pre-configured in this image)
USER pptruser

# Install dependencies (only production ones)
RUN npm install --omit=dev

# Copy the rest of the app files
COPY . .

# Expose the necessary port
EXPOSE 3000

# Start the application
CMD ["node", "index.js"]
