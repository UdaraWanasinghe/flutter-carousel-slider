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

  CarouselSlider.builder({
    Key key,
    @required this.slideBuilder,
    @required this.slideTransform,
    @required this.slideIndicator,
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
  })  : children = null,
        super(key: key);

  CarouselSlider({
    Key key,
    @required this.children,
    @required this.slideTransform,
    @required this.slideIndicator,
    this.viewportFraction = 1,
    this.enableAutoSlider = false,
    this.autoSliderTimeout = const Duration(seconds: 5),
    this.autoSliderTransitionTime = const Duration(seconds: 2),
    this.autoSliderTransitionCurve = Curves.easeOutQuad,
    this.keepPage = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.scrollDirection = Axis.horizontal,
    this.unlimitedMode = false,
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
  int _currentPage = 0;
  double _pageDelta = 0;
  bool _isPlaying;

  CarouselSliderState({bool isPlaying = false}) : _isPlaying = isPlaying;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(
      viewportFraction: widget.viewportFraction,
      keepPage: widget.keepPage,
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
          itemCount: widget.unlimitedMode ? null : widget.itemCount,
          controller: _pageController,
          scrollDirection: widget.scrollDirection,
          physics: widget.scrollPhysics,
          itemBuilder: (context, index) {
            index %= widget.itemCount;
            Widget slide = widget.children == null
                ? widget.slideBuilder(index)
                : widget.children[index];
            return widget.slideTransform.transform(context, slide, index,
                _currentPage, _pageDelta, widget.itemCount);
          },
        ),
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
