# Use the official Corretto-Alpine image to create a build artifact.
FROM docker.io/amazoncorretto:17-alpine3.18-jdk as builder


# Download and install Maven 3.9.4
ENV MAVEN_VERSION 3.9.4
RUN wget -q https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt \
    && rm apache-maven-${MAVEN_VERSION}-bin.tar.gz
ENV PATH="/opt/apache-maven-${MAVEN_VERSION}/bin:${PATH}"


# Copy src code to the container
WORKDIR /usr/src/app
COPY src ./src
COPY pom.xml ./

# Build a release artifact
RUN mvn clean package -DskipTests

# Use the official openjdk image for a base image.
# It's based on Debian and sets the JAVA_VERSION in the environment to your project's pom.xml
FROM docker.io/amazoncorretto:17-alpine3.18-jdk


# Create a user group 'javauser' and user 'javauser'
# Create a user within the docker container (different than users on the EC2 instance)
RUN addgroup -S javagroup && adduser -S javauser -G javagroup

# Set the working directory and switch to the 'javauser' user
WORKDIR /usr/app
USER javauser

# Copy the jar file built in the first stage
COPY --from=builder /usr/src/app/target/app.jar ./app.jar

# Set the spring profiles active environment variable
# spring will automatically grab this env and apply it, no need to manually inject into app.properties
# if not specified during build command, default is staging
ARG SPRING_PROFILE=staging
ENV SPRING_PROFILES_ACTIVE=$SPRING_PROFILE

# Your application's port number
EXPOSE 8080

# Run your jar file
ENTRYPOINT ["java","-jar","./app.jar"]