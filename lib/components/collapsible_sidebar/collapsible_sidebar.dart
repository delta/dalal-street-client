/// Credits: https://github.com/RyuuKenshi/flutter_collapsible_sidebar
import 'dart:math' as math show pi;

import 'package:flutter/material.dart';

import 'components/collapsible_avatar.dart';
import 'components/collapsible_container.dart';
import 'components/collapsible_item.dart';
import 'components/collapsible_item_selection.dart';
import 'components/collapsible_item_widget.dart';

// TODO(enhancement): close the sidebar when esc is pressed
class CollapsibleSidebar extends StatefulWidget {
  const CollapsibleSidebar({
    Key? key,
    required this.items,
    this.title = 'Lorem Ipsum',
    this.titleStyle,
    this.titleBack = false,
    this.titleBackIcon = Icons.arrow_back,
    this.onHoverPointer = SystemMouseCursors.click,
    this.textStyle,
    this.toggleTitleStyle,
    this.toggleTitle = 'Collapse',
    this.avatarImg,
    this.height = double.infinity,
    this.minWidth = 80,
    this.maxWidth = 270,
    this.borderRadius = 15,
    this.iconSize = 40,
    this.toggleButtonIcon = Icons.chevron_right,
    this.backgroundColor = const Color(0xff2B3138),
    this.selectedIconBox = const Color(0xff2F4047),
    this.selectedIconColor = const Color(0xff4AC6EA),
    this.selectedTextColor = const Color(0xffF3F7F7),
    this.unselectedIconColor = const Color(0xff6A7886),
    this.unselectedTextColor = const Color(0xffC0C7D0),
    this.itemSelectorDecoration,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastLinearToSlowEaseIn,
    this.screenPadding = 4,
    this.showToggleButton = true,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.fitItemsToBottom = false,
    required this.body,
    this.onTitleTap,
    this.onAvatarTap,
    this.isCollapsed = true,
    this.sidebarBoxShadow = const [
      BoxShadow(
        color: Colors.blue,
        blurRadius: 10,
        spreadRadius: 0.01,
        offset: Offset(3, 3),
      ),
    ],
  }) : super(key: key);

  final String title, toggleTitle;
  final MouseCursor onHoverPointer;
  final TextStyle? titleStyle, textStyle, toggleTitleStyle;
  final bool titleBack;
  final IconData titleBackIcon;
  final Widget body;
  final Widget? avatarImg;
  final bool showToggleButton, fitItemsToBottom, isCollapsed;
  final List<CollapsibleItem> items;
  final double height,
      minWidth,
      maxWidth,
      borderRadius,
      iconSize,
      padding = 10,
      itemPadding = 10,
      topPadding,
      bottomPadding,
      screenPadding;
  final IconData toggleButtonIcon;
  final Color backgroundColor,
      selectedIconBox,
      selectedIconColor,
      selectedTextColor,
      unselectedIconColor,
      unselectedTextColor;
  final Decoration? itemSelectorDecoration;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onTitleTap, onAvatarTap;
  final List<BoxShadow> sidebarBoxShadow;

  @override
  _CollapsibleSidebarState createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<CollapsibleSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late CurvedAnimation _curvedAnimation;
  late double tempWidth;

  // ignore: prefer_typing_uninitialized_variables
  var _isCollapsed;
  late double _currWidth,
      _delta,
      _delta1By4,
      _delta3by4,
      _maxOffsetX,
      _maxOffsetY;
  late int _selectedItemIndex;

  @override
  void initState() {
    assert(widget.items.isNotEmpty);

    super.initState();

    tempWidth = widget.maxWidth > 270 ? 270 : widget.maxWidth;

    _currWidth = widget.minWidth;
    _delta = tempWidth - widget.minWidth;
    _delta1By4 = _delta * 0.25;
    _delta3by4 = _delta * 0.75;
    _maxOffsetX = widget.padding * 2 + widget.iconSize;
    _maxOffsetY = widget.itemPadding * 2 + widget.iconSize;
    for (var i = 0; i < widget.items.length; i++) {
      if (!widget.items[i].isSelected) continue;
      _selectedItemIndex = i;
      break;
    }

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _controller.addListener(() {
      _currWidth = _widthAnimation.value;
      if (_controller.isCompleted) _isCollapsed = _currWidth == widget.minWidth;
      setState(() {});
    });

    _isCollapsed = widget.isCollapsed;
    var endWidth = _isCollapsed ? widget.minWidth : tempWidth;
    _animateTo(endWidth);
  }

  @override
  void didUpdateWidget(covariant CollapsibleSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (var i = 0; i < widget.items.length; i++) {
      if (!widget.items[i].isSelected) continue;
      setState(() => _selectedItemIndex = i);
      break;
    }
  }

