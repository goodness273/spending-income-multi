import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';
import 'package:spending_income/utils/app_theme/index.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../transactions/add_transaction/add_transaction_modal.dart';

// Import the screen widgets
import 'dashboard_screen.dart';
import '../transaction_screen/transaction_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';

/// HomeScreen acts as the main navigation container using a
/// custom BottomAppBar with a centered FloatingActionButton.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Tracks the currently selected tab index
  // 0: Dashboard, 1: Transactions, 2: Analytics, 3: Profile
  int _selectedIndex = 0;

  // List of the screen widgets to display in the body
  static const List<Widget> _screenOptions = <Widget>[
    DashboardScreen(),
    TransactionScreen(),
    AnalyticsScreen(), // Corresponds to index 2
    ProfileScreen(),   // Corresponds to index 3
  ];

  // Handles taps on the navigation items in the BottomAppBar
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handles taps on the central Floating Action Button
  void _onFabTapped() {
    AddTransactionModal.show(
      context,
      (Transaction transaction) {
        // Use the transaction provider to add the transaction
        final transactionService = ref.read(transactionServiceProvider);
        final user = ref.read(authStateProvider).value;
        
        if (user != null) {
          // Create a complete transaction with userId
          final completeTransaction = transaction.copyWith(userId: user.uid);
          transactionService.addTransaction(completeTransaction);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction added successfully!')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Determine theme-specific colors for navigation elements
    final Color selectedItemColor = AppThemeHelpers.getPrimaryColor(isDarkMode);
    // Using mediumGray for unselected items as it matched the light theme image
    const Color unselectedItemColor = AppColors.mediumGray;
    // FAB colors are inverted: Black on Light, White on Dark
    final Color fabBackgroundColor = isDarkMode ? AppColors.white : AppColors.primaryBlack;
    final Color fabIconColor = isDarkMode ? AppColors.primaryBlack : AppColors.white;
    // BottomAppBar background matches the main screen background
    final Color bottomAppBarColor = AppThemeHelpers.getBackgroundColor(isDarkMode);

    return Scaffold(
      // Body displays the currently selected screen using IndexedStack
      // IndexedStack preserves the state of the screens when switching tabs
      body: IndexedStack(
        index: _selectedIndex,
        children: _screenOptions,
      ),

      // Central Floating Action Button configuration
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabTapped,
        backgroundColor: fabBackgroundColor,
        elevation: 4.0, // Give FAB slightly more emphasis
        highlightElevation: 2.0,
        shape: const CircleBorder(), // Standard circular FAB
        child: SvgPicture.asset(
          'assets/Icons/Add or Plus.svg', // The Add icon
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(fabIconColor, BlendMode.srcIn),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Custom BottomAppBar with notch for the FAB
      bottomNavigationBar: BottomAppBar(
        color: bottomAppBarColor, // Set background to match screen background
        elevation: 0.0, // Make the bar flat with no shadow
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 65.0, // Slightly taller to accommodate labels
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem(
                iconSelectedAsset: 'assets/Icons/Dashboard selected.svg',
                iconUnselectedAsset: 'assets/Icons/Dashboard not selected.svg',
                label: 'Dashboard',
                itemIndex: 0,
                currentIndex: _selectedIndex,
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
                onTap: () => _onNavItemTapped(0),
              ),
              _buildNavItem(
                iconSelectedAsset: 'assets/Icons/Transactions selected.svg',
                iconUnselectedAsset: 'assets/Icons/Transactions not selected.svg',
                label: 'Transactions',
                itemIndex: 1,
                currentIndex: _selectedIndex,
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
                onTap: () => _onNavItemTapped(1),
              ),
              const SizedBox(width: 40), // Space for FAB
              _buildNavItem(
                iconSelectedAsset: 'assets/Icons/Analytics selected.svg',
                iconUnselectedAsset: 'assets/Icons/Analytics not selected.svg',
                label: 'Analytics',
                itemIndex: 2,
                currentIndex: _selectedIndex,
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
                onTap: () => _onNavItemTapped(2),
              ),
              _buildNavItem(
                iconSelectedAsset: 'assets/Icons/Profile selected.svg',
                iconUnselectedAsset: 'assets/Icons/User not selected.svg',
                label: 'Profile',
                itemIndex: 3,
                currentIndex: _selectedIndex,
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
                onTap: () => _onNavItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the navigation items
  Widget _buildNavItem({
    required String iconSelectedAsset,
    required String iconUnselectedAsset,
    required String label,
    required int itemIndex,
    required int currentIndex,
    required Color selectedColor,
    required Color unselectedColor,
    required VoidCallback onTap,
  }) {
    final bool isSelected = itemIndex == currentIndex;
    final Color itemColor = isSelected ? selectedColor : unselectedColor;
    final String iconAsset = isSelected ? iconSelectedAsset : iconUnselectedAsset;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                iconAsset,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
                semanticsLabel: '$label icon',
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: itemColor,
                  fontSize: 10,
                  height: 1.2,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



