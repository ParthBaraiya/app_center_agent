import 'package:app_center_agent/models/search_models/search_application_data.dart';

class SearchDistributionGroupData extends SearchApplicationData {
  final String group;

  const SearchDistributionGroupData({
    required this.group,
    required super.app,
    required super.organization,
  });

  factory SearchDistributionGroupData.fromUrl(String url) {
    // TODO(parth): Implement this constructor to load the data from the
    // AppCenter's URL. This will be useful when we implement deep linking.
    throw UnimplementedError('This constructor is not implemented yet!');
  }
}
