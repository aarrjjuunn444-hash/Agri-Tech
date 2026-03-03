FROM tomcat:9.0-jdk11-openjdk-slim

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Add MySQL Driver
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

# Copy project files
COPY . /usr/local/tomcat/webapps/ROOT/

# Railway provides dynamic PORT
ENV CATALINA_OPTS="-Dserver.port=$PORT"

EXPOSE 8080

CMD ["catalina.sh", "run"]
