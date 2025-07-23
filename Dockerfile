# Base image with Java 17 and Maven installed
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy plugin source code
COPY . .

# Build the plugin (you can remove -DskipTests if you want tests to run)
RUN mvn -B clean install -DskipTests

# Runtime stage (optional: if you want Jenkins + plugin in the same image)
FROM jenkins/jenkins:lts-jdk17

# Install required Jenkins plugins and copy built HPI
COPY --from=builder /app/target/authorize-project.hpi /usr/share/jenkins/ref/plugins/authorize-project.hpi

# Optional: preinstall any dependencies
# RUN /usr/local/bin/install-plugins.sh git matrix-auth credentials

# Expose Jenkins port
EXPOSE 8080

# Jenkins runs by default
