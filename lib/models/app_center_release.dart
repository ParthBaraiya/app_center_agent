import 'package:app_center_agent/utils/extension.dart';
import 'package:intl/intl.dart';

class AppCenterRelease extends _AppCenterReleaseBase {
  final bool? mandatoryUpdate;

  AppCenterRelease({
    super.id,
    super.version,
    super.origin,
    super.shortVersion,
    this.mandatoryUpdate,
    super.uploadedAt,
    super.enabled,
    super.isExternalBuild,
  });

  factory AppCenterRelease.fromJson(Map<String, dynamic> json) =>
      AppCenterRelease(
        id: json['id'],
        version: json['version'],
        origin: json['origin'],
        shortVersion: json['short_version'],
        mandatoryUpdate: json['mandatory_update'],
        uploadedAt: json['uploaded_at'],
        enabled: json['enabled'],
        isExternalBuild: json['is_external_build'],
      );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'mandatory_update': mandatoryUpdate,
      };
}

class AppCenterReleaseDetails extends _AppCenterReleaseBase {
  final String? appName;
  final String? appDisplayName;
  final String? appOs;
  final String? releaseNotes;
  final String? provisioningProfileName;
  final String? provisioningProfileType;
  final String? provisioningProfileExpiryDate;
  final bool? isProvisioningProfileSyncing;
  final int? size;
  final String? minOs;
  final String? deviceFamily;
  final String? androidMinApiLevel;
  final String? bundleIdentifier;
  final List<String>? packageHashes;
  final String? fingerprint;
  final String? downloadUrl;
  final String? secondaryDownloadUrl;
  final String? appIconUrl;
  final String? installUrl;
  final String? destinationType;
  final List<ReleaseDistributionGroup>? distributionGroups;
  final List<DistributionStore>? distributionStores;
  final List<ReleaseDestination>? destinations;
  final bool? isUdidProvisioned;
  final bool? canResign;
  final Build? build;
  final String? status;

  AppCenterReleaseDetails({
    super.id,
    this.appName,
    this.appDisplayName,
    this.appOs,
    super.version,
    super.origin,
    super.shortVersion,
    this.releaseNotes,
    this.provisioningProfileName,
    this.provisioningProfileType,
    this.provisioningProfileExpiryDate,
    this.isProvisioningProfileSyncing,
    this.size,
    this.minOs,
    this.deviceFamily,
    this.androidMinApiLevel,
    this.bundleIdentifier,
    this.packageHashes,
    this.fingerprint,
    super.uploadedAt,
    this.downloadUrl,
    this.secondaryDownloadUrl,
    this.appIconUrl,
    this.installUrl,
    this.destinationType,
    this.distributionGroups,
    this.distributionStores,
    this.destinations,
    this.isUdidProvisioned,
    this.canResign,
    this.build,
    super.enabled,
    this.status,
    super.isExternalBuild,
  });

  factory AppCenterReleaseDetails.fromJson(Map<String, dynamic> json) =>
      AppCenterReleaseDetails(
        id: json['id'],
        appName: json['app_name'],
        appDisplayName: json['app_display_name'],
        appOs: json['app_os'],
        version: json['version'],
        origin: json['origin'],
        shortVersion: json['short_version'],
        releaseNotes: json['release_notes'],
        provisioningProfileName: json['provisioning_profile_name'],
        provisioningProfileType: json['provisioning_profile_type'],
        provisioningProfileExpiryDate: json['provisioning_profile_expiry_date'],
        isProvisioningProfileSyncing: json['is_provisioning_profile_syncing'],
        size: json['size'],
        minOs: json['min_os'],
        deviceFamily: json['device_family'],
        androidMinApiLevel: json['android_min_api_level'],
        bundleIdentifier: json['bundle_identifier'],
        packageHashes: json['package_hashes'] == null
            ? []
            : List<String>.from(json['package_hashes']!.map((x) => x)),
        fingerprint: json['fingerprint'],
        uploadedAt: json['uploaded_at'],
        downloadUrl: json['download_url'],
        secondaryDownloadUrl: json['secondary_download_url'],
        appIconUrl: json['app_icon_url'],
        installUrl: json['install_url'],
        destinationType: json['destination_type'],
        distributionGroups: json['distribution_groups'] == null
            ? []
            : List<ReleaseDistributionGroup>.from(json['distribution_groups']!
                .map((x) => ReleaseDistributionGroup.fromJson(x))),
        distributionStores: json['distribution_stores'] == null
            ? []
            : List<DistributionStore>.from(json['distribution_stores']!
                .map((x) => DistributionStore.fromJson(x))),
        destinations: json['destinations'] == null
            ? []
            : List<ReleaseDestination>.from(json['destinations']!
                .map((x) => ReleaseDestination.fromJson(x))),
        isUdidProvisioned: json['is_udid_provisioned'],
        canResign: json['can_resign'],
        build: json['build'] == null ? null : Build.fromJson(json['build']),
        enabled: json['enabled'],
        status: json['status'],
        isExternalBuild: json['is_external_build'],
      );

