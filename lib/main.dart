import 'package:flutter/material.dart';

void main() => runApp(const MangaArabApp());

enum UserRole { owner, headAdmin, superAdmin, adminMonth, admin, translator, editor, member, guest }

class MangaArabApp extends StatefulWidget {
  const MangaArabApp({Key? key}) : super(key: key);
  @override
  State<MangaArabApp> createState() => _MangaArabAppState();
}

class _MangaArabAppState extends State<MangaArabApp> {
  Color primaryColor = const Color(0xFFFF5722);
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MANGA ARAB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDarkMode ? const Color(0xFF0D0D12) : const Color(0xFFF5F5F7),
        cardColor: isDarkMode ? const Color(0xFF161622) : Colors.white,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: isDarkMode ? Brightness.dark : Brightness.light),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MasterAppScreen(
          activeColor: primaryColor,
          isDarkMode: isDarkMode,
          onThemeChange: (c) => setState(() => primaryColor = c),
          onModeToggle: () => setState(() => isDarkMode = !isDarkMode),
        ),
      ),
    );
  }
}

class MasterAppScreen extends StatefulWidget {
  final Color activeColor;
  final bool isDarkMode;
  final ValueChanged<Color> onThemeChange;
  final VoidCallback onModeToggle;

  const MasterAppScreen({
    Key? key,
    required this.activeColor,
    required this.isDarkMode,
    required this.onThemeChange,
    required this.onModeToggle,
  }) : super(key: key);

  @override
  State<MasterAppScreen> createState() => _MasterAppScreenState();
}

class _MasterAppScreenState extends State<MasterAppScreen> {
  int _tab = 0;
  String username = "BENZO";
  UserRole role = UserRole.owner;
  int coins = 999999;
  String equippedFrame = "Golden hex";
  Color customNameColor = const Color(0xFFFFB703);
  int selectedFontId = 1;

  // الصلاحيات الاستثنائية الممنوحة (Overrides)
  bool canBanOverride = true;
  bool canTimeoutOverride = true;
  bool canUseBrowserOverride = true;
  bool doublePoints = true;
  bool antiHackShield = true;
  String? activeBroadcast;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // الرتب بالترتيب الهرمي الدقيق
  final Map<UserRole, String> roleLabels = {
    UserRole.owner: "👑 الفاوندر والمالك",
    UserRole.headAdmin: "⚡ هيد ادمن",
    UserRole.superAdmin: "🛡️ سوبر ادمن",
    UserRole.adminMonth: "⭐ ادمن الشهر",
    UserRole.admin: "🔰 ادمن",
    UserRole.translator: "✍️ مترجم",
    UserRole.editor: "🎨 محرر",
    UserRole.member: "👤 عضو",
    UserRole.guest: "👀 ضيف (قراءة مقفلة)",
  };

  // المتجر والإطارات
  final List<Map<String, dynamic>> shopFrames = [
    {"name": "Golden hex", "price": 1200, "color": Colors.amber, "icon": Icons.star},
    {"name": "Laurel wreath", "price": 1200, "color": Colors.amberAccent, "icon": Icons.emoji_events},
    {"name": "Rage blue", "price": 1400, "color": Colors.blueAccent, "icon": Icons.flash_on},
    {"name": "Jet ring", "price": 1600, "color": Colors.purpleAccent, "icon": Icons.album},
    {"name": "Fire aura", "price": 3000, "color": Colors.deepOrangeAccent, "icon": Icons.local_fire_department},
    {"name": "Kitsune", "price": 3000, "color": Colors.pinkAccent, "icon": Icons.auto_awesome},
  ];

  // المهام اليومية ورتبة الصياد A
  final List<Map<String, dynamic>> dailyQuests = [
    {"title": "قراءة يومية 3 فصول", "cur": 2, "max": 3, "reward": 6, "done": false},
    {"title": "جلسة قراءة 8 فصول", "cur": 7, "max": 8, "reward": 8, "done": false},
    {"title": "كتابة تعليق يومي", "cur": 1, "max": 1, "reward": 3, "done": false},
    {"title": "تسجيل الدخول اليومي", "cur": 1, "max": 1, "reward": 5, "done": true},
  ];

  // سجل العمليات الشامل
  final List<String> auditLogs = [
    "[أمان] درع مكافحة التخريب والاختراق يعمل بنسبة 100%.",
    "[صلاحيات] تم تنصيب BENZO مالكاً ومؤسساً للإمبراطورية.",
  ];

  // شات الإدارة السري
  final List<String> adminChat = [
    "BENZO (الفاوندر): تم ربط فصول سوات مانجا وتيم إكس ومانجاليك.",
    "سوبر ادمن: تم تفعيل مراقبة مكافحة التخريب اللحظية.",
  ];

