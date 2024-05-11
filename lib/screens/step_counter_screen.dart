import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});
  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  static const int _snakeRows = 20;
  static const int _snakeColumns = 20;
  static const double _snakeCellSize = 10.0;

  UserAccelerometerEvent? _userAccelerometerEvent;
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;

  DateTime? _userAccelerometerUpdateTime;
  DateTime? _accelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;
  DateTime? _magnetometerUpdateTime;

  int? _userAccelerometerLastInterval;
  int? _accelerometerLastInterval;
  int? _gyroscopeLastInterval;
  int? _magnetometerLastInterval;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  Duration sensorInterval = SensorInterval.normalInterval;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors Plus Example'),
        elevation: 4,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
              ),
              child: SizedBox(
                height: _snakeRows * _snakeCellSize,
                width: _snakeColumns * _snakeCellSize,
                child: Snake(
                  rows: _snakeRows,
                  columns: _snakeColumns,
                  cellSize: _snakeCellSize,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                4: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  children: [
                    SizedBox.shrink(),
                    Text('X'),
                    Text('Y'),
                    Text('Z'),
                    Text('Interval'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('UserAccelerometer'),
                    ),
                    Text(_userAccelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_userAccelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_userAccelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text(
                        '${_userAccelerometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Accelerometer'),
                    ),
                    Text(_accelerometerEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_accelerometerEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_accelerometerEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text('${_accelerometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Gyroscope'),
                    ),
                    Text(_gyroscopeEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_gyroscopeEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_gyroscopeEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text('${_gyroscopeLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Magnetometer'),
                    ),
                    Text(_magnetometerEvent?.x.toStringAsFixed(1) ?? '?'),
                    Text(_magnetometerEvent?.y.toStringAsFixed(1) ?? '?'),
                    Text(_magnetometerEvent?.z.toStringAsFixed(1) ?? '?'),
                    Text('${_magnetometerLastInterval?.toString() ?? '?'} ms'),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Update Interval:'),
              SegmentedButton(
                segments: [
                  ButtonSegment(
                    value: SensorInterval.gameInterval,
                    label: Text('Game\n'
                        '(${SensorInterval.gameInterval.inMilliseconds}ms)'),
                  ),
                  ButtonSegment(
                    value: SensorInterval.uiInterval,
                    label: Text('UI\n'
                        '(${SensorInterval.uiInterval.inMilliseconds}ms)'),
                  ),
                  ButtonSegment(
                    value: SensorInterval.normalInterval,
                    label: Text('Normal\n'
                        '(${SensorInterval.normalInterval.inMilliseconds}ms)'),
                  ),
                  const ButtonSegment(
                    value: Duration(milliseconds: 500),
                    label: Text('500ms'),
                  ),
                  const ButtonSegment(
                    value: Duration(seconds: 1),
                    label: Text('1s'),
                  ),
                ],
                selected: {sensorInterval},
                showSelectedIcon: false,
                onSelectionChanged: (value) {
                  setState(() {
                    sensorInterval = value.first;
                    userAccelerometerEventStream(
                        samplingPeriod: sensorInterval);
                    accelerometerEventStream(samplingPeriod: sensorInterval);
                    gyroscopeEventStream(samplingPeriod: sensorInterval);
                    magnetometerEventStream(samplingPeriod: sensorInterval);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      userAccelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (UserAccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _userAccelerometerEvent = event;
            if (_userAccelerometerUpdateTime != null) {
              final interval = now.difference(_userAccelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _userAccelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _userAccelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support User Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _accelerometerEvent = event;
            if (_accelerometerUpdateTime != null) {
              final interval = now.difference(_accelerometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _accelerometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _accelerometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Accelerometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
        (GyroscopeEvent event) {
          final now = DateTime.now();
          setState(() {
            _gyroscopeEvent = event;
            if (_gyroscopeUpdateTime != null) {
              final interval = now.difference(_gyroscopeUpdateTime!);
              if (interval > _ignoreDuration) {
                _gyroscopeLastInterval = interval.inMilliseconds;
              }
            }
          });
          _gyroscopeUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Gyroscope Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      magnetometerEventStream(samplingPeriod: sensorInterval).listen(
        (MagnetometerEvent event) {
          final now = DateTime.now();
          setState(() {
            _magnetometerEvent = event;
            if (_magnetometerUpdateTime != null) {
              final interval = now.difference(_magnetometerUpdateTime!);
              if (interval > _ignoreDuration) {
                _magnetometerLastInterval = interval.inMilliseconds;
              }
            }
          });
          _magnetometerUpdateTime = now;
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Magnetometer Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }
}

class Snake extends StatefulWidget {
  Snake({super.key, this.rows = 20, this.columns = 20, this.cellSize = 10.0}) {
    assert(10 <= rows);
    assert(10 <= columns);
    assert(5.0 <= cellSize);
  }

  final int rows;
  final int columns;
  final double cellSize;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => SnakeState(rows, columns, cellSize);
}

class SnakeBoardPainter extends CustomPainter {
  SnakeBoardPainter(this.state, this.cellSize);

  GameState? state;
  double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final blackLine = Paint()..color = Colors.black;
    final blackFilled = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromPoints(Offset.zero, size.bottomLeft(Offset.zero)),
      blackLine,
    );
    for (final p in state!.body) {
      final a = Offset(cellSize * p.x, cellSize * p.y);
      final b = Offset(cellSize * (p.x + 1), cellSize * (p.y + 1));

      canvas.drawRect(Rect.fromPoints(a, b), blackFilled);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SnakeState extends State<Snake> {
  SnakeState(int rows, int columns, this.cellSize) {
    state = GameState(rows, columns);
  }

  double cellSize;
  GameState? state;
  AccelerometerEvent? acceleration;
  late StreamSubscription<AccelerometerEvent> _streamSubscription;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: SnakeBoardPainter(state, cellSize));
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      setState(() {
        acceleration = event;
      });
    });

    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _step();
      });
    });
  }

  void _step() {
    final newDirection = acceleration == null
        ? null
        : acceleration!.x.abs() < 1.0 && acceleration!.y.abs() < 1.0
            ? null
            : (acceleration!.x.abs() < acceleration!.y.abs())
                ? math.Point<int>(0, acceleration!.y.sign.toInt())
                : math.Point<int>(-acceleration!.x.sign.toInt(), 0);
    state!.step(newDirection);
  }
}

class GameState {
  GameState(this.rows, this.columns) {
    snakeLength = math.min(rows, columns) - 5;
  }

  int rows;
  int columns;
  late int snakeLength;

  List<math.Point<int>> body = <math.Point<int>>[const math.Point<int>(0, 0)];
  math.Point<int> direction = const math.Point<int>(1, 0);

  void step(math.Point<int>? newDirection) {
    var next = body.last + direction;
    next = math.Point<int>(next.x % columns, next.y % rows);

    body.add(next);
    if (body.length > snakeLength) body.removeAt(0);
    direction = newDirection ?? direction;
  }
}
