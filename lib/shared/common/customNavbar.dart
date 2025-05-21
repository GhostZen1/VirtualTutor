import 'package:tosl_operation/modules/global.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<IconData> icons;
  final List<String> labels;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.icons,
    required this.labels,
  }) : assert(icons.length == labels.length,
            'Icons and labels must be the same length.');

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: onTap,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      items: List.generate(
        icons.length,
        (index) => BottomNavigationBarItem(
          icon: Icon(icons[index]),
          label: labels[index],
        ),
      ),
    );
  }
}
