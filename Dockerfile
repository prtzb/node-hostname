# Use an official Node.js runtime as a parent image
FROM node:23-slim

# Set environment variables
ENV NODE_ENV=production

# Create app directory and set it as working directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm ci --only=production

# Bundle app source code
COPY . .

# Expose application port
EXPOSE 3000

RUN groupadd -r node-hostname && useradd -r -g node-hostname node-hostname
USER node-hostname

# Run the application
CMD ["npm", "start"]
