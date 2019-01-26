FROM alpine:latest

ENV CONFIG_JSON=none CERT_PEM=none KEY_PEM=none VER=4.13.0

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && mkdir -m 777 /v2raybin \ 
 && cd /v2raybin \
 && curl -L -H "Cache-Control: no-cache" -o v2ray.zip https://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip \
 && unzip v2ray.zip \
 && chmod +x /v2raybin/v2ray \
 && rm -rf v2ray.zip \
 && chgrp -R 0 /v2raybin \
 && chmod -R g+rwX /v2raybin \
 && echo -e "$CONFIG_JSON" > config.json
 
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh 

ENTRYPOINT  /entrypoint.sh 

EXPOSE 8080
