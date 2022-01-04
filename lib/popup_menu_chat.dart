library popup_menu_chat;

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:popup_menu_chat/popup_menu_animation.dart';

import 'popup_menu_controller.dart';

enum PressType {
  longPress,
  singlePress,
}

enum PopupPosition {
  top,
  bottom,
}

class PopupMenuChat extends StatefulWidget {
  const PopupMenuChat({
    Key? key,
    required this.child,
    required this.menuBuilder,
    required this.pressType,
    this.controller,
    this.popupPosition,
    this.verticalMargin = 0.0,
    this.horizontalMargin = 0.0,
    this.menuOnChange,
  }) : super(key: key);

  final Widget child;
  final PressType pressType;
  final double verticalMargin;
  final double horizontalMargin;
  final PopupPosition? popupPosition;
  final PopupMenuChatController? controller;
  final Widget menuBuilder;
  final void Function(bool)? menuOnChange;

  @override
  _PopupMenuChatState createState() => _PopupMenuChatState();
}

class _PopupMenuChatState extends State<PopupMenuChat> {
  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  PopupMenuChatController? _controller;

  void _showPopupMenu() {
    final anchorSize = _childBox?.size ?? Size.zero;
    final touchOffset = _controller?.onLongPressOffset ?? Offset.zero;
    final maxWidth =
        (_parentBox?.size ?? Size.zero).width - 2 * widget.horizontalMargin;
    final anchorOffset =
        _childBox?.localToGlobal(Offset(-widget.horizontalMargin, 0)) ??
            Offset.zero;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _controller?.hideMenu();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
            _buildMenu(
              maxWidth: maxWidth,
              anchorSize: anchorSize,
              touchOffset: touchOffset,
              anchorOffset: anchorOffset,
            )
          ],
        );
      },
    );

    if (_overlayEntry != null) {
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }

  void _hidePopupMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateView() {
    final menuIsShowing = _controller?.menuIsShowing ?? false;
    widget.menuOnChange?.call(menuIsShowing);
    if (menuIsShowing) {
      _showPopupMenu();
    } else {
      _hidePopupMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller ??= PopupMenuChatController();
    _controller?.addListener(_updateView);

    // After loading if all value null
    WidgetsBinding.instance?.addPostFrameCallback((call) {
      if (mounted) {
        _childBox = context.findRenderObject() as RenderBox?;
        _parentBox =
            Overlay.of(context)?.context.findRenderObject() as RenderBox?;
      }
    });
  }

  @override
  void dispose() {
    _hidePopupMenu();
    _controller?.removeListener(_updateView);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          if (widget.pressType == PressType.singlePress) {
            _controller?.showMenu();
          }
        },
        onLongPressStart: (value) {
          if (widget.pressType == PressType.longPress) {
            _controller?.showMenu(offsetTouch: value.globalPosition);
          }
        },
        child: widget.child,
      ),
    );

    if (Platform.isIOS) {
      return child;
    }

    return WillPopScope(
      onWillPop: () {
        _hidePopupMenu();
        return Future.value(true);
      },
      child: child,
    );
  }

  Widget _buildMenu({
    required double maxWidth,
    required Size anchorSize,
    required Offset touchOffset,
    required Offset anchorOffset,
  }) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          minWidth: 0,
        ),
        child: CustomMultiChildLayout(
          delegate: _MenuLayoutDelegate(
            anchorSize: anchorSize,
            anchorOffset: anchorOffset,
            touchOffset: touchOffset,
            verticalMargin: widget.verticalMargin,
            popupPosition: widget.popupPosition,
          ),
          children: <Widget>[
            LayoutId(
              id: MenuLayoutId.content,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: widget.menuBuilder,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MenuLayoutId {
  content,
}

class _MenuLayoutDelegate extends MultiChildLayoutDelegate {
  _MenuLayoutDelegate({
    this.popupPosition,
    required this.anchorSize,
    required this.touchOffset,
    required this.anchorOffset,
    required this.verticalMargin,
  });

  final Size anchorSize;
  final Offset touchOffset;
  final Offset anchorOffset;
  final double verticalMargin;
  final PopupPosition? popupPosition;

  @override
  void performLayout(Size size) {
    var contentSize = Size.zero;
    var contentOffset = Offset.zero;

    final anchorCenterX = anchorOffset.dx + anchorSize.width / 2;
    final anchorTopY = anchorOffset.dy;
    final anchorBottomY = anchorTopY + anchorSize.height;

    if (hasChild(MenuLayoutId.content)) {
      contentSize = layoutChild(
        MenuLayoutId.content,
        BoxConstraints.loose(size),
      );
    }

    final freeTapBottom = touchOffset.dy;
    final freeTapTop = touchOffset.dy - contentSize.height;

    contentOffset = Offset(
      verticalMargin,
      touchOffset.dy > size.height / 2 ? freeTapTop : freeTapBottom,
    );

    if (hasChild(MenuLayoutId.content)) {
      positionChild(MenuLayoutId.content, contentOffset);
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}
