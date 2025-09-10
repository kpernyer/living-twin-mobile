import 'package:injectable/injectable.dart';
import '../core/api/api_service_interface.dart';
import '../core/network/dio_client.dart';
import '../core/result/api_result.dart';

@LazySingleton(as: IApiService)
class ApiService implements IApiService {
  final DioClient _dioClient;
  
  ApiService(this._dioClient);
  
  @override
  Future<ApiResult<ConversationResponse>> conversationalQuery({
    required String question,
    String? conversationId,
    int k = 5,
    int memoryWindow = 10,
  }) async {
    final body = {
      'question': question,
      'k': k,
      'memoryWindow': memoryWindow,
      if (conversationId != null) 'conversationId': conversationId,
    };

    return _dioClient.post<ConversationResponse>(
      path: '/query/conversation/query',
      data: body,
      fromJson: ConversationResponse.fromJson,
    );
  }

  @override
  Future<ApiResult<List<ConversationSummary>>> getConversations() async {
    return _dioClient.get<List<ConversationSummary>>(
      path: '/query/conversations',
      fromJson: (json) => (json['conversations'] as List)
          .map((item) => ConversationSummary.fromJson(item))
          .toList(),
    );
  }

  @override
  Future<ApiResult<Conversation>> getConversation(String conversationId) async {
    return _dioClient.get<Conversation>(
      path: '/query/conversations/$conversationId',
      fromJson: Conversation.fromJson,
    );
  }

  @override
  Future<ApiResult<void>> deleteConversation(String conversationId) async {
    return _dioClient.delete<void>(
      path: '/query/conversations/$conversationId',
    );
  }

  @override
  Future<ApiResult<QueryResponse>> query({
    required String question,
    int k = 5,
  }) async {
    final body = {
      'question': question,
      'k': k,
    };

    return _dioClient.post<QueryResponse>(
      path: '/query',
      data: body,
      fromJson: QueryResponse.fromJson,
    );
  }

  @override
  Future<ApiResult<IngestResponse>> ingestDocument({
    required String content,
    required String title,
    String? source,
    Map<String, dynamic>? metadata,
  }) async {
    final body = {
      'content': content,
      'title': title,
      if (source != null) 'source': source,
      if (metadata != null) 'metadata': metadata,
    };

    return _dioClient.post<IngestResponse>(
      path: '/ingest',
      data: body,
      fromJson: IngestResponse.fromJson,
    );
  }

  @override
  Future<ApiResult<HealthStatus>> healthCheck() async {
    return _dioClient.get<HealthStatus>(
      path: '/healthz',
      fromJson: HealthStatus.fromJson,
    );
  }
}