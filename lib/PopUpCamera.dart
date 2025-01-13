import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras[0], // Select the back camera
        ResolutionPreset.ultraHigh
      );

      await _cameraController?.initialize();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera View'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
          children: [
            if (_isCameraInitialized && _cameraController != null)
              CameraPreview(_cameraController!)
            else
              Center(child: CircularProgressIndicator()),
          ],
        ),
    );
  }
}
