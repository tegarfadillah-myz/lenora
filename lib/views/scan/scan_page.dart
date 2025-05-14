import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'scan_result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? _controller;
  File? _imageFile;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      setState(() {
        _imageFile = File(image.path);
        _isAnalyzing = true;
      });
      _analyzeImage();
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isAnalyzing = true;
        });
        _analyzeImage();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _analyzeImage() {
    if (_imageFile == null) return;

    // Simulate analysis delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isAnalyzing = false;
      });
    });

    int hash = _imageFile!.path.hashCode;
    final conditions = ['Berjerawat', 'Normal'];
    final skinTypes = ['Berminyak', 'Kering', 'Kombinasi'];
    final acneTypes = [
      'Jerawat Batu',
      'Jerawat Kecil-kecil',
      'Tidak Ada Jerawat',
    ];

    final skinCondition = conditions[hash.abs() % conditions.length];
    final skinType = skinTypes[hash.abs() % skinTypes.length];
    final acneType =
        (skinCondition == 'Berjerawat')
            ? acneTypes[(hash.abs() ~/ conditions.length) % 2]
            : acneTypes[2];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ResultPage(
              imageFile: _imageFile!,
              skinCondition: skinCondition,
              skinType: skinType,
              acneType: acneType,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F2D52)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'AI SKIN FACE',
          style: TextStyle(
            color: Color(0xFF0F2D52),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Camera Preview
          Container(
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: 1 / _controller!.value.aspectRatio,
              child: Transform.scale(
                scale: 1.5,
                child: Center(child: CameraPreview(_controller!)),
              ),
            ),
          ),

          // Corner Brackets Overlay
          if (!_isAnalyzing)
            CustomPaint(painter: CornerBracketsPainter(), child: Container()),

          // Loading Indicator
          if (_isAnalyzing)
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center Selfie Button
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: _takePicture,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 38,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  // Upload Button (Right Side)
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        color: Colors.white.withOpacity(0.15),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scan Text Overlay
          Positioned(
            top: MediaQuery.of(context).size.height * 0.6,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Scan wajah\ntepat di tengah kamera',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CornerBracketsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    final centerSquareSize = size.width * 0.7;
    final startX = (size.width - centerSquareSize) / 2;
    final startY =
        (size.height - centerSquareSize) /
        2.5; // Moved up by adjusting the divisor
    final lineLength = centerSquareSize * 0.2;

    // Top line
    canvas.drawLine(
      Offset(startX, startY),
      Offset(startX + lineLength, startY),
      paint,
    );
    canvas.drawLine(
      Offset(startX + centerSquareSize - lineLength, startY),
      Offset(startX + centerSquareSize, startY),
      paint,
    );

    // Bottom line
    canvas.drawLine(
      Offset(startX, startY + centerSquareSize),
      Offset(startX + lineLength, startY + centerSquareSize),
      paint,
    );
    canvas.drawLine(
      Offset(startX + centerSquareSize - lineLength, startY + centerSquareSize),
      Offset(startX + centerSquareSize, startY + centerSquareSize),
      paint,
    );

    // Left line
    canvas.drawLine(
      Offset(startX, startY),
      Offset(startX, startY + lineLength),
      paint,
    );
    canvas.drawLine(
      Offset(startX, startY + centerSquareSize - lineLength),
      Offset(startX, startY + centerSquareSize),
      paint,
    );

    // Right line
    canvas.drawLine(
      Offset(startX + centerSquareSize, startY),
      Offset(startX + centerSquareSize, startY + lineLength),
      paint,
    );
    canvas.drawLine(
      Offset(startX + centerSquareSize, startY + centerSquareSize - lineLength),
      Offset(startX + centerSquareSize, startY + centerSquareSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
