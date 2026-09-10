import 'package:flutter/material.dart';

void main() => runApp(const MangaArabApp());

class MangaArabApp extends StatefulWidget {
  const MangaArabApp({Key? key}) : super(key: key);

  @override
  State<MangaArabApp> createState() => _MangaArabAppState();
}

class _MangaArabAppState extends State<MangaArabApp> {
  Color primaryThemeColor = const Color(0xFFFF5722);

  void changeTheme(Color color) {
    setState(() => primaryThemeColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MANGA ARAB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D12),
        cardColor: const Color(0xFF161622),
        primaryColor: primaryThemeColor,
        colorScheme: ColorScheme.dark(primary: primaryThemeColor),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainHubScreen(
          activeColor: primaryThemeColor,
          onThemeChanged: changeTheme,
        ),
      ),
    );
  }
}

class MainHubScreen extends StatefulWidget {
  final Color activeColor;
  final Function(Color) onThemeChanged;

  const MainHubScreen({Key? key, required this.activeColor, required this.onThemeChanged}) : super(key: key);

  @override
  State<MainHubScreen> createState() => _MainHubScreenState();
}

class _MainHubScreenState extends State<MainHubScreen> {
  int userCoins = 2450;
  String username = "BENZO";
  String selectedFrame = "Golden hex";
  int _currentViewIndex = 0; // 0: Home, 1: Shop, 2: Missions, 3: Profile, 4: Support

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> libraryManga = [
    "The Divine Ring Descends",
    "Skills have no cooldown",
    "God Rank Option",
  ];

  final List<Map<String, dynamic>> avatarFrames = [
    {"name": "Golden hex", "price": 1200, "color": Colors.amber, "icon": Icons.hexagon},
    {"name": "Laurel wreath", "price": 1200, "color": Colors.amberAccent, "icon": Icons.workspace_premium},
    {"name": "Rage blue", "price": 1400, "color": Colors.blueAccent, "icon": Icons.flash_on},
    {"name": "Jet ring", "price": 1600, "color": Colors.purpleAccent, "icon": Icons.album},
    {"name": "Fire aura", "price": 3000, "color": Colors.deepOrangeAccent, "icon": Icons.local_fire_department},
    {"name": "Kitsune mask", "price": 3000, "color": Colors.pinkAccent, "icon": Icons.masks},
  ];

