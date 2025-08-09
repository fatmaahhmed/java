# ===== Stage 1: Build =====
FROM maven:3.9.6-eclipse-temurin-11 AS builder
WORKDIR /src
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -DskipTests package

# ===== Stage 2: Runtime =====
FROM eclipse-temurin:11-jre-jammy
WORKDIR /app
COPY --from=builder /src/target/*.jar app.jar
EXPOSE 8090
ENTRYPOINT ["java","-jar","/app/app.jar"]
