#!/usr/bin/env pwsh


# This script automates the deployment process for the SuperService application. Just run pwsh Deploy.ps1 in the root directory

param(
    [string]$Environment = "local",
    [string]$ImageName = "superservice",
    [string]$ContainerName = "superservice-container",
    [int]$Port = 8080
)

Write-Host " Starting SuperService Deployment Process..."

# Function to check if command exists in the system where this will be run
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Checking prerequisites(optinnally i have added to run a pre req check)- please have below tools in order to run the application as a docker container
Write-Host "Checking prerequisites..."

if (-not (Test-Command "dotnet")) {
    Write-Error " .NET Core SDK is not installed. Please install it from https://dotnet.microsoft.com/download"
    exit 1
}

if (-not (Test-Command "docker")) {
    Write-Error " Docker is not installed. Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
    exit 1
}

Write-Host " Prerequisites check passed" 

# Step 1: Running automated tests
Write-Host " Step 1: Running automated tests..."
Set-Location "super-service"

try {
    dotnet test test/SuperService.UnitTests.csproj --verbosity normal
    if ($LASTEXITCODE -ne 0) {
        Write-Error " Tests failed. Deployment aborted."
        exit 1
    }
    Write-Host "All tests passed!" 
} catch {
    Write-Error " Error running tests: $_"
    exit 1
}

#  Build and package as Docker image
Write-Host "🐳 Step 2: Building Docker image..." 
Set-Location "src"

try {
    # Build the Docker image
    docker build -t $ImageName .
    if ($LASTEXITCODE -ne 0) {
        Write-Error " Docker build failed. Deployment aborted."
        exit 1
    }
    Write-Host " Docker image built successfully!" 
} catch {
    Write-Error " Error building Docker image: $_"
    exit 1
}

# Deploy and run the image
Write-Host " Step 3: Deploying and running the application..." 

# Stop and remove existing container if it exists
try {
    docker stop $ContainerName 2>$null
    docker rm $ContainerName 2>$null
    Write-Host "🔄 Cleaned up existing container" 
} catch {
    # Exception can occur Container might not exist, which is fine if running for first time
}

try {
    # Run the container
    docker run -d `
        --name $ContainerName `
        -p "${Port}:8080" `
        --restart unless-stopped `
        --health-cmd "curl -f http://localhost:8080/time || exit 1" `
        --health-interval 30s `
        --health-timeout 3s `
        --health-retries 3 `
        $ImageName

    if ($LASTEXITCODE -ne 0) {
        Write-Error " Failed to start container. Deployment aborted."
        exit 1
    }
    Write-Host " Container started successfully!" 
} catch {
    Write-Error " Error starting container: $_"
    exit 1
}

# Wait a moment for the application to start
Write-Host " Waiting for application to start..." 
Start-Sleep -Seconds 5

# Check if the application is running
try {
    $response = Invoke-WebRequest -Uri "http://localhost:${Port}/time" -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host " Application is running successfully!" 
        Write-Host " Application URL: http://localhost:${Port}/time" 
        Write-Host " Container status: $(docker ps --filter name=$ContainerName --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}')" 
    } else {
        Write-Warning " Application responded with status code: $($response.StatusCode)"
    }
} catch {
    Write-Warning " Could not verify application health: $_"
}

# Return to original directory
Set-Location ../..

Write-Host " Deployment completed successfully!" 
