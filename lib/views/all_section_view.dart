import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nested_expanded_list/model/itemmodel.dart';

import 'section_view.dart';

class AllSections extends StatefulWidget {
  const AllSections({super.key, required this.title});

  final String title;

  @override
  State<AllSections> createState() => _AllSectionsState();
}

class _AllSectionsState extends State<AllSections>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;
  final headerColor = Colors.grey.shade100;
  final subheaderColor = Colors.grey.shade200;
  final subsectionheaderColor = Colors.grey.shade300;
  final Color draggableItemColor = Colors.transparent;
  List<Item> items = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.deepPurpleAccent.shade200,
      end: Colors.blue.shade800,
    ).animate(_controller);
    items = <Item>[
      Item(
        title: 'Section 1',
        color: headerColor,
        subsection: <Item>[
          Item(
            title: 'Subsection 1',
            color: subheaderColor,
            subsection: <Item>[
              Item(
                title: 'Subsection 1.1',
                color: subsectionheaderColor,
              ),
              Item(
                title: 'Subsection 1.2',
                color: subsectionheaderColor,
              ),
            ],
          ),
          Item(
            title: 'Subsection 2',
            color: subheaderColor,
            subsection: <Item>[
              Item(
                title: 'Subsection 2.1',
                color: subsectionheaderColor,
              ),
              Item(
                title: 'Subsection 2.2',
                color: subsectionheaderColor,
              ),
            ],
          ),
        ],
      ),
      Item(
        title: 'Section 2',
        color: headerColor,
        subsection: <Item>[
          Item(
            title: 'Subsection 2.1',
            color: subheaderColor,
          ),
          Item(
            title: 'Subsection 2.2',
            color: subheaderColor,
          ),
        ],
      ),
      Item(
        title: 'Section 3',
        color: headerColor,
        subsection: <Item>[
          Item(
            title: 'Subsection 3.1',
            color: subheaderColor,
          ),
          Item(
            title: 'Subsection 3.2',
            color: subheaderColor,
          ),
        ],
      ),
      Item(
        title: 'Section 4',
        color: headerColor,
        subsection: <Item>[
          Item(
            title: 'Subsection 4.1',
            color: subheaderColor,
          ),
          Item(
            title: 'Subsection 4.2',
            color: subheaderColor,
          ),
        ],
      ),
      Item(
        title: 'Section 5',
        color: headerColor,
        subsection: <Item>[
          Item(
            title: 'Subsection 5.1',
            color: subheaderColor,
          ),
          Item(
            title: 'Subsection 5.2',
            color: subheaderColor,
          ),
        ],
      ),
      Item(
        title: 'Section 6',
        color: headerColor,
        subsection: <Item>[
          Item(
            title: 'Subsection 6.1',
            color: subheaderColor,
          ),
          Item(
            title: 'Subsection 6.2',
            color: subheaderColor,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            elevation: elevation,
            color: draggableItemColor,
            shadowColor: draggableItemColor,
            child: child,
          );
        },
        child: child,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 70),
        child: AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return AppBar(
                backgroundColor: _colorAnimation.value,
                title: Text(widget.title),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Follow for more such content\n@ig_krishnakumar ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Spacer(),
                            Text(
                              'Drag to reorder',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Tap to expand',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ReorderableListView.builder(
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = items.removeAt(oldIndex);
                    items.insert(newIndex, item);
                  });
                },
                proxyDecorator: proxyDecorator,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) => Sections(
                  key: Key(items.elementAt(index).title),
                  item: items[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
