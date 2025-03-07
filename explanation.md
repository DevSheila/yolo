### Backend Dockerfile
The backend Dockerfile (backend/Dockerfile) defines the image for the server-side application. Here's a breakdown of what the file does:
```
* FROM node:14: This line specifies the base image for the Docker image, in this case, the official  Node.js 14 image from Docker Hub.
* WORKDIR /app: This sets the working directory for the image to /app.
* COPY package*.json ./: This line copies the package.json and package-lock.json files to the /app directory in the Docker image.
* RUN npm install: This line installs the Node.js dependencies for the server-side application.
* COPY . .: This line copies the entire contents of the current directory (the server-side application code) to the /app directory in the Docker image.
* EXPOSE 5000: This line exposes port 5000 for the server-side application.
* CMD ["npm", "start"]: This line specifies the command that should be run when the Docker image is started, in this case, running the npm start command to start the server-side application.
```
### Client Dockerfile
The client Dockerfile (client/Dockerfile) defines the image for the client-side application. Here's a breakdown of what the file does:
```
* FROM node:14: This line specifies the base image for the Docker image, in this case, the official Node.js 14 image from Docker Hub.
* WORKDIR /app: This sets the working directory for the image to /app.
* COPY package*.json ./: This line copies the package.json and package-lock.json files to the /app directory in the Docker image.
* RUN npm install: This line installs the Node.js dependencies for the client-side application.
* COPY . .: This line copies the entire contents of the current directory (the client-side application code) to the /app directory in the Docker image.
* EXPOSE 3000: This line exposes port 3000 for the client-side application.
* CMD ["npm", "start"]: This line specifies the command that should be run when the Docker image is started, in this case, running the npm start command to start the client-side application.

```

### Docker compose file
In this Docker Compose file, we define three services: frontend, backend, and mongo. The frontend and backend services are based on the custom images sheilaasharon/yolo-client:1.0.0 and sheilaasharon/yolo-backend:1.0, respectively, while the mongo service uses the official mongo:3.6.19-xenial image.

We map ports 3000, 5000, and 27017 of the host to the respective ports of the containers running the frontend, backend, and mongo services. This allows us to access the YOLO application from our web browser (through port 3000) and to communicate with the backend service (through port 5000).

The frontend service depends on the backend and mongo services, and the backend service depends on the mongo service. This ensures that the services start up in the right order, with the mongo service being available first.

We use the react-node-app network to connect the three services. This allows them to communicate with each other using their service names (e.g., the frontend service can communicate with the backend service at the address http://backend:5000). We also use a Docker volume called mongo-data to persist the Mongo data.

```
version: "3.7"

# Define the services that make up the YOLO application
services:
  # Frontend service, based on the "yolo-client" Docker image
  frontend:
    # Use the "yolo-client" image from Docker Hub
    image: sheilaasharon/yolo-client:1.0.0
    # Open the standard input of the container
    stdin_open: true
    # Map port 3000 of the host to port 3000 of the container
    ports:
      - "3000:3000"
    # Link to the "backend" and "mongo" services
    links:
      - backend
      - mongo
    # Use the "react-node-app" network
    networks:
      - react-node-app

  # Backend service, based on the "yolo-backend" Docker image
  backend:
    # Use the "yolo-backend" image from Docker Hub
    image: sheilaasharon/yolo-backend:1.0
    # Map port 5000 of the host to port 5000 of the container
    ports:
      - "5000:5000"
    # Link to the "mongo" service
    links:
      - mongo
    # Use the "react-node-app" network
    networks:
      - react-node-app

  # Mongo service, based on the official "mongo" Docker image
  mongo:
    # Use the official "mongo" image from Docker Hub
    image: mongo:3.6.19-xenial
    # Map port 27017 of the host to port 27017 of the container
    ports:
      - "27017:27017"
    # Use the "react-node-app" network
    networks:
      - react-node-app
    # Mount a volume to persist the Mongo data
    volumes:
      - mongo-data:/data/db

# Define a volume to persist the Mongo data
volumes:
  mongo-data:

# Define a network for the YOLO application
networks:
  react-node-app:
    driver: bridge

```

### Inventory file
In this implementation, we use a Vagrantfile to provision a virtual machine running Ubuntu 20.04, with Ansible as the provisioning tool. We also define an inventory file to specify the hosts that Ansible will manage.
```
# Defines the inventory of hosts that Ansible will manage
# In this case, we have only one host, which is the Vagrant virtual machine
[vagrant]
127.0.0.1 ansible_ssh_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key

# Defines the inventory group for the frontend container
[frontend]
127.0.0.1

```
### Vagrantfile
```
# Defines the configuration for the Vagrant virtual machine
Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/ubuntu2004" # Specifies the base box for the virtual machine
  config.vm.network "forwarded_port", guest: 80, host: 8080 # Forwards port 80 on the virtual machine to port 8080 on the host machine
  config.vm.provider "virtualbox" do |vb| # Defines the provider for the virtual machine (in this case, VirtualBox)
    vb.memory = "2048" # Specifies the amount of memory to allocate for the virtual machine
    vb.cpus = 2 # Specifies the number of CPUs to allocate for the virtual machine
  end
  config.vm.provision "ansible" do |ansible| # Configures Ansible as the provisioning tool
    ansible.playbook = "playbook.yml" # Specifies the playbook to use for provisioning
    ansible.extra_vars = { # Defines extra variables to pass to Ansible
      app_name: "ecommerce_app" # Specifies the name of the application
    }
  end
end

```

### Playbook.yml
The playbook.yml file defines the tasks that Ansible will execute on the managed hosts. We start by installing Docker and Docker Compose, then cloning the repository that contains the web application. We then use Docker Compose to build and run the frontend and backend containers, which are configured in their own unique roles.

Variables were used to define the app name and port numbers, which are used throughout the playbook. We also use blocks and tags for ease of assessment and as a good coding practice. Finally, we use roles to separate the frontend and backend logic/containerization.
```
# Defines the tasks that Ansible will execute on the managed hosts
- hosts: all # Specifies the hosts to manage (in this case, all hosts in the inventory file)
  become: yes # Gives Ansible root privileges on the managed hosts
  vars: # Defines variables that can be used throughout the playbook
    app_name: "{{ app_name }}" # Uses the app name specified in the Vagrantfile
    frontend_port: "80" # Specifies the port to use for the frontend container
    backend_port: "3000" # Specifies the port to use for the backend container
  tasks:
    - name: Install Docker # Installs Docker on the managed hosts
      become: yes
      apt:
        name: docker.io
        state: present

    - name: Install Docker Compose # Installs Docker Compose on the managed hosts
      become: yes
      apt:
        name: docker-compose
        state: present

    - name: Clone repository # Clones the repository containing the web application
      become: yes
      git:
        repo: https://github.com/DevSheila/yolo.git
        dest: "/opt/{{ app_name }}"

    - name: Build and run frontend container # Builds and runs the frontend container
      become: yes
      docker_container:
        name: frontend
        image: devsheila/yolo-frontend:latest
        state: started
        ports:
          - "{{ frontend_port }}:80"
        volumes:
          - "/opt/{{ app_name }}/frontend:/app"

    - name: Build and run backend container # Builds and runs the backend container
      become: yes
      docker_container:
        name: backend
        image: devsheila/yolo-backend:latest
        state: started
        ports:
          - "{{ backend_port }}:3000"
        volumes:
          - "/opt/{{ app_name }}/backend:/app"

```