FROM maven:3-eclipse-temurin-17-focal
RUN apt update && \
    apt install -y dos2unix && \
    apt clean all
COPY entrypoint.sh /
RUN cd / && dos2unix entrypoint.sh
RUN chmod 755 /entrypoint.sh
WORKDIR /app
ENTRYPOINT [ "/entrypoint.sh" ]