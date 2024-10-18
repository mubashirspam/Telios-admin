import 'package:flutter/material.dart';
import 'package:telios_admin/settings/repositoy.dart';
import 'package:telios_admin/settings/router.dart';

import '../model/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<SelfVsUnitparentId>?> _fetchHome;
  final _repo = Repository();
  bool isLoading = false;
  String slectedId = "IND";

  Future<List<SelfVsUnitparentId>> fetchHome() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      await _repo.refreshTokenIfNeeded();
      final response = await _repo.executeWithTokenRefresh(
          () => _repo.fetcHome(levelId: slectedId, token: currentToken.value!));

      if (response != null) {
        return response.response?.data?.first.portalData?.selfVsUnitparentId ??
            [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHome = fetchHome();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: DefaultTabController(
        initialIndex: 0,
        animationDuration: const Duration(milliseconds: 200),

        length: 3, // Number of tabs
        child: Column(
          children: [
            TabBar(
              unselectedLabelStyle: TextStyle(
                color: color.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              labelStyle: TextStyle(
                color: color.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: color.primary,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (value) {
                setState(() {
                  slectedId = countries[value].id;
                  _fetchHome = fetchHome();
                });
              },
              tabs: List.generate(
                countries.length,
                (index) => Tab(
                  text: countries[index].name,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [itemsWidget(), itemsWidget(), itemsWidget()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemsWidget() {
    return FutureBuilder(
        future: _fetchHome,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _fetchHome = fetchHome();
                    });
                  },
                  child: Text("Retry")),
            );
          }
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisExtent: 100,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => Card(
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "${index + 1}",
                          style: Theme.of(context).textTheme.titleMedium,
                        )),
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot
                                    .data![index].selfVsUnitparentIdLevelKey ??
                                ""),
                            Text(snapshot.data![index].selfVsUnitparentIdUnit ??
                                ''),
                            Text(snapshot.data![index]
                                    .selfVsUnitparentIdNumNextLevel ??
                                ''),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          appRouter.go(ScreenPaths.level2(snapshot
                              .data![index].selfVsUnitparentIdLevelKey!));
                        },
                        icon: const Icon(Icons.arrow_forward_ios))
                  ],
                ),
              ),
            );
          }
          return Center(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _fetchHome = fetchHome();
                  });
                },
                child: Text("Retry")),
          );
        });
  }
}
