import '../models/gabinete_category.dart';
import '../models/gabinete_hold.dart';
import '../models/gabinete_request.dart';
import '../models/gabinete_enums.dart';

abstract class GabineteRepository {
  // Catalog
  Future<List<GabineteCategory>> fetchCategories();

  // Requests
  Future<List<GabineteRequest>> fetchRequestsInRange(
    DateTime start,
    DateTime endExclusive,
  );

  Future<List<GabineteRequest>> fetchMyRequests(String userId);

  Future<List<GabineteRequest>> fetchAllRequests();

  // Holds
  Future<GabineteSlotHold> createHold({
    required String slotKey,
    required String userId,
    required Duration ttl,
  });

  Future<void> releaseHold({
    required String holdId,
    required String userId,
  });

  /// Consome o hold e cria o request.
  /// (No app, o membro só solicita. Decisão/atribuição fica pro painel web.)
  Future<GabineteRequest> createRequestFromHold({
    required String holdId,
    required String userId,
    required String categoryId,
    required String memberName,
    required String whatsapp,
    required String? note,
  });

  /// Admin muda status (confirm/cancel/complete).
  Future<GabineteRequest> adminUpdateStatus({
    required String requestId,
    required String adminUserId,
    required GabineteRequestStatus newStatus,
  });
}