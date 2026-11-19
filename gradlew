#!/usr/bin/env bash
set -e

DEFAULT_JVM_OPTS="-Xmx2048m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WRAPPER_JAR="$SCRIPT_DIR/gradle/wrapper/gradle-wrapper.jar"

if [ -f "$WRAPPER_JAR" ]; then
    exec java $DEFAULT_JVM_OPTS \
      -classpath "$WRAPPER_JAR" \
      org.gradle.wrapper.GradleWrapperMain "$@"

elif command -v gradle >/dev/null 2>&1; then
    export GRADLE_OPTS="${GRADLE_OPTS:-} $DEFAULT_JVM_OPTS"
    exec gradle "$@"

else
    mkdir -p "$SCRIPT_DIR/gradle/wrapper"

    GRADLE_ZIP="/tmp/gradle-8.2-bin.zip"

    curl -fsSL \
      "https://services.gradle.org/distributions/gradle-8.2-bin.zip" \
      -o "$GRADLE_ZIP"

    unzip -qo "$GRADLE_ZIP" -d /tmp/gradle-dist

    export GRADLE_OPTS="${GRADLE_OPTS:-} $DEFAULT_JVM_OPTS"

    exec /tmp/gradle-dist/gradle-8.2/bin/gradle "$@"
fi
