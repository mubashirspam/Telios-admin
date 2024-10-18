import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../model/map.dart';
import '../settings/router.dart';

class MapWidget extends StatelessWidget {
  final int selectedIndex;
  final void Function(int)? onSelectionChanged;

  final MapShapeSource source;
  const MapWidget({
    super.key,
    required this.selectedIndex,
    required this.onSelectionChanged,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;

    return Stack(
      children: <Widget>[
        SizedBox(
          child: SfMaps(
            layers: <MapLayer>[
              MapShapeLayer(
                selectedIndex: selectedIndex,

                onSelectionChanged: onSelectionChanged,

                selectionSettings: MapSelectionSettings(
                  color: color.primary,
                  strokeColor: color.onSurface,
                  strokeWidth: 1,
                ),
                onWillZoom: (MapZoomDetails map) {
                  return true;
                },

                showDataLabels: true,
                loadingBuilder: (BuildContext context) {
                  return const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  );
                },
                source: source,
                // shapeTooltipBuilder: (BuildContext context, int index) {
                //   return _buildCustomTooltipWidget("name", "id", context);
                // },
                strokeColor: color.onSurface,
                strokeWidth: 0.5,
                // ignore: prefer_const_constructors
                tooltipSettings: MapTooltipSettings(
                  color: color.primary,
                  strokeColor: color.onSurface,
                  strokeWidth: 0.5,
                  hideDelay: 3.0,
                ),
                dataLabelSettings: MapDataLabelSettings(
                  overflowMode: MapLabelOverflow.ellipsis,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCustomTooltipWidget(String id, name, BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.73, -0.68),
          end: const Alignment(-0.73, 0.68),
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.primary,
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      // key: bottomSheetKey,
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              id,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(),
            ),
          ),
          const ColoredBox(
            color: Colors.white,
            child: SizedBox(
              height: 1,
              width: double.maxFinite,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(_getTooltipText(name),
                style: Theme.of(context).textTheme.bodySmall!.copyWith()),
          ),
        ],
      ),
    );
  }

  String _getTooltipText(String name) {
    return 'survey count of state $name  ';
  }
}

class BuildMap extends StatefulWidget {
  final MapLevel block;
  final String shapeDataField;
  final int index;

  const BuildMap({
    super.key,
    required this.block,
    required this.index,
    required this.shapeDataField,
  });

  @override
  State<BuildMap> createState() => _MapState();
}

class _MapState extends State<BuildMap> {
  late MapZoomPanBehavior _mapZoomPanBehavior;

  late MapShapeSource _shapeSource;

  @override
  void initState() {
    final Uint8List geoJsonBytes =
        Uint8List.fromList(utf8.encode(widget.block.geoJson ?? ""));
    _mapZoomPanBehavior = MapZoomPanBehavior();

    _shapeSource = MapShapeSource.memory(
      geoJsonBytes,
      shapeDataField: widget.shapeDataField,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Center(
                              child: Text(
                                "${widget.index + 1}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${widget.block.levelName} : ${widget.block.levelKey}"),
                              Text(
                                  "Total Count from API : ${widget.block.nextLevelCount}"),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: SfMaps(
                          layers: <MapLayer>[
                            MapShapeLayer(
                              //  selectedIndex: 1,

                              onSelectionChanged: (int index) {},

                              selectionSettings: MapSelectionSettings(
                                color: Theme.of(context).colorScheme.primary,
                                strokeColor: Colors.black,
                                strokeWidth: 1,
                              ),

                              zoomPanBehavior: _mapZoomPanBehavior,
                              showDataLabels: true,
                              loadingBuilder: (BuildContext context) {
                                return const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                );
                              },
                              source: _shapeSource,
                              // shapeTooltipBuilder: (BuildContext context, int index) {
                              //   return _buildCustomTooltipWidget(state.villages![index], context);
                              // },
                              strokeColor: Colors.black,
                              strokeWidth: 0.5,
                              // ignore: prefer_const_constructors

                              dataLabelSettings: MapDataLabelSettings(
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        overflow: TextOverflow.fade,
                                        fontSize: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          appRouter.go(
                            ScreenPaths.level3(
                              widget.block.levelKey,
                            ),
                          );
                        },
                        icon: Icon(Icons.arrow_forward))
                  ],
                ),
              ),
            ),
            if (widget.block.nextLevels != null)
              SizedBox(
                width: 130,
                child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: widget.block.nextLevels!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListTile(
                          contentPadding: EdgeInsets.all(0),
                          onTap: () {},
                          leading: CircleAvatar(
                            radius: 10,
                            child: Text(
                              "${index + 1},",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 7),
                            ),
                          ),
                          title: Text(
                            widget.block.nextLevels![index].levelName ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 8),
                          ),
                          subtitle: Text(
                            widget.block.nextLevels![index].levelKey ?? "",
                            style: TextStyle(fontSize: 7),
                          ),
                        )

                    // SizedBox(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             "${index + 1}: ${widget.block.nextLevels![index].levelName} ",
                    //             style: Theme.of(context)
                    //                 .textTheme
                    //                 .bodySmall!
                    //                 .copyWith(fontWeight: FontWeight.bold),
                    //           ),
                    //           const SizedBox(height: 5),
                    //           Text(
                    //             "ID: ${widget.block.nextLevels![index].levelKey},",
                    //             style: const TextStyle(fontSize: 7),
                    //           ),
                    //           const SizedBox(height: 10),
                    //         ],
                    //       ),
                    //     )

                    ),
              ),
          ],
        ),
      ),
    );
  }
}
