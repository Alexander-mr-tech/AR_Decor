import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:camera/camera.dart';
import 'dart:math' as math;

class Aecore extends StatefulWidget {
  const Aecore({super.key});

  @override
  State<Aecore> createState() => _AecoreState();
}

class _AecoreState extends State<Aecore> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  Object? model;

  double _rotationX = 0.0;
  double _rotationY = 0.0;
  double _zoom = 1.5;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.ultraHigh);
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text("3D Model AR View"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          // ✅ Live Camera Background
          _isCameraInitialized && _cameraController != null
              ? Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Transform.rotate(
                angle: math.pi / 2.0,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _cameraController!.value.previewSize!.width,
                    height: _cameraController!.value.previewSize!.height,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            ),
          )
              : Center(child: CircularProgressIndicator()),

          // ✅ 3D Model
          Positioned.fill(
            child: Cube(
              onSceneCreated: (Scene scene) {
                model = Object(
                  scale: Vector3(_zoom, _zoom, _zoom),
                  position: Vector3(0, -1, -3),
                  fileName: "assets/models/Chair1.obj",
                );
                scene.world.add(model!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
