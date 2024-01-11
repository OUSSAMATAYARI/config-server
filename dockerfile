# Use a base image with JDK 17 and Maven
FROM eclipse-temurin:17-jdk-focal AS builder

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper files
COPY .mvn/ .mvn

# Copy the Maven project descriptor
COPY mvnw pom.xml ./

RUN chmod +x mvnw
# Build the dependencies
RUN ./mvnw dependency:go-offline

# Copy the application source
COPY src ./src

# Build the application
RUN ./mvnw package -DskipTests

# Use a smaller base image for the application
FROM eclipse-temurin:17-jdk-focal

# Set the working directory
WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /app/target/config-server-0.0.1-SNAPSHOT.jar ./app.jar

# Define the command to run your application
CMD ["java", "-jar", "app.jar"]

EXPOSE 8888
               
