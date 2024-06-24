import 'package:calcupiano/design/adaptive.dart';
import 'package:calcupiano/design/multiplatform.dart';

import 'package:calcupiano/events.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:calcupiano/service/soundpack.dart';
import 'package:calcupiano/stage_manager.dart';
import 'package:calcupiano/ui/soundpack_composer.dart';
import 'package:calcupiano/ui/soundpack_editor.dart';
import 'package:calcupiano/ui/soundpack_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:rettulf/rettulf.dart';
import 'package:calcupiano/i18n.dart';

part 'soundpack.i18n.dart';

const double _iconSize = 36;

class SoundpackPage extends StatefulWidget {
  const SoundpackPage({super.key});

  @override
  State<SoundpackPage> createState() => _SoundpackPageState();
}

class _SoundpackPageState extends State<SoundpackPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await StageManager.closeSoundpackPreview(ctx: context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: I18n.title.text(),
          centerTitle: context.isCupertino,
          actions: [
            PullDownButton(
              itemBuilder: (context) => [
                PullDownMenuItem(
                  icon: Icons.create,
                  title: I18n.createSoundpack,
                  onTap: () {},
                ),
                const PullDownMenuDivider(),
                PullDownMenuTitle(
                  title: I18n.importSoundpack.text(),
                ),
                PullDownMenuActionsRow.medium(
                  items: [
                    PullDownMenuItem(
                      enabled: false,
                      onTap: () {},
                      title: I18n.link,
                      icon: Icons.link,
                    ),
                    if (!kIsWeb)
                      PullDownMenuItem(
                        onTap: () async {
                          await Packager.pickAndImportSoundpackArchive();
                        },
                        title: I18n.localFile,
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
      ),
    );
  }

  @ListenTo([K.externalSoundpackIdList])
  Widget buildBody() {
    return H.listenToCustomSoundpackIdList() >>
        (ctx, _) {
          final allSoundpacks = R.id2BuiltinSoundpacks.keys.toList() + (H.externalSoundpackIdList ?? const []);
          return AdaptiveBuilder(
            defaultBuilder: (ctx, screen) {
              return buildSoundpackList(ctx, allSoundpacks, 300);
            },
            layoutDelegate: AdaptiveLayoutDelegateWithScreenType(
              watchPortrait: (ctx, screen) {
                return buildSoundpackList(ctx, allSoundpacks, 300);
              },
              watchLandscape: (ctx, screen) {
                return buildSoundpackList(ctx, allSoundpacks, 300);
              },
              headsetPortrait: (ctx, screen) {
                return buildSoundpackList(ctx, allSoundpacks, 300);
              },
              headsetLandscape: (ctx, screen) {
                return buildSoundpackList(ctx, allSoundpacks, 200);
              },
              tabletPortrait: (ctx, screen) {
                return buildSoundpackList(ctx, allSoundpacks, 400);
              },
              tabletLandscape: (ctx, screen) {
                return buildSoundpackList(ctx, allSoundpacks, 300);
              },
            ),
          );
        };
  }

  @ListenTo([K.externalSoundpackIdList])
  Widget buildSoundpackList(BuildContext ctx, List<String> allSoundpacks, double extent) {
    return MasonryGridView.extent(
      maxCrossAxisExtent: extent,
      itemCount: allSoundpacks.length,
      physics: const RangeMaintainingScrollPhysics(),
      itemBuilder: (ctx, index) {
        return SoundpackItem(id: allSoundpacks[index]);
      },
    );
  }
}

class SoundpackItem extends StatefulWidget {
  final String id;

  const SoundpackItem({
    super.key,
    required this.id,
  });

  @override
  State<SoundpackItem> createState() => _SoundpackItemState();
}

class _SoundpackItemState extends State<SoundpackItem> with TickerProviderStateMixin {
  /// Cache the Soundpack object, because deserialization is expensive.
  SoundpackProtocol? _soundpack;
  var isPlaying = false;
  late final AnimationController ctrl;

  @override
  void initState() {
    super.initState();
    _soundpack = SoundpackService.findById(widget.id);
    ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(covariant SoundpackItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update current Soundpack object, perhaps due to a deletion.
    _soundpack = SoundpackService.findById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return H.listenToCurrentSoundpackID() >>
        (ctx, _) {
          final soundpack = _soundpack;
          if (soundpack != null) {
            return buildCard(context, soundpack);
          } else {
            return buildCorruptedSoundpack(context);
          }
        };
  }

  @ListenTo([K.currentSoundpackID])
  Widget buildCard(
    BuildContext ctx,
    SoundpackProtocol soundpack,
  ) {
    final isSelected = H.currentSoundpackID == soundpack.id;
    return InkWell(
      onTap: () async {
        if (H.currentSoundpackID != soundpack.id) {
          eventBus.fire(SoundpackChangeEvent(soundpack));
          await Player.preloadSoundpack(soundpack);
        }
      },
      child: [
        [
          AnimatedOpacity(
            opacity: isSelected ? 1.0 : 0.15,
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastLinearToSlowEaseIn,
            child: soundpack.preview
                ?.build(
                  ctx,
                  fit: BoxFit.fill,
                )
                .container(w: double.infinity),
          ),
        ].stack(),
        ListTile(
          selected: isSelected,
          title: soundpack.displayName.text(style: ctx.textTheme.titleLarge),
          subtitle: [
            soundpack.author.text(style: ctx.textTheme.bodyLarge),
            soundpack.description.text(
              style: ctx.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ].column(caa: CrossAxisAlignment.start),
        ),
        ButtonBar(
          children: [
            IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: CurveTween(curve: Curves.easeIn).animate(ctrl),
              ),
              onPressed: () {
                setState(() {
                  isPlaying = !isPlaying;
                });
                if (isPlaying) {
                  ctrl.forward();
                } else {
                  ctrl.reverse();
                }
              },
            ),
            moreMenu(ctx, soundpack).align(at: Alignment.topRight),
          ],
        ),
      ].column(),
    ).inCard(
      elevation: isSelected ? 15 : 2,
      clip: Clip.hardEdge,
    );
  }

  Widget buildCorruptedSoundpack(BuildContext ctx) {
    return ListTile(
      leading: const Icon(Icons.sentiment_very_dissatisfied_outlined, size: _iconSize),
      title: I18n.corruptedSoundpack.text(),
      subtitle: I18n.corruptedSoundpackSubtitle.text(),
      trailing: Icon(Icons.delete_outline, color: ctx.$red$, size: _iconSize).onTap(() async {
        await DB.removeSoundpackById(widget.id);
      }),
    );
  }
}

extension _MenuX on State {
  Widget moreMenu(
    BuildContext ctx,
    SoundpackProtocol soundpack,
  ) {
    List<PopupMenuEntry> buildExportSoundpackButtons(LocalSoundpack soundpack) {
      final buttons = <PopupMenuEntry>[];
      void add(String title, IconData icon, VoidCallback onTap) {
        buttons.add(PopupMenuItem(
          child: ListTile(
            leading: Icon(icon),
            title: title.text(),
            onTap: () async {
              ctx.navigator.pop();
              onTap();
            },
          ),
        ));
      }

      final isSupportShareFiles = isAndroid || isIOS || isMacOS || isWeb;
      if (isSupportShareFiles) {
        add(I18n.op.share, Icons.share_rounded, () async {
          await StageManager.closeSoundpackPreview(ctx: context);
          await Packager.shareSoundpackArchive(soundpack);
        });
      } else {
        add(I18n.op.saveAs, Icons.save_as, () async {
          await StageManager.closeSoundpackPreview(ctx: context);
          await Packager.saveAsSoundpackArchive(soundpack);
        });
      }

      return buttons;
    }

    PopupMenuEntry buildViewOrEditBtn() {
      if (soundpack is LocalSoundpack) {
        return PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.edit),
            title: I18n.op.edit.text(),
            onTap: () async {
              await StageManager.closeSoundpackPreview(ctx: context);
              ctx.navigator.pop();
              final anyChanged =
                  await ctx.navigator.push(MaterialPageRoute(builder: (_) => LocalSoundpackEditor(soundpack)));
              if (anyChanged == true) {
                if (!mounted) return;
                // ignore: invalid_use_of_protected_member
                setState(() {});
              }
            },
          ),
        );
      } else {
        return PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: I18n.op.info.text(),
            onTap: () async {
              await StageManager.closeSoundpackPreview(ctx: context);
              ctx.navigator.pop();
              ctx.navigator.push(MaterialPageRoute(builder: (_) => SoundpackViewer(soundpack)));
            },
          ),
        );
      }
    }

    final btn = PopupMenuButton(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.piano_outlined),
            title: I18n.op.play$Music.text(),
            onTap: () async {
              ctx.navigator.pop();
              StageManager.showSoundpackPreviewOf(soundpack, ctx: context);
            },
          ),
        ),
        if (soundpack is LocalSoundpack)
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.audio_file_outlined),
              title: I18n.op.compose.text(),
              onTap: () async {
                await StageManager.closeSoundpackPreview(ctx: context);
                ctx.navigator.pop();
                ctx.navigator.push(MaterialPageRoute(builder: (_) => SoundpackComposer(soundpack)));
              },
            ),
          ),
        const PopupMenuDivider(),
        buildViewOrEditBtn(),
        if (!kIsWeb)
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: I18n.op.duplicate.text(),
              onTap: () async {
                await StageManager.closeSoundpackPreview(ctx: context);
                ctx.navigator.pop();
                await Packager.duplicateSoundpack(soundpack);
              },
            ),
          ),
        if (soundpack is LocalSoundpack && isDesktop)
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: I18n.op.revealInFolder.text(),
              onTap: () async {
                await StageManager.closeSoundpackPreview(ctx: context);
                ctx.navigator.pop();
                await Packager.revealSoundpackInFolder(soundpack);
              },
            ),
          ),
        if (soundpack is LocalSoundpack) ...buildExportSoundpackButtons(soundpack),
        if (soundpack is! BuiltinSoundpack)
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.delete_outline, color: ctx.$red$),
              title: I18n.op.delete.text(style: TextStyle(color: ctx.$red$)),
              onTap: () async {
                await StageManager.closeSoundpackPreview(ctx: context);
                ctx.navigator.pop();
                await Future.delayed(const Duration(milliseconds: 500));
                await DB.removeSoundpackById(soundpack.id);
              },
            ),
          ),
      ],
      child: IgnorePointer(
          child: TextButton(
        child: const Icon(Icons.more_horiz_rounded),
        onPressed: () {},
      )),
    );
    return btn;
  }
}
