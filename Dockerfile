FROM keymetrics/pm2:6
MAINTAINER Shawn Hwei <shawn@shawnh.net>

ARG timezone=UTC

RUN apk update && apk upgrade

RUN apk add --no-cache ca-certificates wget tzdata && update-ca-certificates

RUN cp /usr/share/zoneinfo/$timezone /etc/localtime && echo "$timezone" > /etc/timezone && date && apk del tzdata

RUN wget -O /tmp/flood.tar.gz "https://github.com/jfurrow/flood/archive/v1.0.0.tar.gz"

RUN tar -xzf /tmp/flood.tar.gz -C /tmp && mv /tmp/flood-1.0.0 /flood && rm /tmp/flood.tar.gz

WORKDIR /flood

RUN npm install --production --quiet

COPY config.js /flood/config.js

EXPOSE 3000

ENTRYPOINT ["pm2-docker", "--name=flood", "npm", "--", "start"]
