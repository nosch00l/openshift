FROM alpine:latest

ENV CONFIG_JSON=none CERT_PEM=none KEY_PEM=none VER=4.13.0

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && mkdir -m 777 /v2raybin \ 
 && cd /v2raybin \
 && curl -L -H "Cache-Control: no-cache" -o v2ray.zip https://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip \
 && unzip v2ray.zip \
 && rm -rf v2ray.zip \
 && chmod +x *.* \
 && rm -rf config.json \
 && chgrp -R 0 /v2raybin \
 && chmod -R g+rwX /v2raybin
 
ADD entrypoint.sh /entrypoint.sh
ADD config.json /v2raybin/config.json

RUN chmod +x /entrypoint.sh \
&& chmod +x /v2raybin/v2ray.json

ENTRYPOINT  /entrypoint.sh 

EXPOSE 8080
