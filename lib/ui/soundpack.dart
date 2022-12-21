import 'package:calcupiano/design/dialog.dart';

import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/events.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/ui/actions.dart';
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
                title: 'Create Soundpack',
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
    return ListView.builder(
      itemCount: builtinList.length + customList.length,
      physics: const RangeMaintainingScrollPhysics(),
      itemBuilder: (ctx, index) {
        if (index < builtinList.length) {
          return BuiltinSoundpackItem(
            soundpack: builtinList[index],
          );
        } else {
          return CustomSoundpackItem(id: customList[index - builtinList.length]);
        }
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
    return buildCardWithContextMenu(context);
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildCardWithContextMenu(BuildContext ctx) {
    return H.listenToCurrentSoundpackID() <<
        (ctx, _, __) {
          final isSelected = H.currentSoundpackID == soundpack.id;
          return CupertinoContextMenu.builder(
              actions: [
                if (!isSelected)
                  CupertinoContextMenuAction(
                    trailingIcon: CupertinoIcons.checkmark,
                    child: "Use".text(),
                    onPressed: () {
                      ctx.navigator.pop();
                      eventBus.fire(SoundpackChangeEvent(soundpack));
                    },
                  ),
                CupertinoContextMenuAction(
                  trailingIcon: CupertinoIcons.ear,
                  child: "Preview".text(),
                ),
              ],
              builder: (ctx, anim) {
                return buildCard(ctx, isSelected);
              });
        };
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildCard(BuildContext ctx, bool isSelected) {
    return ListTile(
      leading: _buildSoundpackSwitchIcon(isSelected, soundpack),
      selected: isSelected,
      titleTextStyle: ctx.textTheme.headlineSmall,
      title: soundpack.name.text(),
      subtitle: soundpack.description.text(),
      trailing: Icon(Icons.navigate_next_rounded),
    ).inCard();
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
      return buildCardWithContextMenu(context, soundpack);
    } else {
      return buildCorruptedSoundpackWithContextMenu(context);
    }
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildCardWithContextMenu(BuildContext ctx, ExternalSoundpackProtocol soundpack) {
    return H.listenToCurrentSoundpackID() <<
        (ctx, _, __) {
          final isSelected = H.currentSoundpackID == soundpack.id;
          return CupertinoContextMenu.builder(
              actions: [
                if (!isSelected)
                  CupertinoContextMenuAction(
                    trailingIcon: CupertinoIcons.checkmark,
                    child: "Use".text(),
                    onPressed: () {
                      ctx.navigator.pop();
                      eventBus.fire(SoundpackChangeEvent(soundpack));
                    },
                  ),
                CupertinoContextMenuAction(
                  trailingIcon: CupertinoIcons.pencil,
                  child: "Edit".text(),
                ),
                CupertinoContextMenuAction(
                  trailingIcon: CupertinoIcons.ear,
                  child: "Preview".text(),
                ),
                CupertinoContextMenuAction(
                  trailingIcon: CupertinoIcons.delete,
                  isDestructiveAction: true,
                  child: "Delete".text(),
                  onPressed: () async {
                    if (!mounted) return;
                    context.navigator.pop();
                    await Future.delayed(const Duration(milliseconds: 500));
                    await H.soundpacks.removeSoundpackById(soundpack.id);
                  },
                ),
              ],
              builder: (ctx, anim) {
                return buildCard(ctx, isSelected, soundpack);
              });
        };
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildCard(BuildContext ctx, bool isSelected, ExternalSoundpackProtocol soundpack) {
    if (soundpack is LocalSoundpack) {
      return buildLocalSoundpackCard(ctx, isSelected, soundpack);
    } else if (soundpack is UrlSoundpack) {
      return buildUrlSoundpackCard(ctx, isSelected, soundpack);
    } else {
      return buildNeverSoundpackCard(ctx);
    }
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildLocalSoundpackCard(BuildContext ctx, bool isSelected, LocalSoundpack soundpack) {
    return ListTile(
      leading: _buildSoundpackSwitchIcon(isSelected, soundpack),
      selected: isSelected,
      titleTextStyle: ctx.textTheme.headlineSmall,
      title: (soundpack.meta.name ?? "No Name").text(),
      subtitle: (soundpack.meta.description ?? "No Info").text(),
      trailing: Icon(Icons.navigate_next_rounded),
    ).inCard();
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildUrlSoundpackCard(BuildContext ctx, bool isSelected, UrlSoundpack soundpack) {
    return ListTile(
      leading: _buildSoundpackSwitchIcon(isSelected, soundpack),
      selected: isSelected,
      titleTextStyle: ctx.textTheme.headlineSmall,
      title: (soundpack.meta.name ?? "No Name").text(),
      subtitle: (soundpack.meta.description ?? "No Info").text(),
      trailing: Icon(Icons.navigate_next_rounded),
    ).inCard();
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildNeverSoundpackCard(BuildContext ctx) {
    return ListTile(
      leading: Icon(Icons.question_mark_rounded, size: _iconSize),
      titleTextStyle: ctx.textTheme.headlineSmall,
      title: "What is thi?".text(),
      subtitle: "Why can you find this?".text(),
      trailing: Icon(Icons.navigate_next_rounded),
    ).inCard();
  }

  Widget buildCorruptedSoundpackWithContextMenu(BuildContext ctx) {
    return CupertinoContextMenu.builder(
        actions: [
          CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.delete,
            isDestructiveAction: true,
            child: "Delete".text(),
            onPressed: () async {
              if (!mounted) return;
              context.navigator.pop();
              await Future.delayed(const Duration(milliseconds: 500));
              await H.soundpacks.removeSoundpackById(widget.id);
            },
          ),
        ],
        builder: (ctx, anim) {
          return buildCorruptedSoundpack(ctx);
        });
  }

  Widget buildCorruptedSoundpack(BuildContext ctx) {
    return ListTile(
      leading: Icon(Icons.sentiment_very_dissatisfied_outlined, size: _iconSize),
      title: "A Corrupted Soundpack".text(),
      subtitle: "Sorry, please long press to delete".text(),
    ).inCard();
  }
}

Widget _buildSoundpackSwitchIcon(bool isSelected, SoundpackProtocol soundpack) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 500),
    switchInCurve: Curves.fastLinearToSlowEaseIn,
    child: isSelected
        ? const Icon(Icons.done, size: _iconSize)
        : const Icon(
            Icons.radio_button_off_rounded,
            size: _iconSize,
          ).onTap(() {
            eventBus.fire(SoundpackChangeEvent(soundpack));
          }),
  );
}
