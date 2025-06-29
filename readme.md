# DevOps Interview Task

Thank you for taking the time to do our technical test. We need to deploy a new .NET Core Web API application using a docker container.

Write code to do the following:

1. Run the automated tests
2. Package the application as a docker image
3. Deploy and run the image locally or in a public cloud

Improvements can also be made. For example:

- Make any changes to the application you think are useful for a deploy process
- Host the application in a secure fashion

The application is included under [`.\super-service`](`.\super-service`).

Your solution should be triggered by a powershell script called `Deploy.ps1`.

## Submitting

Create a Git repository which includes instructions on how to run the solution. 

---

# Solution

## Overview
This solution implements a complete DevOps pipeline for deploying a .NET 6.0 Web API application using Docker containers. The application provides a simple time service that returns the current server time via a REST API endpoint.

## Requirements

### Prerequisites
- **.NET 6.0 SDK** - [Download here](https://dotnet.microsoft.com/download/dotnet/6.0)
- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop)
- **PowerShell** (Windows) or **PowerShell Core** (macOS/Linux)


## How to Run the Application

### Quick Start (Recommended)
```powershell
# Clone the repository
git clone <repository-url>
cd devops

# Run the complete deployment pipeline
./Deploy.ps1 
OR
pwsh Deploy.ps1
```


### Access the Application
- **URL**: `http://localhost:8080/time`
- **Method**: GET
- **Response**: Current server time in JSON format
- **Example**: `"2025-06-29T09:32:00.1413455Z"`

## What Was Implemented

### ✅ Core Requirements
1. **Automated Testing** - NUnit tests run before deployment
2. **Docker Packaging** - Multi-stage build for optimized images
3. **Local Deployment** - Containerized application with health checks

### 🔧 Improvements Made
- **Security**: Non-root user, minimal attack surface
- **Performance**: Multi-stage Docker builds, optimized layers
- **Reliability**: Health checks, restart policies, error handling
- **Maintainability**: Comprehensive documentation, troubleshooting guides

### 🚀 Deployment Features
- **One-command deployment** via PowerShell script
- **Automatic testing** with failure prevention
- **Health monitoring** and verification
- **Configurable parameters** (ports, container names)
- **Cleanup and rollback** capabilities

## Project Structure
```
devops/
├── README.md                 # This documentation
├── Deploy.ps1               # Main deployment script
└── super-service/
    ├── src/                 # Main application
    │   ├── Controllers/     # API endpoints
    │   ├── Model/          # Business logic
    │   ├── Dockerfile      # Container configuration
    │   └── SuperService.csproj
    └── test/               # Unit tests
        ├── TimeControllerTests.cs
        └── SuperService.UnitTests.csproj
```

## Troubleshooting

### Common Issues
- **Port 8080 in use**: Use `./Deploy.ps1 -Port 9000`
- **Docker not running**: Start Docker Desktop
- **Tests failing**: Check .NET SDK version (requires 6.0)

### Useful Commands
```bash
# View logs
docker logs superservice-container

# Check status
docker ps

# Stop application
docker stop superservice-container
```

---

**Note**: This solution demonstrates modern DevOps practices and is ready for production deployment or CI/CD integration.