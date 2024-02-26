import 'package:flutter/material.dart';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/player_provider_parameters.dart';

import '../../player_provider.dart';
import '../../shared/skip_fragment_button.dart';

class BottomControls extends ConsumerWidget {
  final PlayerProviderParameters p;
  final bool seekShowUI;
  final Duration seekTo;
  const BottomControls(
    this.p, {
    super.key,
    required this.seekShowUI,
    required this.seekTo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (
      opTimecode,
      hideController,
      playerFit
    ) = ref.watch(playerPageProvider(p).select(
        (value) => (value.opTimecode, value.hideController, value.playerFit)));

    final (player, position, buffer, duration) = ref.watch(playerStateProvider
        .select((s) => (s.player, s.position, s.buffer, s.duration)));

    final showSkip = opTimecode.length == 2 &&
        (opTimecode.first) <= position.inSeconds &&
        opTimecode.last > position.inSeconds;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            const Spacer(),
            AnimatedOpacity(
              opacity: showSkip ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: IgnorePointer(
                ignoring: !showSkip,
                child: SkipFragmentButton(
                  title: 'Пропустить опенинг',
                  onSkip: () => player.seek(Duration(seconds: opTimecode.last)),
                  //onClose: () => notifier.opTimecode = [],
                  onClose: () =>
                      ref.read(playerPageProvider(p)).opTimecode = [],
                ),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: ProgressBar(
                progress: seekShowUI ? seekTo : position,
                buffered: buffer,
                total: duration,
                onDragUpdate: (_) {
                  if (hideController.isVisible) {
                    hideController.show();
                  }
                },
                onSeek: (p) {
                  player.seek(p);
                },
                timeLabelTextStyle: const TextStyle(color: Colors.white),
                thumbRadius: 8,
                timeLabelPadding: 4,
                timeLabelLocation: TimeLabelLocation.below,
                timeLabelType: TimeLabelType.totalTime,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(
              color: Colors.white,
              onPressed: () {
                player.seek(
                  position + const Duration(seconds: 85),
                );
              },
              icon: const Icon(
                Icons.double_arrow_rounded,
              ),
              iconSize: 21,
              tooltip: 'Перемотать 125 секунд',
            ),
            IconButton(
              color: Colors.white,
              onPressed: () =>
                  ref.read(playerPageProvider(p)).changePlayerFit(),
              icon: Icon(
                playerFit != BoxFit.contain
                    ? Icons.close_fullscreen_rounded
                    : Icons.open_in_full_rounded,
              ),
              iconSize: 21,
            ),
            // IconButton(
            //   onPressed: () =>
            //       MobilePlayerSettings.show(context),
            //   icon: const Icon(
            //     Icons.settings_rounded,
            //   ),
            //   iconSize: 21,
            //   color: Colors.white,
            // ),
            const SizedBox(
              width: 8,
            ),
          ],
        ),
      ],
    );
  }
}
