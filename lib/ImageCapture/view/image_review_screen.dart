import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home/view/home_screen.dart';
import 'package:unstudio/ImageCapture/view/selfie_screen.dart';
import 'package:unstudio/ImageCapture/controller/image_capture_controller.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selfieProvider = Provider.of<ImageCaptureController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Review Selfies')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: selfieProvider.capturedSelfies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder:
                  (_, index) => Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(selfieProvider.capturedSelfies[index].path),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 16,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ChangeNotifierProvider(
                                        create:
                                            (_) => ImageCaptureController(
                                              cameras: selfieProvider.cameras,
                                              existingSelfies:
                                                  selfieProvider
                                                      .capturedSelfies,
                                              retakeIndex: index,
                                            ),
                                        child: SelfieCaptureScreen(),
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
            ),
          ),
          ElevatedButton(
            onPressed:
                selfieProvider.isComplete
                    ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                      );
                    }
                    : null,
            child: const Text('Confirm Images'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
