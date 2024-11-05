import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
      ),
      title: 'Vedic ReadMore Demo',
      home: const DemoApp(),
    );
  }
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  final isCollapsed = ValueNotifier<bool>(false);

  // For mentions feature
  final userMap = {
    123: 'Sage',
    456: 'Rishi',
  };

  var _trimMode = TrimMode.Line;
  int _trimLines = 3;
  int _trimLength = 240;

  void _incrementTrimLines() => setState(() => _trimLines++);
  void _decrementTrimLines() => setState(() => _trimLines = _trimLines > 1 ? _trimLines - 1 : 1);
  void _incrementTrimLength() => setState(() => _trimLength++);
  void _decrementTrimLength() => setState(() => _trimLength = _trimLength > 1 ? _trimLength - 1 : 1);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vedic Texts ReadMore'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettings(),
            const SizedBox(height: 20),

            // First ReadMore section
            ReadMoreText(
              'The Vedas are the oldest sacred texts of Hinduism, composed in Vedic Sanskrit. They contain spiritual knowledge, philosophical teachings, and ritual practices. The four Vedas are Rigveda, Yajurveda, Samaveda, and Atharvaveda.',
              trimMode: _trimMode,
              trimLines: _trimLines,
              trimLength: _trimLength,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              colorClickableText: const Color(0xFF02BB9F),
              trimCollapsedText: '... Read More',
              trimExpandedText: ' Show Less',
            ),

            const Divider(color: Color(0xFF167F67), height: 30),

            // Second ReadMore section with annotations
            ReadMoreText(
              'The ancient sages <@123> and <@456> composed these texts. Visit https://vedas.org to learn more about #VedicKnowledge and #AncientWisdom.',
              trimMode: _trimMode,
              trimLines: _trimLines,
              trimLength: _trimLength,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              colorClickableText: const Color(0xFF02BB9F),
              trimCollapsedText: '... Expand',
              trimExpandedText: ' Collapse',
              delimiter: ' ',
              delimiterStyle: const TextStyle(color: Colors.black87),
              moreStyle: const TextStyle(color: Color(0xFF02BB9F), fontWeight: FontWeight.bold),
              lessStyle: const TextStyle(color: Color(0xFF02BB9F), fontWeight: FontWeight.bold),
            ),

            const Divider(color: Color(0xFF167F67), height: 30),

            // Third ReadMore section with clickable spans
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                children: [
                  const TextSpan(
                    text: 'The Upanishads are philosophical texts. ',
                  ),
                  TextSpan(
                    text: '@Sage',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showMessage('Clicked on Sage'),
                  ),
                  const TextSpan(
                    text: ' and ',
                  ),
                  TextSpan(
                    text: '@Rishi',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showMessage('Clicked on Rishi'),
                  ),
                  const TextSpan(
                    text: ' explore concepts like Brahman (ultimate reality), Atman (soul), karma (action), and dharma (duty).',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Collapse control button
            ValueListenableBuilder(
              valueListenable: isCollapsed,
              builder: (context, value, child) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () => isCollapsed.value = !isCollapsed.value,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text('Toggle Collapse: ${value ? "Collapsed" : "Expanded"}'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('TrimMode Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SegmentedButton<TrimMode>(
          segments: const [
            ButtonSegment<TrimMode>(
              value: TrimMode.Length,
              label: Text('Length'),
            ),
            ButtonSegment<TrimMode>(
              value: TrimMode.Line,
              label: Text('Line'),
            ),
          ],
          selected: <TrimMode>{_trimMode},
          onSelectionChanged: (Set<TrimMode> newSelection) {
            setState(() {
              _trimMode = newSelection.first;
            });
          },
        ),
        const SizedBox(height: 10),
        if (_trimMode == TrimMode.Length)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrementTrimLength,
              ),
              Text('Length: $_trimLength'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _incrementTrimLength,
              ),
            ],
          ),
        if (_trimMode == TrimMode.Line)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrementTrimLines,
              ),
              Text('Lines: $_trimLines'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _incrementTrimLines,
              ),
            ],
          ),
      ],
    );
  }

  @override
  void dispose() {
    isCollapsed.dispose();
    super.dispose();
  }
}