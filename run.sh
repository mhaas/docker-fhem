# Create named volumes first:
#docker volume create fhem-config
#docker volume create fhem-logs
docker run \
    -v fhem-config:/ec/fhem/ \
    -v fhem-logs:/opt/fhem/log \
    --detach=true \
    --name=fhem \
    --restart=unless-stopped \
    -p 7072:7072 \
    -p 8083:8083 \
    mhaas/fhem
