#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Automated PlantUML generator for Living Twin Mobile
/// 
/// Usage: dart tools/generate_uml.dart
/// 
/// This script analyzes the codebase and generates:
/// - System architecture diagrams
/// - Component relationship diagrams  
/// - User flow diagrams
/// - System description markdown

class UMLGenerator {
  final String projectRoot;
  final String docsPath;
  final String libPath;
  
  // Analysis results
  Map<String, List<String>> features = {};
  Map<String, List<String>> services = {};
  Map<String, List<String>> models = {};
  List<String> coreComponents = [];
  Map<String, List<String>> dependencies = {};
  
  UMLGenerator(this.projectRoot) 
      : docsPath = '$projectRoot/docs/system',
        libPath = '$projectRoot/lib';

  Future<void> generateAll() async {
    print('🔍 Analyzing codebase...');
    await analyzeCodebase();
    
    print('📊 Generating system architecture...');
    await generateSystemArchitecture();
    
    print('🔄 Generating component diagram...');
    await generateComponentDiagram();
    
    print('👤 Generating user flows...');
    await generateUserFlows();
    
    print('📝 Creating system description...');
    await generateSystemDescription();
    
    print('🖼️ Rendering PlantUML diagrams...');
    await renderDiagrams();
    
    print('✅ UML generation complete!');
    print('📂 Check: docs/system/');
  }

  Future<void> analyzeCodebase() async {
    final libDir = Directory(libPath);
    if (!await libDir.exists()) {
      throw Exception('lib directory not found');
    }

    await _analyzeDirectory(libDir);
    await _analyzeDependencies();
  }

