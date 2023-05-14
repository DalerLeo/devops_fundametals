DATE=`date +%d-%m-%Y`

docker build -t dalerepam/devops-nest-app .
docker tag dalerepam/devops-nest-app:latest dalerepam/devops-nest-app:$DATE
docker push dalerepam/devops-nest-app:$DATE