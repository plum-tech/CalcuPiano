import 'package:calcupiano/r.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rettulf/rettulf.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'about.i18n.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? content;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString("assets/about.md").then((value) {
      setState(() {
        content = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "About".text(),
      ),
      body: buildMain(context),
    );
  }

  Widget buildMain(BuildContext ctx) {
    final data = content;
    if (data == null) {
      return "TAT".text();
    } else {
      return Markdown(
        selectable: true,
        data: data,
        physics: const RangeMaintainingScrollPhysics(),
        onTapLink: (text, href, title) {
          if (href != null) {
            launchUrlString(href, mode: LaunchMode.externalApplication);
          }
        },
      );
    }
  }
}