  final List<Map<String, dynamic>> dailyMissions = [
    {"title": "قراءة يومية 3 فصول", "target": 3, "current": 2, "reward": 6, "claimed": false},
    {"title": "جلسة قراءة 8 فصول", "target": 8, "current": 7, "reward": 8, "claimed": false},
    {"title": "تعليق يومي على عمل", "target": 1, "current": 1, "reward": 3, "claimed": false},
    {"title": "تقديم 3 إعجابات", "target": 3, "current": 3, "reward": 2, "claimed": false},
    {"title": "تسجيل الدخول اليومي", "target": 1, "current": 1, "reward": 5, "claimed": true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      appBar: _buildCustomAppBar(),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentViewIndex,
            children: [
              _buildHomeScreen(),
              _buildShopScreen(),
              _buildMissionsScreen(),
              _buildProfileScreen(),
              _buildSupportScreen(),
            ],
          ),
          // زر الهدية العائم الدائم
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () => _showDailyGiftDialog(),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C),
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.activeColor, width: 2),
                  boxShadow: [
                    BoxShadow(color: widget.activeColor.withOpacity(0.3), blurRadius: 10),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.card_giftcard, color: Colors.white, size: 28),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.deepOrange, shape: BoxShape.circle),
                        child: const Text("1", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F0F18),
      elevation: 4,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Row(
        children: [
          Text(
            "MANGA",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: widget.activeColor),
          ),
          const SizedBox(width: 4),
          const Text(
            "ARAB",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.swap_horiz, color: Colors.white),
          tooltip: "عمل عشوائي",
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم اختيار عمل عشوائي لمشاهدته الآن!")),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => _showSearchDialog(),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("لا توجد إشعارات جديدة غير مقروءة")),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0F0F18),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF141422)),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: widget.activeColor.withOpacity(0.3),
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: widget.activeColor, width: 3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                            const SizedBox(width: 6),
                            Text("$userCoins", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.home, "الرئيسية", 0),
          _drawerItem(Icons.storefront, "المتجر", 1),
          _drawerItem(Icons.emoji_events, "المهمات والإنجازات", 2),
          _drawerItem(Icons.person, "الملف الشخصي", 3),
          _drawerItem(Icons.volunteer_activism, "ادعمنا واحصل على نقاط ❤️", 4, isRed: true),
          const Divider(color: Colors.white12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("ألوان المظهر الحي:", style: TextStyle(color: Colors.white60, fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _colorCircle(const Color(0xFFFF5722)),
                _colorCircle(Colors.amber),
                _colorCircle(Colors.pinkAccent),
                _colorCircle(Colors.purpleAccent),
                _colorCircle(Colors.tealAccent),
                _colorCircle(Colors.cyanAccent),
                _colorCircle(Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorCircle(Color c) {
    return GestureDetector(
      onTap: () {
        widget.onThemeChanged(c);
        Navigator.pop(context);
      },
      child: CircleAvatar(
        radius: 14,
        backgroundColor: c,
        child: widget.activeColor == c ? const Icon(Icons.check, size: 14, color: Colors.black) : null,
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int viewIndex, {bool isRed = false}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.redAccent : Colors.white70),
      title: Text(title, style: TextStyle(color: isRed ? Colors.redAccent : Colors.white, fontWeight: isRed ? FontWeight.bold : FontWeight.normal)),
      onTap: () {
        setState(() => _currentViewIndex = viewIndex);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildHomeScreen() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // بانر رئيسي
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [widget.activeColor.withOpacity(0.8), Colors.black],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("MANGA ARAB", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              const Text("وجهتك الأولى لقراءة المانجا والمانهو المترجمة بالعربية.", style: TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text("أحدث الفصول المترجمة 🔥", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        _buildMangaCard(
          "The Divine Ring Descends: The Strongest Otherworld",
          "الفصل 100",
          "9.0 ⭐",
        ),
        _buildMangaCard(
          "I Reincarnated As the Crazed Heir",
          "الفصل 85",
          "8.8 ⭐",
        ),
        _buildMangaCard(
          "Skills have no cooldown",
          "الفصل 42",
          "8.2 ⭐",
        ),
      ],
    );
  }

  Widget _buildMangaCard(String title, String chapter, String rating) {
    return Card(
      color: const Color(0xFF141422),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 50,
            height: 70,
            color: widget.activeColor.withOpacity(0.2),
            child: Icon(Icons.book, color: widget.activeColor),
          ),
        ),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text("$chapter • $rating", style: const TextStyle(color: Colors.white54, fontSize: 12)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: widget.activeColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => MangaReaderView(mangaTitle: title)),
            );
          },
          child: const Text("قراءة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildShopScreen() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("متجر مانجا عرب 🛒", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("نقاطك: $userCoins 🪙", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 14),
        const Text("إطارات الصورة المميزة (Avatar Frames):", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: avatarFrames.length,
          itemBuilder: (ctx, i) {
            final f = avatarFrames[i];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF141422),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selectedFrame == f['name'] ? widget.activeColor : Colors.white10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(f['icon'], size: 48, color: f['color']),
                  const SizedBox(height: 6),
                  Text(f['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("${f['price']} نقطة", style: const TextStyle(color: Colors.amber, fontSize: 12)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: widget.activeColor),
                    onPressed: () {
                      if (userCoins >= (f['price'] as int)) {
                        setState(() {
                          userCoins -= (f['price'] as int);
                          selectedFrame = f['name'];
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم شراء وتجهيز إطار ${f['name']} بنجاح!")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("رصيد النقاط لا يكفي لشراء هذا الإطار!")),
                        );
                      }
                    },
                    child: Text(selectedFrame == f['name'] ? "مفعّل" : "شراء الآن", style: const TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMissionsScreen() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // بطاقة رتبة الصياد A المطابقة للصورة
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF141422),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.activeColor.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("صياد رتبة A", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  CircleAvatar(backgroundColor: widget.activeColor, child: const Text("A", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 4),
              const Text("المستوى 44 • 15,352 XP", style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: 0.85, backgroundColor: Colors.white10, color: widget.activeColor),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text("مهام يومية ☀️", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        ...dailyMissions.map((m) {
          final isDone = m['current'] >= m['target'];
          return Card(
            color: const Color(0xFF141422),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(m['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Text("${m['current']} / ${m['target']}", style: const TextStyle(color: Colors.white54, fontSize: 12)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: m['claimed'] ? Colors.grey : (isDone ? widget.activeColor : Colors.white10),
                ),
                onPressed: (!m['claimed'] && isDone)
                    ? () {
                        setState(() {
                          m['claimed'] = true;
                          userCoins += (m['reward'] as int);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم استلام +${m['reward']} نقطة بنجاح! 🪙")),
                        );
                      }
                    : null,
                child: Text(
                  m['claimed'] ? "مكتمل" : "+${m['reward']}",
                  style: TextStyle(color: m['claimed'] ? Colors.white30 : Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildProfileScreen() {
    return List
