# Use the official Node.js image as a base image
FROM node:14

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the app on port 3000
EXPOSE 3000

# Command to run the application
CMD ["node", "index.js"]
