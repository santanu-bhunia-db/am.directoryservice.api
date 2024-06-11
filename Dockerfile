FROM artifactory.sdlc.ctl.gcp.db.com/dkr-all/dkr-mcr/dotnet/sdk:8.0.202-alpine3.19 AS build-env
WORKDIR /app

# Copy everything
COPY . ./
USER root
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

RUN rm ./NuGet.config

# Build runtime image
FROM artifactory.sdlc.ctl.gcp.db.com/dkr-all/dkr-mcr/dotnet/aspnet:8.0.2-jammy-chiseled
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "am.directoryservice.api.dll"]