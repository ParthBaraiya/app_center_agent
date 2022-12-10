class SearchOrganizationData {
  final String organization;

  const SearchOrganizationData({
    required this.organization,
  });

  factory SearchOrganizationData.fromUrl(String url) {
    // TODO(parth): Implement this constructor to load the data from the
    // AppCenter's URL. This will be useful when we implement deep linking.
    throw UnimplementedError('This constructor is not implemented yet!');
  }
}
