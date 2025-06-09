import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/scan/presentation/widgets/guide_row.dart';
import 'package:sugeye/features/scan/presentation/widgets/scan_option_button.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const Gap(25),
        const Text(
          'Opsi Pemindaian Fundus',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.veniceBlue,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Untuk mendeteksi Retinopati Diabetik, Anda dapat mengambil gambar fundus baru atau mengunggah gambar yang sudah ada.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.bleachedCedar.withAlpha(204),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),
        ScanOptionButton(
          icon: Icons.camera_alt_outlined,
          label: 'Ambil Gambar Baru',
          backgroundColor: AppColors.veniceBlue,
          textColor: AppColors.white,
          onPressed: () {
            GoRouter.of(context).pushNamed(Routes.camera);
          },
        ),
        const SizedBox(height: 20),
        ScanOptionButton(
          icon: Icons.upload_file_outlined,
          label: 'Unggah Gambar yang Ada',
          backgroundColor: AppColors.angelBlue,
          textColor: AppColors.bleachedCedar,
          onPressed: () {
            GoRouter.of(context).pushNamed(Routes.upload);
          },
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.angelBlue.withAlpha(50),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.angelBlue.withAlpha(75)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Panduan Singkat:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.veniceBlue,
                ),
              ),
              SizedBox(height: 8),
              GuideRow(
                icon: Icons.remove_red_eye_outlined,
                text:
                    'Pastikan Funduslens terpasang dengan benar pada smartphone Anda.',
              ),
              SizedBox(height: 6),
              GuideRow(
                icon: Icons.lightbulb_outline,
                text:
                    'Cari ruangan dengan pencahayaan redup untuk kualitas gambar yang lebih baik.',
              ),
              SizedBox(height: 6),
              GuideRow(
                icon: Icons.center_focus_strong_outlined,
                text:
                    'Usahakan mata tetap stabil dan fokus selama pengambilan gambar.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
