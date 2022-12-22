import 'package:auto_animated/auto_animated.dart';
import 'package:calcupiano/design/animated.dart';
import 'package:calcupiano/design/dialog.dart';

import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/events.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/ui/actions.dart';
import 'package:calcupiano/ui/soundpack_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:rettulf/rettulf.dart';

import '../db.dart';

const double _iconSize = 36;

class SoundpackPage extends StatefulWidget {
  const SoundpackPage({super.key});

  @override
  State<SoundpackPage> createState() => _SoundpackPageState();
}

class _SoundpackPageState extends State<SoundpackPage> with LockOrientationMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: "Soundpack".text(),
        centerTitle: context.isCupertino,
        actions: [
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                icon: Icons.create,
                title: 'Create a soundpack',
                onTap: () {},
              ),
              const PullDownMenuDivider(),
              PullDownMenuTitle(
                title: "Import Soundpack".text(),
              ),
              PullDownMenuActionsRow.medium(
                items: [
                  PullDownMenuItem(
                    enabled: false,
                    onTap: () {},
                    title: 'Link',
                    icon: Icons.link,
                  ),
                  if (!kIsWeb)
                    PullDownMenuItem(
                      onTap: () async {
                        await importSoundpackFromFilePicker();
                      },
                      title: 'Local File',
                      icon: Icons.storage,
                    )
                ],
              )
            ],
            position: PullDownMenuPosition.automatic,
            buttonBuilder: (context, showMenu) => IconButton(
              onPressed: showMenu,
              icon: const Icon(
                CupertinoIcons.ellipsis_circle,
                size: 28,
              ),
            ),
          )
        ],
      ),
      body: buildBody(),
    );
  }

  Future<void> importSoundpackFromFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      withData: true,
    );
    final path = result?.files.single.path;
    if (path != null) {
      if (!mounted) return;
      await context.showWaiting(until: importSoundpackFromFile(path), title: "Processing");
    }
  }

  @ListenTo([K.customSoundpackIdList])
  Widget buildBody() {
    return H.listenToCustomSoundpackIdList() <<
        (ctx, _, c) {
          return buildSoundpackList(ctx);
        };
  }

  @ListenTo([K.customSoundpackIdList])
  Widget buildSoundpackList(BuildContext ctx) {
    const builtinList = R.builtinSoundpacks;
    final customList = H.customSoundpackIdList ?? const [];
    return ListView.separated(
      itemCount: builtinList.length + customList.length,
      physics: const RangeMaintainingScrollPhysics(),
      itemBuilder: (ctx, index) {
        final Widget res;
        if (index < builtinList.length) {
          res = BuiltinSoundpackItem(
            soundpack: builtinList[index],
          );
        } else {
          res = CustomSoundpackItem(id: customList[index - builtinList.length]);
        }
        return res;
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(thickness: 1);
      },
    );
  }
}

class BuiltinSoundpackItem extends StatefulWidget {
  final BuiltinSoundpack soundpack;

  const BuiltinSoundpackItem({
    super.key,
    required this.soundpack,
  });

  @override
  State<BuiltinSoundpackItem> createState() => _BuiltinSoundpackItemState();
}

class _BuiltinSoundpackItemState extends State<BuiltinSoundpackItem> {
  BuiltinSoundpack get soundpack => widget.soundpack;

  @override
  Widget build(BuildContext context) {
    return H.listenToCurrentSoundpackID() << (ctx, _, __) => buildCard(context);
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildCard(
    BuildContext ctx,
  ) {
    final isSelected = H.currentSoundpackID == soundpack.id;
    return ListTile(
      leading: _buildSoundpackSwitchIcon(isSelected, soundpack),
      selected: isSelected,
      onTap: () {
        eventBus.fire(SoundpackChangeEvent(soundpack));
      },
      title: soundpack.name.text(style: ctx.textTheme.headlineSmall),
      subtitle: soundpack.description.text(),
      trailing: _moreMenu(ctx, soundpack),
    );
  }
}

class CustomSoundpackItem extends StatefulWidget {
  final String id;

  const CustomSoundpackItem({
    super.key,
    required this.id,
  });

  @override
  State<CustomSoundpackItem> createState() => _CustomSoundpackItemState();
}

class _CustomSoundpackItemState extends State<CustomSoundpackItem> {
  /// Cache the Soundpack object, because deserialization is expensive.
  ExternalSoundpackProtocol? _soundpack;

