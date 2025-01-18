# Use a base image with OpenJDK 17
FROM openjdk:17-jdk-slim as builder

# Set the working directory
WORKDIR /app

# Copy your pom.xml and download dependencies
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy the source code into the image
COPY src /app/src

# Build the application
RUN mvn clean package -DskipTests

# Use the final image with a JRE to run the application
FROM openjdk:17-jre-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build image
COPY --from=builder /app/target/Ecom-0.0.1-SNAPSHOT.jar /app/Ecom.jar

# Expose the port on which the Spring Boot application will run
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "Ecom.jar"]
