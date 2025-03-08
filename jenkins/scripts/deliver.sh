#!/usr/bin/env bash

echo "Installing Maven-built Java application into local repository..."
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.artifactId -q -DforceStdout
mvn help:evaluate -Dexpression=project.version -q -DforceStdout
set +x

# Extract project name and version safely
NAME=$(mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout)
VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

echo "Project Name: $NAME"
echo "Project Version: $VERSION"

# Construct the expected JAR file path
JAR_FILE="target/${NAME}-${VERSION}.jar"

echo "Checking for JAR file: $JAR_FILE"

# Verify that the JAR file exists before executing
if [[ -f "$JAR_FILE" ]]; then
    echo "Running application: $JAR_FILE"
    java -jar "$JAR_FILE"
else
    echo "ERROR: JAR file not found: $JAR_FILE"
    ls -l target/  # List target directory contents for debugging
    exit 1
fi
