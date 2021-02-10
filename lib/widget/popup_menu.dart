import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'toggleable_font_options.dart';
import 'triangle_painter.dart';

abstract class MenuItemProvider {
  String get menuTitle;

  Widget get menuImage;

  TextStyle get menuTextStyle;

  TextAlign get menuTextAlign;
}

class MenuItem extends MenuItemProvider {
  Widget image; // 图标名称
  String title; // 菜单标题
  var userInfo; // 额外的菜单荐信息
  TextStyle textStyle;
  TextAlign textAlign;

  MenuItem(
      {this.title, this.image, this.userInfo, this.textStyle, this.textAlign});

  @override
  Widget get menuImage => image;

  @override
  String get menuTitle => title;

  @override
  TextStyle get menuTextStyle =>
      textStyle ?? TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0);

  @override
  TextAlign get menuTextAlign => textAlign ?? TextAlign.center;
}

enum MenuType { big, oneLine }

typedef MenuClickCallback = Function(MenuItemProvider item);
typedef PopupMenuStateChanged = Function(bool isShow);

class PopupMenu {
  static var itemWidth = 72.0;
  static var itemHeight = 65.0;
  static var arrowHeight = 10.0;
  OverlayEntry _entry;

  /// The left top point of this menu.
  Offset _offset;

  /// Menu will show at above or under this rect
  Rect _showRect;

  /// if false menu is show above of the widget, otherwise menu is show under the widget
  bool _isDown = true;

  /// callback
  VoidCallback dismissCallback;
  MenuClickCallback onClickMenu;
  PopupMenuStateChanged stateChanged;

  Size _screenSize; // 屏幕的尺寸
  /// Cannot be null
  static BuildContext context;

  /// It's showing or not.
  bool _isShow = false;

  bool get isShow => _isShow;

  PopupMenu(
      {MenuClickCallback onClickMenu,
      BuildContext context,
      VoidCallback onDismiss,
      int maxColumn,
      Color backgroundColor,
      PopupMenuStateChanged stateChanged}) {
    this.onClickMenu = onClickMenu;
    this.dismissCallback = onDismiss;
    this.stateChanged = stateChanged;
    if (context != null) {
      PopupMenu.context = context;
    }
  }

