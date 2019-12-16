FROM frolvlad/alpine-glibc:alpine-3.9_glibc-2.29

ENV LANG=C.UTF-8

WORKDIR /app

ADD entrypoint.sh .

RUN apk add openssh

RUN wget https://pandorafms.com/library/wp-content/uploads/2019/11/gotty_linux_amd64.tar.gz && \
    tar xvf gotty_linux_amd64.tar.gz && \
    rm -rf gotty_linux_amd64.tar.gz

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]