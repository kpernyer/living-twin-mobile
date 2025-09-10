import 'package:injectable/injectable.dart';
import '../result/api_result.dart';

/// Abstract interface for API services
/// Provides type-safe API calls with proper error handling
@injectable
abstract class IApiService {
  /// Make a conversational query with memory
  Future<ApiResult<ConversationResponse>> conversationalQuery({
    required String question,
    String? conversationId,
    int k = 5,
    int memoryWindow = 10,
  });
  
  /// Get list of conversations
  Future<ApiResult<List<ConversationSummary>>> getConversations();
  
  /// Get full conversation history
  Future<ApiResult<Conversation>> getConversation(String conversationId);
  
  /// Delete a conversation
  Future<ApiResult<void>> deleteConversation(String conversationId);
  
  /// Regular query (non-conversational)
  Future<ApiResult<QueryResponse>> query({
    required String question,
    int k = 5,
  });
  
  /// Ingest documents
  Future<ApiResult<IngestResponse>> ingestDocument({
    required String content,
    required String title,
    String? source,
    Map<String, dynamic>? metadata,
  });
  
  /// Health check
  Future<ApiResult<HealthStatus>> healthCheck();
}

/// Data classes for API responses
class ConversationResponse {
  final String answer;
  final String conversationId;
  final List<Map<String, dynamic>> sources;
  final double confidence;
  
  const ConversationResponse({
    required this.answer,
    required this.conversationId,
    required this.sources,
    required this.confidence,
  });
  
  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      answer: json['answer'] ?? '',
      conversationId: json['conversationId'] ?? '',
      sources: List<Map<String, dynamic>>.from(json['sources'] ?? []),
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }
}

class ConversationSummary {
  final String id;
  final String title;
  final DateTime lastModified;
  
  const ConversationSummary({
    required this.id,
    required this.title,
    required this.lastModified,
  });
  
  factory ConversationSummary.fromJson(Map<String, dynamic> json) {
    return ConversationSummary(
      id: json['id'],
      title: json['title'],
      lastModified: DateTime.parse(json['lastModified']),
    );
  }
}

class Conversation {
  final String id;
  final String title;
  final List<ConversationMessage> messages;
  final DateTime createdAt;
  final DateTime lastModified;
  
  const Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.lastModified,
  });
  
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((m) => ConversationMessage.fromJson(m))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      lastModified: DateTime.parse(json['lastModified']),
    );
  }
}

class ConversationMessage {
  final String role;
  final String content;
  final DateTime timestamp;
  
  const ConversationMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });
  
  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      role: json['role'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class QueryResponse {
  final String answer;
  final List<Map<String, dynamic>> sources;
  final double confidence;
  
  const QueryResponse({
    required this.answer,
    required this.sources,
    required this.confidence,
  });
  
  factory QueryResponse.fromJson(Map<String, dynamic> json) {
    return QueryResponse(
      answer: json['answer'] ?? '',
      sources: List<Map<String, dynamic>>.from(json['sources'] ?? []),
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }
}

class IngestResponse {
  final String message;
  final String? documentId;
  
  const IngestResponse({
    required this.message,
    this.documentId,
  });
  
  factory IngestResponse.fromJson(Map<String, dynamic> json) {
    return IngestResponse(
      message: json['message'] ?? 'Document ingested successfully',
      documentId: json['documentId'],
    );
  }
}

class HealthStatus {
  final String status;
  final Map<String, dynamic>? details;
  
  const HealthStatus({
    required this.status,
    this.details,
  });
  
  factory HealthStatus.fromJson(Map<String, dynamic> json) {
    return HealthStatus(
      status: json['status'] ?? 'unknown',
      details: json['details'],
    );
  }
}