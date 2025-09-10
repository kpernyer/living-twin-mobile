import 'package:injectable/injectable.dart';

/// Abstract interface for authentication services
/// This allows for easier testing and multiple implementations
@injectable
abstract class IAuthService {
  /// Check if user is authenticated
  bool get isAuthenticated;
  
  /// Get current user data
  Map<String, dynamic>? get currentUser;
  
  /// Get authentication token
  String? get authToken;
  
  /// Initialize the auth service
  Future<void> initialize();
  
  /// Sign in anonymously
  Future<Map<String, dynamic>> signInAnonymously();
  
  /// Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  /// Create user with email and password
  Future<Map<String, dynamic>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });
  
  /// Sign in with Google
  Future<Map<String, dynamic>> signInWithGoogle();
  
  /// Sign out
  Future<void> signOut();
  
  /// Get ID token for API calls
  Future<String?> getIdToken();
  
  /// Refresh authentication token
  Future<String?> refreshToken();
  
  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? displayName,
    String? photoURL,
  });
  
  /// Get user claims for authorization
  Map<String, dynamic> getUserClaims();
  
  /// Check if user has specific permission
  bool hasPermission(String permission);
  
  /// Get tenant ID for multi-tenancy
  String getTenantId();
  
  /// Accept invitation to join organization
  Future<Map<String, dynamic>> acceptInvitation(String invitationCode);
  
  /// Create new organization
  Future<Map<String, dynamic>> createOrganization({
    required String name,
    required String industry,
    required String size,
    String? department,
    String? role,
  });
  
  /// Generate invitation code for organization
  Future<String?> generateInvitationCode();
  
  /// Get organization information
  Map<String, dynamic>? getOrganization();
  
  /// Check if user is organization admin
  bool isOrganizationAdmin();
  
  /// Update organization settings
  Future<Map<String, dynamic>> updateOrganization({
    String? name,
    String? industry,
    String? size,
  });
}