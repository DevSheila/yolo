## Kubernetes object selection:

Due to the need for durable storage and stable, distinctive network identities, I decided to employ a StatefulSet for the MongoDB deployment. By doing this, MongoDB can guarantee that each replica pod has a distinct network identity and that data integrity is maintained via pod rescheduling. I employed a Deployment object for the server and client deployments. This is so that the application may be simply scaled up or down by changing the replica count and without the need for special network IDs.

## Exposing pods to online activity

I exposed both the server and MongoDB pods to internet traffic using a Kubernetes Service object. The Service object enables load balancing and traffic routing to the appropriate pod,as well as automatic failover.

## Persistent storage

Persistent storage for the MongoDB pod was provided using a PersistentVolumeClaim (PVC) object. This makes it possible for data to be kept even if the pod is regenerated or postponed. Since the client and backend did not need persistent storage, I did not employ PVCs for those pods.

## Git workflow:

I used the following Git workflow to achieve the task:

- Forked the original repository
- Cloned the forked repository to my local machine
- Created a new branch for my changes
- Made changes to the YAML files to include StatefulSets and PVCs
- Pushed the changes to the new branch
- Successful running of the applications:
- I tested the applications by following commands:

```
docker-compose up
kubectl apply -f kubernetes-manifest/mongo.yaml
kubectl apply -f kubernetes-manifest/client.yaml
kubectl apply -f kubernetes-manifest/react.yaml
```

- Pushed changes to master branch

## Docker image tag conventions:

For my Docker images, I followed the conventional name pattern of:`<image name>:<tag>`The Node.js server image, for instance, had the filename ` sheilaasharon/yolo-backend:1.0.0.` This makes it easy to identify and personalize images and containers, and allows for easy versioning in the future.
