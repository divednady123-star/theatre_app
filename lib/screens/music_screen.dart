import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../core/services/auth_service.dart';
import '../core/services/data_service.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingId;
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _addMediaFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'mp4', 'm4a'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final path = file.path;
      final name = file.name;

      if (path != null) {
        final ext = file.extension?.toLowerCase() ?? '';
        final isVideo = ext == 'mp4';

        final newItem = MediaItem(
          id: const Uuid().v4(),
          title: name,
          path: path,
          type: isVideo ? 'video' : 'audio',
        );

        if (context.mounted) {
          final dataService = Provider.of<DataService>(context, listen: false);
          await dataService.addMediaItem(newItem);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تمت إضافة ${newItem.title} بنجاح!')),
          );
        }
      }
    }
  }

  void _togglePlayAudio(MediaItem item) async {
    if (_currentlyPlayingId == item.id && _isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(DeviceFileSource(item.path));
      setState(() {
        _currentlyPlayingId = item.id;
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AuthService>(context).isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الموسيقى والمؤثرات'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add_to_photos),
              tooltip: 'إضافة مقطع صوتي أو فيديو',
              onPressed: () => _addMediaFile(context),
            ),
        ],
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          final mediaList = dataService.mediaList;

          if (mediaList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.library_music_outlined, size: 80, color: AppConstants.textMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد مقاطع صوتية أو فيديو مضافة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.royalBlueDark),
                  ),
                  const SizedBox(height: 8),
                  const Text('يمكن للمشرف إضافة ملفات MP3 للمسرحية من الأعلى.'),
                  if (isAdmin) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _addMediaFile(context),
                      icon: const Icon(Icons.upload_file),
                      label: const Text('إضافة ملف صوتی'),
                    )
                  ]
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: mediaList.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final item = mediaList[index];
              final isCurrent = _currentlyPlayingId == item.id;
              final playingThis = isCurrent && _isPlaying;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.type == 'video' ? Colors.purple.shade100 : Colors.blue.shade100,
                    child: Icon(
                      item.type == 'video' ? Icons.videocam : Icons.music_note,
                      color: item.type == 'video' ? Colors.purple : Colors.blue,
                    ),
                  ),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.type == 'video' ? 'ملف فيديو MP4' : 'ملف صوتي MP3'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(playingThis ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 36),
                        color: AppConstants.royalBlueDark,
                        onPressed: () => _togglePlayAudio(item),
                      ),
                      if (isAdmin)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => dataService.removeMediaItem(item.id),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
