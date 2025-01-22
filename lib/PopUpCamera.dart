// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_cube/flutter_cube.dart';
// import 'dart:math' as math;
//
// class FullScreenCamera extends StatefulWidget {
//   const FullScreenCamera({super.key});
//
//   @override
//   _FullScreenCameraState createState() => _FullScreenCameraState();
// }
//
// class _FullScreenCameraState extends State<FullScreenCamera> {
//   late List<CameraDescription> _cameras;
//   CameraController? _cameraController;
//   bool _isCameraInitialized = false;
//   bool _show3DModel = false;
//   FlashMode _flashMode = FlashMode.off;
//   Object? _object3D;
//
//   // Model Controls
//   double _rotationY = 0.0;
//   double _positionZ = -3.0;
//   double _scale = 2.0;
//
//   // Model Selection
//   String _selectedModel = "Chair1.obj"; // Default model
//   final List<String> _models = ["Chair1.obj", "Chair2.obj",];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }
//
//   Future<void> initializeCamera() async {
//     _cameras = await availableCameras();
//     if (_cameras.isNotEmpty) {
//       _cameraController = CameraController(
//         _cameras[0],
//         ResolutionPreset.ultraHigh,
//       );
//       await _cameraController?.initialize();
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     }
//   }
//
//   // Toggle Flashlight
//   void toggleFlash() async {
//     if (_flashMode == FlashMode.off) {
//       setState(() {
//         _flashMode = FlashMode.torch;
//       });
//       await _cameraController?.setFlashMode(FlashMode.torch);
//     } else {
//       setState(() {
//         _flashMode = FlashMode.off;
//       });
//       await _cameraController?.setFlashMode(FlashMode.off);
//     }
//   }
//
//   // Toggle 3D Model Visibility
//   void toggle3DModel() {
//     setState(() {
//       _show3DModel = !_show3DModel;
//     });
//   }
//
//   // Update 3D Model Transformations
//   void updateModel() {
//     if (_object3D != null) {
//       _object3D!.position.setValues(0, 0, _positionZ);
//       _object3D!.rotation.setValues(0, _rotationY, 0);
//       _object3D!.scale.setValues(_scale, _scale, _scale);
//       _object3D!.updateTransform();
//     }
//   }
//
//   // Change the Model
//   void changeModel(String newModel) {
//     setState(() {
//       _selectedModel = newModel;
//       _show3DModel = false; // Hide before changing the model
//       Future.delayed(Duration(milliseconds: 300), () {
//         setState(() {
//           _show3DModel = true; // Show the new model after a short delay
//         });
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Camera with 3D Model"),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(
//               _flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
//             ),
//             onPressed: toggleFlash,
//           ),
//           IconButton(
//             icon: Icon(
//               _show3DModel ? Icons.visibility : Icons.visibility_off,
//             ),
//             onPressed: toggle3DModel,
//           ),
//         ],
//       ),
//       body: _isCameraInitialized
//           ? Stack(
//         children: [
//           // Camera Preview
//           Align(
//             alignment: Alignment.center,
//             child: SizedBox(
//               width: screenSize.width,
//               height: screenSize.height,
//               child: Transform.rotate(
//                 angle: math.pi / 2.0,
//                 child: FittedBox(
//                   fit: BoxFit.cover,
//                   child: SizedBox(
//                     width: _cameraController!.value.previewSize!.width,
//                     height: _cameraController!.value.previewSize!.height,
//                     child: CameraPreview(_cameraController!),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // 3D Model Overlay (Only if _show3DModel is true)
//           if (_show3DModel)
//             Positioned.fill(
//               child: Cube(
//                 onSceneCreated: (Scene scene) {
//                   _object3D = Object(
//                     fileName: "assets/models/$_selectedModel",
//                     scale: Vector3(_scale, _scale, _scale),
//                     position: Vector3(0, 0, _positionZ),
//                   );
//                   _object3D!.rotation.setValues(0, _rotationY, 0);
//                   scene.world.add(_object3D!);
//                 },
//               ),
//             ),
//
//           // Model Control UI
//           if (_show3DModel)
//             Positioned(
//               bottom: 20,
//               left: 0,
//               right: 0,
//               child: Column(
//                 children: [
//                   // Model Selection Dropdown
//                   DropdownButton<String>(
//                     value: _selectedModel,
//                     items: _models.map((String model) {
//                       return DropdownMenuItem(
//                         value: model,
//                         child: Text(model),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         changeModel(value);
//                       }
//                     },
//                   ),
//
//                   // Rotate Left/Right
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.rotate_left, size: 40),
//                         onPressed: () {
//                           setState(() {
//                             _rotationY -= math.pi / 8;
//                             updateModel();
//                           });
//                         },
//                       ),
//                       const SizedBox(width: 20),
//                       IconButton(
//                         icon: const Icon(Icons.rotate_right, size: 40),
//                         onPressed: () {
//                           setState(() {
//                             _rotationY += math.pi / 8;
//                             updateModel();
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//
//                   // Move Forward/Backward
//                   Slider(
//                     value: _positionZ,
//                     min: -5.0,
//                     max: 5.0,
//                     divisions: 10,
//                     label: "Depth: $_positionZ",
//                     onChanged: (value) {
//                       setState(() {
//                         _positionZ = value;
//                         updateModel();
//                       });
//                     },
//                   ),
//
//                   // Scale (Size)
//                   Slider(
//                     value: _scale,
//                     min: 1.0,
//                     max: 5.0,
//                     divisions: 8,
//                     label: "Scale: $_scale",
//                     onChanged: (value) {
//                       setState(() {
//                         _scale = value;
//                         updateModel();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'dart:math' as math;

