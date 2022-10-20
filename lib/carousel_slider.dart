library fluttercarouselslider;

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'carousel_slider_indicators.dart';
import 'carousel_slider_transforms.dart';

export './carousel_slider_indicators.dart';
export './carousel_slider_transforms.dart';

const _kMaxValue = 200000000000;
const _kMiddleValue = 100000;

typedef CarouselSlideBuilder = Widget Function(int index);

class CarouselSlider extends StatefulWidget {
  CarouselSlider({
    Key? key,
    required List<Widget> this.children,
    this.slideTransform = const DefaultTransform(),
    this.slideIndicator,
    this.viewportFraction = 1,
    this.enableAutoSlider = false,
    this.autoSliderDelay = const Duration(seconds: 5),
    this.autoSliderTransitionTime = const Duration(seconds: 2),
    this.autoSliderTransitionCurve = Curves.easeOutQuad,
    this.keepPage = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.unlimitedMode = false,
    this.initialPage = 0,
    this.onSlideChanged,
    this.onSlideStart,
    this.onSlideEnd,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
  })  : slideBuilder = null,
        itemCount = children.length,
        super(key: key);

  CarouselSlider.builder({
    Key? key,
    required this.slideBuilder,
    this.slideTransform = const DefaultTransform(),
    this.slideIndicator,
    required this.itemCount,
    this.viewportFraction = 1,
    this.enableAutoSlider = false,
    this.autoSliderDelay = const Duration(seconds: 5),
    this.autoSliderTransitionTime = const Duration(seconds: 2),
    this.autoSliderTransitionCurve = Curves.easeOutQuad,
    this.keepPage = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.unlimitedMode = false,
    this.initialPage = 0,
    this.onSlideChanged,
    this.onSlideStart,
    this.onSlideEnd,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
  })  : children = null,
        super(key: key);

  final CarouselSlideBuilder? slideBuilder;
  final List<Widget>? children;
  final int itemCount;
  final SlideTransform slideTransform;
  final SlideIndicator? slideIndicator;
  final double viewportFraction;
  final bool enableAutoSlider;

  /// Waiting time before starting the auto slider
  final Duration autoSliderDelay;

  final Duration autoSliderTransitionTime;
  final Curve autoSliderTransitionCurve;
  final bool unlimitedMode;
  final bool keepPage;
  final ScrollPhysics scrollPhysics;
  final Axis scrollDirection;
  final int initialPage;
  final ValueChanged<int>? onSlideChanged;
  final VoidCallback? onSlideStart;
  final VoidCallback? onSlideEnd;
  final Clip clipBehavior;
  final CarouselSliderController? controller;

  @override
  State<StatefulWidget> createState() => _CarouselSliderState();
}

class CarouselSliderController {
  _CarouselSliderState? _state;

  nextPage([Duration? transitionDuration]) {
    if (_state != null && _state!.mounted) {
      _state!._nextPage(transitionDuration);
    }
  }

  previousPage([Duration? transitionDuration]) {
    if (_state != null && _state!.mounted) {
      _state!._previousPage(transitionDuration);
    }
  }

  setAutoSliderEnabled(bool isEnabled) {
    if (_state != null && _state!.mounted) {
      _state!._setAutoSliderEnabled(isEnabled);
    }
  }
}

class _CarouselSliderState extends State<CarouselSlider> {
  PageController? _pageController;
  Timer? _timer;
  int? _currentPage;
  double _pageDelta = 0;
  late bool _isPlaying;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.itemCount > 0)

          ///Notification Listener added in order to capture Slide Start and Slide End events
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                widget.onSlideStart!.call();
              } else if (notification is ScrollEndNotification) {
                widget.onSlideEnd!.call();
              }
              return true;
            },
            child: PageView.builder(
              onPageChanged: (val) {
                widget.onSlideChanged?.call(val);
              },
              clipBehavior: widget.clipBehavior,
              scrollBehavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                overscroll: false,
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              itemCount: widget.unlimitedMode ? _kMaxValue : widget.itemCount,
              controller: _pageController,
              scrollDirection: widget.scrollDirection,
              physics: widget.scrollPhysics,
              itemBuilder: (context, index) {
                final slideIndex = index % widget.itemCount;
                Widget slide = widget.children == null
                    ? widget.slideBuilder!(slideIndex)
                    : widget.children![slideIndex];
                return widget.slideTransform.transform(context, slide, index,
                    _currentPage, _pageDelta, widget.itemCount);
              },
            ),
          ),
        if (widget.slideIndicator != null && widget.itemCount > 0)
          widget.slideIndicator!.build(
              _currentPage! % widget.itemCount, _pageDelta, widget.itemCount),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant CarouselSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enableAutoSlider != widget.enableAutoSlider) {
      _setAutoSliderEnabled(widget.enableAutoSlider);
    }
    if (oldWidget.itemCount != widget.itemCount) {
      _initPageController();
    }
    _initCarouselSliderController();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _pageController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.enableAutoSlider;
    _currentPage = widget.initialPage;
    _initCarouselSliderController();
    _initPageController();
    _setAutoSliderEnabled(_isPlaying);
  }

  void _initCarouselSliderController() {
    if (widget.controller != null) {
      widget.controller!._state = this;
    }
  }

  void _initPageController() {
    _pageController?.dispose();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      keepPage: widget.keepPage,
      initialPage: widget.unlimitedMode
          ? _kMiddleValue * widget.itemCount + _currentPage!
          : _currentPage!,
    );
    _pageController!.addListener(() {
      setState(() {
        _currentPage = _pageController!.page!.floor();
        _pageDelta = _pageController!.page! - _pageController!.page!.floor();
      });
    });
  }

  void _nextPage(Duration? transitionDuration) {
    _pageController!.nextPage(
      duration: transitionDuration ?? widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  void _previousPage(Duration? transitionDuration) {
    _pageController!.previousPage(
      duration: transitionDuration ?? widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  void _setAutoSliderEnabled(bool isEnabled) {
    if (_timer != null) {
      _timer!.cancel();
    }
    if (isEnabled) {
      _timer = Timer.periodic(widget.autoSliderDelay, (timer) {
        _pageController!.nextPage(
          duration: widget.autoSliderTransitionTime,
          curve: widget.autoSliderTransitionCurve,
        );
      });
    }
  }
}
