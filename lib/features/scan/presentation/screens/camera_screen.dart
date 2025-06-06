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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
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

      // ? prefer back camera
      CameraDescription? selectedCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high, // ? adjust resolution as needed
        enableAudio: false, // ? io is not needed for fundus images
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
    } on CameraException catch (e) {
      _showErrorDialog(
        "Camera Error",
        "Failed to initialize camera: ${e.code}\n${e.description}",
      );
      // ?  errors
      if (e.code == 'CameraAccessDenied') {
        // ?  access denied
      }
      // ? Potentially navigate back or show a persistent error message
    } catch (e) {
      _showErrorDialog(
        "Unexpected Error",
        "An unexpected error occurred while initializing the camera: $e",
      );
    }
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
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
      appBar: AppBar(title: const Text('Capture Fundus Image')),
      body:
          // SafeArea(
          // child:
          _isCameraInitialized && _controller != null
          ? Stack(
              alignment: Alignment.center,
              children: <Widget>[
                LayoutBuilder(
                  builder: (context, constraints) {
                    print(
                      "CameraScreen - LayoutBuilder: maxWidth=${constraints.maxWidth}, maxHeight=${constraints.maxHeight}",
                    );

                    // ? check controller state *inside* LayoutBuilderadf (ijmportant)
                    if (_controller == null ||
                        !_controller!.value.isInitialized) {
                      print(
                        "CameraScreen - LayoutBuilder: Controller not initialized here!",
                      );
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

                    // ? later remove the need for the size, and just use the full screen like in the backup screen lol
                    if (squareSize <= 0) {
                      print(
                        "CameraScreen - LayoutBuilder: squareSize is zero or negative!",
                      );
                      return Container(
                        color: Colors.red,
                        child: const Center(child: Text("ERROR: Zero Size")),
                      );
                    }
                    // ? here should be sucesfully pass the weird constarint bug
                    return SizedBox(
                      width: squareSize,
                      // height:
                      //     squareSize, // ? maybe dump this square container stuff
                      child: CameraPreview(
                        _controller!,
                      ), // ? display camera feed
                    );
                  },
                ),

                if (_isTakingPicture)
                  Container(
                    color: Colors.black.withAlpha(122),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.angelBlue,
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

      // ),
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
