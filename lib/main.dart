import 'package:flutter/material.dart';

void main() => runApp(const MangaArabApp());

class MangaArabApp extends StatefulWidget {
  const MangaArabApp({Key? key}) : super(key: key);

  @override
  State<MangaArabApp> createState() => _MangaArabAppState();
}

class _MangaArabAppState extends State<MangaArabApp> {
  Color primaryColor = const Color(0xFFFF5722);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MANGA ARAB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D12),
        cardColor: const Color(0xFF161622),
        primaryColor: primaryColor,
        colorScheme: ColorScheme.dark(primary: primaryColor),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainMasterScreen(
          activeColor: primaryColor,
          onThemeChange: (c) => setState(() => primaryColor = c),
        ),
      ),
    );
  }
}

class MainMasterScreen extends StatefulWidget {
  final Color activeColor;
  final ValueChanged<Color> onThemeChange;

  const MainMasterScreen({Key? key, required this.activeColor, required this.onThemeChange}) : super(key: key);

  @override
  State<MainMasterScreen> createState() => _MainMasterScreenState();
}

class _MainMasterScreenState extends State<MainMasterScreen> {
  int _tab = 0;
  int userCoins = 999999;
  String username = "BENZO";
  String currentRole = "👑 الفاوندر والمالك";
  bool isOwner = true;
  String equippedFrame = "Golden hex";
  bool doublePoints = true;
  bool antiHackShield = true;
  String? activeBroadcast;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> frames = [
    {"name": "Golden hex", "price": 1200, "color": Colors.amber, "icon": Icons.star},
    {"name": "Laurel wreath", "price": 1200, "color": Colors.amberAccent, "icon": Icons.emoji_events},
    {"name": "Rage blue", "price": 1400, "color": Colors.blueAccent, "icon": Icons.flash_on},
    {"name": "Jet ring", "price": 1600, "color": Colors.purpleAccent, "icon": Icons.album},
    {"name": "Fire aura", "price": 3000, "color": Colors.deepOrangeAccent, "icon": Icons.local_fire_department},
  ];

  final List<Map<String, dynamic>> customPackages = [
    {"name": "باقة المحارب الفضي ⚔️", "points": 5000, "desc": "إزالة الإعلانات + شارة فضية"},
    {"name": "باقة التنين الذهبي 🐉", "points": 12000, "desc": "فتح مصادر سوات ومانجاليك"},
    {"name": "باقة إمبراطور المانجا 👑", "points": 25000, "desc": "دبل نقاط دائم وفصول تيم إكس"},
    {"name": "باقة حاكم الظلال ⚡", "points": 50000, "desc": "تحميل الفصول بدون نت"},
    {"name": "باقة العرش الإلهي 🪐", "points": 100000, "desc": "تربل نقاط وثيم ملكي خاص"},
  ];

  final List<String> auditLogs = [
    "[أمان] تشغيل درع مكافحة الاختراق بنجاح.",
    "[رتبة] تفعيل صلاحيات الفاوندر المطلقة للمستخدم BENZO.",
    "[متجر] جاهزية 5 باقات ملكية للشراء والاستخدام.",
  ];

  final List<String> adminChatMessages = [
    "BENZO (الفاوندر): يا شباب، تم تفعيل سحب الفصول تلقائياً من سوات ومانجاليك.",
    "مشرف عام: تم فحص التعليقات ولا توجد مخالفات حالياً.",
  ];

  final List<String> adminAnnouncements = [
    "📢 إعلان إداري: يمنع حظر أي عضو بدون تسجيل سبب العقوبة في الـ Log.",
  ];

