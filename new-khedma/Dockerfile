# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy jar
COPY *.jar app.jar

# Copy the uploads directory
COPY uploads /app/uploads

# Expose port
EXPOSE 8089

# Set environment variables
ENV SPRING_DATASOURCE_URL=jdbc:mysql://10.104.22.59:3306/pi111?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&maxAllowedPacket=67108864 \
    SPRING_DATASOURCE_USERNAME=castini_user \
    SPRING_DATASOURCE_PASSWORD=secret \
    SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT=org.hibernate.dialect.MySQL8Dialect

# Ensure uploads folder has write permissions (if needed)
RUN chmod -R 777 /app/uploads

# Run the jar file
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
