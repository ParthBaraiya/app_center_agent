enum UserPermission {
  manager(mappingString: "manager"),
  developer(mappingString: "developer"),
  viewer(mappingString: "viewer"),
  tester(mappingString: "tester");

  final String mappingString;

  const UserPermission({required this.mappingString});
}

enum CreationOrigin {
  appCenter(mappingString: 'appcenter'),
  hockeyApp(mappingString: 'hockeyapp'),
  codePush(mappingString: 'codepush');

  final String mappingString;

  const CreationOrigin({required this.mappingString});
}

enum NetworkState {
  idle,
  loading,
  success,
  error;

  bool get isIdle => this == NetworkState.idle;
  bool get isLoading => this == NetworkState.loading;
  bool get isSuccess => this == NetworkState.success;
  bool get isError => this == NetworkState.error;
}

extension StringToEnumExtension on String {
  CreationOrigin get toCreationOrigin {
    for (final origin in CreationOrigin.values) {
      if (origin.mappingString == this) return origin;
    }

    throw StateError('Invalid string');
  }

  UserPermission get toUserPermission {
    for (final permission in UserPermission.values) {
      if (permission.mappingString == this) return permission;
    }

    throw StateError('Invalid string');
  }
}
