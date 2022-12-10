import 'package:app_center_agent/apiservice/api_urls.dart';
import 'package:app_center_agent/models/organization_list_response.dart';
import 'package:app_center_agent/stores/organization_store.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../stores/user_store.dart';

part 'apiservice.g.dart';

@RestApi(baseUrl: APIUrls.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @GET(APIUrls.user)
  Future<User> getUser({
    @Header(kAuthHeaderKey) required String? auth,
  });

  @GET(APIUrls.organizationList)
  Future<List<OrganizationResponse>> getAllOrganizations({
    @Header(kAuthHeaderKey) String? auth,
  });

  @GET(APIUrls.organization)
  Future<OrganizationModel> getOrganization({
    @Header(kAuthHeaderKey) String? auth,
    @Path(kOrganizationNameKey) required String name,
  });
}
