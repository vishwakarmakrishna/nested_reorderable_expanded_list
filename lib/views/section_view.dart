import 'package:flutter/material.dart';
import 'package:nested_expanded_list/expandedpanellist.dart';
import 'package:nested_expanded_list/model/itemmodel.dart';

class Sections extends StatefulWidget {
  const Sections({super.key, required this.item});
  final Item item;

  @override
  State<Sections> createState() => _SectionsState();
}

class _SectionsState extends State<Sections> with TickerProviderStateMixin {
  bool expanded = false;
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;
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
      begin: widget.item.color,
      end: widget.item.color.withAlpha(10),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, _) {
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
              ),
              child: ExpansionTileCardCustom(
                  headerBackgroundColor: _colorAnimation.value,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Visibility(
                      visible: widget.item.subsection != null,
                      child: Icon(
                        expanded ? Icons.expand_less : Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  trailing: const SizedBox.shrink(),
                  onExpansionChanged: (value) {
                    setState(() {
                      expanded = value;
                    });
                  },
                  baseColor: Colors.transparent,
                  elevation: 0,
                  key: Key(widget.item.title),
                  initiallyExpanded: expanded,
                  title: Text(
                    widget.item.title.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  children: [
                    if (widget.item.subsection != null)
                      Visibility(
                        visible: widget.item.subsection != null,
                        child: ReorderableListView(
                          shrinkWrap: true,
                          children: widget.item.subsection!
                              .map(
                                (e) => Padding(
                                  key: Key(e.title),
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Sections(
                                    item: e,
                                  ),
                                ),
                              )
                              .toList(),
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final item =
                                  widget.item.subsection!.removeAt(oldIndex);
                              widget.item.subsection!.insert(newIndex, item);
                            });
                          },
                        ),
                      )
                  ]),
            ),
          );
        });
  }
}