class FullScreenCamera extends StatefulWidget {
  const FullScreenCamera({super.key});

  @override
  _FullScreenCameraState createState() => _FullScreenCameraState();
}

class _FullScreenCameraState extends State<FullScreenCamera> {
  late List<CameraDescription> _cameras;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _show3DModel = false;
  FlashMode _flashMode = FlashMode.off;
  Object? _object3D;

  // Model Selection
  String _selectedModel = "Chair1.obj"; // Default model
  final List<String> _models = ["Chair1.obj", "Chair2.obj"];

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.ultraHigh,
      );
      await _cameraController?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  // Toggle Flashlight
  void toggleFlash() async {
    if (_flashMode == FlashMode.off) {
      setState(() {
        _flashMode = FlashMode.torch;
      });
      await _cameraController?.setFlashMode(FlashMode.torch);
    } else {
      setState(() {
        _flashMode = FlashMode.off;
      });
      await _cameraController?.setFlashMode(FlashMode.off);
    }
  }

  // Toggle 3D Model Visibility
  void toggle3DModel() {
    setState(() {
      _show3DModel = !_show3DModel;
    });
  }

  // Change the Model
  void changeModel(String newModel) {
    setState(() {
      _selectedModel = newModel;
      _show3DModel = false;
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _show3DModel = true;
        });
      });
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera with 3D Model"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
            ),
            onPressed: toggleFlash,
          ),
          IconButton(
            icon: Icon(
              _show3DModel ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: toggle3DModel,
          ),
        ],
      ),
      body: _isCameraInitialized
          ? Stack(
        children: [
          // Camera Preview
          Align(
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
          ),

          // 3D Model Overlay (Only if _show3DModel is true)
          if (_show3DModel)
            Positioned.fill(
              child: Cube(
                onSceneCreated: (Scene scene) {
                  _object3D = Object(
                    fileName: "assets/models/$_selectedModel",
                    scale: Vector3(2.0, 2.0, 2.0),
                    position: Vector3(0, 0, -3.0),
                  );

                  _object3D!.rotation.setValues(0, 0, 0);
                  scene.world.add(_object3D!);
                },
              ),
            ),

          // Model Selection UI
          if (_show3DModel)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Model Selection Dropdown
                  DropdownButton<String>(
                    value: _selectedModel,
                    items: _models.map((String model) {
                      return DropdownMenuItem(
                        value: model,
                        child: Text(model),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        changeModel(value);
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
