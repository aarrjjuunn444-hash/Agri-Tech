FROM tomcat:9.0-jdk11-openjdk-slim

# 1. Clear default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Download MySQL Driver so your Java code can connect to the DB
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

# 3. Copy your project files into the ROOT directory
# Ensure 'WebContent' matches the folder name in your GitHub repo
COPY WebContent/ /usr/local/tomcat/webapps/ROOT/

# 4. Expose the port
EXPOSE 8080

# 5. Start the server (This MUST be the last line)
CMD ["catalina.sh", "run"]

