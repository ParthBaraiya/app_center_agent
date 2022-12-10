import 'package:app_center_agent/apiservice/repository.dart';
import 'package:app_center_agent/stores/network_store.dart';
import 'package:app_center_agent/stores/user_store.dart';
import 'package:app_center_agent/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'organization_store.g.dart';

class OrganizationStore = _OrganizationStore with _$OrganizationStore;

abstract class _OrganizationStore extends NetworkStore with Store {
  _OrganizationStore({
    required String name,
    required String displayName,
    required CreationOrigin origin,
    required this.user,
  })  : _name = name,
        _displayName = displayName,
        _origin = origin {
    loadOrganization();
  }

  late final String _name;
  late final String _displayName;
  late final CreationOrigin _origin;
  late final UserStore user;

  @observable
  OrganizationModel? organization;

  @computed
  CreationOrigin get origin => organization?.origin ?? _origin;

  @computed
  String get name => organization?.name ?? _name;

  @computed
  String get displayName => organization?.displayName ?? _displayName;

  Future<void> loadOrganization({bool force = false}) async {
    if ((_name.isEmpty || organization != null) && !force) return;

    await networkCall(() async {
      organization = await ApiRepository.instance
          .getOrganization(name: name, token: user.token);
    });
  }
}

@immutable
class OrganizationModel {
  final String displayName;
  final String name;
  final CreationOrigin origin;
  final String id;
  final String? avatar;
  final DateTime createdDate;
  final DateTime updatedDate;

  const OrganizationModel({
    required this.displayName,
    required this.name,
    required this.origin,
    required this.avatar,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      OrganizationModel(
        displayName: json['display_name'] as String,
        name: json['name'] as String,
        origin: (json['origin'] as String).toCreationOrigin,
        createdDate: DateTime.parse(json['created_at'] as String? ?? ''),
        updatedDate: DateTime.parse(json['updated_at'] as String? ?? ''),
        avatar: json['avatar_url'] as String?,
        id: json['id'],
      );

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant OrganizationModel other) => id == other.id;
}
