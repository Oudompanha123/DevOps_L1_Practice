# Twitter App: Running in a Docker Container

A Spring Boot 3.3 web app (Java 17) with Thymeleaf pages, Spring Security login, and an in-memory H2 database. This guide shows how to build it into a Docker image and run it as a container.

## Prerequisites

- Docker Desktop installed and running.
- The `docker` command available in your terminal. Check with:
  ```powershell
  docker --version
  ```
  If it says `docker` is not recognized, add the Docker Desktop `resources\bin` folder (for example `C:\Users\<you>\AppData\Local\Programs\DockerDesktop\resources\bin`) to your user PATH. Then close and reopen your terminal or VS Code completely.

Java and Maven don't need to be installed locally, because the app is compiled inside Docker.

## Dockerfile

The [Dockerfile](Dockerfile) uses a multi-stage build:

1. **Build stage** (`maven:3.9-eclipse-temurin-17`) downloads dependencies and packages the app into a jar with `mvn package`.
2. **Run stage** (`eclipse-temurin:17-jre`) copies only the jar into a smaller image with just the Java runtime and starts it on port 8080.

[.dockerignore](.dockerignore) keeps the local `target/` folder out of the build.

## Steps

Run these commands from this folder (the one containing `Dockerfile`).

### 1. Build the image

```powershell
docker build -t java-app:latest .
```

### 2. Run the container

```powershell
docker run -d --name java-app -p 8080:8080 java-app:latest
```

- `-d` runs the container in the background.
- `--name java-app` names the container.
- `-p 8080:8080` maps port 8080 on your PC to port 8080 in the container.

### 3. Check that it's running

```powershell
docker ps
docker logs java-app
```

The logs should contain `Started TwitterAppApplication`.

### 4. Open the app

| URL | What it shows |
| --- | --- |
| http://localhost:8080/login | Login page |
| http://localhost:8080/register | Register a new user |
| http://localhost:8080/actuator/health | Health check (should show `"status":"UP"`) |

### 5. Stop and remove the container

```powershell
docker stop java-app
docker rm java-app
```

You have to remove the old container before running step 2 again, or Docker will report that the name `java-app` is already in use.

## Notes

- **Data is not saved.** The app uses an in-memory H2 database, so users and posts are lost when the container restarts.
- **Tests are skipped** during the image build (`-DskipTests`).
- **Tracing warnings** may appear in the logs. The app sends traces to a Tempo server address for Kubernetes (`tempo.monitoring.svc.cluster.local`), which doesn't exist when running locally. The app still works normally.
