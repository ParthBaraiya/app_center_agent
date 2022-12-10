part of 'routing_configurations.dart';

enum RouteData {
  home(path: '/', name: 'home'),
  login(path: '/login', name: 'login');

  final String name;
  final String path;

  const RouteData({required this.path, required this.name});
}
