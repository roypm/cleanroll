import 'photo_item.dart';

enum DecisionKind { keep, delete }

class SessionDecision {
  const SessionDecision({
    required this.photo,
    required this.kind,
    required this.index,
  });

  final PhotoItem photo;
  final DecisionKind kind;
  final int index;
}
