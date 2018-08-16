#/bin/sh

echo "Please enter the Grafana admin password:"
read GF_SECURITY_ADMIN_PASSWORD

echo $GF_SECURITY_ADMIN_PASSWORD | sudo docker secret create grafana-GF_SECURITY_ADMIN_PASSWORD -
echo "Grafana admin password stored to Docker secrets."

echo "Creating Grafana configuration volume..."
sudo docker volume create grafana-config

echo "Creating Grafana data volume..."
sudo docker volume create grafana-data
