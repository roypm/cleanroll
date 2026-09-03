enum PhotoPermission { unknown, granted, limited, denied, permanentlyDenied }

extension PhotoPermissionX on PhotoPermission {
  bool get hasAccess =>
      this == PhotoPermission.granted || this == PhotoPermission.limited;
}
