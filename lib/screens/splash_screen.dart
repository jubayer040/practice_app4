import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _textAnim1, _textAnimEnd1;
  late Animation<double> _textAnim2, _textAnimEnd2;
  late Animation<double> _textAnim3, _textAnimEnd3;
  // late Animation<double> _textAnim4, _textAnimEnd4;
  late Animation<double> _textAnim5, _textAnimEnd5;
  late Animation<double> _textAnim6, _textAnimEnd6;
  // late Animation<double> _textAnim7, _textAnimEnd7;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _initializeAnimation();
  }

  void _initializeAnimation() {
    ///
    /// scale animation
    _textAnim1 = Tween(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.4, curve: Curves.easeInExpo)),
    );

    _textAnim2 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.4, 0.55, curve: Curves.bounceIn)),
    );

    _textAnim3 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.55, 0.7, curve: Curves.bounceIn)),
    );

    _textAnim5 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.70, 0.85, curve: Curves.bounceIn)),
    );
    _textAnim6 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.85, 1.0, curve: Curves.bounceIn)),
    );

    // ///
    // /// opacity animation
    // _textAnimEnd1 =
    //     CurvedAnimation(parent: _controller, curve: const Interval(.0, .07));
    // _textAnimEnd2 =
    //     CurvedAnimation(parent: _controller, curve: const Interval(.10, .19));
    // _textAnim3 =
    //     CurvedAnimation(parent: _controller, curve: const Interval(.24, .33));
    // _textAnimEnd4 =
    //     CurvedAnimation(parent: _controller, curve: const Interval(.38, .47));
    // _textAnimEnd5 =
    //     CurvedAnimation(parent: _controller, curve: const Interval(.52, .61));
    // _textAnimEnd6 =
    //     CurvedAnimation(parent: _controller, curve: const Interval(.66, .75));
    // _textAnimEnd7 =
    //     CurvedAnimation(parent: _controller, curve: const Interval(.80, .89));
    if (mounted) _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _getAnimation(
                          img: "assets/images/w.png", animation: _textAnim1),
                      _getAnimation(
                          img: "assets/images/e.png", animation: _textAnim2),
                      _getAnimation(
                          img: "assets/images/l.png", animation: _textAnim3),
                      _getAnimation(
                          img: "assets/images/c.png", animation: _textAnim1),
                      _getAnimation(
                          img: "assets/images/o.png", animation: _textAnim5),
                      _getAnimation(
                          img: "assets/images/m.png", animation: _textAnim6),
                      _getAnimation(
                          img: "assets/images/e.png", animation: _textAnim1),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _getAnimation({
    required String img,
    required Animation<double> animation,
  }) {
    return
        // Opacity(
        //   opacity: (animation.value).clamp(0.0, 1.0),
        //   child:
        Transform.scale(
      scale: animation.value,
      alignment: Alignment.center,
      child: Image.asset(img, fit: BoxFit.cover),
      //  ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
