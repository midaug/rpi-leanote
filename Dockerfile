FROM resin/rpi-golang

LABEL maintainer="blog.midaug.win"

ENV LEANOTE_VERSION 2.6.1

ADD https://gitee.com/midaug/files/raw/master/leanote-linux-arm-v${LEANOTE_VERSION}.bin.tar.gz /usr/local/leanote.tar.gz

RUN tar -xzvf /usr/local/leanote.tar.gz -C /usr/local && \
    rm -f /usr/local/leanote.tar.gz && \
    mkdir /data && \
    ln -s /usr/local/leanote /data

RUN chmod +x /usr/local/leanote/bin/run.sh

RUN hash=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-64};echo;); \
    sed -i "s/app.secret=.*$/app.secret=$hash #/" /usr/local/leanote/conf/app.conf; \
    sed -i "s/db.host=.*$/db.host=mongodb /" /usr/local/leanote/conf/app.conf; \
    sed -i "s/site.url=.*$/site.url=\${SITE_URL} /" /usr/local/leanote/conf/app.conf; 

VOLUME /data

EXPOSE 9000
WORKDIR  /usr/local/leanote/bin
ENTRYPOINT ["sh", "run.sh"]
