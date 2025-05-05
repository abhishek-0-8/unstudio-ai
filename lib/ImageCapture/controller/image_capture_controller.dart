import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// A controller class that manages the camera for capturing selfies.
///
/// This controller is responsible for:
/// - Initializing the camera
/// - Handling selfie capture
/// - Managing a fixed number of selfies
/// - Supporting retake functionality
class ImageCaptureController extends ChangeNotifier {
  // List of available cameras on the device.
  final List<CameraDescription> cameras;

  late CameraController controller;
  late Future<void> initializeControllerFuture;

  // List to store captured selfies as image files.
  List<XFile> capturedSelfies = [];
  int currentSelfieIndex = 0;
  final int totalSelfies = 6;
  int? retakeIndex;

  ImageCaptureController({
    required this.cameras,
    List<XFile>? existingSelfies,
    this.retakeIndex,
  }) {
    // Initialize captured selfies with existing ones if provided
    capturedSelfies =
        existingSelfies != null ? List<XFile>.from(existingSelfies) : [];

    // Determine the current selfie index (used during sequential capture)
    currentSelfieIndex = retakeIndex ?? capturedSelfies.length;

    // Select the front camera, defaulting to the first available if not found
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    // Initialize the camera controller with high resolution and no audio
    controller = CameraController(
      frontCamera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    // Begin the camera initialization
    initializeControllerFuture = controller.initialize();
  }

  /// Captures a selfie using the camera.
  ///
  /// Handles both regular capture and retake scenarios.
  /// Updates the list and notifies listeners after capturing.
  Future<void> captureSelfie(BuildContext context) async {
    try {
      // Wait until camera is fully initialized
      await initializeControllerFuture;
      final photo = await controller.takePicture();

      if (retakeIndex != null && retakeIndex! < capturedSelfies.length) {
        // If retaking, replace the existing selfie at the specified index
        capturedSelfies[retakeIndex!] = photo;
      } else {
        // Add a new selfie if within limits
        if (currentSelfieIndex < totalSelfies) {
          capturedSelfies.add(photo);
          currentSelfieIndex++;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error capturing selfie: $e");
    }
  }

  /// Returns `true` if the required number of selfies have been captured.
  bool get isComplete => capturedSelfies.length == totalSelfies;

  /// Disposes the camera controller when the object is destroyed.
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
