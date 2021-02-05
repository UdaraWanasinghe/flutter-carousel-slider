library fluttercarouselslider;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'carousel_slider_indicators.dart';
import 'carousel_slider_transforms.dart';

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
  })  : slideBuilder = null,
        itemCount = children.length,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CarouselSliderState(isPlaying: enableAutoSlider);
  }
}

class CarouselSliderState extends State<CarouselSlider> {
  PageController _pageController;
  Timer _timer;
  int _currentPage;
  double _pageDelta = 0;
  bool _isPlaying;

  CarouselSliderState({bool isPlaying = false}) : _isPlaying = isPlaying;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = new PageController(
      viewportFraction: widget.viewportFraction,
      keepPage: widget.keepPage,
      initialPage: widget.initialPage,
    );
    if (_isPlaying) {
      _timer = Timer.periodic(widget.autoSliderTimeout, (timer) {
        _pageController.nextPage(
          duration: widget.autoSliderTransitionTime,
          curve: widget.autoSliderTransitionCurve,
        );
      });
    }
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page.floor() % widget.itemCount;
        _pageDelta = _pageController.page - _pageController.page.floor();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView.builder(
          itemCount: widget.unlimitedMode
              ? widget.itemCount > 0
                  ? null
                  : 0
              : widget.itemCount,
          controller: _pageController,
          scrollDirection: widget.scrollDirection,
          physics: widget.scrollPhysics,
          itemBuilder: (context, index) {
            index %= widget.itemCount;
            Widget slide = widget.children == null ? widget.slideBuilder(index) : widget.children[index];
            return widget.slideTransform.transform(context, slide, index, _currentPage, _pageDelta, widget.itemCount);
          },
        ),
        if (widget.slideIndicator != null && widget.itemCount > 0)
          widget.slideIndicator.build(_currentPage, _pageDelta, widget.itemCount),
      ],
    );
  }

  void setPlaying(bool playing) {
    if (_timer != null) {
      _timer.cancel();
    }
    if (playing) {
      _timer = Timer.periodic(widget.autoSliderTimeout, (timer) {
        _pageController.nextPage(
          duration: widget.autoSliderTransitionTime,
          curve: widget.autoSliderTransitionCurve,
        );
      });
    }
  }

  void nextPage() {
    _pageController.nextPage(
      duration: widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: widget.autoSliderTransitionTime,
      curve: widget.autoSliderTransitionCurve,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}

typedef Widget CarouselSlideBuilder(int index);
