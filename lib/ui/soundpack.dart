import 'package:calcupiano/design/multiplatform.dart';
import 'package:calcupiano/events.dart';
import 'package:calcupiano/foundation.dart';
import 'package:calcupiano/r.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../db.dart';
import '../impl/soundpack.dart';

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
      ),
      body: buildBody(),
    );
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
          return CustomSoundpackItem(id: customList[index - builtinList.length - 1]);
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
                // TODO: builtin soundpack can't be deleted.
                CupertinoContextMenuAction(
                  trailingIcon: CupertinoIcons.delete,
                  isDestructiveAction: true,
                  child: "Delete".text(),
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
      leading: isSelected ? Icon(Icons.done, size: 36) : null,
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
