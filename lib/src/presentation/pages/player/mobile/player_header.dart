import 'package:flutter/material.dart';

class PlayerHeader extends StatelessWidget {
  final String animeName;
  final int episodeNumber;
  final String studioName;
  final int streamQuality;
  final Function(int) onQualitySelect;

  const PlayerHeader({
    super.key,
    required this.animeName,
    required this.episodeNumber,
    required this.studioName,
    required this.streamQuality,
    required this.onQualitySelect,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0), //15 kToolbarHeight
        child: ListTile(
          leading: const BackButton(
            color: Colors.white,
          ),
          title: Text(
            animeName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Text(
            'Серия $episodeNumber • $studioName',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          trailing: QualityButton(
            streamQuality: streamQuality,
            onSelected: onQualitySelect,
          ),
        ),
      ),
    );
  }
}

class QualityButton extends StatelessWidget {
  final int streamQuality;
  //final int initialValue;
  final Function(int) onSelected;

  const QualityButton({
    super.key,
    required this.streamQuality,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: streamQuality,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child: Text('720p'),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text('480p'),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text('360p'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: QualityTextWidget(
          quality: streamQuality,
        ),
      ),
    );
  }
}

class QualityTextWidget extends StatelessWidget {
  final int quality;
  const QualityTextWidget({super.key, required this.quality});

  String getString(int value) {
    String str;

    const map = {0: '720p', 1: '480p', 2: '360p'};

    str = map[value] ?? 'N/A';

    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          getString(quality),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(
          width: 4,
        ),
        const Icon(Icons.expand_more)
      ],
    );
  }
}