  final List<Map<String, String>> bannedUsers = [];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHome(),
      _buildShop(),
      _buildMissions(),
      _buildProfile(),
      _buildAdminDashboard(),
      if (isOwner) _buildOwnerRoom(),
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
          IconButton(icon: const Icon(Icons.search), onPressed: _showSearch),
          IconButton(
            icon: const Icon(Icons.security, color: Colors.amber),
            tooltip: "لوحة المشرفين",
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
                pages[_tab >= pages.length ? 0 : _tab],
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    backgroundColor: widget.activeColor,
                    onPressed: _showGift,
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
                CircleAvatar(radius: 30, backgroundColor: widget.activeColor, child: const Icon(Icons.person, color: Colors.black, size: 36)),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(currentRole, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text("$userCoins 🪙", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          _drawerTile(Icons.home, "الرئيسية", 0),
          _drawerTile(Icons.storefront, "المتجر", 1),
          _drawerTile(Icons.emoji_events, "المهمات والإنجازات", 2),
          _drawerTile(Icons.person, "الملف الشخصي", 3),
          _drawerTile(Icons.security, "لوحة الإدارة والمشرفين 🛡️", 4),
          if (isOwner) _drawerTile(Icons.build, "غرفة المالك BENZO 👑", 5),
          _drawerTile(Icons.volunteer_activism, "ادعمنا واحصل على نقاط ❤️", 6, isRed: true),
          const Divider(color: Colors.white12),
          const Padding(padding: EdgeInsets.all(14), child: Text("المظهر الحي:", style: TextStyle(color: Colors.white60))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _colorCircle(const Color(0xFFFF5722)),
              _colorCircle(Colors.amber),
              _colorCircle(Colors.purpleAccent),
              _colorCircle(Colors.tealAccent),
              _colorCircle(Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, int idx, {bool isRed = false}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.redAccent : Colors.white70),
      title: Text(title, style: TextStyle(color: isRed ? Colors.redAccent : Colors.white, fontWeight: isRed ? FontWeight.bold : FontWeight.normal)),
      onTap: () {
        setState(() => _tab = idx);
        Navigator.pop(context);
      },
    );
  }

  Widget _colorCircle(Color c) {
    return GestureDetector(
      onTap: () {
        widget.onThemeChange(c);
        Navigator.pop(context);
      },
      child: CircleAvatar(radius: 14, backgroundColor: c),
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
          child: const Text("MANGA ARAB\nوجهتك الأولى للمانجا المترجمة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        const SizedBox(height: 16),
        const Text("الأعمال الحصرية (سوات - تيم إكس - مانجاليك) 🔥", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _mangaCard("The Divine Ring Descends", "الفصل 100", "9.0 ⭐"),
        _mangaCard("I Reincarnated As the Crazed Heir", "الفصل 85", "8.8 ⭐"),
        _mangaCard("Skills have no cooldown", "الفصل 42", "8.2 ⭐"),
      ],
    );
  }

  Widget _mangaCard(String title, String chapter, String rating) {
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
            Navigator.push(context, MaterialPageRoute(builder: (c) => MangaReaderView(title: title)));
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
            const Text("متجر الإطارات 🛒", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("$userCoins 🪙", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        ...frames.map((f) => Card(
          color: const Color(0xFF141422),
          child: ListTile(
            leading: Icon(f['icon'], color: f['color'], size: 36),
            title: Text(f['name']),
            subtitle: Text("${f['price']} نقطة", style: const TextStyle(color: Colors.amber)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: widget.activeColor),
              onPressed: () {
                setState(() => equippedFrame = f['name']);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم تجهيز إطار ${f['name']} بنجاح!")));
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
        _missionTile("قراءة 3 فصول يومية", "2 / 3", "+6 نقاط"),
        _missionTile("جلسة قراءة 8 فصول", "7 / 8", "+8 نقاط"),
        _missionTile("تسجيل الدخول اليومي", "1 / 1", "+5 نقاط (مكتمل)"),
      ],
    );
  }

  Widget _missionTile(String title, String progress, String reward) {
    return Card(
      color: const Color(0xFF141422),
      child: ListTile(
        title: Text(title),
        subtitle: Text(progress),
        trailing: Text(reward, style: TextStyle(color: widget.activeColor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildProfile() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(radius: 40, backgroundColor: widget.activeColor, child: const Icon(Icons.person, size: 48, color: Colors.black)),
              const SizedBox(height: 8),
              Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(currentRole, style: const TextStyle(color: Colors.amber, fontSize: 12)),
              Text("الإطار النشط: $equippedFrame", style: const TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.people, color: Colors.cyanAccent),
                label: const Text("المتابعون والرتب"),
                onPressed: _showFollowers,
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

  // لوحة الإدارة والمشرفين (Admin Dashboard)
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
                onPressed: _showBanDialog,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                icon: const Icon(Icons.timer, color: Colors.black),
                label: const Text("تايم أوت", style: TextStyle(color: Colors.black)),
                onPressed: _showTimeoutDialog,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text("شات الإدارة السري 💬", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
        const SizedBox(height: 8),
        Container(
          height: 140,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF141422), borderRadius: BorderRadius.circular(10)),
          child: ListView.builder(
            itemCount: adminChatMessages.length,
            itemBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(adminChatMessages[i], style: const TextStyle(fontSize: 12, color: Colors.white70)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text("إعلانات الإدارة العامة 📢", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
        const SizedBox(height: 8),
        ...adminAnnouncements.map((a) => Card(
          color: const Color(0xFF141424),
          child: Padding(padding: const EdgeInsets.all(10), child: Text(a, style: const TextStyle(fontSize: 12, color: Colors.white))),
        )).toList(),
      ],
    );
  }

  // غرفة المالك والفاوندر الخارقة (Owner Super Room)
  Widget _buildOwnerRoom() {
    final nameCtrl = TextEditingController(text: username);
    final broadcastCtrl = TextEditingController();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("غرفة عمليات المالك والفاوندر BENZO 👑", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
        const SizedBox(height: 12),
        SwitchListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("درع مكافحة الاختراق (Anti-Hack)"),
          value: antiHackShield,
          onChanged: (v) {
            setState(() => antiHackShield = v);
            _addLog("تم ${v ? 'تفعيل' : 'تعطيل'} درع مكافحة الاختراق");
          },
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("مضاعفة النقاط (دبل نقاط)"),
          value: doublePoints,
          onChanged: (v) => setState(() => doublePoints = v),
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("شحن 50,000 نقطة لمحفظتك"),
          trailing: const Icon(Icons.add_circle, color: Colors.greenAccent),
          onTap: () {
            setState(() => userCoins += 50000);
            _addLog("تم شحن 50,000 نقطة لمحفظة المالك");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم شحن 50,000 نقطة بنجاح 🪙")));
          },
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("إنشاء ونشر باقة جديدة للمتجر 💎"),
          trailing: const Icon(Icons.add, color: Colors.amber),
          onTap: _showCreatePackageDialog,
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: const Color(0xFF141424),
          title: const Text("إرسال إشعار فوري لجميع المستخدمين 📢"),
          trailing: const Icon(Icons.campaign, color: Colors.redAccent),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF1A1A2E),
                title: const Text("اكتب الإشعار:"),
                content: TextField(controller: broadcastCtrl, decoration: const InputDecoration(hintText: "نص الإشعار...")),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (broadcastCtrl.text.isNotEmpty) {
                        setState(() => activeBroadcast = broadcastCtrl.text);
                        _addLog("إرسال إشعار عام: ${broadcastCtrl.text}");
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text("إرسال للجميع"),
                  )
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        const Text("سجل العمليات والرقابة (Audit Logs):", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
        const SizedBox(height: 8),
        Container(
          height: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF0A0A12), b
