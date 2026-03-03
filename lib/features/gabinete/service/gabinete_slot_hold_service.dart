import 'dart:async';

import '../data/gabinete_repository.dart';
import '../models/gabinete_hold.dart';

class GabineteSlotHoldService {
  final GabineteRepository repository;

  GabineteSlotHoldService({
    required this.repository,
  });

  static const Duration defaultTtl = Duration(minutes: 3);

  GabineteSlotHold? _currentHold;
  Timer? _timer;

  GabineteSlotHold? get currentHold => _currentHold;

  bool get hasActiveHold => _currentHold !=null;

  Future<GabineteSlotHold> startHold({
    required String slotKey,
    required String userId,
    Duration ttl = defaultTtl,
  }) async {
    await releaseHoldIfExists(userId);

    final hold = await repository.createHold(
      slotKey: slotKey, 
      userId: userId, 
      ttl: ttl
      );

      _currentHold = hold;

      _timer?.cancel();
      _timer = Timer(ttl, () async {
        await releaseHoldIfExists(userId);
      });

      return hold;
  }

  Future<void> releaseHoldIfExists(String userId) async {
    if (_currentHold == null) return;

    try {
      await repository.releaseHold
      (
        holdId: _currentHold!.id.value, 
        userId: userId,
      );
    } catch (_) {
      
    }

    _timer?.cancel();
    _timer = null;
    _currentHold = null;
  }

  void dispose() {
    _timer?.cancel();
  }
}