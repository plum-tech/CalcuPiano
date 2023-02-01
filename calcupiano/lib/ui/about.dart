import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rettulf/rettulf.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'about.i18n.dart';

/// Change this url if you want to make a custom build.
const githubReadmeRawUrl = "https://github.com/liplum/CalcuPiano";

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
        title: I18n.title.text(),
        actions: [
          IconButton(
              onPressed: () {
                context.navigator.push(MaterialPageRoute(builder: (_) {
                  final packageInfo = R.packageInfo;
                  final version = packageInfo != null ? "v${packageInfo.version}" : "v${R.version}";
                  return LicensePage(
                    applicationName: R.appName,
                    applicationVersion: version,
                  );
                }));
              },
              icon: const Icon(Icons.policy_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await launchUrlString(githubReadmeRawUrl, mode: LaunchMode.externalApplication);
        },
        label: "GITHUB".text(), // Hardcoded
        icon: const Icon(UniconsLine.github),
      ),
      floatingActionButtonLocation: context.isPortrait ? null : FloatingActionButtonLocation.endTop,
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
        onTapLink: (text, href, title) async {
          if (href != null) {
            await launchUrlString(href, mode: LaunchMode.externalApplication);
          }
        },
      );
    }
  }
}
