FROM bellsoft/liberica-openjdk-alpine-musl:21.0.10

ENV NODE_ENV=production

RUN apk add --update --no-cache \
      kubectl=1.34.2-r5 \
      nodejs-current=24.9.0-r1 \
      npm=11.11.0-r0 \
      postgresql14-client \
      bash \
      jq=1.8.1-r0 && \
    npm set prefer-dedupe=true strict-ssl=false && \
    npm install --logs-max=0 -g mongosh@2.2.5 && \
    ln -s /usr/local/bin/mongosh /usr/local/bin/mongo && \
    npm cache clean --force && \
    apk del -r npm && \
    rm -rf /var/cache/apk/*
