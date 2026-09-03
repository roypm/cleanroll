class PhotoItem {
  const PhotoItem({required this.id, this.createdAt});

  final String id;
  final DateTime? createdAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PhotoItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
