import 'package:flutter/material.dart';

enum AlertType { success, error, warning, info }

class AppAlert {
  static void show(
    BuildContext context, {
    required AlertType type,
    required String title,
    required String description,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry; // 👈 declare first

    overlayEntry = OverlayEntry(
      builder: (context) => _TopAlertBanner(
        type: type,
        title: title,
        description: description,
        onClose: () => overlayEntry.remove(), // 👈 safe now
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }
}

class _TopAlertBanner extends StatefulWidget {
  final AlertType type;
  final String title;
  final String description;
  final VoidCallback onClose;

  const _TopAlertBanner({
    required this.type,
    required this.title,
    required this.description,
    required this.onClose,
  });

  @override
  State<_TopAlertBanner> createState() => _TopAlertBannerState();
}

class _TopAlertBannerState extends State<_TopAlertBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get bgColor {
    switch (widget.type) {
      case AlertType.success:
        return const Color(0xFF2E7D32); // green
      case AlertType.error:
        return const Color(0xFF7F1D1D); // dark red
      case AlertType.warning:
        return const Color(0xFFF59E0B); // amber
      case AlertType.info:
        return const Color(0xFF2563EB); // blue
    }
  }

  IconData get icon {
    switch (widget.type) {
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.warning:
        return Icons.warning_amber_rounded;
      case AlertType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 12,
      right: 12,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.redAccent, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
