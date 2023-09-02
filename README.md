# Dockerize a Laravel Application

Dockerizing a Node.js application along with MongoDB using Docker Compose is a common practice for creating portable and easily deployable development environments. When you’re finished, you’ll have a demo Nodejs application running on two separate service containers:

An app service running Nodejs;
A db service running Mongodb;

# Prerequisites
1.Jenkins installed and configured.
2.Docker installed on the Jenkins agent.
3.Node.js application source code with a Dockerfile.
4.A MongoDB service to be run in a Docker container.
5.Jenkins pipeline with Docker and Docker Compose plugins installed.

# Step 1 — Obtaining the Demo Application
To get started, we’ll fetch the demo Nodejs application from its Github repository. We’re interested in the tutorial-01 branch, which contains the basic Nodejs application we’ve created in the first guide of this series.

To obtain the application code that is compatible with this tutorial, download release tutorial-1.0.1 to your home directory with:

```
cd ~
curl -L https://github.com/ajithredrigo2/demo/archive/test.zip -o demo.zip
```
We’ll need the unzip command to unpack the application code. In case you haven’t installed this package before, do so now with:

```
sudo apt update
sudo apt install unzip
```

Now, unzip the contents of the application and rename the unpacked directory for easier access:
```
unzip demo.zip
sudo mv demo-test demo
```
Navigate to the laravel directory:
```
cd demo
```
In the next step, we’ll create a Dockerfile to set up the application.


# Step 3 — Setting Up the Application’s Dockerfile
Although Mongodb services will be based on default images obtained from the Docker Hub, we still need to build a custom image for the application container. We’ll create a new Dockerfile for that.

In your Node.js application's directory, create a Dockerfile to define how your application should be built and run within a Docker container. Here's a simple example Dockerfile:

Create a new Dockerfile with:
```
nano Dockerfile
```
Copy the following contents to your Dockerfile:

### Dockerfile
```
# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app

# Copy your application files to the container
COPY . .

# Expose the port your Node.js application listens on
EXPOSE 4000

# Command to start your Node.js application
#CMD ["node", "index.js"]
CMD ["npm", "start"]
```


# Step 5 — Creating a Multi-Container Environment with Docker Compose
Docker Compose enables you to create multi-container environments for applications running on Docker. It uses service definitions to build fully customizable environments with multiple containers that can share networks and data volumes. This allows for a seamless integration between application components.

To set up our service definitions, we’ll create a new file called docker-compose.yml. Typically, this file is located at the root of the application folder, and it defines your containerized environment, including the base images you will use to build your containers, and how your services will interact.

We’ll define two services in our docker-compose.yml file: api, mongo_db.

The application files will be synchronized on both the app via bind mounts. Bind mounts are useful in development environments because they allow for a performant two-way sync between host machine and containers.

Create a new docker-compose.yml file at the root of the application folder:
```
nano docker-compose.yml
```
A typical docker-compose.yml file starts with a version definition, followed by a services node, under which all services are defined. Shared networks are usually defined at the bottom of that file.

To get started, copy this boilerplate code into your docker-compose.yml file:

### docker-compose.yml
```
version: "3.7"
services:


networks:
  laravel:
    driver: bridge
```
We’ll now edit the services node to include the app, db and apache services.

The app Service
The app service builds a new Docker image based on a Dockerfile located in the same path as the docker-compose.yml file. The new image will be saved locally under the name demo_api_1.

Copy the following service definition under your services node, inside the docker-compose.yml file:

### docker-compose.yml
```
services:
  # Mongodb service
  mongo_db:
    container_name: db_container
    image: mongo:latest
    restart: always
    volumes:
      - mongo_data:/data/db
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin # MongoDB admin username
      - MONGO_INITDB_ROOT_PASSWORD=87654321 # MongoDB admin password

  # Node api service
  api:
    build: .
    ports:
      # local->container
      - 4000:3000
    environment:
      PORT: 3000
      MONGODB_URI: mongodb://mongo_db:27017/demo
      DB_NAME: demo
    depends_on:
      - mongo_db

volumes:
  mongo_data: {}
```
Make sure you save the file when you’re done.


# Conclusion
In this guide, we’ve set up a Docker environment with three containers using Docker Compose to define our infrastructure in a YAML file.

From this point on, you can work on your Laravel application without needing to install and set up a local web server for development and testing. Moreover, you’ll be working with a disposable environment that can be easily replicated and distributed, which can be helpful while developing your application and also when moving towards a production environment.
