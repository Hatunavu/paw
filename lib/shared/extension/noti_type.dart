enum NotiType { comment, like, follow }

extension NotiTypeExtension on NotiType {
  String get type {
    switch (this) {
      case NotiType.follow:
        return 'follow';
      case NotiType.like:
        return 'like';
      case NotiType.comment:
        return 'comment';
    }
  }
}

extension NotiTypeValueExtension on String {
  NotiType get toNotiType {
    switch (this) {
      case 'follow':
        return NotiType.follow;
      case 'like':
        return NotiType.like;
      case 'comment':
        return NotiType.comment;
    }
  }
}
