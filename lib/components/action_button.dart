import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
    required this.icon,
    this.activeIcon,
    required this.label,
    this.onTap,
    this.active = false,
  });

  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final Future<void> Function()? onTap;
  final bool active;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  late bool active;
  IconData? currentIcon;

  @override
  void initState() {
    super.initState();
    active = widget.active;
    if (active) {
      currentIcon ??= widget.activeIcon;
    } else {
      currentIcon ??= widget.icon;
    }
  }

  Future<void> onTap() async {
    if (widget.onTap != null) {
      await widget.onTap!();
    }
    setState(
      () {
        if (widget.activeIcon != null) {
          active = !active;
          if (active) {
            currentIcon = widget.activeIcon;
          } else {
            currentIcon = widget.icon;
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 50, minHeight: 50),
          child: Column(
            children: [
              Icon(
                currentIcon,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 2),
              Text(
                widget.label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
