# --restart=always enables autostart on boot:
# https://serverfault.com/questions/633067/how-do-i-auto-start-docker-containers-at-system-boot
# Create named volumes first:
#docker volume create mosquitto-data
#docker volume create mosquitto-logs
#docker volume create mosquitto-config
docker run \
    -v mosquitto-data:/var/lib/mosquitto \
    -v mosquitto-logs:/var/log/mosquitto \
    -v mosquitto-config:/etc/mosquitto \
    --detach=true \
    --name=mosquitto \
    --restart=unless-stopped \
    -p 1883:1883 \
    mhaas/mosquitto
