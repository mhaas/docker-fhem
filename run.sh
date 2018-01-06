# Create named volumes first:
#docker volume create fhem-config
#docker volume create fhem-logs
docker run \
    --detach=true \
    -v fhem-config:/etc/fhem/ \
    -v fhem-logs:/opt/fhem/log \
    --name=fhem \
    --restart=unless-stopped \
    -p 7072:7072 \
    -p 8083:8083 \
    --device=/dev/ttyACM0 \
    mhaas/fhem
