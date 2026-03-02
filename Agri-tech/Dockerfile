# Use Tomcat 9 with Java 11 or 8 (whichever your project uses)
FROM tomcat:9.0-jdk11-openjdk-slim

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into the container
# Replace 'your-project.war' with the actual name of your file in the /target or /dist folder
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Railway uses a dynamic PORT environment variable. 
# This line tells Tomcat to listen to the port Railway provides.
EXPOSE 8080

CMD ["catalina.sh", "run"]
# Add this BEFORE the CMD line if you don't have the driver in your WAR
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/
