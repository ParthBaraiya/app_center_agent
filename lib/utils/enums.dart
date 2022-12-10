enum UserPermission {
  manager(mappingString: 'manager'),
  developer(mappingString: 'developer'),
  viewer(mappingString: 'viewer'),
  tester(mappingString: 'tester');

  final String mappingString;

  const UserPermission({required this.mappingString});
}

enum CreationOrigin {
  appCenter('appcenter', 'App Center'),
  hockeyApp('hockeyapp', 'Hockey App'),
  codePush('codepush', 'Code Push'),
  none('', 'None');

  final String mappingString;
  final String display;

  const CreationOrigin(
    this.mappingString,
    this.display,
  );
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

    return CreationOrigin.none;
  }

  UserPermission? get toUserPermission {
    for (final permission in UserPermission.values) {
      if (permission.mappingString == this) return permission;
    }

    return null;
  }
}
