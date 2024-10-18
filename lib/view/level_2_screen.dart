import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telios_admin/settings/repositoy.dart';
import 'package:telios_admin/view/map_widget.dart';

import '../model/model.dart';

class Level2Screen extends StatefulWidget {
  final String id;
  const Level2Screen({super.key, required this.id});

  @override
  State<Level2Screen> createState() => _Level2ScreenState();
}

class _Level2ScreenState extends State<Level2Screen> {
  late Future<List<MapLevel>?> _fetchMap;
  final _repo = Repository();
  bool isLoading = false;

  Future<List<MapLevel>> fetchMap() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      await _repo.refreshTokenIfNeeded();
      final response = await _repo.executeWithTokenRefresh(
          () => _repo.fetchMap(levelId: widget.id, token: currentToken.value!));

      if (response != null) {
        return await _repo.convertMapLevelRemoteToLocal(
            remoteData: response, id: 2);
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
    _fetchMap = fetchMap();
  }

  int crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          context.go('/'); // Navigate to home
                        },
                        icon: const Icon(Icons.chevron_left)),
                    Text(widget.id),
                    const Spacer(),
                    ...List.generate(
                        4, (index) => _buildeGridButton((index + 1), context)),
                  ],
                ),
              )),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: FutureBuilder(
                future: _fetchMap,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _fetchMap = fetchMap();
                          });
                        },
                        child: const Text('Retry'),
                      ),
                    )
                    );
                  }
                  if (snapshot.hasData) {
                    final blocks = snapshot.data;
                    if (blocks == null || blocks.isEmpty) {
                     return const Text("No Data Found");
                    } else {
                      return GridView.builder(
                        itemCount: blocks.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return BuildMap(
                            shapeDataField: 'Level3',
                            block: blocks[index],
                            index: index,
                          );
                        },
                      );
                    }
                  } else {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _fetchMap = fetchMap();
                          });
                        },
                        child: const Text('Retry'),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildeGridButton(int index, BuildContext context) {
    bool isSelected = index == crossAxisCount;
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        setState(() {
          crossAxisCount = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: CircleAvatar(
          backgroundColor: isSelected ? color.primary : color.secondary,
          child: Center(
            child: Text(
              "$index",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: isSelected ? color.onPrimary : color.onSecondary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}



