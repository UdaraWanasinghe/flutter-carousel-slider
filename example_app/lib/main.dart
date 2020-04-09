import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carousel Slider Demo',
      home: MyHomePage(title: 'Flutter Carousel Slider'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  final List<String> letters = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
  ];

  Transforms _transform = Transforms.CubeTransform;
  SlideTransform _slideTransform = CubeTransform();
  Indicators _indicator = Indicators.CircularSlideIndicator;
  SlideIndicator _slideIndicator = CircularSlideIndicator(
    padding: EdgeInsets.only(bottom: 32),
  );
  bool _isPlaying = false;
  GlobalKey<CarouselSliderState> _sliderKey = GlobalKey<CarouselSliderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.transform),
            onPressed: () {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text("Transforms"),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _getTransformRadio(
                                Transforms.CubeTransform, _transform, setState),
                            _getTransformRadio(Transforms.ZoomOutSlideTransform,
                                _transform, setState),
                            _getTransformRadio(Transforms.RotateUpTransform,
                                _transform, setState),
                            _getTransformRadio(Transforms.RotateDownTransform,
                                _transform, setState),
                            _getTransformRadio(Transforms.TabletTransform,
                                _transform, setState),
                            _getTransformRadio(Transforms.StackTransform,
                                _transform, setState),
                            _getTransformRadio(Transforms.ParallaxTransform,
                                _transform, setState),
                            _getTransformRadio(
                                Transforms.ForegroundToBackgroundTransform,
                                _transform,
                                setState),
                            _getTransformRadio(Transforms.FlipVerticalTransform,
                                _transform, setState),
                            _getTransformRadio(Transforms.DepthTransform,
                                _transform, setState),
                            _getTransformRadio(
                                Transforms.BackgroundToForegroundTransform,
                                _transform,
                                setState),
                            _getTransformRadio(Transforms.AccordionTransform,
                                _transform, setState),
                            _getTransformRadio(Transforms.DefaultTransform,
                                _transform, setState),
                            _getTransformRadio(
                                Transforms.FlipHorizontalTransform,
                                _transform,
                                setState),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.transit_enterexit),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text("Indicators"),
                    content: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: <Widget>[
                            _getIndicatorRadio(
                                Indicators.CircularSlideIndicator,
                                _indicator,
                                setState),
                            _getIndicatorRadio(
                                Indicators.CircularWaveSlideIndicator,
                                _indicator,
                                setState),
                            _getIndicatorRadio(
                                Indicators.CircularStaticIndicator,
                                _indicator,
                                setState),
                            _getIndicatorRadio(
                                Indicators.SequentialFillIndicator,
                                _indicator,
                                setState),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 400,
            child: CarouselSlider(
              key: _sliderKey,
              unlimitedMode: true,
              autoSliderTransitionTime: Duration(seconds: 1),
              itemCount: letters.length,
              slideBuilder: (index) {
                return Container(
                  color: colors[index],
                  child: Center(
                    child: Text(
                      letters[index],
                      style: TextStyle(
                        fontSize: 200,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              slideTransform: _slideTransform,
              slideIndicator: _slideIndicator,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 240, maxWidth: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: 48,
                    icon: Icon(Icons.skip_previous),
                    onPressed: () {
                      _sliderKey.currentState.previousPage();
                    },
                  ),
                  IconButton(
                    iconSize: 64,
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          _isPlaying = !_isPlaying;
                          _sliderKey.currentState.setPlaying(_isPlaying);
                        },
                      );
                    },
                  ),
                  IconButton(
                    iconSize: 48,
                    icon: Icon(Icons.skip_next),
                    onPressed: () {
                      _sliderKey.currentState.nextPage();
                    },
                  ),
                ],
              ),
            ),
          ),
          Center(child: Text("ᴅᴇᴠᴇʟᴏᴘᴇᴅ ʙʏ ᑗᗫᗅᖇᗅ 🧘‍♂️🎶🎵💛🧡")),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _getRadio(value, groupValue, onChange) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChange,
        ),
        Text(
          value.toString().split('.').last,
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }

  Widget _getTransformRadio(value, groupValue, state) {
    return _getRadio(value, groupValue, (value) {
      setState(() {
        _transform = value;
        _slideTransform = _getTransform(value);
        state(() {});
        Navigator.of(context).pop();
      });
    });
  }

  Widget _getIndicatorRadio(value, groupValue, state) {
    return _getRadio(value, groupValue, (value) {
      setState(() {
        _indicator = value;
        _slideIndicator = _getIndicator(value);
        state(() {});
        Navigator.of(context).pop();
      });
    });
  }

  SlideTransform _getTransform(Transforms transform) {
    switch (transform) {
      case Transforms.CubeTransform:
        return CubeTransform();
      case Transforms.AccordionTransform:
        return AccordionTransform();
      case Transforms.BackgroundToForegroundTransform:
        return BackgroundToForegroundTransform();
      case Transforms.ForegroundToBackgroundTransform:
        return ForegroundToBackgroundTransform();
      case Transforms.DefaultTransform:
        return DefaultTransform();
      case Transforms.DepthTransform:
        return DepthTransform();
      case Transforms.FlipHorizontalTransform:
        return FlipHorizontalTransform();
      case Transforms.FlipVerticalTransform:
        return FlipVerticalTransform();
      case Transforms.ParallaxTransform:
        return ParallaxTransform();
      case Transforms.StackTransform:
        return StackTransform();
      case Transforms.TabletTransform:
        return TabletTransform();
      case Transforms.RotateDownTransform:
        return RotateDownTransform();
      case Transforms.RotateUpTransform:
        return RotateUpTransform();
      case Transforms.ZoomOutSlideTransform:
        return ZoomOutSlideTransform();
    }
    return CubeTransform();
  }

  SlideIndicator _getIndicator(Indicators indicator) {
    switch (indicator) {
      case Indicators.CircularSlideIndicator:
        return CircularSlideIndicator(
          padding: EdgeInsets.only(bottom: 32),
        );
      case Indicators.CircularWaveSlideIndicator:
        return CircularWaveSlideIndicator(
          padding: EdgeInsets.only(bottom: 32),
        );
      case Indicators.CircularStaticIndicator:
        return CircularStaticIndicator(
          padding: EdgeInsets.only(bottom: 32),
          enableAnimation: true,
        );
      case Indicators.SequentialFillIndicator:
        return SequentialFillIndicator(
          padding: EdgeInsets.only(bottom: 32),
          enableAnimation: true,
        );
    }
    return CircularSlideIndicator(
      padding: EdgeInsets.only(bottom: 32),
    );
  }
}

enum Transforms {
  CubeTransform,
  AccordionTransform,
  BackgroundToForegroundTransform,
  ForegroundToBackgroundTransform,
  DefaultTransform,
  DepthTransform,
  FlipHorizontalTransform,
  FlipVerticalTransform,
  ParallaxTransform,
  StackTransform,
  TabletTransform,
  RotateDownTransform,
  RotateUpTransform,
  ZoomOutSlideTransform,
}

enum Indicators {
  CircularSlideIndicator,
  CircularWaveSlideIndicator,
  CircularStaticIndicator,
  SequentialFillIndicator,
}
