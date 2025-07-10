FROM bellsoft/liberica-openjdk-alpine-musl:8u402

ENV NODE_ENV=production

RUN apk add --update --no-cache \
      kubectl=1.28.4-r3 \
      nodejs-current=21.7.2-r0 \
      npm=10.2.5-r0 \
      postgresql14-client=14.17-r0 && \
    npm set prefer-dedupe=true strict-ssl=false && \
    npm install --logs-max=0 -g mongosh@2.2.5 && \
    ln -s /usr/local/bin/mongosh /usr/local/bin/mongo && \
    npm cache clean --force && \
    apk del -r npm && \
    rm -rf /var/cache/apk/*
