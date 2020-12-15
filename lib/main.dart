import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final drawModelMap = <Color, DrawModel>{};
  final nodeSize = 30.0;
  final chainSize = 4.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        foregroundPainter: WirePainter(drawModelMap.values.toList()),
        painter: WirePainter(drawModelMap.values.toList()),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                  right: 60,
                  top: 200,
                  child: DragTargetWidget(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        height: nodeSize,
                        width: nodeSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      );
                    },
                    onDragSuccess: (position) {
                      final drawModel = drawModelMap[Colors.green]
                        ..currentPosition = position;
                      setState(() {
                        drawModelMap[Colors.green] = drawModel;
                      });
                    },
                    onWillAccept: (MaterialColor data) {
                      return data == Colors.green;
                    },
                  )),
              Positioned(
                left: 60,
                top: 410,
                child: DraggableWidget(
                  onPointerDown: (position) {
                    final drawModel = DrawModel(
                        position,
                        position,
                        Paint()
                          ..color = Colors.green
                          ..strokeWidth = chainSize);
                    setState(() {
                      drawModelMap[Colors.green] = drawModel;
                    });
                  },
                  onPointerMove: (position) {
                    final drawModel = drawModelMap[Colors.green]
                      ..currentPosition = position;
                    setState(() {
                      drawModelMap[Colors.green] = drawModel;
                    });
                  },
                  onDragCanceled: (position) {
                    setState(() {
                      drawModelMap.remove(Colors.green);
                    });
                  },
                  feedback: Container(
                    height: nodeSize,
                    width: nodeSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                  ),
                  data: Colors.green,
                  child: Container(
                    child: Center(
                      child: Container(
                        height: nodeSize,
                        width: nodeSize,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                      ),
                    ),
                    height: nodeSize,
                    width: nodeSize,
                  ),
                ),
              ),
              Positioned(
                right: 60,
                top: 410,
                child: DragTargetWidget(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: nodeSize,
                      width: nodeSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    );
                  },
                  onDragSuccess: (position) {
                    final drawModel = drawModelMap[Colors.red]
                      ..currentPosition = position;
                    setState(() {
                      drawModelMap[Colors.red] = drawModel;
                    });
                  },
                  onWillAccept: (MaterialColor data) {
                    return data == Colors.red;
                  },
                ),
              ),
              Positioned(
                  left: 60,
                  top: 200,
                  child: DraggableWidget(
                    onPointerDown: (position) {
                      final drawModel = DrawModel(
                          position,
                          position,
                          Paint()
                            ..color = Colors.red
                            ..strokeWidth = chainSize);
                      setState(() {
                        drawModelMap[Colors.red] = drawModel;
                      });
                    },
                    onPointerMove: (position) {
                      final drawModel = drawModelMap[Colors.red]
                        ..currentPosition = position;
                      setState(() {
                        drawModelMap[Colors.red] = drawModel;
                      });
                    },
                    onDragCanceled: (position) {
                      setState(() {
                        drawModelMap.remove(Colors.red);
                      });
                    },
                    feedback: Container(
                      height: nodeSize,
                      width: nodeSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    ),
                    data: Colors.red,
                    child: Container(
                      child: Center(
                        child: Container(
                          height: nodeSize,
                          width: nodeSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      height: nodeSize,
                      width: nodeSize,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class WirePainter extends CustomPainter {
  final List<DrawModel> drawModels;

  WirePainter(this.drawModels);
  @override
  void paint(Canvas canvas, Size size) {
    for (final drawModel in drawModels) {
      final startPosition = drawModel.startPosition;
      final currentPosition = drawModel.currentPosition;
      canvas.drawLine(startPosition, currentPosition, drawModel.paint);
      canvas.drawCircle(currentPosition, 15, drawModel.paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawModel {
  Offset startPosition;
  Offset currentPosition;
  Paint paint;

  DrawModel(this.startPosition, this.currentPosition, this.paint);
}

typedef _OnDragMove = void Function(Offset position);
typedef _OnDragCanceled = void Function(Offset position);
typedef _OnDragSuccess = void Function(Offset position);
typedef _OnDragStart = void Function(Offset position);

class DraggableWidget<T> extends StatelessWidget {
  final _OnDragMove onPointerMove;
  final _OnDragStart onPointerDown;
  final _OnDragCanceled onDragCanceled;
  final Widget feedback;
  final Widget child;
  final T data;

  DraggableWidget(
      {Key key,
      this.onPointerMove,
      this.onPointerDown,
      this.onDragCanceled,
      @required this.feedback,
      this.child,
      @required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Listener(
            onPointerDown: (details) {
              print("On Pan Start: $details");
            },
            onPointerMove: (details) {
              print("On Pan Move: $details");
              final localPosition = details.position;
              print("Local pos on mov: $localPosition");
              onPointerMove(localPosition);
            },
            child: Draggable<T>(
              onDraggableCanceled: (v, offset) {
                onDragCanceled(offset);
              },
              onDragCompleted: () {},
              onDragStarted: () {
                final RenderBox renderBox = context.findRenderObject();
                final globalPosition = renderBox.localToGlobal(Offset.zero);
                final localPosition =
                    Offset(globalPosition.dx + 15, globalPosition.dy + 15);
                print("Local pos on start: $localPosition");
                onPointerDown(localPosition);
              },
              data: data,
              feedback: feedback,
              child: child,
            )));
  }
}

class DragTargetWidget<T> extends StatelessWidget {
  final _OnDragSuccess onDragSuccess;
  final DragTargetBuilder builder;
  final DragTargetWillAccept<T> onWillAccept;

  DragTargetWidget(
      {Key key, this.onDragSuccess, this.builder, @required this.onWillAccept})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      onAcceptWithDetails: (details) {
        print("On accept with details: ${details.offset}");
      },
      onAccept: (data) {
        print("Drag Success!");
        final RenderBox renderBox = context.findRenderObject();
        final globalPosition = renderBox.localToGlobal(Offset.zero);
        final localPosition =
            Offset(globalPosition.dx + 15, globalPosition.dy + 15);
        print("Local pos on success $localPosition");
        onDragSuccess(localPosition);
      },
      onWillAccept: onWillAccept,
      builder: builder,
    );
  }
}
