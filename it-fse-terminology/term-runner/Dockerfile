FROM docker.io/maven:3-openjdk-17
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh
WORKDIR /app
ENTRYPOINT [ "/entrypoint.sh" ]