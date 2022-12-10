import 'package:app_center_agent/models/search_models/search_organization_data.dart';

class SearchApplicationData extends SearchOrganizationData {
  final String app;

  const SearchApplicationData({
    required super.organization,
    required this.app,
  });

  factory SearchApplicationData.fromUrl(String url) {
    // TODO(parth): Implement this constructor to load the data from the
    // AppCenter's URL. This will be useful when we implement deep linking.
    throw UnimplementedError('This constructor is not implemented yet!');
  }
}
