import 'image_review_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unstudio/ImageCapture/controller/image_capture_controller.dart';

class SelfieCaptureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ImageCaptureController>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: controller.initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                CameraPreview(controller.controller),
                Container(color: Colors.black.withOpacity(0.3)),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Text(
                        'Selfie ${controller.currentSelfieIndex} of ${controller.totalSelfies}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: GestureDetector(
                        onTap: () async {
                          await controller.captureSelfie(context);

                          if (controller.retakeIndex != null ||
                              controller.isComplete) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => ReviewPage()),
                            );
                          }
                        },
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
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
