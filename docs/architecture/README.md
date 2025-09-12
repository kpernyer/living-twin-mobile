# Living Twin Mobile Architecture

This document provides architectural diagrams for the Living Twin mobile application.

## System Structure

The following diagram shows the overall system architecture with all layers and components:

### Generated PNG Image
![System Structure](./Living%20Twin%20Mobile%20System%20Architecture.png)

### Local File Reference
```plantuml
@startuml
!include system_structure.puml
@enduml
```

[View System Structure PlantUML Source](./system_structure.puml)

## Normal User Flow

The following sequence diagram shows the typical user flow through the application:

### Generated PNG Image
![Normal Flow](./Living%20Twin%20Mobile%20Normal%20Flow.png)

### Local File Reference
```plantuml
@startuml
!include normal_flow.puml
@enduml
```

[View Normal Flow PlantUML Source](./normal_flow.puml)

## How to View These Diagrams

### Method 1: PlantUML Online Server
- Replace `your-org` in the URLs above with your actual GitHub organization
- The diagrams will render automatically in GitHub, GitLab, or any markdown viewer that supports PlantUML

### Method 2: VS Code Extension
1. Install the "PlantUML" extension by jebbs
2. Open the `.puml` files
3. Press `Alt+D` to preview

### Method 3: Local PlantUML
```bash
# Install PlantUML
brew install plantuml

# Generate PNG images
plantuml docs/architecture/system_structure.puml
plantuml docs/architecture/normal_flow.puml
```

### Method 4: IntelliJ/WebStorm
- Install PlantUML integration plugin
- Right-click on `.puml` files and select "Show PlantUML diagram"

### Method 5: Online Editor
- Copy the content from the `.puml` files
- Paste into [PlantText](https://www.planttext.com/) or [PlantUML Online](http://www.plantuml.com/plantuml/uml/)

## Architecture Overview

### Key Components

- **Presentation Layer**: Flutter widgets and screens organized by features
- **Core Layer**: Infrastructure services (DI, networking, security, caching)
- **Services Layer**: Business logic and API integration
- **Data Layer**: Models and storage (local + remote)

### Key Patterns

- **Dependency Injection**: GetIt + Injectable for clean architecture
- **State Management**: Provider pattern with mixins for reusable behavior
- **Offline-First**: SQLite caching with network fallback
- **Error Handling**: Sentry integration with structured logging
- **Security**: Secure storage for sensitive data, token management