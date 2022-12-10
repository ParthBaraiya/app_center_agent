const kAuthHeaderKey = 'X-API-Token';
const kOrganizationNameKey = 'org_name';

class APIUrls {
  APIUrls._();

  //
  //
  // Base URL
  //
  //

  static const baseUrl = 'https://api.appcenter.ms/';

  //
  //
  // Endpoints
  //
  //

  static const user = '/v0.1/user';
  static const organization = '/v0.1/orgs/$kOrganizationNameKey}';
  static const organizationList = '/v0.1/orgs/';
}
