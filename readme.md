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


# Solution

1) For the solution to be working and running , Run "pwsh Deploy.ps1" at root directory . 
2) Main reuirements- dotnet v6.0+(updated this from dotnet 3.0 which is out of support version), Docker daemon running in system to host containers, powershell in the system preinstalled
2) Deploy.ps1 content (Check requirements like dotnet & Docker + Run automated test + Build image + run container + test the apllication via health check )
3) DockerFile is created to build image 