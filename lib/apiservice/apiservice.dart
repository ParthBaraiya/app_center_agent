import 'package:app_center_agent/apiservice/api_urls.dart';
import 'package:app_center_agent/models/app_center_release.dart';
import 'package:app_center_agent/models/appcenter_application.dart';
import 'package:app_center_agent/models/distribution_groups.dart';
import 'package:app_center_agent/models/organization.dart';
import 'package:app_center_agent/models/user.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'apiservice.g.dart';

@RestApi(baseUrl: APIUrls.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @GET('/user')
  Future<User> getUser({
    @Header(kAuthHeaderKey) required String? auth,
  });

  @GET('/apps')
  Future<List<AppCenterApplication>> getAllAppsForUser({
    @Header(kAuthHeaderKey) required String? auth,
  });

  @GET('/orgs')
  Future<List<Organization>> getAllOrganizations({
    @Header(kAuthHeaderKey) String? auth,
  });

  @GET('/orgs/{org_name}')
  Future<OrganizationDetails> getOrganization({
    @Header(kAuthHeaderKey) String? auth,
    @Path('org_name') required String name,
  });

  // TODO: Use /apps enpoint and group organizations from the list.
  //
  // NOTE: This endpoint is not working for all organizations.
  //
  // @GET('/orgs/{org_name}/apps')
  // Future<List<AppCenterApplication>> getAppsListForOrganization({
  //   @Header(kAuthHeaderKey) String? auth,
  //   @Path('org_name') required String name,
  // });

  @GET('/apps/{owner_name}/{app_name}/distribution_groups')
  Future<List<AppCenterGroup>> getDistributionGroupsForApp({
    @Header(kAuthHeaderKey) String? auth,
    @Path('owner_name') required String? appOwnerName,
    @Path('app_name') required String? appName,
  });

  @GET(
      '/apps/{owner_name}/{app_name}/distribution_groups/{group_name}/releases')
  Future<List<AppCenterRelease>> getAppRelease({
    @Header(kAuthHeaderKey) String? auth,
    @Path('owner_name') required String owner,
    @Path('app_name') required String app,
    @Path('group_name') required String group,
  });

  @GET(
      '/apps/{owner_name}/{app_name}/distribution_groups/{group_name}/releases/{release_id}')
  Future<AppCenterReleaseDetails> getAppReleaseDetails({
    @Header(kAuthHeaderKey) String? auth,
    @Path('owner_name') required String owner,
    @Path('app_name') required String app,
    @Path('group_name') required String group,
    @Path('release_id') required int releaseId,
  });
}
