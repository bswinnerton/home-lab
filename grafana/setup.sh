#/bin/sh

[ -f .env ] || echo ".env file not present"; exit 1

echo "Creating Grafana configuration volume..."
sudo docker volume create grafana-config

echo "Creating Grafana data volume..."
sudo docker volume create grafana-data