  @override
  void initState() {
    super.initState();
    _soundpack = H.soundpacks.getSoundpackById(widget.id);
  }

  @override
  void didUpdateWidget(covariant CustomSoundpackItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update current Soundpack object, perhaps due to a deletion.
    _soundpack = H.soundpacks.getSoundpackById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final soundpack = _soundpack;
    if (soundpack != null) {
      return H.listenToCurrentSoundpackID() << (ctx, _, __) => buildCard(context, soundpack);
    } else {
      return buildCorruptedSoundpack(context);
    }
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildCard(BuildContext ctx, ExternalSoundpackProtocol soundpack) {
    final isSelected = H.currentSoundpackID == soundpack.id;
    if (soundpack is LocalSoundpack) {
      return buildLocalSoundpackCard(ctx, isSelected, soundpack);
    } else if (soundpack is UrlSoundpack) {
      return buildUrlSoundpackCard(ctx, isSelected, soundpack);
    } else {
      return const SizedBox();
    }
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildLocalSoundpackCard(BuildContext ctx, bool isSelected, LocalSoundpack soundpack) {
    return ListTile(
      leading: _buildSoundpackSwitchIcon(isSelected, soundpack),
      onTap: () {
        eventBus.fire(SoundpackChangeEvent(soundpack));
      },
      selected: isSelected,
      title: (soundpack.meta.name ?? "No Name").text(style: ctx.textTheme.headlineSmall),
      subtitle: (soundpack.meta.description ?? "No Info").text(),
      trailing: _moreMenu(ctx, soundpack),
    );
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildUrlSoundpackCard(BuildContext ctx, bool isSelected, UrlSoundpack soundpack) {
    return ListTile(
      leading: _buildSoundpackSwitchIcon(isSelected, soundpack),
      selected: isSelected,
      onTap: () {
        eventBus.fire(SoundpackChangeEvent(soundpack));
      },
      title: (soundpack.meta.name ?? "No Name").text(style: ctx.textTheme.headlineSmall),
      subtitle: (soundpack.meta.description ?? "No Info").text(),
      trailing: _moreMenu(ctx, soundpack),
    );
  }

  Widget buildCorruptedSoundpack(BuildContext ctx) {
    return ListTile(
      leading: Icon(Icons.sentiment_very_dissatisfied_outlined, size: _iconSize),
      title: "A Corrupted Soundpack".text(),
      subtitle: "Sorry, please delete this".text(),
      trailing: Icon(Icons.delete_outline, color: ctx.$red$, size: _iconSize).onTap(() async {
        await H.soundpacks.removeSoundpackById(widget.id);
      }),
    );
  }
}

Widget _buildSoundpackSwitchIcon(bool isSelected, SoundpackProtocol soundpack) {
  if (isSelected) {
    return const Icon(Icons.done, size: _iconSize);
  } else {
    return const SizedBox.square(dimension: _iconSize);
  }
}

Widget _moreMenu(
  BuildContext ctx,
  SoundpackProtocol soundpack,
) {
  final btn = PopupMenuButton(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
    position: PopupMenuPosition.under,
    padding: EdgeInsets.zero,
    itemBuilder: (BuildContext context) => [
      if (soundpack is! BuiltinSoundpack)
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.edit),
            title: "Edit".text(),
            onTap: () {
              ctx.navigator.pop();
              if (soundpack is LocalSoundpack) {
                ctx.navigator.push(MaterialPageRoute(builder: (_) => LocalSoundpackEditor(soundpack)));
              } else if (soundpack is UrlSoundpack) {
                ctx.navigator.push(MaterialPageRoute(builder: (_) => UrlSoundpackEditor(soundpack)));
              }
            },
          ),
        ),
      PopupMenuItem(
        child: ListTile(
          leading: Icon(Icons.copy_outlined),
          title: "Duplicate".text(),
          onTap: () {
            ctx.navigator.pop();
            duplicateSoundpack(soundpack);
          },
        ),
      ),
      if (soundpack is! BuiltinSoundpack)
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete_outline, color: ctx.$red$),
            title: "Delete".text(style: TextStyle(color: ctx.$red$)),
            onTap: () async {
              ctx.navigator.pop();
              await Future.delayed(const Duration(milliseconds: 500));
              await H.soundpacks.removeSoundpackById(soundpack.id);
            },
          ),
        ),
    ],
    child: const Icon(Icons.more_horiz_rounded, size: _iconSize),
  );
  return btn;
}
