import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});
  final String label;
  final IconData icon;
}

const List<Destination> destinations = [
  Destination(label: "Home", icon: Icons.home),
  Destination(label: "Scan", icon: Icons.control_camera),
  Destination(label: "Patines", icon: Icons.people),
  Destination(label: "Profiles", icon: Icons.person),
];