  // قائمة الإعلانات الإدارية
  final List<String> adminAnnouncements = [
    "📢 إعلان رسمي: يمنع حظر أي عضو دون تدوين السبب في سجل الـ Logs.",
  ];

  void _addLog(String text) {
    setState(() => auditLogs.insert(0, "[${DateTime.now().hour}:${DateTime.now().minute}] $text"));
  }

  bool get canAccessBrowser => role == UserRole.owner || canUseBrowserOverride;
  bool get canModerate => role == UserRole.owner || role == UserRole.headAdmin || role == UserRole.superAdmin || canBanOverride;

  @override
  Widget build(BuildContext context) {
    final List<Widget> views = [
      _buildHome(),
      _buildShop(),
      _buildMissions(),
      _buildProfile(),
      _buildAdminDashboard(),
      if (role == UserRole.owner) _buildOwnerRoom(),
      _buildSupport(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F18),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Row(
          children: [
            Text("MANGA", style: TextStyle(fontWeight: FontWeight.w900, color: widget.activeColor)),
            const SizedBox(width: 4),
            const Text("ARAB", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.amber),
            onPressed: widget.onModeToggle,
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: _showSearch),
          if (canModerate)
            IconButton(
              icon: const Icon(Icons.security, color: Colors.cyanAccent),
              tooltip: "لوحة الإدارة",
              onPressed: () => setState(() => _tab = 4),
            ),
        ],
      ),
      body: Column(
        children: [
          if (activeBroadcast != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: Colors.redAccent.shade700,
              child: Text("إشعار BENZO: $activeBroadcast", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          Expanded(
            child: Stack(
              children: [
                views[_tab >= views.length ? 0 : _tab],
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    backgroundColor: widget.activeColor,
                    onPressed: _showDailyGift,
                    child: const Icon(Icons.card_giftcard, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                CircleAvatar(
                  radius: 32,
                  backgroundColor: widget.activeColor,
                  child: const Icon(Icons.person, color: Colors.black, size: 38),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: customNameColor)),
                      Text(roleLabels[role]!, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text("$coins 🪙", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.home, "الرئيسية", 0),
          _drawerItem(Icons.storefront, "المتجر والإطارات 🛒", 1),
          _drawerItem(Icons.emoji_events, "المهمات ورتبة الصياد 🏆", 2),
          _drawerItem(Icons.person, "الملف الشخصي", 3),
          if (canModerate) _drawerItem(Icons.security, "لوحة تحكم المشرفين 🛡️", 4),
          if (role == UserRole.owner) _drawerItem(Icons.build, "غرفة المالك BENZO 👑", 5),
          _drawerItem(Icons.volunteer_activism, "ادعمنا واحصل على نقاط ❤️", 6, isRed: true),
          const Divider(color: Colors.white12),
          const Padding(padding: EdgeInsets.all(12), child: Text("مغير الألوان الحي:", style: TextStyle(color: Colors.white60))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _colorDot(const Color(0xFFFF5722)),
              _colorDot(Colors.amber),
              _colorDot(Colors.pinkAccent),
              _colorDot(Colors.purpleAccent),
              _colorDot(Colors.tealAccent),
              _colorDot(Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int idx, {bool isRed = false}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.redAccent : widget.activeColor),
      title: Text(title, style: TextStyle(color: isRed ? Colors.redAccent : Colors.white)),
      onTap: () {
        setState(() => _tab = idx);
        Navigator.pop(context);
      },
    );
  }

  Widget _colorDot(Color c) {
    return GestureDetector(
      onTap: () {
        widget.onThemeChange(c);
        Navigator.pop(context);
      },
      child: CircleAvatar(radius: 12, backgroundColor: c),
    );
  }

  Widget _buildHome() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [widget.activeColor, Colors.black87]),
          ),
          padding: const EdgeInsets.all(14),
          alignment: Alignment.bottomRight,
          child: const Text("MANGA ARAB\nوجهتك الأولى للمانجا والمانهو المترجمة 👑", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        ),
        const SizedBox(height: 16),
        const Text("الأعمال الحصرية (سوات مانجا - تيم إكس - مانجاليك) 🔥", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _mangaTile("The Divine Ring Descends", "الفصل 100 (سوات مانجا)", "9.0 ⭐"),
        _mangaTile("I Reincarnated As the Crazed Heir", "الفصل 85 (تيم إكس)", "8.8 ⭐"),
        _mangaTile("Skills have no cooldown", "الفصل 42 (مانجاليك)", "8.2 ⭐"),
      ],
    );
  }

  Widget _mangaTile(String title, String chapter, String rating) {
    return Card(
      color: const Color(0xFF141422),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.book, color: widget.activeColor, size: 36),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text("$chapter • $rating", style: const TextStyle(color: Colors.white54)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: widget.activeColor),
          onPressed: () {
            if (role == UserRole.guest) {
              _showGuestBlocker();
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => MangaReaderScreen(title: title)));
            }
          },
          child: const Text("قراءة", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildShop() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("متجر الإطارات والباقات 🛒", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("$coins 🪙", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ...shopFrames.map((f) => Card(
          color: const Color(0xFF141422),
          child: ListTile(
            leading: Icon(f['icon'], color: f['color'], size: 36),
            title: Text(f['name']),
            subtitle: Text("${f['price']} نقطة", style: const TextStyle(color: Colors.amber)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: widget.activeColor),
              onPressed: () {
                setState(() => equippedFrame = f['name']);
                _addLog("شراء وتجهيز إطار: ${f['name']}");
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم تجهيز ${f['name']} بنجاح!")));
              },
              child: Text(equippedFrame == f['name'] ? "مفعّل" : "شراء", style: const TextStyle(color: Colors.black)),
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildMissions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFF141422), borderRadius: BorderRadius.circular(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("صياد رتبة A • المستوى 44", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: 0.85, color: widget.activeColor, backgroundColor: Colors.white10),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text("المهام اليومية ☀️", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...dailyQuests.map((q) => Card(
          color: const Color(0xFF141422),
          child: ListTile(
            title: Text(q['title']),
            subtitle: Text("${q['cur']} / ${q['max']}"),
            trailing: Text("+${q['reward']} نقطة", style: TextStyle(color: widget.activeColor, fontWeight: FontWeight.bold)),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(radius: 38, backgroundColor: widget.activeColor, child: const Icon(Icons.person, size: 44, color: Colors.black)),
              const SizedBox(height: 8),
              Text(username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: customNameColor)),
              Text(roleLabels[role]!, style: const TextStyle(color: Colors.amber, fontSize: 12)),
              Text("الإطار: $equippedFrame | خط رقم: $selectedFontId", style: const TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.people, color: Colors.cyanAccent),
                    label: const Text("المتابعون والرتب"),
                    onPressed: _showFollowersModal,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.font_download, color: Colors.amber),
                    label: const Text("الـ 100 خط والألوان"),
                    onPressed: _showFontDialog,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text("26.3k\nتعليق", textAlign: TextAlign.center),
            Text("1.1k\nمقروءة", textAlign: TextAlign.center),
            Text("824\nبالمكتبة", textAlign: TextAlign.center),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminDashboard() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("لوحة تحكم الإدارة والمشرفين 🛡️", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                icon: const Icon(Icons.gavel, color: Colors.white),
                label: const Text("حظر (Ban)", style: TextStyle(color: Colors.white)),
                onPressed: () => _openActionDialog("حظر عضو (Ban) 🚫"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                icon: const Icon(Icons.timer, color: Colors.black),
                label: const Text("تايم أوت", style: TextStyle(color: Colors.black)),
                onPressed: () => _openActionDialog("تايم أوت 24 ساعة ⏱️"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text("شات الإدارة السري 💬", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
        Container(
          height: 120,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF141422), borderRadius: BorderRadius.circular(10)),
          child: ListView.builder(
            itemCount: adminChat.length,
            itemBuilder: (_, i) => Text(adminChat[i], style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        ),
        const SizedBox(height: 14),
        const Text("الإعلانات الإدارية 📢", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
        ...adminAnnouncements.map((a) => Card(
          color: const Color(0xFF141424),
          child: Padding(padding: const EdgeInsets.all(10), child: Text(a, style: const TextStyle(fontSize: 12, color: Colors.white))),
        )).toList(),
      ],
    );
  }

  Widget _buildOwnerRoom() {
    final nameCtrl = TextEditingController();
    final broadcastCtrl = TextEditingController();
    final transferCtrl = TextEditingController();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("غرفة عمليات المالك والفاوندر BENZO 👑", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
        const SizedBox(height: 12),
        SwitchListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("درع مكافحة التخريب والاختراق (Anti-Hack)"),
          value: antiHackShield,
          onChanged: (v) {
            setState(() => antiHackShield = v);
            _addLog("درع الحماية: ${v ? 'مفعل' : 'معطل'}");
          },
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("مضاعفة النقاط (دبل نقاط)"),
          value: doublePoints,
          onChanged: (v) => setState(() => doublePoints = v),
        ),
   
