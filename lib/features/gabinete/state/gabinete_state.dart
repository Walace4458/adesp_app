import '../models/gabinete_category.dart';
import '../models/gabinete_request.dart';
import '../models/gabinete_slot.dart';

class GabineteState {
  final bool isLoading;
  final String? errorMessage;

  final List<GabineteCategory> categories;
  final List<GabineteRequest> rangeRequests;
  final List<GabineteRequest> myRequests;
  final List<GabineteRequest> allRequests;

  final GabineteSlot? selectedSlot;
  final DateTime? holdStart;

  const GabineteState({
    required this.isLoading,
    required this.categories,
    required this.rangeRequests,
    required this.myRequests,
    required this.allRequests,
    this.selectedSlot,
    this.holdStart,
    this.errorMessage,
  });

  factory GabineteState.initial() => const GabineteState(
        isLoading: false,
        categories: [],
        rangeRequests: [],
        myRequests: [],
        allRequests: [],
        selectedSlot: null,
        holdStart: null,
        errorMessage: null,
      );

  GabineteState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<GabineteCategory>? categories,
    List<GabineteRequest>? rangeRequests,
    List<GabineteRequest>? myRequests,
    List<GabineteRequest>? allRequests,
    GabineteSlot? selectedSlot,
    DateTime? holdStart,
  }) {
    return GabineteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      categories: categories ?? this.categories,
      rangeRequests: rangeRequests ?? this.rangeRequests,
      myRequests: myRequests ?? this.myRequests,
      allRequests: allRequests ?? this.allRequests,
      selectedSlot: selectedSlot,
      holdStart: holdStart,
    );
  }
}