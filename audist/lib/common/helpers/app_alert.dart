import 'package:flutter/material.dart';

enum AlertType { success, error, warning, info }

class AppAlert {
  // Holds the currently displayed alert
  static OverlayEntry? _currentOverlay;

  static void show(
      BuildContext context, {
        required AlertType type,
        required String title,
        required String description,
        Duration duration = const Duration(seconds: 4),
      }) {
    // Remove previous alert if it exists
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _TopAlertBanner(
        type: type,
        title: title,
        description: description,
        onClose: () {
          overlayEntry.remove();
          if (_currentOverlay == overlayEntry) _currentOverlay = null;
        },
      ),
    );

    overlay.insert(overlayEntry);
    _currentOverlay = overlayEntry;

    // Auto dismiss after duration
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
        if (_currentOverlay == overlayEntry) _currentOverlay = null;
      }
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
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
        return const Color(0xFF2E7D32);
      case AlertType.error:
        return const Color(0xFF7F1D1D);
      case AlertType.warning:
        return const Color(0xFFF59E0B);
      case AlertType.info:
        return const Color(0xFF2563EB);
    }
  }

  Color get borderColor {
    switch (widget.type) {
      case AlertType.success:
        return Colors.greenAccent;
      case AlertType.error:
        return Colors.redAccent;
      case AlertType.warning:
        return Colors.amber;
      case AlertType.info:
        return Colors.blueAccent;
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
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor.withAlpha(200),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: borderColor, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: borderColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            color: Colors.white,
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
      ),
    );
  }
}
