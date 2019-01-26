FROM ubuntu:latest as builder

RUN apt-get update
RUN apt-get install curl -y
RUN curl -L -o /tmp/go.sh https://install.direct/go.sh
RUN chmod +x /tmp/go.sh
RUN /tmp/go.sh

FROM alpine:latest

LABEL maintainer "Darian Raymond <admin@v2ray.com>"
RUN mkdir -m 777 /v2raybin \ 
&& cd /v2raybin

COPY --from=builder /usr/bin/v2ray/v2ray /v2raybin/
COPY --from=builder /usr/bin/v2ray/v2ctl /v2raybin/
COPY --from=builder /usr/bin/v2ray/geoip.dat /v2raybin/
COPY --from=builder /usr/bin/v2ray/geosite.dat /v2raybin/

RUN set -ex \
&& apk --no-cache add ca-certificates \
&& chmod +x /v2raybin/v2ray \
&& rm -rf v2ray.zip \
&& rm -rf v2ray-v$VER-linux-64 \
&& chgrp -R 0 /v2raybin \
&& chmod -R g+rwX /v2raybin 
 
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh 

ENTRYPOINT  /entrypoint.sh 

EXPOSE 8080
