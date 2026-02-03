import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

//late List<CameraDescription> cameras;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "SILANT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: const Text("Login"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              const SizedBox(width: 8),
              /*ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("SIgn Up"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),*/
            ],
          ),
        ],
      ),

      // ✅ FIX 2: Added SingleChildScrollView to avoid overflow on mobile
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Sign Language Converter",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Convert sign language to text in real-time using your camera",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // ✅ FIX 3: LayoutBuilder added for responsive UI (web vs mobile)
              LayoutBuilder(
                builder: (context, constraints) {
                  // ✅ FIX 4: Screen width check
                  bool isMobile = constraints.maxWidth < 700;

                  if (isMobile) {
                    return Column(
                      children: const [
                        CameraBox(),
                        SizedBox(height: 20),
                        OutputBox(),
                        SizedBox(height: 20),
                        Manual(),
                      ],
                    );
                  }
                  // ✅ FIX 5: MOBILE → Column instead of Row
                  /*return Column(
                      children: [
                        const CameraBox(),
                        const SizedBox(height: 20),
                        const OutputBox(),
                        Column(children: [Manual()]),
                      ],
                    );*/
                  else {
                    // ✅ FIX 6: WEB/DESKTOP → Row layout
                    return Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(child: CameraBox()),
                            SizedBox(width: 16),
                            Expanded(child: OutputBox()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Manual(), // 👈 next line
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= CAMERA BOX =================
class CameraBox extends StatefulWidget {
  const CameraBox({super.key});

  @override
  State<CameraBox> createState() => _CameraBoxState();
}

class _CameraBoxState extends State<CameraBox> {
  bool isCameraOn = false;

  ///final ImagePicker picker = ImagePicker();
  CameraController? controller;
  Future<void> openCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller!.initialize();
    setState(() {});
  }

  void closeCamera() {
    controller?.dispose();
    controller = null;
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width < 700 ? 15 : 17;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 350,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // vertical center
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Camera Feed",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
            ),
            const SizedBox(height: 8),
            Icon(isCameraOn ? Icons.videocam : Icons.videocam_off),
            SizedBox(height: 8),
            Text(isCameraOn ? "camera on" : "Camera Of",
                style: TextStyle(fontSize: fontSize)),
            SizedBox(height: 20),
            if (isCameraOn &&
                controller != null &&
                controller!.value.isInitialized)
              SizedBox(
                  height: 130,
                  width: 300,
                  child: AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: CameraPreview(controller!),
                  )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!isCameraOn) {
                  await openCamera();
                } else {
                  closeCamera();
                }

                setState(() {
                  isCameraOn = !isCameraOn;
                });
              },
              child: Text(isCameraOn ? "Close Camera" : "Open Camera"),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= OUTPUT BOX =================
class OutputBox extends StatelessWidget {
  const OutputBox({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = MediaQuery.of(context).size.width < 700 ? 15 : 20;
    return Container(
      padding: const EdgeInsets.all(16),
      height: 350,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            "Converted Text",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
          const SizedBox(height: 20),

          // ✅ FIX 7: Removed fixed width, using double.infinity
          Container(
            width: screenWidth < 600
                ? screenWidth * 0.9 // mobile (90%)
                : screenWidth * 0.4,
            height: 200,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt),
                SizedBox(height: 20),
                Text(
                  "Text will be Visible after Translated",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Manual extends StatelessWidget {
  const Manual({super.key});

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width < 700 ? 15 : 20;
    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("How It Works", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            "• Click Start Camerato enable your webcam",
            style: TextStyle(fontSize: fontSize),
          ),
          Text(
            "• Perform sign language gestures in front of the camera",
            style: TextStyle(fontSize: fontSize),
          ),
          Text(
            "• The AI will detect and convert signs to text in real-time",
            style: TextStyle(fontSize: fontSize),
          ),
          Text(
            "• Copy or clear the text using the buttons above",
            style: TextStyle(fontSize: fontSize),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
          ),
          Container(
            //width: double.infinity,
            padding: const EdgeInsets.all(3),
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
              color: Colors.black,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "© 2026 SILANT · Empowering communication through sign language",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  "© 2026 SILANT. Bridging communication through AI-powered sign language translation.",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  "SILANT – Making communication accessible for everyone using sign language AI.",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                Text(
                  "Phone No:+91 9710313236",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

