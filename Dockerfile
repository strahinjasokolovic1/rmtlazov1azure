# Multi-stage Dockerfile za Lazes TCP server
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Kopiraj pom fajlove i module potrebne za server
COPY pom.xml ./
COPY shared ./shared
COPY server ./server

# Kompajliraj i spakuj fat jar sa svim zavisnostima
RUN mvn clean package -pl shared,server -am -DskipTests

# Runtime slika sa minimalnim JRE-om
FROM eclipse-temurin:21-jre
WORKDIR /app

COPY --from=build /app/server/target/lazes-server.jar app.jar

ENV PORT=5555
EXPOSE 5555

ENTRYPOINT ["java", "-jar", "app.jar"]
