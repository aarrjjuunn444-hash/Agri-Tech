FROM tomcat:9.0-jdk11-openjdk-slim

# 1. Clean out default Tomcat files
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Create the ROOT directory manually
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# 3. Add MySQL Driver (Essential for your DB connection)
ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar /usr/local/tomcat/lib/

# 4. Copy EVERYTHING from your WebContent folder into ROOT
# The dot (.) at the end of the first path is very important
COPY WebContent/. /usr/local/tomcat/webapps/ROOT/

# 5. Copy your compiled Java classes (if you have them)
# If your classes are in a 'build/classes' or 'bin' folder, uncomment the line below:
# COPY build/classes/. /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080

CMD ["catalina.sh", "run"]
