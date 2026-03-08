import 'package:flutter/material.dart';

class TabletLayoutWrapper extends StatelessWidget {
  final Widget child;
  final Widget? sidePanel;
  final List<NavigationRailDestination>? destinations;
  final int? selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  const TabletLayoutWrapper({
    super.key,
    required this.child,
    this.sidePanel,
    this.destinations,
    this.selectedIndex,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 800;

        if (!isTablet) return child;

        return Row(
          children: [
            if (destinations != null)
              NavigationRail(
                extended: constraints.maxWidth > 1000,
                destinations: destinations!,
                selectedIndex: selectedIndex ?? 0,
                onDestinationSelected: onDestinationSelected,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                unselectedIconTheme: const IconThemeData(color: Colors.white54),
                selectedIconTheme: IconThemeData(
                  color: Theme.of(context).primaryColor,
                ),
                labelType: constraints.maxWidth > 1000
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
              ),
            if (destinations != null)
              VerticalDivider(
                thickness: 1,
                width: 1,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            Expanded(flex: 3, child: child),
            if (sidePanel != null) ...[
              VerticalDivider(
                thickness: 1,
                width: 1,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              Expanded(flex: 1, child: sidePanel!),
            ],
          ],
        );
      },
    );
  }
}
