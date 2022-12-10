import 'package:app_center_agent/models/search_models/search_distribution_group_data.dart';

class SearchReleaseData extends SearchDistributionGroupData {
  final int releaseId;

  const SearchReleaseData({
    required this.releaseId,
    required super.group,
    required super.app,
    required super.organization,
  });

  factory SearchReleaseData.fromUrl(String url) {
    // TODO(parth): Implement this constructor to load the data from the
    // AppCenter's URL. This will be useful when we implement deep linking.
    throw UnimplementedError('This constructor is not implemented yet!');
  }
}
