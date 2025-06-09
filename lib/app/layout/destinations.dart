import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

const List<Destination> destinations = [
  Destination(label: "Beranda", icon: Icons.home),
  Destination(label: "Pindai", icon: Icons.control_camera),
  // Destination(label: "FundusAI", icon: Icons.forum),
  Destination(label: "FundusAI", icon: Icons.adjust),
  Destination(label: "Kasus", icon: Icons.assignment),
  Destination(label: "Profil", icon: Icons.person),
];
