FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

COPY . .
RUN dotnet restore "container-registry.csproj"

RUN dotnet build "container-registry.csproj" -c Release -o /app/build

FROM build AS publish
ARG PROJECT_NAME
RUN dotnet publish "container-registry..csproj" -c Release -o /app/publish


FROM base AS final
ARG PROJECT_NAME
WORKDIR /app
COPY --from=publish /app/publish .
ENV DLL_NAME="container-registry.dll"

ENTRYPOINT ["sh","-c","dotnet ${DLL_NAME}"]