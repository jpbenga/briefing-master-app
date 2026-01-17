# This Dockerfile is a starting point for building the Android APK of your Flutter application.
# You might need to install other dependencies or configure the build process further.

# Use a base image with Flutter and Android SDK
FROM cirrusci/flutter:stable

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Build the APK
RUN flutter build apk
