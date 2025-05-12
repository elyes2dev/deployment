# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim
WORKDIR /app

COPY *.jar app.jar

# Make port available to the world outside this container
EXPOSE 8089


# Set environment variables with defaults that will be overridden by docker-compose
ENV SPRING_DATASOURCE_URL=jdbc:mysql://10.104.22.59:3306/pi111?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&maxAllowedPacket=67108864 \
    SPRING_DATASOURCE_USERNAME=castini_user \
    SPRING_DATASOURCE_PASSWORD=secret \
    SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT=org.hibernate.dialect.MySQL8Dialect

# Run the jar file
ENTRYPOINT ["java", "-jar", "/app/app.jar"]