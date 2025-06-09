import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  List<CameraDescription>? _backCameras;
  bool _isCameraInitialized = false;
  bool _isTakingPicture = false;
  bool _isFlashOn = false;

  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.setFlashMode(FlashMode.off);
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        _showErrorDialog(
          "No cameras found",
          "This device does not have any available cameras.",
        );
        return;
      }

      _backCameras = _cameras!
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList();

      if (_backCameras == null || _backCameras!.isEmpty) {
        _showErrorDialog(
          "No back cameras found",
          "This device does not have any back cameras available for medical imaging.",
        );
        return;
      }

      CameraDescription selectedCamera = _backCameras!.first;

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      // ? disable auto macro focus by focusing once, then locking.
      try {
        await _controller!.setFocusMode(FocusMode.auto);
        // ? allow time for focus to settle before locking
        await Future.delayed(const Duration(milliseconds: 500));
      } on CameraException catch (e) {
        debugPrint("FocusMode.auto is not supported: ${e.description}");
      }
      try {
        await _controller!.setFocusMode(FocusMode.locked);
      } on CameraException catch (e) {
        debugPrint("FocusMode.locked is not supported: ${e.description}");
      }

      // ? set minimum zoom to 1.0x to avoid switching to ultra-wide camera.
      final double deviceMinZoom = await _controller!.getMinZoomLevel();
      final double deviceMaxZoom = await _controller!.getMaxZoomLevel();
      _minZoomLevel = max(1.0, deviceMinZoom);
      _maxZoomLevel = deviceMaxZoom;

      // ? set initial zoom to the minimum allowed (1.0x or higher)
      _currentZoomLevel = _minZoomLevel;
      _baseScale = _minZoomLevel;
      await _controller!.setZoomLevel(_currentZoomLevel);

      // ? restore flash state after camera initialization
      if (_isFlashOn) {
        await _controller!.setFlashMode(FlashMode.torch);
      }

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });

      debugPrint('Selected back camera: ${selectedCamera.name}');
      debugPrint('Lens direction: ${selectedCamera.lensDirection}');
      debugPrint('Sensor orientation: ${selectedCamera.sensorOrientation}');
    } on CameraException catch (e) {
      _showErrorDialog(
        "Camera Error",
        "Failed to initialize camera: ${e.code}\n${e.description}",
      );
    } catch (e) {
      _showErrorDialog(
        "Unexpected Error",
        "An unexpected error occurred while initializing the camera: $e",
      );
    }
  }

  Future<void> _handleZoom(double scale) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    // ? calculate new zoom level
    double newZoomLevel = _baseScale * scale;

    // ? clamp zoom level to valid range
    newZoomLevel = newZoomLevel.clamp(_minZoomLevel, _maxZoomLevel);

    try {
      await _controller!.setZoomLevel(newZoomLevel);
      setState(() {
        _currentZoomLevel = newZoomLevel;
      });
    } catch (e) {
      debugPrint('Zoom error: $e');
    }
  }

  // ? handle zoom start (when user starts pinching)
  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentZoomLevel;
  }

  // ? Handle zoom update (during pinching)
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    _handleZoom(details.scale);
  }

  // ? reset zoom to minimum level
  Future<void> _resetZoom() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      await _controller!.setZoomLevel(_minZoomLevel);
      setState(() {
        _currentZoomLevel = _minZoomLevel;
        _baseScale = _minZoomLevel;
      });
    } catch (e) {
      debugPrint('Reset zoom error: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });

      if (_isFlashOn) {
        await _controller!.setFlashMode(FlashMode.torch);
      } else {
        await _controller!.setFlashMode(FlashMode.off);
      }
    } catch (e) {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to toggle flash: $e')));
      }
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isTakingPicture) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error: Camera not ready or picture already being taken.',
          ),
        ),
      );
      return;
    }

    if (_controller!.value.isTakingPicture) {
      return;
    }

    setState(() {
      _isTakingPicture = true;
    });

    try {
      final XFile imageFile = await _controller!.takePicture();

      if (mounted) {
        GoRouter.of(
          context,
        ).pushNamed(Routes.displayPicture, extra: imageFile.path).then((value) {
          _resetZoom();
        });
      }
    } on CameraException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking picture: ${e.description}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  void _showErrorDialog(String title, String content) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(color: AppColors.paleCarmine),
        ),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.veniceBlue),
            ),
            onPressed: () {
              GoRouter.of(context).pop();
              if (title == "No cameras found" ||
                  title == "No back cameras found" ||
                  (content.contains("CameraAccessDenied") &&
                      GoRouter.of(context).canPop())) {
                GoRouter.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil Fundus'),
        actions: [
          // ? zoom level indicator
          if (_isCameraInitialized)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(128),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_currentZoomLevel.toStringAsFixed(1)}x',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isCameraInitialized && _controller != null
          ? Stack(
              alignment: Alignment.center,
              children: <Widget>[
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (_controller == null ||
                        !_controller!.value.isInitialized) {
                      return const Center(
                        child: Text(
                          "Controller not ready in LayoutBuilder",
                          style: TextStyle(
                            color: Colors.red,
                            backgroundColor: Colors.yellow,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    final double squareSize = constraints.maxWidth;

                    if (squareSize <= 0) {
                      return Container(
                        color: Colors.red,
                        child: const Center(child: Text("ERROR: Zero Size")),
                      );
                    }

                    return SizedBox(
                      width: squareSize,
                      child: GestureDetector(
                        onScaleStart: _handleScaleStart,
                        onScaleUpdate: _handleScaleUpdate,
                        child: CameraPreview(
                          _controller!,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withAlpha(122),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(50),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white.withAlpha(75),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // ? camera controls
                              Positioned(
                                bottom: 80,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // Flash toggle button
                                    _buildControlButton(
                                      icon: _isFlashOn
                                          ? Icons.flash_on
                                          : Icons.flash_off,
                                      color: _isFlashOn
                                          ? Colors.yellow
                                          : Colors.white,
                                      onPressed: _toggleFlash,
                                      tooltip: _isFlashOn
                                          ? 'Turn off flash'
                                          : 'Turn on flash',
                                    ),

                                    // ? zoom reset button
                                    _buildControlButton(
                                      icon: Icons.zoom_out_map,
                                      color: Colors.white,
                                      onPressed: _resetZoom,
                                      tooltip: 'Reset zoom',
                                    ),
                                  ],
                                ),
                              ),

                              // ? zoom instructions overlay
                              // Positioned(
                              //   top: 20,
                              //   left: 20,
                              //   right: 20,
                              //   child: Container(
                              //     padding: const EdgeInsets.all(12),
                              //     decoration: BoxDecoration(
                              //       color: Colors.black.withAlpha(128),
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     child: const Text(
                              //       'Pinch to zoom • Focus on the center guide',
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 12,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // ? loading overlay when taking picture
                if (_isTakingPicture)
                  Container(
                    color: Colors.black.withAlpha(122),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.angelBlue),
                          SizedBox(height: 16),
                          Text(
                            'Mengambil gambar...',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : Container(
              color: AppColors.bleachedCedar,
              child: Center(
                child: _cameras == null && !_isCameraInitialized
                    ? const CircularProgressIndicator(
                        color: AppColors.angelBlue,
                      )
                    : Text(
                        _cameras == null || _cameras!.isEmpty
                            ? 'No cameras found.'
                            : _backCameras == null || _backCameras!.isEmpty
                            ? 'No back cameras found for medical imaging.'
                            : 'Failed to initialize camera. Ensure permissions are granted.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isCameraInitialized && !_isTakingPicture
          ? FloatingActionButton.large(
              onPressed: _takePicture,
              heroTag: 'cameraScreenFAB',
              backgroundColor: AppColors.angelBlue,
              foregroundColor: AppColors.bleachedCedar,
              tooltip: 'Take Picture',
              child: const Icon(Icons.camera_alt, size: 40),
            )
          : null,
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(178),
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 32),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
