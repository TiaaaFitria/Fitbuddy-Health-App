<<<<<<< HEAD
// DeviceInfoPage.dart
// ignore_for_file: deprecated_member_use
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/services.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final List<Map<String, String>> _infoList = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  String _safe(dynamic v) {
    try {
      if (v == null) return '-';
      return v.toString();
    } catch (_) {
      return '-';
    }
  }

  Future<void> _getDeviceInfo() async {
    setState(() {
      _loading = true;
      _error = null;
      _infoList.clear();
    });

    try {
      final Map<String, String> info = {};

      if (kIsWeb || UniversalPlatform.isWeb) {
        final web = await _deviceInfo.webBrowserInfo;
        final browserName = web.browserName.toString().split('.').last;
        info['Platform'] = 'Web';
        info['Browser'] = browserName;
        info['App Code Name'] = _safe(web.appCodeName);
        info['App Name'] = _safe(web.appName);
        info['App Version'] = _safe(web.appVersion);
        info['User Agent'] = _safe(web.userAgent);
        info['Vendor'] = _safe(web.vendor);
        info['Language'] = _safe(web.language);
        info['Hardware Concurrency'] = _safe(web.hardwareConcurrency);
        info['Device Memory (GB)'] = _safe(web.deviceMemory);
      }
      else if (UniversalPlatform.isAndroid) {
        final a = await _deviceInfo.androidInfo;
        info['Platform'] = 'Android';
        info['Brand'] = _safe(a.brand);
        info['Manufacturer'] = _safe(a.manufacturer);
        info['Model'] = _safe(a.model);
        info['Device'] = _safe(a.device);
        info['Product'] = _safe(a.product);
        info['Board'] = _safe(a.board);
        info['Hardware'] = _safe(a.hardware);
        info['Bootloader'] = _safe(a.bootloader);
        info['Android Version'] = _safe(a.version.release);
        info['SDK Int'] = _safe(a.version.sdkInt);
        info['Security Patch'] = _safe(a.version.securityPatch);
        info['Fingerprint'] = _safe(a.fingerprint);
        info['Is Physical Device'] = _safe(a.isPhysicalDevice);
        info['Id'] = _safe(a.id);
      }
      else if (UniversalPlatform.isIOS) {
        final i = await _deviceInfo.iosInfo;
        info['Platform'] = 'iOS';
        info['Name'] = _safe(i.name);
        info['System Name'] = _safe(i.systemName);
        info['System Version'] = _safe(i.systemVersion);
        info['Model'] = _safe(i.model);
        info['Localized Model'] = _safe(i.localizedModel);
        info['Identifier for Vendor'] = _safe(i.identifierForVendor);
        info['Is Physical Device'] = _safe(i.isPhysicalDevice);
        try {
          info['utsname.sysname'] = _safe(i.utsname.sysname);
          info['utsname.nodename'] = _safe(i.utsname.nodename);
          info['utsname.release'] = _safe(i.utsname.release);
          info['utsname.version'] = _safe(i.utsname.version);
          info['utsname.machine'] = _safe(i.utsname.machine);
        } catch (_) {}
      }
      else if (UniversalPlatform.isWindows) {
        final w = await _deviceInfo.windowsInfo;
        info['Platform'] = 'Windows';
        info['Computer Name'] = _safe(w.computerName);
        info['User Name'] = _safe(w.userName);
        info['Number of Cores'] = _safe(w.numberOfCores);
        info['System Memory (MB)'] = _safe(w.systemMemoryInMegabytes);
        info['Build Number'] = _safe(w.buildNumber);
        info['Product Name'] = _safe(w.productName);
        info['Release ID'] = _safe(w.releaseId);
        info['Install Date'] = _safe(w.installDate);
      }
      else if (UniversalPlatform.isMacOS) {
        final m = await _deviceInfo.macOsInfo;
        info['Platform'] = 'macOS';
        info['Computer Name'] = _safe(m.computerName);
        info['Host Name'] = _safe(m.hostName);
        info['Model'] = _safe(m.model);
        info['OS Release'] = _safe(m.osRelease);
        info['Kernel Version'] = _safe(m.kernelVersion);
        info['Active CPUs'] = _safe(m.activeCPUs);
        info['Memory Size (bytes)'] = _safe(m.memorySize);
      }
      else if (UniversalPlatform.isLinux) {
        final l = await _deviceInfo.linuxInfo;
        info['Platform'] = 'Linux';
        info['Name'] = _safe(l.name);
        info['Version'] = _safe(l.version);
        info['ID'] = _safe(l.id);
        info['Pretty Name'] = _safe(l.prettyName);
        info['Build ID'] = _safe(l.buildId);
        info['Machine ID'] = _safe(l.machineId);
        info['Variant'] = _safe(l.variant);
        info['Variant ID'] = _safe(l.variantId);
        info['Version Codename'] = _safe(l.versionCodename);
        info['Version ID'] = _safe(l.versionId);
      } else {
        info['Platform'] = 'Unknown';
        info['Note'] = 'Platform tidak dikenali atau tidak didukung oleh plugin.';
      }

      final List<Map<String, String>> list = [];
      info.forEach((k, v) => list.add({k: v}));

      if (mounted) {
        setState(() {
          _infoList.clear();
          _infoList.addAll(list);
          _loading = false;
        });
      }
    } catch (e, st) {
      debugPrint('Error getting device info: $e\n$st');
      if (mounted) {
        setState(() {
          _error = 'Gagal mengambil info perangkat: ${_safe(e)}';
          _loading = false;
        });
      }
    }
  }

  void _copyAllInfo() {
    final text = _infoList.map((m) {
      final k = m.keys.first;
      final v = m.values.first;
      return '$k: $v';
    }).join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Informasi perangkat disalin'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    final theme = Theme.of(context);

    return Card(
      elevation: theme.cardTheme.elevation ?? 6,
      shadowColor: theme.cardTheme.shadowColor ?? Colors.black26,
      shape: theme.cardTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: theme.primaryColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForKey(String key) {
    final k = key.toLowerCase();
    if (k.contains('platform')) return Icons.devices;
    if (k.contains('browser') || k.contains('user agent')) return Icons.language;
    if (k.contains('brand') || k.contains('manufacturer')) return Icons.phonelink;
    if (k.contains('model') || k.contains('device')) return Icons.devices_other;
    if (k.contains('version') || k.contains('build')) return Icons.system_update;
    if (k.contains('memory') || k.contains('ram')) return Icons.memory;
    if (k.contains('cores') || k.contains('cpu')) return Icons.memory;
    if (k.contains('id') || k.contains('machine')) return Icons.vpn_key;
    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info Lengkap'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation ?? 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _getDeviceInfo,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy all',
            onPressed: _copyAllInfo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style:
                          theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  )
                : ListView.builder(
                    itemCount: _infoList.length,
                    itemBuilder: (context, i) {
                      final e = _infoList[i];
                      final title = e.keys.first;
                      final value = e.values.first;
                      return _buildCard(title, value, _iconForKey(title));
                    },
                  ),
      ),
    );
  }
}
=======
// DeviceInfoPage.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/services.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage({super.key});

  @override
  State<DeviceInfoPage> createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final List<Map<String, String>> _infoList = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  // Robust helper to toString safely
  String _safe(dynamic v) {
    try {
      if (v == null) return '-';
      return v.toString();
    } catch (_) {
      return '-';
    }
  }

  Future<void> _getDeviceInfo() async {
    setState(() {
      _loading = true;
      _error = null;
      _infoList.clear();
    });

    try {
      final Map<String, String> info = {};

      // ===== WEB =====
      if (kIsWeb || UniversalPlatform.isWeb) {
        final web = await _deviceInfo.webBrowserInfo;
        // browserName could be an enum, guard it
        final browserName = web.browserName.toString().split('.').last;
        info['Platform'] = 'Web';
        info['Browser'] = browserName;
        info['App Code Name'] = _safe(web.appCodeName);
        info['App Name'] = _safe(web.appName);
        info['App Version'] = _safe(web.appVersion);
        info['User Agent'] = _safe(web.userAgent);
        info['Vendor'] = _safe(web.vendor);
        info['Language'] = _safe(web.language);
        info['Hardware Concurrency'] = _safe(web.hardwareConcurrency);
        info['Device Memory (GB)'] = _safe(web.deviceMemory);
      }
      // ===== ANDROID =====
      else if (UniversalPlatform.isAndroid) {
        final a = await _deviceInfo.androidInfo;
        info['Platform'] = 'Android';
        info['Brand'] = _safe(a.brand);
        info['Manufacturer'] = _safe(a.manufacturer);
        info['Model'] = _safe(a.model);
        info['Device'] = _safe(a.device);
        info['Product'] = _safe(a.product);
        info['Board'] = _safe(a.board);
        info['Hardware'] = _safe(a.hardware);
        info['Bootloader'] = _safe(a.bootloader);
        info['Android Version'] = _safe(a.version.release);
        info['SDK Int'] = _safe(a.version.sdkInt);
        info['Security Patch'] = _safe(a.version.securityPatch);
        info['Fingerprint'] = _safe(a.fingerprint);
        info['Is Physical Device'] = _safe(a.isPhysicalDevice);
        info['Id'] = _safe(a.id);
      }
      // ===== IOS =====
      else if (UniversalPlatform.isIOS) {
        final i = await _deviceInfo.iosInfo;
        info['Platform'] = 'iOS';
        info['Name'] = _safe(i.name);
        info['System Name'] = _safe(i.systemName);
        info['System Version'] = _safe(i.systemVersion);
        info['Model'] = _safe(i.model);
        info['Localized Model'] = _safe(i.localizedModel);
        info['Identifier for Vendor'] = _safe(i.identifierForVendor);
        info['Is Physical Device'] = _safe(i.isPhysicalDevice);
        // utsname fields
        try {
          info['utsname.sysname'] = _safe(i.utsname.sysname);
          info['utsname.nodename'] = _safe(i.utsname.nodename);
          info['utsname.release'] = _safe(i.utsname.release);
          info['utsname.version'] = _safe(i.utsname.version);
          info['utsname.machine'] = _safe(i.utsname.machine);
        } catch (_) {}
      }
      // ===== WINDOWS =====
      else if (UniversalPlatform.isWindows) {
        final w = await _deviceInfo.windowsInfo;
        info['Platform'] = 'Windows';
        info['Computer Name'] = _safe(w.computerName);
        info['User Name'] = _safe(w.userName);
        info['Number of Cores'] = _safe(w.numberOfCores);
        info['System Memory (MB)'] = _safe(w.systemMemoryInMegabytes);
        info['Build Number'] = _safe(w.buildNumber);
        info['Product Name'] = _safe(w.productName);
        info['Release ID'] = _safe(w.releaseId);
        info['Install Date'] = _safe(w.installDate);
      }
      // ===== MACOS =====
      else if (UniversalPlatform.isMacOS) {
        final m = await _deviceInfo.macOsInfo;
        info['Platform'] = 'macOS';
        info['Computer Name'] = _safe(m.computerName);
        info['Host Name'] = _safe(m.hostName);
        info['Model'] = _safe(m.model);
        info['OS Release'] = _safe(m.osRelease);
        info['Kernel Version'] = _safe(m.kernelVersion);
        info['Active CPUs'] = _safe(m.activeCPUs);
        info['Memory Size (bytes)'] = _safe(m.memorySize);
      }
      // ===== LINUX =====
      else if (UniversalPlatform.isLinux) {
        final l = await _deviceInfo.linuxInfo;
        info['Platform'] = 'Linux';
        info['Name'] = _safe(l.name);
        info['Version'] = _safe(l.version);
        info['ID'] = _safe(l.id);
        info['Pretty Name'] = _safe(l.prettyName);
        info['Build ID'] = _safe(l.buildId);
        info['Machine ID'] = _safe(l.machineId);
        info['Variant'] = _safe(l.variant);
        info['Variant ID'] = _safe(l.variantId);
        info['Version Codename'] = _safe(l.versionCodename);
        info['Version ID'] = _safe(l.versionId);
      } else {
        info['Platform'] = 'Unknown';
        info['Note'] = 'Platform tidak dikenali atau tidak didukung oleh plugin.';
      }

      // convert map -> list (preserve insertion order)
      final List<Map<String, String>> list = [];
      info.forEach((k, v) => list.add({k: v}));

      if (mounted) {
        setState(() {
          _infoList.clear();
          _infoList.addAll(list);
          _loading = false;
        });
      }
    } catch (e, st) {
      // debug print supaya mudah dilacak saat pengembangan
      debugPrint('Error getting device info: $e\n$st');
      if (mounted) {
        setState(() {
          _error = 'Gagal mengambil info perangkat: ${_safe(e)}';
          _loading = false;
        });
      }
    }
  }

  void _copyAllInfo() {
    final text = _infoList.map((m) {
      final k = m.keys.first;
      final v = m.values.first;
      return '$k: $v';
    }).join('\n');
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Informasi perangkat disalin'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    final theme = Theme.of(context);

    return Card(
      elevation: theme.cardTheme.elevation ?? 6,
      shadowColor: theme.cardTheme.shadowColor ?? Colors.black26,
      shape: theme.cardTheme.shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: theme.primaryColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForKey(String key) {
    final k = key.toLowerCase();
    if (k.contains('platform')) return Icons.devices;
    if (k.contains('browser') || k.contains('user agent')) return Icons.language;
    if (k.contains('brand') || k.contains('manufacturer')) return Icons.phonelink;
    if (k.contains('model') || k.contains('device')) return Icons.devices_other;
    if (k.contains('version') || k.contains('build')) return Icons.system_update;
    if (k.contains('memory') || k.contains('ram')) return Icons.memory;
    if (k.contains('cores') || k.contains('cpu')) return Icons.memory;
    if (k.contains('id') || k.contains('machine')) return Icons.vpn_key;
    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Info Lengkap'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation ?? 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _getDeviceInfo,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy all',
            onPressed: _copyAllInfo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style:
                          theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  )
                : ListView.builder(
                    itemCount: _infoList.length,
                    itemBuilder: (context, i) {
                      final e = _infoList[i];
                      final title = e.keys.first;
                      final value = e.values.first;
                      return _buildCard(title, value, _iconForKey(title));
                    },
                  ),
      ),
    );
  }
}
>>>>>>> bc4ed19293464f12c16099e9a02ca1f1ebdf90f4
