### Docker compose file
In this Docker Compose file, we define three services: frontend, backend, and mongo. The frontend and backend services are based on the custom images sheilaasharon/yolo-client:1.0.0 and sheilaasharon/yolo-backend:1.0, respectively, while the mongo service uses the official mongo:3.6.19-xenial image.

We map ports 3000, 5000, and 27017 of the host to the respective ports of the containers running the frontend, backend, and mongo services. This allows us to access the YOLO application from our web browser (through port 3000) and to communicate with the backend service (through port 5000).

The frontend service depends on the backend and mongo services, and the backend service depends on the mongo service. This ensures that the services start up in the right order, with the mongo service being available first.

We use the react-node-app network to connect the three services. This allows them to communicate with each other using their service names (e.g., the frontend service can communicate with the backend service at the address http://backend:5000). We also use a Docker volume called mongo-data to persist the Mongo data.