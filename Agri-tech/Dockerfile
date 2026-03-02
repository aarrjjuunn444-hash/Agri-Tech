FROM tomcat:9.0-jdk11-openjdk-slim

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Add MySQL Driver to Tomcat's library
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

# Copy your web content. 
# NOTE: Ensure 'WebContent' matches the exact folder name inside your 'Agri-tech' folder.
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080

# The start command MUST be the very last line
CMD ["catalina.sh", "run"]