  Future<void> _analyzeDirectory(Directory dir) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        await _analyzeFile(entity);
      }
    }
  }

  Future<void> _analyzeFile(File file) async {
    final content = await file.readAsString();
    final relativePath = file.path.replaceFirst(projectRoot, '');
    
    // Categorize by directory structure
    if (relativePath.contains('/features/')) {
      final feature = _extractFeatureName(relativePath);
      features[feature] = features[feature] ?? [];
      features[feature]!.add(_extractFileName(file.path));
    } else if (relativePath.contains('/services/')) {
      final serviceName = _extractFileName(file.path);
      services[serviceName] = _extractClasses(content);
    } else if (relativePath.contains('/models/')) {
      final modelName = _extractFileName(file.path);
      models[modelName] = _extractClasses(content);
    } else if (relativePath.contains('/core/')) {
      coreComponents.add(_extractFileName(file.path));
    }
    
    // Extract dependencies
    dependencies[_extractFileName(file.path)] = _extractImports(content);
  }

  String _extractFeatureName(String path) {
    final match = RegExp(r'/features/([^/]+)/').firstMatch(path);
    return match?.group(1) ?? 'unknown';
  }

  String _extractFileName(String path) {
    return path.split('/').last.replaceAll('.dart', '');
  }

  List<String> _extractClasses(String content) {
    final classes = <String>[];
    final regex = RegExp(r'class\s+([A-Z]\w+)');
    regex.allMatches(content).forEach((match) {
      classes.add(match.group(1)!);
    });
    return classes;
  }

  List<String> _extractImports(String content) {
    final imports = <String>[];
    // Simple pattern matching for imports
    final lines = content.split('\n');
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('import ')) {
        // Extract import path - try both single and double quotes
        var match = RegExp(r"import\s+'(.+?)'").firstMatch(trimmed);
        match ??= RegExp(r'import\s+"(.+?)"').firstMatch(trimmed);
        
        if (match != null) {
          final import = match.group(1)!;
          if (!import.startsWith('dart:') && !import.startsWith('package:flutter')) {
            imports.add(import);
          }
        }
      }
    }
    return imports;
  }

  Future<void> _analyzeDependencies() async {
    final pubspecFile = File('$projectRoot/pubspec.yaml');
    if (await pubspecFile.exists()) {
      final content = await pubspecFile.readAsString();
      // Extract key dependencies for architecture diagram
      dependencies['external'] = [];
      if (content.contains('get_it:')) dependencies['external']!.add('GetIt DI');
      if (content.contains('injectable:')) dependencies['external']!.add('Injectable');
      if (content.contains('dio:')) dependencies['external']!.add('Dio HTTP');
      if (content.contains('shared_preferences:')) dependencies['external']!.add('SharedPreferences');
      if (content.contains('sentry_flutter:')) dependencies['external']!.add('Sentry');
      if (content.contains('sqlite')) dependencies['external']!.add('SQLite');
    }
  }

  Future<void> generateSystemArchitecture() async {
    final uml = StringBuffer();
    uml.writeln('@startuml Living Twin Mobile - System Architecture');
    uml.writeln('!theme plain');
    uml.writeln('title Living Twin Mobile - Generated System Architecture');
    uml.writeln('');
    
    // External layer
    uml.writeln('package "External Services" {');
    uml.writeln('  [Living Twin API] as API');
    uml.writeln('  [AprioOne System] as AprioOne');
    for (final dep in dependencies['external'] ?? []) {
      final name = dep.replaceAll(' ', '');
      uml.writeln('  [$dep] as $name');
    }
    uml.writeln('}');
    uml.writeln('');
    
    // Features layer
    uml.writeln('package "Features Layer" {');
    for (final feature in features.keys) {
      final featureName = feature[0].toUpperCase() + feature.substring(1);
      uml.writeln('  package "$featureName" {');
      for (final component in features[feature]!) {
        uml.writeln('    [$component]');
      }
      uml.writeln('  }');
    }
    uml.writeln('}');
    uml.writeln('');
    
    // Services layer
    uml.writeln('package "Services Layer" {');
    for (final service in services.keys) {
      uml.writeln('  [$service] as ${service}Service');
    }
    uml.writeln('}');
    uml.writeln('');
    
    // Core layer
    uml.writeln('package "Core Layer" {');
    for (final core in coreComponents) {
      if (!core.contains('test')) {
        uml.writeln('  [$core]');
      }
    }
    uml.writeln('}');
    uml.writeln('');
    
    // Models layer
    uml.writeln('package "Data Layer" {');
    for (final model in models.keys) {
      uml.writeln('  [$model] as ${model}Model');
    }
    uml.writeln('}');
    uml.writeln('');
    
    // Basic relationships
    uml.writeln('Features --> Services');
    uml.writeln('Services --> Core');
    uml.writeln('Services --> Data');
    uml.writeln('Core --> External');
    uml.writeln('');
    
    uml.writeln('@enduml');
    
    await _writeUMLFile('system_architecture.puml', uml.toString());
  }

  Future<void> generateComponentDiagram() async {
    final uml = StringBuffer();
    uml.writeln('@startuml Living Twin Mobile - Component Relationships');
    uml.writeln('!theme plain');
    uml.writeln('title Component Dependencies - Auto Generated');
    uml.writeln('');
    
    // Main app component
    uml.writeln('component "Living Twin App" as App {');
    uml.writeln('  [Main] --> [AuthWrapper]');
    uml.writeln('  [AuthWrapper] --> [LoginScreen]');
    uml.writeln('  [AuthWrapper] --> [MainScreen]');
    uml.writeln('}');
    uml.writeln('');
    
    // Feature components
    for (final feature in features.keys) {
      uml.writeln('package "$feature Feature" {');
      for (final component in features[feature]!) {
        uml.writeln('  component [$component]');
      }
      uml.writeln('}');
      uml.writeln('');
    }
    
    // Service dependencies
    uml.writeln('package "Service Layer" {');
    for (final service in services.keys) {
      uml.writeln('  interface ${service}Interface');
      uml.writeln('  component [$service]');
      uml.writeln('  ${service}Interface <|.. $service');
    }
    uml.writeln('}');
    uml.writeln('');
    
    // Show key relationships
    if (features.containsKey('auth')) {
      uml.writeln('[AuthWrapper] --> [AuthService]');
    }
    if (features.containsKey('home')) {
      uml.writeln('[MainScreen] --> [HomeScreen]');
    }
    if (features.containsKey('chat')) {
      uml.writeln('[MainScreen] --> [ChatScreen]');
    }
    
    uml.writeln('@enduml');
    
    await _writeUMLFile('component_diagram.puml', uml.toString());
  }

  Future<void> generateUserFlows() async {
    final uml = StringBuffer();
    uml.writeln('@startuml Living Twin Mobile - User Flow');
    uml.writeln('title User Flow - Auto Generated from Code Analysis');
    uml.writeln('');
    
    uml.writeln('actor User');
    uml.writeln('participant App');
    
    // Add participants based on discovered features
    for (final feature in features.keys) {
      final featureName = feature[0].toUpperCase() + feature.substring(1);
      uml.writeln('participant "${featureName}Screen" as $feature');
    }
    
    // Add service participants
    for (final service in services.keys) {
      uml.writeln('participant "$service" as ${service}Svc');
    }
    
    uml.writeln('');
    uml.writeln('== Application Launch ==');
    uml.writeln('User -> App: Launch app');
    uml.writeln('App -> App: Initialize DI');
    
    if (services.containsKey('auth')) {
      uml.writeln('App -> authSvc: initialize()');
    }
    
    uml.writeln('');
    uml.writeln('== Authentication Flow ==');
    if (features.containsKey('auth')) {
      uml.writeln('App -> auth: Show login');
      uml.writeln('User -> auth: Enter credentials');
      if (services.containsKey('auth')) {
        uml.writeln('auth -> authSvc: signIn()');
        uml.writeln('authSvc -> auth: Return result');
      }
    }
    
    uml.writeln('');
    uml.writeln('== Main Features ==');
    if (features.containsKey('home')) {
      uml.writeln('auth -> home: Navigate to home');
    }
    if (features.containsKey('chat')) {
      uml.writeln('User -> chat: Open chat');
    }
    
    uml.writeln('');
    uml.writeln('@enduml');
    
    await _writeUMLFile('user_flow.puml', uml.toString());
  }

  Future<void> generateSystemDescription() async {
    final md = StringBuffer();
    
    md.writeln('# Living Twin Mobile - System Overview');
    md.writeln('');
    md.writeln('*Auto-generated system documentation*');
    md.writeln('');
    md.writeln('Generated on: ${DateTime.now().toIso8601String()}');
    md.writeln('');
    
    // System Architecture
    md.writeln('## System Architecture');
    md.writeln('');
    md.writeln('![System Architecture](./system_architecture.png)');
    md.writeln('');
    md.writeln('### Architecture Layers');
    md.writeln('');
    
    // Features analysis
    md.writeln('#### Features Layer (${features.length} features)');
    for (final feature in features.entries) {
      md.writeln('- **${feature.key}**: ${feature.value.length} components');
      for (final component in feature.value) {
        md.writeln('  - ${component}');
      }
    }
    md.writeln('');
    
    // Services analysis
    md.writeln('#### Services Layer (${services.length} services)');
    for (final service in services.entries) {
      md.writeln('- **${service.key}**: ${service.value.length} classes');
      for (final className in service.value) {
        md.writeln('  - ${className}');
      }
    }
    md.writeln('');
    
    // Core components
    md.writeln('#### Core Layer (${coreComponents.length} components)');
    for (final core in coreComponents) {
      if (!core.contains('test')) {
        md.writeln('- ${core}');
      }
    }
    md.writeln('');
    
    // Models
    md.writeln('#### Data Layer (${models.length} models)');
    for (final model in models.entries) {
      md.writeln('- **${model.key}**: ${model.value.length} classes');
      for (final className in model.value) {
        md.writeln('  - ${className}');
      }
    }
    md.writeln('');
    
    // Component Relationships
    md.writeln('## Component Relationships');
    md.writeln('');
    md.writeln('![Component Diagram](./component_diagram.png)');
    md.writeln('');
    md.writeln('### Key Dependencies');
    final externalDeps = dependencies['external'] ?? [];
    for (final dep in externalDeps) {
      md.writeln('- ${dep}');
    }
    md.writeln('');
    
    // User Flows
    md.writeln('## User Flows');
    md.writeln('');
    md.writeln('![User Flow](./user_flow.png)');
    md.writeln('');
    md.writeln('### Identified User Journeys');
    md.writeln('- Application initialization and dependency injection');
    if (features.containsKey('auth')) {
      md.writeln('- Authentication and authorization flow');
    }
    if (features.containsKey('home')) {
      md.writeln('- Home screen and dashboard');
    }
    if (features.containsKey('chat')) {
      md.writeln('- Chat and messaging functionality');
    }
    md.writeln('');
    
    // Technical Details
    md.writeln('## Technical Architecture');
    md.writeln('');
    md.writeln('### Key Patterns Identified');
    md.writeln('- **Dependency Injection**: GetIt + Injectable pattern');
    md.writeln('- **Feature-based Architecture**: Modular feature organization');
    md.writeln('- **Service Layer**: Business logic separation');
    md.writeln('- **Data Models**: Structured data representation');
    md.writeln('');
    
    md.writeln('### External Dependencies');
    for (final dep in externalDeps) {
      md.writeln('- **${dep}**: Core system dependency');
    }
    md.writeln('');
    
    md.writeln('## PlantUML Source Files');
    md.writeln('');
    md.writeln('- [System Architecture](./system_architecture.puml)');
    md.writeln('- [Component Diagram](./component_diagram.puml)');
    md.writeln('- [User Flow](./user_flow.puml)');
    md.writeln('');
    
    md.writeln('---');
    md.writeln('*This documentation is automatically generated. To update, run: `make uml`*');
    
    await _writeFile('SYSTEM.md', md.toString());
  }

  Future<void> renderDiagrams() async {
    final plantUMLFiles = [
      'system_architecture.puml',
      'component_diagram.puml', 
      'user_flow.puml'
    ];
    
    for (final file in plantUMLFiles) {
      final result = await Process.run('plantuml', [
        '$docsPath/$file'
      ]);
      
      if (result.exitCode != 0) {
        print('⚠️  Warning: Could not render $file');
        print('   Install PlantUML: brew install plantuml');
        print('   Or view .puml files in VS Code with PlantUML extension');
      }
    }
  }

  Future<void> _writeUMLFile(String filename, String content) async {
    await _writeFile(filename, content);
  }

  Future<void> _writeFile(String filename, String content) async {
    final docsDir = Directory(docsPath);
    if (!await docsDir.exists()) {
      await docsDir.create(recursive: true);
    }
    
    final file = File('$docsPath/$filename');
    await file.writeAsString(content);
    print('📝 Generated: ${file.path}');
  }
}

Future<void> main(List<String> args) async {
  try {
    final projectRoot = Directory.current.path;
    final generator = UMLGenerator(projectRoot);
    
    print('🚀 Living Twin Mobile - UML Generator');
    print('📂 Project: $projectRoot');
    print('');
    
    await generator.generateAll();
    
    print('');
    print('🎉 System documentation generated successfully!');
    print('📖 View: docs/system/SYSTEM.md');
    
  } catch (e, stackTrace) {
    print('❌ Error: $e');
    print('📍 Stack trace:');
    print(stackTrace);
    exit(1);
  }
}