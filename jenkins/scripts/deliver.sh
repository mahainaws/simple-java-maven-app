#!/usr/bin/env bash

echo "Installing Maven-built Java application into local repository..."
set -x
mvn jar:jar install:install
set +x

# Extract project name and version safely (removes extra output)
NAME=$(mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout | tr -d '\r' | sed -e 's/\x1b\[[0-9;]*m//g')
VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout | tr -d '\r' | sed -e 's/\x1b\[[0-9;]*m//g')

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