  static const _sizeSuffixes = ['B', 'KB', 'MB', 'GB', 'TB'];

  String get displaySize {
    var suffixIndex = 0;
    double reminder = size?.toDouble() ?? 0.0;

    while (reminder > 1000) {
      reminder = reminder / 1000;
      suffixIndex++;
    }

    return '${reminder == reminder.toInt() ? reminder : reminder.toStringAsFixed(2)} ${_sizeSuffixes[suffixIndex]}';
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'app_name': appName,
        'app_display_name': appDisplayName,
        'app_os': appOs,
        'release_notes': releaseNotes,
        'provisioning_profile_name': provisioningProfileName,
        'provisioning_profile_type': provisioningProfileType,
        'provisioning_profile_expiry_date': provisioningProfileExpiryDate,
        'is_provisioning_profile_syncing': isProvisioningProfileSyncing,
        'size': size,
        'min_os': minOs,
        'device_family': deviceFamily,
        'android_min_api_level': androidMinApiLevel,
        'bundle_identifier': bundleIdentifier,
        'package_hashes': packageHashes == null
            ? []
            : List<dynamic>.from(packageHashes!.map((x) => x)),
        'fingerprint': fingerprint,
        'download_url': downloadUrl,
        'secondary_download_url': secondaryDownloadUrl,
        'app_icon_url': appIconUrl,
        'install_url': installUrl,
        'destination_type': destinationType,
        'distribution_groups': distributionGroups == null
            ? []
            : List<dynamic>.from(distributionGroups!.map((x) => x.toJson())),
        'distribution_stores': distributionStores == null
            ? []
            : List<dynamic>.from(distributionStores!.map((x) => x.toJson())),
        'destinations': destinations == null
            ? []
            : List<dynamic>.from(destinations!.map((x) => x.toJson())),
        'is_udid_provisioned': isUdidProvisioned,
        'can_resign': canResign,
        'build': build?.toJson(),
        'status': status,
      };
}

class Build {
  final String? branchName;
  final String? commitHash;
  final String? commitMessage;

  Build({
    this.branchName,
    this.commitHash,
    this.commitMessage,
  });

  factory Build.fromJson(Map<String, dynamic> json) => Build(
        branchName: json['branch_name'],
        commitHash: json['commit_hash'],
        commitMessage: json['commit_message'],
      );

  Map<String, dynamic> toJson() => {
        'branch_name': branchName,
        'commit_hash': commitHash,
        'commit_message': commitMessage,
      };
}

class ReleaseDestination {
  final String? id;
  final String? name;
  final bool? isLatest;
  final String? type;
  final String? publishingStatus;
  final String? destinationType;
  final String? displayName;

  ReleaseDestination({
    this.id,
    this.name,
    this.isLatest,
    this.type,
    this.publishingStatus,
    this.destinationType,
    this.displayName,
  });

  factory ReleaseDestination.fromJson(Map<String, dynamic> json) =>
      ReleaseDestination(
        id: json['id'],
        name: json['name'],
        isLatest: json['is_latest'],
        type: json['type'],
        publishingStatus: json['publishing_status'],
        destinationType: json['destination_type'],
        displayName: json['display_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_latest': isLatest,
        'type': type,
        'publishing_status': publishingStatus,
        'destination_type': destinationType,
        'display_name': displayName,
      };
}

class ReleaseDistributionGroup {
  final String? id;
  final String? name;

  ReleaseDistributionGroup({
    this.id,
    this.name,
  });

  factory ReleaseDistributionGroup.fromJson(Map<String, dynamic> json) =>
      ReleaseDistributionGroup(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class DistributionStore {
  final String? id;
  final String? name;
  final String? type;
  final String? publishingStatus;

  DistributionStore({
    this.id,
    this.name,
    this.type,
    this.publishingStatus,
  });

  factory DistributionStore.fromJson(Map<String, dynamic> json) =>
      DistributionStore(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        publishingStatus: json['publishing_status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'publishing_status': publishingStatus,
      };
}

class _AppCenterReleaseBase {
  final int? id;

  /// Build Number of the app
  final String? version;
  final String? origin;
  final String? shortVersion;
  final String? uploadedAt;
  final bool? enabled;
  final bool? isExternalBuild;

  _AppCenterReleaseBase({
    this.id,
    this.version,
    this.origin,
    this.shortVersion,
    this.uploadedAt,
    this.enabled,
    this.isExternalBuild,
  });

  String get fullVersion =>
      '$shortVersion${version == null || version!.isEmpty ? '' : ' ($version)'}';

  String get formattedUploadDate {
    final date = DateTime.tryParse(uploadedAt ?? '');

    if (date == null) return '';

    if (date.withoutTime == DateTime.now().withoutTime) {
      return DateFormat('hh:mm a').format(date);
    } else {
      return DateFormat('dd MMM, yyyy | hh:mm a').format(date);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'version': version,
        'origin': origin,
        'short_version': shortVersion,
        'uploaded_at': uploadedAt,
        'enabled': enabled,
        'is_external_build': isExternalBuild,
      };
}
