# Galaxy Docker-Swarm Replication
This is an attempt to replicate galaxy docker-swarm/compose implementation on kubernetes k8s cluster
run using command
```
$ kubectl create -f galaxy-web.yaml
```
add label to pod using
```
$ kubectl label pod galaxy KEY1=galaxy1
```
expose service using 
```
$ kubectl expose pod galaxy --port=80 --name=galaxy
```
## Notes
this implementation makes use of a single pod to run all containers
separate volumes can be dedicated to each pod by using persistentvolumeclaims.(See directory separate pods for more details)

