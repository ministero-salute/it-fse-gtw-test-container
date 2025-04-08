FROM maven:3.9.5-eclipse-temurin-21
RUN apt update && \
    apt install -y dos2unix && \
    apt clean all
COPY entrypoint.sh /
RUN cd / && dos2unix entrypoint.sh
RUN chmod 755 /entrypoint.sh
WORKDIR /app
ENTRYPOINT [ "/entrypoint.sh" ]