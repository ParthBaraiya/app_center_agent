import 'package:app_center_agent/stores/user_account_list_store.dart';
import 'package:app_center_agent/utils/navigation/routing_configurations.dart';
import 'package:app_center_agent/widgets/default_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessObserverWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final listingStore = UserAccountListStore.instance;

    return Scaffold(
      body: SafeArea(
        child: listingStore.currentUser == null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'No user found.',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () => context.goNamed(RouteData.login.name),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Observer(
                builder: (_) {
                  final userStore = listingStore.currentUser!;

                  if (userStore.networkState.isIdle) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Can not load data. Please try again later',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: userStore.loadUserData,
                              child: const Text(
                                'Retry',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (userStore.networkState.isLoading) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Loading user data please wait...',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    );
                  }

                  if (userStore.networkState.isError ||
                      userStore.user == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userStore.networkError ??
                                  'Error loading user data...',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.goNamed(RouteData.login.name),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              foregroundImage: NetworkImage(
                                userStore.user!.avatar ??
                                    'https://via.placeholder.com/150?text=${userStore.user!.initials}',
                              ),
                              maxRadius: 25,
                              minRadius: 15,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                userStore.user!.displayName,
                                style: const TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            DefaultIconButton(
                              onTap: () {
                                // TODO: Sign out user...
                              },
                              icon: Icons.logout_outlined,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Observer(builder: (context) {
                              final orgs = userStore.organizations;
                              if (orgs.networkState.isIdle) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Can not load organizations. Please try again later',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () => orgs
                                              .loadOrganizations(force: true),
                                          child: const Text(
                                            'Retry',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (orgs.networkState.isLoading) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          'Loading organizations please wait...',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 16),
                                        CircularProgressIndicator(),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (orgs.networkState.isError) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          userStore.networkError ??
                                              'Error loading organizations...',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () => orgs
                                              .loadOrganizations(force: true),
                                          child: const Text(
                                            'Retry',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              if (orgs.organizations.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'No organizations found!',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () => orgs
                                              .loadOrganizations(force: true),
                                          child: const Text(
                                            'Retry',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final organizations =
                                  orgs.organizations.values.toList();

                              return PageView.builder(
                                itemBuilder: (_, index) {
                                  final org = organizations[index]
                                    ..loadOrganization();
                                  return Center(child: Text(org.displayName));
                                },
                                itemCount: orgs.organizations.length,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
