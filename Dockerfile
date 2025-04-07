# Use Node.js image as base
FROM node:16

# Set working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files from the host to the container
COPY . .

# Expose the port the app will run on
EXPOSE 3000

# Run the app
CMD ["node", "index.js"]
