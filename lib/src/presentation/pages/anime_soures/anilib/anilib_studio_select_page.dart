import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/extensions/buildcontext.dart';
import '../../../../../anime_lib/models/models.dart';
import '../../../../domain/models/pages_extra.dart';
import '../../../../domain/enums/anime_source.dart';
import '../../../../../anime_lib/enums/enums.dart';
import '../../../widgets/error_widget.dart';
import '../../player/domain/player_page_extra.dart' as ppe;
import '../shared/compact_info_chip.dart';
import '../shared/nothing_found.dart';

import 'anilib_source_controller.dart';

class AnilibStudioSelectPage extends ConsumerWidget {
  const AnilibStudioSelectPage(
    this.extra, {
    super.key,
    required this.episodeId,
    required this.playlist,
    required this.selectedEpisode,
  });

  final AnimeSourcePageExtra extra;
  final int episodeId;
  final int selectedEpisode;
  final List<AnilibPlaylist> playlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studiosAsync = ref.watch(anilibEpisodeProvider(episodeId));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(anilibEpisodeProvider(episodeId).future),
        child: SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      extra.animeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Серия $selectedEpisode',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              ...studiosAsync.when(
                data: (studios) {
                  if (studios.players.isEmpty) {
                    return [const SourceNothingFound()];
                  }

                  return [
                    SliverList.builder(
                      itemCount: studios.players.length,
                      itemBuilder: (context, index) {
                        final item = studios.players[index];

                        return StudioListItem(
                          item,
                          onTap: () {
                            final anilib = ppe.AnilibPlayerList(
                              host: studios.videoHost,
                              //host: AnilibUtils.kVideoHosts[0],
                              playlist: playlist,
                            );

                            final e = ppe.PlayerPageExtra(
                              titleInfo: ppe.TitleInfo(
                                shikimoriId: extra.shikimoriId,
                                animeName: extra.animeName,
                                imageUrl: extra.imageUrl,
                              ),
                              studio: ppe.Studio(
                                id: item.team.id,
                                name: item.team.name,
                                type: item.translationType.name,
                              ),
                              selected: selectedEpisode,
                              animeSource: AnimeSource.anilib,
                              startPosition: '',
                              anilib: anilib,
                              libria: null,
                              kodik: null,
                            );

                            GoRouter.of(context).pushNamed('player', extra: e);
                          },
                        );
                      },
                    ),
                  ];
                },
                loading: () => [
                  const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator())),
                ],
                error: (err, stack) => [
                  SliverFillRemaining(
                    child: CustomErrorWidget(
                      err.toString(),
                      () => ref.invalidate(
                        anilibEpisodeProvider(episodeId),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudioListItem extends StatelessWidget {
  const StudioListItem(
    this.item, {
    super.key,
    required this.onTap,
  });

  final AnilibPlayer item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final teamName = item.team.name
        .replaceFirst('.Subtitles', '')
        .replaceFirst('|Субтитры', '');

    return ListTile(
      onTap: onTap,
      // leading: CachedCircleImage(
      //   item.team.teamCover,
      //   httpHeaders: const {
      //     'Origin': AnilibUtils.kOrigin,
      //     'Referer': AnilibUtils.kReferer,
      //     'User-Agent': AnilibUtils.kUserAgent,
      //   },
      // ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              teamName,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          if (item.translationType == TranslationType.sub)
            const CompactInfoChip(
              'Субтитры',
            ),
        ],
      ),
      trailing: CompactInfoChip(item.video[0].quality.toShort),
    );
  }
}