  void show(
      {Rect rect,
      GlobalKey widgetKey,
      VoidCallback onPlayClick,
      VoidCallback onTafseerCallback}) {
    if (rect == null && widgetKey == null) {
      print("'rect' and 'key' can't be both null");
      return;
    }

    this._showRect = rect ?? PopupMenu.getWidgetGlobalRect(widgetKey);
    this._screenSize = window.physicalSize / window.devicePixelRatio;
    this.dismissCallback = dismissCallback;

    _calculatePosition(PopupMenu.context);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupMenuLayout(_offset, onPlayClick, onTafseerCallback);
    });

    Overlay.of(PopupMenu.context).insert(_entry);
    _isShow = true;
    if (this.stateChanged != null) {
      this.stateChanged(true);
    }
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void _calculatePosition(BuildContext context) {
    _offset = _calculateOffset(PopupMenu.context);
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.left + _showRect.width / 2.0 - menuWidth() / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + menuWidth() > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - menuWidth() - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - menuHeight();
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // The have not enough space above, show menu under the widget.
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isDown = false;
    } else {
      dy -= arrowHeight;
      _isDown = true;
    }

    return Offset(dx, dy);
  }

  double menuWidth() {
    return MediaQuery.of(context).size.width - 100;
  }

  // This height exclude the arrow
  double menuHeight() {
    return 70;
  }

  Widget buildPopupMenuLayout(
      Offset offset, VoidCallback onPlayClick, VoidCallback onTafseerCallback) {
    return Material(
      color: Colors.black26,
      child: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            dismiss();
          },
//        onTapDown: (TapDownDetails details) {
//          dismiss();
//        },
          // onPanStart: (DragStartDetails details) {
          //   dismiss();
          // },
          onVerticalDragStart: (DragStartDetails details) {
            dismiss();
          },
          onPanStart: (DragStartDetails details) {
            dismiss();
          },
          child: Container(
            child: Stack(
              children: <Widget>[
                // triangle arrow
                Positioned(
                  left: _showRect.left + _showRect.width / 2.0 - 7.5,
                  top: _isDown
                      ? offset.dy + menuHeight()
                      : offset.dy - arrowHeight,
                  child: CustomPaint(
                    size: Size(15.0, arrowHeight),
                    painter: TrianglePainter(
                        isDown: _isDown, color: Theme.of(context).cardColor),
                  ),
                ),
                // menu content
                Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              width: menuWidth(),
                              height: menuHeight(),
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Image.asset(
                                        'assets/images/tafseer_aya.png',
                                        width: 27,
                                        height: 27,
                                        fit: BoxFit.cover),
                                    onPressed: () async {
                                      dismiss();
                                      onTafseerCallback();
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 31,
                                    color: Theme.of(context).primaryColor,
                                    icon: Icon(Icons.play_circle_fill),
                                    onPressed: () {
                                      dismiss();
                                      onPlayClick();
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: VerticalDivider(
                                      width: 1,
                                    ),
                                  ),
                                  ToggleableFontOptions.normal(true),
                                  ToggleableFontOptions.large(true),
                                  ToggleableFontOptions.bold(true)
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  void itemClicked(MenuItemProvider item) {
    if (onClickMenu != null) {
      onClickMenu(item);
    }

    dismiss();
  }

  void dismiss() {
    if (!_isShow) {
      // Remove method should only be called once
      return;
    }

    _entry.remove();
    _isShow = false;
    if (dismissCallback != null) {
      dismissCallback();
    }

    if (this.stateChanged != null) {
      this.stateChanged(false);
    }
  }
}

class _MenuItemWidget extends StatefulWidget {
  final MenuItemProvider item;

  // 是否要显示右边的分隔线
  final bool showLine;
  final Color lineColor;
  final Color backgroundColor;
  final Color highlightColor;

  final Function(MenuItemProvider item) clickCallback;

  _MenuItemWidget(
      {this.item,
      this.showLine = false,
      this.clickCallback,
      this.lineColor,
      this.backgroundColor,
      this.highlightColor});

  @override
  State<StatefulWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  var highlightColor = Color(0x55000000);
  var color = Color(0xff232323);

  @override
  void initState() {
    color = widget.backgroundColor;
    highlightColor = widget.highlightColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        color = highlightColor;
        setState(() {});
      },
      onTapUp: (details) {
        color = widget.backgroundColor;
        setState(() {});
      },
      onLongPressEnd: (details) {
        color = widget.backgroundColor;
        setState(() {});
      },
      onTap: () {
        if (widget.clickCallback != null) {
          widget.clickCallback(widget.item);
        }
      },
      child: Container(
          width: PopupMenu.itemWidth,
          height: PopupMenu.itemHeight,
          decoration: BoxDecoration(
              color: color,
              border: Border(
                  right: BorderSide(
                      color: widget.showLine
                          ? widget.lineColor
                          : Colors.transparent))),
          child: _createContent()),
    );
  }

  Widget _createContent() {
    if (widget.item.menuImage != null) {
      // image and text
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 30.0,
            height: 30.0,
            child: widget.item.menuImage,
          ),
          Container(
            height: 22.0,
            child: Material(
              color: Colors.transparent,
              child: Text(
                widget.item.menuTitle,
                style: widget.item.menuTextStyle,
              ),
            ),
          )
        ],
      );
    } else {
      // only text
      return Container(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Text(
              widget.item.menuTitle,
              style: widget.item.menuTextStyle,
              textAlign: widget.item.menuTextAlign,
            ),
          ),
        ),
      );
    }
  }
}
