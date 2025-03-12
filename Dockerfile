# Use Puppeteer's official image
FROM ghcr.io/puppeteer/puppeteer:latest

# Switch to root to install packages
USER root

# Install dependencies and Google Chrome
RUN apt-get update && apt-get install -y google-chrome-stable

# Switch back to Puppeteer user
USER pptruser

# Set the working directory
WORKDIR /app

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
