# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose the port your Node.js application listens on (e.g., 3000)
EXPOSE 8000

# Command to start your Node.js application
CMD ["npm", "start"]
