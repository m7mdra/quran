import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quran/data/local/quran_provider.dart';
import 'package:quran/data/model/quran.dart';
import 'dart:math' as math;
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<Surah> list;

  @override
  void initState() {
    super.initState();
    QuranProvider().loadSurahList().then((value) {
      setState(() {
        list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: QuranProvider().loadSurahList(),
        builder: (BuildContext context, AsyncSnapshot<List<Surah>> snapshot) {
          if (!snapshot.hasData) return Container();
          var ayah = snapshot.data[50].ayahs;
          return  new GridView.custom(
            gridDelegate: new HomeGridDelegate(),
            childrenDelegate: new HomeChildDelegate(),
            padding: new EdgeInsets.all(12.0),
          );
        },
      ),
    );
  }
}

class HomeChildDelegate extends SliverChildDelegate {

  @override
  Widget build(BuildContext context, int index) {

    if(index >= 20)
      return null;

    Color color = Colors.red;

    if(index == 0)
      color = Colors.blue;
    else if(index == 1 || index == 10)
      color = Colors.cyan;
    else if(index < 10)
      color = Colors.green;

    return new Container(decoration: new BoxDecoration(color: color , shape: BoxShape.rectangle));
  }

  @override
  bool shouldRebuild(SliverChildDelegate oldDelegate) => true;

  @override
  int get estimatedChildCount => 20;
}

class HomeGridDelegate extends SpanableSliverGridDelegate {

  HomeGridDelegate() : super(3, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0);

  @override
  int getCrossAxisSpan(int index) {
    if(index > 1 && index < 10)
      return 1;

    return 3;
  }

  @override
  double getMainAxisExtent(int index) {
    if(index == 0)
      return 220.0;

    if(index == 1 || index == 10)
      return 50.0;

    return 100.0;
  }
}
class _CoordinateOffset {
  final double main, cross;
  _CoordinateOffset(this.main, this.cross);
}

typedef int GetCrossAxisSpan(int index);

typedef double GetMainAxisExtent(int index);

class SpanableSliverGridLayout extends SliverGridLayout {

  /// Creates a layout that uses equally sized and spaced tiles.
  ///
  /// All of the arguments must not be null and must not be negative. The
  /// `crossAxisCount` argument must be greater than zero.
  const SpanableSliverGridLayout(
      this.crossAxisCount,
      this.childCrossAxisExtent,
      this.crossAxisStride,
      this.mainAxisSpacing,
      this.getCrossAxisSpan,
      this.getMainAxisExtend) :
        assert(crossAxisCount != null && crossAxisCount > 0),
        assert(mainAxisSpacing != null && mainAxisSpacing >= 0),
        assert(childCrossAxisExtent != null && childCrossAxisExtent >= 0),
        assert(crossAxisStride != null && crossAxisStride >= 0),
        assert(getCrossAxisSpan != null),
        assert(getMainAxisExtend != null);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of pixels from the leading edge of one tile to the trailing
  /// edge of the same tile in the main axis.
  final double mainAxisSpacing;

  /// The number of pixels from the leading edge of one tile to the leading edge
  /// of the next tile in the cross axis.
  final double crossAxisStride;

  /// The number of pixels from the leading edge of one tile to the trailing
  /// edge of the same tile in the cross axis.
  final double childCrossAxisExtent;

  final GetCrossAxisSpan getCrossAxisSpan;

  final GetMainAxisExtent getMainAxisExtend;

  _CoordinateOffset _findOffset(int index) {
    int cross= 0;
    double mainOffset = 0.0;
    double crossOffset = 0.0;
    double extend = 0.0;
    int span;

    for (int i = 0; i <= index; i++) {

      span = getCrossAxisSpan(i);
      span = math.min(this.crossAxisCount, math.max(0, span));

      if((cross + span) > this.crossAxisCount) {
        cross = 0;
        mainOffset += extend + this.mainAxisSpacing;
        crossOffset = 0.0;
        extend = 0.0;
      }

      crossOffset = cross * crossAxisStride;
      extend = math.max(extend, getMainAxisExtend(i));
      cross += span;
    }

    return new _CoordinateOffset(mainOffset, crossOffset);
  }

  int getMinOrMaxChildIndexForScrollOffset(double scrollOffset, bool min) {
    int cross = 0;
    double mainOffset = 0.0;
    double extend = 0.0;
    int i = 0;
    int span = 0;

    while (true) {
      span = getCrossAxisSpan(i);
      span = math.min(this.crossAxisCount, math.max(0, span));

      if ((cross + span) > this.crossAxisCount) {
        cross = 0;
        mainOffset += extend + this.mainAxisSpacing;
        extend = 0.0;
      }

      extend = math.max(extend, getMainAxisExtend(i));
      cross += span;

      if (min && scrollOffset <= mainOffset + extend) {
        return (i ~/ this.crossAxisCount) * this.crossAxisCount;
      }
      else if(!min && scrollOffset < mainOffset) {
        return i;
      }
      i++;
    }
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) => getMinOrMaxChildIndexForScrollOffset(scrollOffset, true);

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) => getMinOrMaxChildIndexForScrollOffset(scrollOffset, false);

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    var span = getCrossAxisSpan(index);
    var mainAxisExtent = getMainAxisExtend(index);
    var offset = _findOffset(index);

    return new SliverGridGeometry(
      scrollOffset: offset.main,
      crossAxisOffset: offset.cross,
      mainAxisExtent: mainAxisExtent,
      crossAxisExtent: this.childCrossAxisExtent + (span - 1) * this.crossAxisStride,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    if(childCount <= 0)
      return 0.0;

    var lastOffset = _findOffset(childCount-1);
    var extent = getMainAxisExtend(childCount-1);
    return lastOffset.main + extent;
  }
}

abstract class SpanableSliverGridDelegate extends SliverGridDelegate {
  /// Creates a delegate that makes grid layouts with a fixed number of tiles in
  /// the cross axis.
  ///
  /// All of the arguments must not be null. The `mainAxisSpacing` and
  /// `crossAxisSpacing` arguments must not be negative. The `crossAxisCount`
  /// and `childAspectRatio` arguments must be greater than zero.
  const SpanableSliverGridDelegate(
      this.crossAxisCount,
      {this.mainAxisSpacing: 0.0,
        this.crossAxisSpacing: 0.0,
      }) : assert(crossAxisCount != null && crossAxisCount > 0),
        assert(mainAxisSpacing != null && mainAxisSpacing >= 0),
        assert(crossAxisSpacing != null && crossAxisSpacing >= 0);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final double usableCrossAxisExtent = constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    return new SpanableSliverGridLayout(
      crossAxisCount,
      childCrossAxisExtent,
      childCrossAxisExtent + crossAxisSpacing,
      mainAxisSpacing,
      getCrossAxisSpan,
      getMainAxisExtent,
    );
  }

  int getCrossAxisSpan(int index);

  double getMainAxisExtent(int index);

  @override
  bool shouldRelayout(SpanableSliverGridDelegate oldDelegate) {
    return oldDelegate.crossAxisCount != crossAxisCount
        || oldDelegate.mainAxisSpacing != mainAxisSpacing
        || oldDelegate.crossAxisSpacing != crossAxisSpacing;
  }
}
