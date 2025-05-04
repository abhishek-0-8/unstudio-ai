import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SelfieCaptureScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final List<XFile> existingSelfies; // Accept existing selfies for retake
  final int? retakeIndex; // If not null, retake a specific selfie


  const SelfieCaptureScreen({Key? key, required this.cameras,
    this.existingSelfies = const [],
    this.retakeIndex,}) : super(key: key);

  @override
  State<SelfieCaptureScreen> createState() => _SelfieCaptureScreenState();
}

class _SelfieCaptureScreenState extends State<SelfieCaptureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int _currentSelfieIndex = 0;
  final int _totalSelfies = 6;
  late List<XFile> _capturedSelfies = [];

  @override
  void initState() {
    super.initState();

    _capturedSelfies = List<XFile>.from(widget.existingSelfies);
    _currentSelfieIndex = widget.retakeIndex ?? _capturedSelfies.length;

    try {
      // Finding the front camera, or fallback to the first available camera
      final frontCamera = widget.cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () {
          if (widget.cameras.isNotEmpty) {
            return widget.cameras.first;
          } else {
            throw Exception('No cameras found on this device.');
          }
        },
      );

      // Initializing the camera controller with ultra-high resolution and no audio
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );

      // Ensuring the controller is initialized before use
      _initializeControllerFuture = _controller.initialize();
    } catch (e) {
      // Displaying error dialog if camera initialization fails
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Camera Error'),
            content: Text('Unable to access the camera.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    // Disposing the camera controller when the screen is disposed
    _controller.dispose();
    super.dispose();
  }

  // Function to capture a selfie
  void _captureSelfie() async {
    try {
      // Ensuring the camera is initialized before capturing
      await _initializeControllerFuture;

      // Capturing the photo and adding it to the list
      final photo = await _controller.takePicture();
      setState(() {
        _capturedSelfies.add(photo);
        _currentSelfieIndex++;
      });

      // If the user has captured all selfies, navigate to the review page
      if (_currentSelfieIndex == _totalSelfies) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewPage(selfies: _capturedSelfies, cameras: _capturedSelfies,),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error capturing selfie: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Camera preview with aspect ratio
                CameraPreview(_controller),
                // Semi-transparent overlay to make UI elements stand out
                Container(color: Colors.black.withOpacity(0.3)),
                // UI elements placed on top of the camera preview
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Selfie count display at the top center
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Text(
                        'Selfie $_currentSelfieIndex of $_totalSelfies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    // Capture button at the bottom
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: GestureDetector(
                        onTap: _captureSelfie,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // Show loading indicator while camera is initializing
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ReviewPage extends StatelessWidget {
  final List<XFile> selfies;
  final List<CameraDescription> cameras;

  const ReviewPage({
    Key? key,
    required this.selfies,
    required this.cameras,
  }) : super(key: key);

  void _retakeSelfie(BuildContext context, int index) {
    final updatedSelfies = List<XFile>.from(selfies);
    updatedSelfies.removeAt(index);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SelfieCaptureScreen(
          cameras: cameras,
          existingSelfies: updatedSelfies,
          retakeIndex: index,
        ),
      ),
    );
  }

  void _confirmImages(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(), // Your actual Home Page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Selfies')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: selfies.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (_, index) => Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(selfies[index].path),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white, size: 16),
                        onPressed: () => _retakeSelfie(context, index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: selfies.length == 6
                ? () => _confirmImages(context)
                : null,
            child: Text('Confirm Images'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome to Home Page!'),
      ),
    );
  }
}
