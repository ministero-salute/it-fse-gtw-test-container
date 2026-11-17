# Immagine generica per i microservizi Spring Boot di FSE 2.0.
#
# Il build context è la cartella locale del microservizio (es. ../../it-fse-gtw-config):
# viene compilato il codice presente sul branch attualmente in checkout.
#
# Build multi-stage:
#   1. "build":   mvn package (test esclusi) con cache Maven condivisa
#   2. "runtime": JRE 21, utente non-root, solo il fat-jar

ARG MAVEN_IMAGE=docker.io/library/maven:3.9-eclipse-temurin-21
ARG RUNTIME_IMAGE=docker.io/library/eclipse-temurin:21-jre

# ---------------------------------------------------------------------------
FROM ${MAVEN_IMAGE} AS build

WORKDIR /src

# Solo i sorgenti necessari: target/, .git/, IDE ecc. restano fuori dall'immagine.
COPY pom.xml ./
COPY src ./src

# La cache Maven (~/.m2) è condivisa tra tutte le build dei microservizi.
# I test non vengono né compilati né eseguiti (alcuni branch hanno test non allineati).
RUN --mount=type=cache,id=fse2-m2,target=/root/.m2 \
    MAVEN_OPTS="-Xmx1g" mvn -B -q -e \
      -Dmaven.test.skip=true -Djacoco.skip=true -Dmaven.javadoc.skip=true -Dsonar.skip=true \
      package \
 && cp "$(ls -S target/*.jar | head -n 1)" /tmp/app.jar

# ---------------------------------------------------------------------------
FROM ${RUNTIME_IMAGE} AS runtime

LABEL org.opencontainers.image.vendor="Ministero della Salute - FSE 2.0" \
      org.opencontainers.image.description="Microservizio FSE 2.0 (build locale)"

RUN groupadd --system --gid 10001 app \
 && useradd --system --uid 10001 --gid app --home-dir /app --shell /usr/sbin/nologin app

WORKDIR /app
COPY --from=build --chown=app:app /tmp/app.jar /app/app.jar

USER app

# Opzioni JVM sovrascrivibili da compose (JAVA_TOOL_OPTIONS)
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75 -XX:+ExitOnOutOfMemoryError -XX:TieredStopAtLevel=1 -XX:+UseSerialGC"

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
