# Use an official Node.js runtime as a parent image
FROM node:14-alpine

# Set the working directory for client application to /client
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the working client directory
COPY ./package*.json ./

# Install the client application dependencies
RUN npm install

# Copy the rest of the client  application files to the working directory
COPY . .

#  Expose port 3000 for the application
EXPOSE 3000

# Start the application
CMD [ "npm", "start" ]