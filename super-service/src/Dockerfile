
# I have created a multi stage Docker file. Reason=without multi-stage build, the image size is 500mb, with multi-stage build, the image size is ~350mb
# Main objective for an extra stage build is to have a published version of SuperService ready and reduced iamge size.
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy project files and restore dependencies
COPY ["SuperService.csproj", "./"]
RUN dotnet restore "SuperService.csproj"


COPY . .
RUN dotnet build "SuperService.csproj" -c Release -o /app/build

# Publish the application- I will  use it later to be used directly in last stage build
RUN dotnet publish "SuperService.csproj" -c Release -o /app/publish

# Runtime stage(Final stage)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

# Create non-root user for security
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app
USER appuser

# Copy published application
COPY --from=build --chown=appuser:appuser /app/publish .

EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Health check added to make sure container is in desired state. We can run it from docker run command as well.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/time || exit 1

# Command to start the application
ENTRYPOINT ["dotnet", "SuperService.dll"] 