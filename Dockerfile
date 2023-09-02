# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy your application files to the container
COPY . .

# Expose the port your Node.js application listens on
EXPOSE 4000

# Command to start your Node.js application
CMD ["node", "index.js"]
