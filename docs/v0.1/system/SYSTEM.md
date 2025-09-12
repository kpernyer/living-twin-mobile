# Living Twin Mobile - System Overview

*Auto-generated system documentation*

Generated on: 2025-09-12T12:12:36.831537

## System Architecture

![System Architecture](https://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/kpernyer/living-twin-mobile/main/docs/v0.1/system/system_architecture.puml)

### Architecture Layers

#### Features Layer (7 features)
- **home**: 1 components
  - home_screen
- **chat**: 2 components
  - chat_screen
  - conversational_chat_screen
- **auth**: 1 components
  - login_screen
- **ingest**: 1 components
  - ingest_screen
- **pulse**: 1 components
  - pulse_screen
- **communication**: 1 components
  - communication_screen
- **onboarding**: 1 components
  - organization_setup_screen

#### Services Layer (7 services)
- **auth**: 1 classes
  - AuthService
- **speech_service**: 2 classes
  - SpeechResult
  - SpeechService
- **auth_service_di**: 1 classes
  - AuthServiceDI
- **api_service**: 1 classes
  - ApiService
- **api_client_enhanced**: 1 classes
  - ApiClientEnhanced
- **communication_service**: 3 classes
  - Communication
  - CommunicationResponse
  - CommunicationService
- **local_storage**: 1 classes
  - LocalStorageService

#### Core Layer (17 components)
- api_result
- auth_result
- injection.config
- injection
- cache_manager
- error_handling_mixin
- loading_mixin
- secure_storage_service
- auth_service_interface
- dio_client
- debouncer
- datetime_extensions
- context_extensions
- string_extensions
- api_service_interface
- sentry_config

#### Data Layer (13 models)
- **organization.freezed**: 0 classes
- **organization.g**: 0 classes
- **organization**: 4 classes
  - Organization
  - BrandingConfig
  - OrganizationMember
  - OrganizationInvitation
- **schema**: 26 classes
  - StorageKeys
  - BaseEntity
  - TenantSettings
  - TenantModel
  - UserPreferences
  - UserModel
  - TeamSettings
  - TeamModel
  - GoalModel
  - DocumentModel
  - ChunkModel
  - ApiResponse
  - PaginationInfo
  - PaginatedResponse
  - SearchFilters
  - DateRange
  - SearchRequest
  - SearchResult
  - SearchResponse
  - PubSubMessageMetadata
  - PubSubMessage
  - CreateTenantForm
  - CreateUserForm
  - CreateGoalForm
  - ValidationPatterns
  - ValidationRules
- **goal_model**: 3 classes
  - GoalModel
  - GoalsState
  - GoalsBloc
- **chat_message**: 1 classes
  - ChatMessage
- **user_model.g**: 0 classes
- **goal_model.freezed**: 0 classes
- **user_model**: 2 classes
  - UserPreferences
  - UserModel
- **chat_message.freezed**: 0 classes
- **goal_model.g**: 0 classes
- **chat_message.g**: 0 classes
- **user_model.freezed**: 0 classes

## Component Relationships

![Component Diagram](https://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/kpernyer/living-twin-mobile/main/docs/v0.1/system/component_diagram.puml)

### Key Dependencies
- GetIt DI
- Injectable
- Dio HTTP
- SharedPreferences
- Sentry

## User Flows

![User Flow](https://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/kpernyer/living-twin-mobile/main/docs/v0.1/system/user_flow.puml)

### Identified User Journeys
- Application initialization and dependency injection
- Authentication and authorization flow
- Home screen and dashboard
- Chat and messaging functionality

## Technical Architecture

### Key Patterns Identified
- **Dependency Injection**: GetIt + Injectable pattern
- **Feature-based Architecture**: Modular feature organization
- **Service Layer**: Business logic separation
- **Data Models**: Structured data representation

### External Dependencies
- **GetIt DI**: Core system dependency
- **Injectable**: Core system dependency
- **Dio HTTP**: Core system dependency
- **SharedPreferences**: Core system dependency
- **Sentry**: Core system dependency

## PlantUML Source Files

- [System Architecture](./system_architecture.puml)
- [Component Diagram](./component_diagram.puml)
- [User Flow](./user_flow.puml)

---
*This documentation is automatically generated. To update, run: `make uml`*
