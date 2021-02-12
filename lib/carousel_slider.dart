library fluttercarouselslider;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'carousel_slider_indicators.dart';
import 'carousel_slider_transforms.dart';

const _kMaxValue = 200000000000;
const _kMiddleValue = 100000;

class CarouselSlider extends StatefulWidget {
  final CarouselSlideBuilder slideBuilder;
  final List<Widget> children;
  final int itemCount;
  final SlideTransform slideTransform;
  final SlideIndicator slideIndicator;
  final double viewportFraction;
  final bool enableAutoSlider;
  final Duration autoSliderTimeout;
  final Duration autoSliderTransitionTime;
  final Curve autoSliderTransitionCurve;
  final bool unlimitedMode;
  final bool keepPage;
  final ScrollPhysics scrollPhysics;
  final Axis scrollDirection;
  final int initialPage;
  final CarouselSliderController controller;

  CarouselSlider.builder({
    Key key,
    @required this.slideBuilder,
    this.slideTransform = const DefaultTransform(),
    this.slideIndicator,
    @required this.itemCount,
    this.viewportFraction = 1,
    this.enableAutoSlider = false,
    this.autoSliderTimeout = const Duration(seconds: 5),
    this.autoSliderTransitionTime = const Duration(seconds: 2),
    this.autoSliderTransitionCurve = Curves.easeOutQuad,
    this.keepPage = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.unlimitedMode = false,
    this.initialPage = 0,
    this.controller,
  })  : children = null,
        super(key: key);

  CarouselSlider({
    Key key,
    @required this.children,
    this.slideTransform = const DefaultTransform(),
    this.slideIndicator,
    this.viewportFraction = 1,
    this.enableAutoSlider = false,
    this.autoSliderTimeout = const Duration(seconds: 5),
    this.autoSliderTransitionTime = const Duration(seconds: 2),
    this.autoSliderTransitionCurve = Curves.easeOutQuad,
    this.keepPage = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.unlimitedMode = false,
    this.initialPage = 0,
    this.controller,
  })  : slideBuilder = null,
        itemCount = children.length,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  PageController _pageController;
  Timer _timer;
  int _currentPage;
  double _pageDelta = 0;
  bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.enableAutoSlider;
    _currentPage = widget.initialPage;
    _initCarouselSliderController();
    _initPageController();
    _setAutoSliderEnabled(_isPlaying);
  }

  void _initPageController() {
    _pageController?.dispose();
    _pageController = new PageController(
      viewportFraction: widget.viewportFraction,
      keepPage: widget.keepPage,
      initialPage: widget.unlimitedMode ? _kMiddleValue * widget.itemCount + _currentPage : _currentPage,
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page.floor();
        _pageDelta = _pageController.page - _pageController.page.floor();
      });
    });
  }

  void _initCarouselSliderController() {
    if (widget.controller != null) {
      widget.controller._state = this;
    }
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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.itemCount > 0)
          PageView.builder(
            itemCount: widget.unlimitedMode ? _kMaxValue : widget.itemCount,
            controller: _pageController,
            scrollDirection: widget.scrollDirection,
            physics: widget.scrollPhysics,
            itemBuilder: (context, index) {
              final slideIndex = index % widget.itemCount;
              Widget slide = widget.children == null ? widget.slideBuilder(slideIndex) : widget.children[slideIndex];
              return widget.slideTransform.transform(context, slide, index, _currentPage, _pageDelta, widget.itemCount);
            },
          ),
        if (widget.slideIndicator != null && widget.itemCount > 0)
          widget.slideIndicator.build(_currentPage % widget.itemCount, _pageDelta, widget.itemCount),
      ],
    );
  }

  void _setAutoSliderEnabled(bool isEnabled) {
    if (_timer != null) {
      _timer.cancel();
    }
    if (isEnabled) {
      _timer = Timer.periodic(widget.autoSliderTimeout, (timer) {
        _pageController.nextPage(
          duration: widget.autoSliderTransitionTime,
          curve: widget.autoSliderTransitionCurve,
        );
      });
    }
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _pageController?.dispose();
  }
}

class CarouselSliderController {
  _CarouselSliderState _state;

  nextPage() {
    if (_state != null && _state.mounted) {
      _state._nextPage();
    }
  }

  previousPage() {
    if (_state != null && _state.mounted) {
      _state._previousPage();
    }
  }

  setAutoSliderEnabled(bool isEnabled) {
    if (_state != null && _state.mounted) {
      _state._setAutoSliderEnabled(isEnabled);
    }
  }
}

typedef Widget CarouselSlideBuilder(int index);
