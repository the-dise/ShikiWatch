//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../constants/config.dart';
import '../../domain/models/animes.dart';
import '../../domain/models/user_anime_rates.dart';
import '../../utils/shiki_utils.dart';
import '../../utils/target_platform.dart';
import '../widgets/image_with_shimmer.dart';

class AnimeCard extends StatelessWidget {
  final UserAnimeRates data;

  const AnimeCard(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createDT = DateTime.parse(data.createdAt!).toLocal();
    final updateDT = DateTime.parse(data.updatedAt!).toLocal();
    final createString = DateFormat('yyyy-MM-dd в HH:mm').format(createDT);
    final updateString = DateFormat('yyyy-MM-dd в HH:mm').format(updateDT);
    return Material(
      surfaceTintColor: Colors.transparent,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.transparent,
      child: Tooltip(
        //showDuration: const Duration(seconds: 2),
        waitDuration: TargetP.instance.isDesktop
            ? const Duration(seconds: 1)
            : const Duration(milliseconds: 0),
        message: 'Изменено: $updateString\nСоздано: $createString',
        child: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            context.goNamed(
              'library_anime',
              params: <String, String>{
                'id': (data.anime?.id!).toString(),
              },
              extra: data.anime,
            );
            //context.push('/library/${data.anime?.id!}', extra: data.anime);
          },
          //onLongPress: () => log('onLongPress'),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisSize: MainAxisSize.min,
            children: [
              //Hero(
              //  tag: data.anime?.id ?? 0,
              //  child:
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImageWithShimmerWidget(
                  imageUrl:
                      AppConfig.staticUrl + (data.anime?.image?.original ?? ''),
                  width: 120,
                  height: 150,
                ),
              ),
              //),
              Padding(
                //padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
                padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    //FittedBox(
                    //  child:
                    Text(
                      (data.anime?.russian == ''
                              ? data.anime?.name
                              : data.anime?.russian) ??
                          '',
                      //data.anime?.russian ?? data.anime?.name ?? '',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      //style: Theme.of(context).textTheme.titleSmall,
                      style: const TextStyle(
                        //letterSpacing: 0.0,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    //),
                    const SizedBox(height: 4),

                    data.anime?.status == 'released'
                        ? Text(
                            //'${data.episodes.toString()} / ${data.anime?.episodes.toString()} эп, Вышло',
                            //'${data.anime?.episodes.toString()} эп / Вышло',
                            '${data.episodes.toString()} из ${data.anime?.episodes.toString()} эп.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  Theme.of(context).textTheme.bodySmall!.color,
                            ),
                          )
                        : Text(
                            '${data.episodes.toString()} / ${data.anime?.episodesAired.toString()} из ${data.anime?.episodes.toString()} эп.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  Theme.of(context).textTheme.bodySmall!.color,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimeTileExp extends StatelessWidget {
  final Animes data;

  const AnimeTileExp(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/explore/${data.id!}', extra: data),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: ImageWithShimmerWidget(
                imageUrl: AppConfig.staticUrl + (data.image?.original ?? ''),
                width: 120,
                height: 150,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                (data.russian == '' ? data.name : data.russian) ?? '',
                //data.russian ?? data.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${getKind(data.kind ?? '')} • ${data.score}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
                const Icon(
                  Icons.star,
                  size: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
