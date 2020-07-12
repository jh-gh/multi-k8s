echo "Starting deploy.sh"
docker build -t jhnz/multi-client:latest -t jhnz/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jhnz/multi-server:latest -t jhnz/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jhnz/multi-worker:latest -t jhnz/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push jhnz/multi-client:latest
docker push jhnz/multi-server:latest
docker push jhnz/multi-worker:latest
docker push jhnz/multi-client:$SHA
docker push jhnz/multi-server:$SHA
docker push jhnz/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=jhnz/multi-server:$SHA
kubectl set image deployments/client-deployment client=jhnz/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=jhnz/multi-worker:$SHA