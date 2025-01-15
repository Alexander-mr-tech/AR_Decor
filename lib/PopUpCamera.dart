import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math' as math;

class FullScreenCamera extends StatefulWidget {
  @override
  _FullScreenCameraState createState() => _FullScreenCameraState();
}

class _FullScreenCameraState extends State<FullScreenCamera> {
  late List<CameraDescription> _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    // Get list of available cameras
    _cameras = await availableCameras();

    if (_cameras.isNotEmpty) {
      // Initialize camera controller for the first available camera (back camera)
      _cameraController = CameraController(
        _cameras[0], // Use the first camera (e.g., back camera)
        ResolutionPreset.ultraHigh, // Set the resolution preset (high, medium, low)
      );

      // Initialize the camera
      await _cameraController?.initialize();

      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    // Dispose the camera controller to release resources
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Full-screen size
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _isCameraInitialized
          ? Stack(
        children: [
          // Display the camera preview
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Transform.rotate(
                angle: math.pi / 2.0, // Apply rotation (optional)
                child: FittedBox(
                  fit: BoxFit.cover, // BoxFit.cover ensures the preview fills the screen
                  child: SizedBox(
                    width: _cameraController!.value.previewSize!.width,
                    height: _cameraController!.value.previewSize!.height,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
