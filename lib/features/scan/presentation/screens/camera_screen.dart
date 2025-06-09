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
  bool _isCameraInitialized = false;
  bool _isTakingPicture = false;
  bool _isFlashOn = false;
  int _selectedCameraIndex = 0;

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

    // ? App state changed before any chance initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(); //?  reinitialize the camera to fix potential issues
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

      // Use selected camera index instead of always finding back camera
      CameraDescription selectedCamera;
      if (_selectedCameraIndex < _cameras!.length) {
        selectedCamera = _cameras![_selectedCameraIndex];
      } else {
        // Fallback to back camera or first available
        _selectedCameraIndex = _cameras!.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
        );
        if (_selectedCameraIndex == -1) _selectedCameraIndex = 0;
        selectedCamera = _cameras![_selectedCameraIndex];
      }

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      // Restore flash state after camera initialization
      if (_isFlashOn) {
        await _controller!.setFlashMode(FlashMode.torch);
      }

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
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

  // Add flash toggle functionality
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
      // Revert state if operation failed
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

  // Add camera flip functionality
  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No other cameras available')),
      );
      return;
    }

    // Dispose current controller
    await _controller?.dispose();
    _controller = null;

    // Switch to next camera
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;

    setState(() {
      _isCameraInitialized = false;
      _isFlashOn = false; // Reset flash when switching cameras
    });

    // Initialize new camera
    await _initializeCamera();
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
      // ? capture is already pending => do nothing.
      return;
    }

    setState(() {
      _isTakingPicture = true;
    });

    try {
      final XFile imageFile = await _controller!.takePicture();
      //?  possibly pass the imageFile.path to the DisplayPictureScreen. ????
      if (mounted) {
        GoRouter.of(
          context,
        ).pushNamed(Routes.displayPicture, extra: imageFile.path).then((value) {
          // ? executes when DisplayPictureScreen is popped.
          // ? maybe re-initialize or refresh camera state if needed ??,
        }); // ! especially if the user chose "Retake".
        // _controller?.dispose();
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
              //? change this shit to gorouter , for now navigator aja
              // ?  navigate back if error  critical (either use pop or goback , need testing!)
              if (title == "No cameras found" ||
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
      appBar: AppBar(title: const Text('Capture Fundus')),
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
                      child: CameraPreview(
                        _controller!,
                        child: Stack(
                          children: [
                            // Focus indicator in center
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

                            // Camera controls row - bottom positioned for easy thumb access
                            Positioned(
                              bottom: 30,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Flash toggle button - bottom left
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(178),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        _isFlashOn
                                            ? Icons.flash_on
                                            : Icons.flash_off,
                                        color: _isFlashOn
                                            ? Colors.yellow
                                            : Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: _toggleFlash,
                                      tooltip: _isFlashOn
                                          ? 'Turn off flash'
                                          : 'Turn on flash',
                                      padding: const EdgeInsets.all(12),
                                    ),
                                  ),

                                  // Camera flip button - bottom right
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(178),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.flip_camera_ios,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed:
                                          _cameras != null &&
                                              _cameras!.length > 1
                                          ? _flipCamera
                                          : null,
                                      tooltip: 'Flip camera',
                                      padding: const EdgeInsets.all(12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // // Optional: Settings/info button at top right (less frequently used)
                            // Positioned(
                            //   top: 20,
                            //   right: 20,
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       color: Colors.black.withOpacity(0.5),
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //     child: IconButton(
                            //       icon: const Icon(
                            //         Icons.info_outline,
                            //         color: Colors.white,
                            //         size: 24,
                            //       ),
                            //       onPressed: () {
                            //         ScaffoldMessenger.of(context).showSnackBar(
                            //           SnackBar(
                            //             content: Text(
                            //               'Resolution: ${_controller?.value.previewSize?.width.toInt()}x${_controller?.value.previewSize?.height.toInt()}\n'
                            //               'Flash: ${_isFlashOn ? "On" : "Off"}\n'
                            //               'Camera: ${_cameras != null && _selectedCameraIndex < _cameras!.length ? _cameras![_selectedCameraIndex].name : "Unknown"}',
                            //             ),
                            //             duration: const Duration(seconds: 3),
                            //           ),
                            //         );
                            //       },
                            //       tooltip: 'Camera info',
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Loading overlay when taking picture
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
                            'Capturing image...',
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
}
