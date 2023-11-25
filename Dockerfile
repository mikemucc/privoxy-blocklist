# FROM ubuntu:latest as builder

# RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential autoconf wget libghc-zlib-dev libpcre3 libpcre3-dev

# RUN wget https://sourceforge.net/projects/ijbswa/files/Sources/3.0.34%20%28stable%29/privoxy-3.0.34-stable-src.tar.gz/download

# ENV builddir=/privoxy
# RUN mkdir $builddir && tar -xzvf download --strip-components=1 -C $builddir
# WORKDIR $builddir
# RUN autoheader && autoconf && ./configure && make

FROM ubuntu:latest
# COPY --from=builder /privoxy/privoxy /usr/sbin/privoxy
RUN apt-get update && apt-get upgrade -y
RUN apt-get install privoxy sed grep bash wget -y
ENV TMPDIR=/tmp
COPY privoxy-blocklist.sh /
COPY config /etc/privoxy/config
COPY privoxy-blocklist.conf /etc/privoxy-blocklist.conf
RUN /privoxy-blocklist.sh
ENTRYPOINT ["privoxy"]
CMD ["--no-daemon", "/etc/privoxy/config"]