  void _animateTo(double endWidth) {
    _widthAnimation = Tween<double>(
      begin: _currWidth,
      end: endWidth,
    ).animate(_curvedAnimation);
    _controller.reset();
    _controller.forward();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      _currWidth += details.primaryDelta!;
      if (_currWidth > tempWidth) {
        _currWidth = tempWidth;
      } else if (_currWidth < widget.minWidth) {
        _currWidth = widget.minWidth;
      } else {
        setState(() {});
      }
    }
  }

  void _onHorizontalDragEnd(DragEndDetails _) {
    if (_currWidth == tempWidth) {
      setState(() => _isCollapsed = false);
    } else if (_currWidth == widget.minWidth) {
      setState(() => _isCollapsed = true);
    } else {
      var threshold = _isCollapsed ? _delta1By4 : _delta3by4;
      var endWidth = _currWidth - widget.minWidth > threshold
          ? tempWidth
          : widget.minWidth;
      _animateTo(endWidth);
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.topLeft,
        children: [
          Padding(
            padding: EdgeInsets.only(left: widget.minWidth * 1.1),
            child: widget.body,
          ),
          Padding(
            padding: EdgeInsets.all(widget.screenPadding),
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: CollapsibleContainer(
                height: widget.height,
                width: _currWidth,
                padding: widget.padding,
                borderRadius: widget.borderRadius,
                color: widget.backgroundColor,
                sidebarBoxShadow: widget.sidebarBoxShadow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _avatar,
                    SizedBox(
                      height: widget.topPadding,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        reverse: widget.fitItemsToBottom,
                        child: Stack(
                          children: [
                            CollapsibleItemSelection(
                              height: _maxOffsetY,
                              offsetY: _maxOffsetY * _selectedItemIndex,
                              color: widget.selectedIconBox,
                              decoration: widget.itemSelectorDecoration,
                              duration: widget.duration,
                              curve: widget.curve,
                            ),
                            Column(
                              children: _items,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: widget.bottomPadding,
                    ),
                    widget.showToggleButton
                        ? Divider(
                            color: widget.unselectedIconColor,
                            indent: 5,
                            endIndent: 5,
                            thickness: 1,
                          )
                        : const SizedBox(height: 5),
                    widget.showToggleButton
                        ? _toggleButton
                        : SizedBox(
                            height: widget.iconSize,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Widget get _avatar => CollapsibleItemWidget(
        onHoverPointer: widget.onHoverPointer,
        padding: widget.itemPadding,
        offsetX: _offsetX,
        scale: _fraction,
        leading: widget.titleBack
            ? Icon(
                widget.titleBackIcon,
                size: widget.iconSize,
                color: widget.unselectedIconColor,
              )
            : GestureDetector(
                onTap: widget.onAvatarTap,
                child: CollapsibleAvatar(
                  backgroundColor: widget.unselectedIconColor,
                  avatarSize: widget.iconSize,
                  name: widget.title,
                  avatarImg: widget.avatarImg!,
                  textStyle:
                      _textStyle(widget.backgroundColor, widget.titleStyle),
                ),
              ),
        title: widget.title,
        textStyle: _textStyle(widget.unselectedTextColor, widget.titleStyle),
        onTap: widget.onTitleTap,
      );

  List<Widget> get _items => List.generate(
        widget.items.length,
        (index) {
          var item = widget.items[index];
          var textColor = widget.unselectedTextColor;
          if (item.isSelected) {
            textColor = widget.selectedTextColor;
          }
          return CollapsibleItemWidget(
            onHoverPointer: widget.onHoverPointer,
            padding: widget.itemPadding,
            offsetX: _offsetX,
            scale: _fraction,
            leading: SizedBox(
              width: widget.iconSize,
              height: widget.iconSize,
              child: item.icon,
            ),
            title: item.text,
            textStyle: _textStyle(textColor, widget.textStyle),
            onTap: () {
              if (item.isSelected) return;
              item.onPressed();
            },
          );
        },
      );

  Widget get _toggleButton => CollapsibleItemWidget(
        onHoverPointer: widget.onHoverPointer,
        padding: widget.itemPadding,
        offsetX: _offsetX,
        scale: _fraction,
        leading: Transform.rotate(
          angle: _currAngle,
          child: Icon(
            widget.toggleButtonIcon,
            size: widget.iconSize,
            color: widget.unselectedIconColor,
          ),
        ),
        title: widget.toggleTitle,
        textStyle:
            _textStyle(widget.unselectedTextColor, widget.toggleTitleStyle),
        onTap: () {
          _isCollapsed = !_isCollapsed;
          var endWidth = _isCollapsed ? widget.minWidth : tempWidth;
          _animateTo(endWidth);
        },
      );

  double get _fraction => (_currWidth - widget.minWidth) / _delta;
  double get _currAngle => -math.pi * _fraction;
  double get _offsetX => _maxOffsetX * _fraction;

  TextStyle _textStyle(Color color, TextStyle? style) => style == null
      ? TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: color,
        )
      : style.copyWith(color: color);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
