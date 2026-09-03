class AlbumInfo {
  const AlbumInfo({
    required this.id,
    required this.name,
    required this.assetCount,
    this.coverAssetId,
  });

  final String id;
  final String name;
  final int assetCount;
  final String? coverAssetId;
}
