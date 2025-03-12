# Use Puppeteer's official image
FROM ghcr.io/puppeteer/puppeteer:latest

# Install dependencies and Google Chrome
RUN apt-get update && apt-get install -y google-chrome-stable

# Set the working directory
WORKDIR /app

# Switch to Puppeteer user
USER pptruser

# Copy package.json and package-lock.json first
COPY --chown=pptruser:pptruser package.json package-lock.json ./

# Install dependencies (only production)
RUN npm install --omit=dev

# Copy the rest of the app files
COPY --chown=pptruser:pptruser . .

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "index.js"]
