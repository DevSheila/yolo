# Use an official Node.js runtime as a parent image
FROM node:14-alpine

# Set the working directory for client application to /client
WORKDIR /client

# Copy the package.json and package-lock.json files to the working client directory
COPY ./client/package*.json ./

# Copy the rest of the client  application files to the working directory
COPY ./client .

# Install the client application dependencies
RUN npm install

# Set the working directory for backend application to /backend
WORKDIR /backend

# Copy the package.json and package-lock.json files to the working backend directory

COPY ./backend/package*.json ./

# Copy the rest of the backend  application files to the working directory
COPY ./backend .

# # Install the backend application dependencies
RUN npm install

# # Expose port 5000 for the application
EXPOSE 5000

# # Start the application
CMD [ "npm", "start" ]
