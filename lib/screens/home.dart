import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_background.dart';


class Home extends StatelessWidget {
  final int nurseId;

  const Home({super.key, required this.nurseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome Nurse $nurseId")),
      body: Center(
        child: Text(
          "Hello Nurse! Your ID is $nurseId",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: const [
                SizedBox(height: 24),
                _Header(),
                SizedBox(height: 30),
                _SearchBar(),
                SizedBox(height: 30),
                _QuickActionsRow(),
                SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }

// ------------------ Header ------------------
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: SvgPicture.asset(
                'assets/ACLC.svg',
                height: 50,
                width: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: const Text(
                'ACLC Clinic',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const _ProfileMenu(),
      ],
    );
  }
}

// ------------------ Profile Menu ------------------
class _ProfileMenu extends StatefulWidget {
  const _ProfileMenu();

  @override
  State<_ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<_ProfileMenu> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 55),
      elevation: 12,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.primaryGradient.colors.first.withOpacity(0.2),
          width: 1,
        ),
      ),
      onOpened: () => setState(() => _isMenuOpen = true),
      onCanceled: () => setState(() => _isMenuOpen = false),
      child: Container(
        decoration: BoxDecoration(
          gradient: _isMenuOpen ? AppColors.primaryGradient : null,
          color: _isMenuOpen ? null : Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          Icons.person,
          color: _isMenuOpen ? Colors.white : Colors.grey.shade600,
          size: 16,
        ),
      ),
      itemBuilder: (_) => [
        _menuItem(
          'account',
          Icons.account_circle_rounded,
          'Account',
          AppColors.primaryGradient.colors.first,
        ),
        const PopupMenuDivider(height: 16),
        _menuItem(
          'logout',
          Icons.logout_rounded,
          'Logout',
          Colors.red.shade400,
        ),
      ],
      onSelected: (value) {
        setState(() => _isMenuOpen = false);
        if (value == 'account') {
          Navigator.pushNamed(context, '/userinfo');
        } else if (value == 'logout') {
          Navigator.pushReplacementNamed(context, '/signin');
        }
      },
    );
  }

  static PopupMenuItem<String> _menuItem(
      String value, IconData icon, String text, Color color) {
    return PopupMenuItem(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: value == 'account'
                  ? LinearGradient(
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: value == 'logout' ? color.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(width: 14),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------ Search Bar ------------------
class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, String>> _filteredPatients = [];
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<List<Map<String, String>>> _fetchPatients(String query) async {
    // TODO: Replace with API call
    return [];
  }

  void _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredPatients = [];
      });
      return;
    }

    final results = await _fetchPatients(query);
    setState(() {
      _filteredPatients = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Searching for a patient?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isFocused
                  ? AppColors.primaryGradient.colors.first
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: _onSearch,
            decoration: InputDecoration(
              hintText: 'Search by patient name/diagnosis',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 15,
              ),
              prefixIcon: ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ),
      ],
    );
  }
}

// ------------------ Quick Actions ------------------
class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
          children: const [
            _SquareActionCard(
              'Appointments',
              Icons.calendar_today_rounded,
              'Schedule and manage',
            ),
            _SquareActionCard(
              'Patient Records',
              Icons.folder_shared_rounded,
              'View patient history',
            ),
            _SquareActionCard(
              'Medical Inventory',
              Icons.medication_rounded,
              'Track supplies',
            ),
            _SquareActionCard(
              'Add Form',
              Icons.add_box_rounded,
              'Create new entry',
            ),
          ],
        ),
      ],
    );
  }
}

class _SquareActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;

  const _SquareActionCard(this.title, this.icon, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          switch (title) {
            case 'Appointments':
              Navigator.pushNamed(context, '/appointments');
              break;
            case 'Patient Records':
              Navigator.pushNamed(context, '/patientsrecords');
              break;
            case 'Medical Inventory':
              Navigator.pushNamed(context, '/medicalinventory');
              break;
            case 'Add Form':
              Navigator.pushNamed(context, '/addform');
              break;
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.primaryGradient.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
