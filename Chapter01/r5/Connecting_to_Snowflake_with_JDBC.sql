--generate a new Maven project
mvn archetype:generate -DgroupId=com.example ^
-DartifactId=snowflake-jdbc-demo2 ^
-DarchetypeArtifactId=maven-archetype-quickstart ^
-DinteractiveMode=false

--validate the Maven project
mvn validate

--run the Java JDBC demo
mvn exec:java -Dexec.mainClass=com.example.SnowflakeJDBCDemo
