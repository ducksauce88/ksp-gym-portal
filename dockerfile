# FROM mcr.microsoft.com/dotnet/core/sdk:2.2
# WORKDIR /app
# COPY /app /app
# ENTRYPOINT ["dotnet", "ksp-portal.dll"]

# First stage of multi-stage build
FROM FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /app

# copy the contents of agent working directory on host to workdir in container
COPY . ./

# dotnet commands to build, test, and publish
RUN dotnet restore
RUN dotnet build -c Release
RUN dotnet publish -c Release -o out

# Second stage - Build runtime image
FROM FROM mcr.microsoft.com/dotnet/core/sdk:2.2
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "ksp-portal.dll"]