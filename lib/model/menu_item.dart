import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final Widget Function() pageBuilder; // fungsi yang menghasilkan widget

  MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.pageBuilder,
  });

  // Fungsi bantu untuk membuka halaman
  Widget openPage() {
    return pageBuilder();
  }

  // copyWith untuk membuat salinan dengan beberapa properti diubah
  MenuItem copyWith({
    String? title,
    IconData? icon,
    Color? color,
    Widget Function()? pageBuilder,
  }) {
    return MenuItem(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      pageBuilder: pageBuilder ?? this.pageBuilder,
    );
  }
}
