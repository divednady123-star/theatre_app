import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../core/services/auth_service.dart';
import '../core/services/data_service.dart';
import '../models/music_track.dart';
import '../providers/audio_player_provider.dart';

class MusicScreen extends StatelessWidget {
  const MusicScreen({Key? key}) : super(key: key);

  void _showAddTrackDialog(BuildContext context) {
    final titleController = TextEditingController();
    final durationController = TextEditingController(text: '03:30');
    final composerController = TextEditingController(text: 'المشرف الموسيقي');
    String category = 'موسيقى تصويرية';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: const [
                  Icon(Icons.library_music, color: AppConstants.softGoldPrimary),
                  SizedBox(width: 8),
                  Text('إضافة ملف صوتي جديد (للمشرف)'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'عنوان التراك الصوتي'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(labelText: 'القسم'),
                      items: const [
                        DropdownMenuItem(value: 'موسيقى تصويرية', child: Text('موسيقى تصويرية')),
                        DropdownMenuItem(value: 'مؤثرات صوتية', child: Text('مؤثرات صوتية')),
                        DropdownMenuItem(value: 'ترانيم وألحان', child: Text('ترانيم وألحان')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => category = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: durationController,
                      decoration: const InputDecoration(labelText: 'مدة التراك (مثال: 03:45)'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: composerController,
                      decoration: const InputDecoration(labelText: 'المؤلف / الكورال'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;

                    final newTrack = MusicTrack(
                      id: const Uuid().v4(),
                      title: titleController.text.trim(),
                      category: category,
                      duration: durationController.text.trim(),
                      audioUrl: 'assets/audio/new_track.mp3',
                      composer: composerController.text.trim(),
                    );

                    await Provider.of<DataService>(context, listen: false).addTrack(newTrack);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تمت إضافة التراك الصوتي بنجاح!')),
                      );
                    }
                  },
                  child: const Text('إضافة والتسجيل'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AuthService>(context).isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('قسم الموسيقى والتراكات'),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showAddTrackDialog(context),
              icon: const Icon(Icons.cloud_upload),
              label: const Text('رفع تراك جديد'),
            )
          : null,
      body: Column(
        children: [
          // Audio Player Control Bar (Integrated top player view)
          Consumer<AudioPlaybackState>(
            builder: (context, audioState, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppConstants.royalBlueDark, AppConstants.royalBluePrimary],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.royalBlueDark.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppConstants.softGoldPrimary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.music_note, color: AppConstants.softGoldPrimary, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                audioState.activeTrackTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                audioState.isPlaying ? 'جارٍ التشغيل الآن...' : 'مشغل الموسيقى الكنسية',
                                style: const TextStyle(color: AppConstants.softGoldLight, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            audioState.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                            color: AppConstants.softGoldPrimary,
                            size: 44,
                          ),
                          onPressed: () {
                            if (audioState.currentlyPlayingId != null) {
                              if (audioState.isPlaying) {
                                audioState.pauseTrack();
                              } else {
                                audioState.resumeTrack();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppConstants.softGoldPrimary,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: AppConstants.softGoldPrimary,
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: audioState.playbackPosition,
                        onChanged: (val) {
                          audioState.seekTo(val);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Track List Section
          Expanded(
            child: Consumer<DataService>(
              builder: (context, dataService, child) {
                final tracks = dataService.tracks;

                if (tracks.isEmpty) {
                  return const Center(child: Text('لا توجد تراكات موسيقية مضافة حالياً.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    return Consumer<AudioPlaybackState>(
                      builder: (context, audioState, child) {
                        final isPlayingThis = audioState.currentlyPlayingId == track.id && audioState.isPlaying;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: isPlayingThis ? AppConstants.softGoldPrimary.withOpacity(0.12) : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isPlayingThis ? AppConstants.softGoldPrimary : AppConstants.royalBluePrimary.withOpacity(0.1),
                              child: Icon(
                                isPlayingThis ? Icons.graphic_eq : Icons.audiotrack,
                                color: isPlayingThis ? AppConstants.royalBlueDark : AppConstants.royalBluePrimary,
                              ),
                            ),
                            title: Text(
                              track.title,
                              style: TextStyle(
                                fontWeight: isPlayingThis ? FontWeight.bold : FontWeight.w600,
                                color: AppConstants.royalBlueDark,
                              ),
                            ),
                            subtitle: Text('${track.category} • ${track.composer}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(track.duration, style: const TextStyle(fontSize: 12, color: AppConstants.textMuted)),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    isPlayingThis ? Icons.pause_circle_outline : Icons.play_circle_outline,
                                    color: AppConstants.softGoldPrimary,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    audioState.playTrack(track.id, track.title);
                                  },
                                ),
                                if (isAdmin)
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    onPressed: () async {
                                      await dataService.deleteTrack(track.id);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
