import 'package:flutter/material.dart';

void main() => runApp(const AiletiApp());

class AiletiApp extends StatelessWidget {
  const AiletiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'عائلتنا',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B5E9B)),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('❤️ عائلتنا', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 30),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 10),
            const Text('أهلاً بعائلتنا ❤️', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('كل العائلة في مكان واحد', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 28),
            _bigButton(context, Icons.chat_bubble_rounded, 'المحادثة', const ChatPage()),
            const SizedBox(height: 16),
            _bigButton(context, Icons.photo_library_rounded, 'الذكريات', const MemoriesPage()),
            const SizedBox(height: 16),
            _bigButton(context, Icons.call_rounded, 'اتصال بالعائلة', const CallPage()),
            const SizedBox(height: 26),
            Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: const [
                    Text('أفراد العائلة', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    ListTile(
                      leading: CircleAvatar(radius: 27, child: Icon(Icons.person, size: 30)),
                      title: Text('أمي', style: TextStyle(fontSize: 20)),
                      subtitle: Text('متاحة الآن', style: TextStyle(fontSize: 16)),
                    ),
                    ListTile(
                      leading: CircleAvatar(radius: 27, child: Icon(Icons.person, size: 30)),
                      title: Text('أبي', style: TextStyle(fontSize: 20)),
                      subtitle: Text('متاح الآن', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bigButton(BuildContext context, IconData icon, String title, Widget page) {
    return SizedBox(
      height: 82,
      child: FilledButton.icon(
        icon: Icon(icon, size: 34),
        label: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  final messages = <String>['السلام عليكم ❤️', 'وعليكم السلام، كيف حالك؟'];
  bool recording = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المحادثة', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(icon: const Icon(Icons.call, size: 30),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CallPage()))),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (_, i) => Align(
                  alignment: i.isEven ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                    decoration: BoxDecoration(
                      color: i.isEven ? const Color(0xFFE9DDF2) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(messages[i], style: const TextStyle(fontSize: 19)),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(fontSize: 19),
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالة...',
                          hintStyle: const TextStyle(fontSize: 18),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onLongPressStart: (_) => setState(() => recording = true),
                      onLongPressEnd: (_) {
                        setState(() => recording = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم حفظ نموذج رسالة صوتية — ربط التسجيل الحقيقي يحتاج Firebase/Storage.')),
                        );
                      },
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('وضع الفيديو الدائري — جاهز للربط بالكاميرا.')),
                      ),
                      child: CircleAvatar(
                        radius: 29,
                        backgroundColor: recording ? Colors.red : const Color(0xFF7B5E9B),
                        child: Icon(recording ? Icons.mic : Icons.mic_none, color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      icon: const Icon(Icons.send, size: 28),
                      onPressed: () {
                        final t = controller.text.trim();
                        if (t.isNotEmpty) {
                          setState(() => messages.add(t));
                          controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CallPage extends StatefulWidget {
  const CallPage({super.key});
  @override State<CallPage> createState() => _CallPageState();
}
class _CallPageState extends State<CallPage> {
  int seconds = 5;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    for (int i = 5; i >= 0; i--) {
      if (!mounted || connected) return;
      setState(() => seconds = i);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (mounted && !connected) setState(() => connected = true);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(connected ? 'متصل' : 'مكالمة واردة')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: connected ? _connected() : _incoming(),
          ),
        ),
      ),
    );
  }

  Widget _incoming() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const CircleAvatar(radius: 65, child: Icon(Icons.person, size: 70)),
      const SizedBox(height: 25),
      const Text('أمي تتصل بك', style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold)),
      const SizedBox(height: 18),
      Text('$seconds', style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
      const Text('سيتم الرد تلقائياً', style: TextStyle(fontSize: 20)),
      const SizedBox(height: 30),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(140, 60)),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.call_end), label: const Text('رفض', style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(width: 18),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size(140, 60)),
          onPressed: () => setState(() { connected = true; seconds = 0; }),
          icon: const Icon(Icons.call), label: const Text('رد الآن', style: TextStyle(fontSize: 20)),
        ),
      ])
    ],
  );

  Widget _connected() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const CircleAvatar(radius: 70, child: Icon(Icons.person, size: 75)),
      const SizedBox(height: 22),
      const Text('أمي', style: TextStyle(fontSize: 31, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      const Icon(Icons.volume_up_rounded, size: 54),
      const Text('مكبر الصوت', style: TextStyle(fontSize: 20)),
      const SizedBox(height: 35),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(minimumSize: const Size(250, 62)),
        icon: const Icon(Icons.videocam, size: 30),
        label: const Text('فتح الكاميرا', style: TextStyle(fontSize: 21)),
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الكاميرا تحتاج ربطاً حقيقياً بالمكالمة.')),
        ),
      ),
      const SizedBox(height: 20),
      FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: Colors.red, minimumSize: const Size(250, 62)),
        icon: const Icon(Icons.call_end, size: 30),
        label: const Text('إنهاء المكالمة', style: TextStyle(fontSize: 21)),
        onPressed: () => Navigator.pop(context),
      )
    ],
  );
}

class MemoriesPage extends StatelessWidget {
  const MemoriesPage({super.key});
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('❤️ الذكريات', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold))),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: 8,
        itemBuilder: (_, i) => Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            color: Colors.primaries[i % Colors.primaries.length].withOpacity(.12),
            child: Center(child: Icon(i % 3 == 0 ? Icons.videocam : Icons.photo, size: 55)),
          ),
        ),
      ),
    ),
  );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  bool autoAnswer = true;
  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: SwitchListTile(
            value: autoAnswer,
            onChanged: (v) => setState(() => autoAnswer = v),
            title: const Text('الرد التلقائي', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            subtitle: const Text('الرد بعد 5 ثوانٍ على المكالمات المسموحة', style: TextStyle(fontSize: 16)),
          )),
          const SizedBox(height: 12),
          const Card(child: ListTile(
            leading: Icon(Icons.lock_outline, size: 32),
            title: Text('العائلة خاصة', style: TextStyle(fontSize: 20)),
            subtitle: Text('الوصول محصور بأفراد العائلة', style: TextStyle(fontSize: 16)),
          ))
        ],
      ),
    ),
  );
}
