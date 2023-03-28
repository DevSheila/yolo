# Use an official Node.js runtime as a parent image
FROM node:14-alpine

# Set the working directory for backend application to /backend
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the working backend directory

COPY ./package*.json ./

# # Install the backend application dependencies
RUN npm install

# Copy the rest of the backend  application files to the working directory
COPY . .

# Expose port 5000 for the application
EXPOSE 5000

# Start the application
CMD [ "npm", "start" ]