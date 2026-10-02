// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// void main() {
//   runApp(const MusicPlayerApp());
// }

// class MusicPlayerApp extends StatelessWidget {
//   const MusicPlayerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Music Player',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color(0xFF1E0B25),
//       ),
//       home: const MusicPlayerScreen(),
//     );
//   }
// }

// // Model bài hát
// class Song {
//   final String title;
//   final String artist;
//   final String path;
//   final String duration;

//   Song({
//     required this.title,
//     required this.artist,
//     required this.path,
//     required this.duration,
//   });
// }

// class MusicPlayerScreen extends StatefulWidget {
//   const MusicPlayerScreen({super.key});

//   @override
//   State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
// }

// class _MusicPlayerScreenState extends State<MusicPlayerScreen>
//     with SingleTickerProviderStateMixin {
//   late AudioPlayer _audioPlayer;
//   late AnimationController _rotationController;

//   bool _isPlaying = false;
//   int _currentIndex = 0;
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;

//   // Danh sách bài hát mẫu
//   final List<Song> _playlist = [
//     Song(
//       title: 'Sample Song 1',
//       artist: 'Artist A',
//       path: 'audios/sample1.mp3',
//       duration: '03:15',
//     ),
//     Song(
//       title: 'Sample Song 2',
//       artist: 'Artist B',
//       path: 'audios/sample2.mp3',
//       duration: '04:02',
//     ),
//     Song(
//       title: 'Sample Song 3',
//       artist: 'Artist C',
//       path: 'audios/sample3.mp3',
//       duration: '02:50',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();

//     // Hiệu ứng quay đĩa đĩa CD
//     _rotationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     );

//     // Lắng nghe sự thay đổi trạng thái player
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       if (mounted) {
//         setState(() {
//           _isPlaying = state == PlayerState.playing;
//         });
//         if (_isPlaying) {
//           _rotationController.repeat();
//         } else {
//           _rotationController.stop();
//         }
//       }
//     });

//     // Lắng nghe độ dài bài hát
//     _audioPlayer.onDurationChanged.listen((newDuration) {
//       if (mounted) setState(() => _duration = newDuration);
//     });

//     // Lắng nghe tiến trình phát
//     _audioPlayer.onPositionChanged.listen((newPosition) {
//       if (mounted) setState(() => _position = newPosition);
//     });

//     // Tự động chuyển bài khi hết nhạc
//     _audioPlayer.onPlayerComplete.listen((event) {
//       _nextSong();
//     });
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     _rotationController.dispose();
//     super.dispose();
//   }

//   Future<void> _playSong(int index) async {
//     _currentIndex = index;
//     await _audioPlayer.stop();
//     await _audioPlayer.play(AssetSource(_playlist[_currentIndex].path));
//   }

//   Future<void> _togglePlayPause() async {
//     if (_isPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       if (_position == Duration.zero) {
//         await _playSong(_currentIndex);
//       } else {
//         await _audioPlayer.resume();
//       }
//     }
//   }

//   void _nextSong() {
//     int nextIndex = (_currentIndex + 1) % _playlist.length;
//     _playSong(nextIndex);
//   }

//   void _previousSong() {
//     int prevIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
//     _playSong(prevIndex);
//   }

//   String _formatDuration(Duration d) {
//     String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return "$minutes:$seconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentSong = _playlist[_currentIndex];

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF4A1040),
//               Color(0xFF1E0B25),
//               Color(0xFF0F0413),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               // Header title
//               const Text(
//                 'NOW PLAYING',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 13,
//                   letterSpacing: 2,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Đĩa nhạc xoay (Album Art / Vinyl)
//               AnimatedBuilder(
//                 animation: _rotationController,
//                 builder: (context, child) {
//                   return Transform.rotate(
//                     angle: _rotationController.value * 2 * math.pi,
//                     child: child,
//                   );
//                 },
//                 child: Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: RadialGradient(
//                       colors: [
//                         Colors.pinkAccent.shade100,
//                         const Color(0xFF2A082D),
//                         Colors.black,
//                       ],
//                       stops: const [0.1, 0.7, 1.0],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.pinkAccent.withOpacity(0.3),
//                         blurRadius: 25,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFF1E0B25),
//                       ),
//                       child: Center(
//                         child: Container(
//                           width: 15,
//                           height: 15,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.pinkAccent,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 25),

//               Text(
//                 currentSong.title.toUpperCase(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 currentSong.artist.toUpperCase(),
//                 style: const TextStyle(
//                   color: Colors.white54,
//                   fontSize: 12,
//                   letterSpacing: 1.2,
//                 ),
//               ),

//               const SizedBox(height: 15),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                 child: Column(
//                   children: [
//                     SliderTheme(
//                       data: SliderTheme.of(context).copyWith(
//                         trackHeight: 3,
//                         thumbShape: const RoundSliderThumbShape(
//                           enabledThumbRadius: 6,
//                         ),
//                         activeTrackColor: Colors.pinkAccent,
//                         inactiveTrackColor: Colors.white24,
//                         thumbColor: Colors.pinkAccent,
//                       ),
//                       child: Slider(
//                         min: 0,
//                         max: _duration.inSeconds.toDouble() > 0
//                             ? _duration.inSeconds.toDouble()
//                             : 1.0,
//                         value: _position.inSeconds
//                             .toDouble()
//                             .clamp(0.0, _duration.inSeconds.toDouble()),
//                         onChanged: (value) async {
//                           final position = Duration(seconds: value.toInt());
//                           await _audioPlayer.seek(position);
//                         },
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _formatDuration(_position),
//                             style: const TextStyle(
//                                 color: Colors.white54, fontSize: 11),
//                           ),
//                           Text(
//                             _formatDuration(_duration),
//                             style: const TextStyle(
//                                 color: Colors.white54, fontSize: 11),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     iconSize: 32,
//                     icon: const Icon(Icons.skip_previous, color: Colors.white),
//                     onPressed: _previousSong,
//                   ),
//                   const SizedBox(width: 15),
//                   Container(
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.pinkAccent,
//                     ),
//                     child: IconButton(
//                       iconSize: 36,
//                       icon: Icon(
//                         _isPlaying ? Icons.pause : Icons.play_arrow,
//                         color: Colors.white,
//                       ),
//                       onPressed: _togglePlayPause,
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   IconButton(
//                     iconSize: 32,
//                     icon: const Icon(Icons.skip_next, color: Colors.white),
//                     onPressed: _nextSong,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 15),
//               const Divider(color: Colors.white12, height: 1),

//               // Danh sách phát bên dưới (Playlist)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _playlist.length,
//                   itemBuilder: (context, index) {
//                     final song = _playlist[index];
//                     final isSelected = index == _currentIndex;

//                     return ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 25,
//                         vertical: 2,
//                       ),
//                       leading: Text(
//                         '${index + 1}.',
//                         style: TextStyle(
//                           color: isSelected ? Colors.pinkAccent : Colors.white54,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       title: Text(
//                         song.title,
//                         style: TextStyle(
//                           color: isSelected ? Colors.pinkAccent : Colors.white,
//                           fontWeight:
//                               isSelected ? FontWeight.bold : FontWeight.normal,
//                           fontSize: 14,
//                         ),
//                       ),
//                       subtitle: Text(
//                         song.artist,
//                         style: const TextStyle(
//                             color: Colors.white38, fontSize: 12),
//                       ),
//                       trailing: Text(
//                         song.duration,
//                         style: const TextStyle(
//                             color: Colors.white38, fontSize: 12),
//                       ),
//                       onTap: () => _playSong(index),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const SmsAnalyzerApp());
}

class SmsAnalyzerApp extends StatelessWidget {
  const SmsAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const SmsAnalyzerHome(),
    );
  }
}

class SmsAnalyzerHome extends StatefulWidget {
  const SmsAnalyzerHome({super.key});

  @override
  State<SmsAnalyzerHome> createState() => _SmsAnalyzerHomeState();
}

class _SmsAnalyzerHomeState extends State<SmsAnalyzerHome> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _allMessages = [];
  List<SmsMessage> _filteredMessages = [];

  bool _isLoading = false;
  String _selectedFilter = 'Tất cả'; // 'Tất cả', 'Quảng cáo', 'OTP'
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSms();
  }

  // Xin quyền và lấy danh sách tin nhắn
  Future<void> _fetchSms() async {
    setState(() => _isLoading = true);

    var permission = await Permission.sms.status;
    if (!permission.isGranted) {
      permission = await Permission.sms.request();
    }

    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
      );
      setState(() {
        _allMessages = messages;
        _applyFilters();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cần cấp quyền đọc SMS để sử dụng ứng dụng!')),
        );
      }
    }
  }

  // Kiểm tra tin nhắn Quảng cáo ([QC] đứng đầu)
  bool _isAdMessage(String? body) {
    if (body == null) return false;
    return body.trim().toUpperCase().startsWith('[QC]');
  }

  // Kiểm tra tin nhắn OTP (Có chứa "OTP" và 6 chữ số)
  bool _isOtpMessage(String? body) {
    if (body == null) return false;
    final upperBody = body.toUpperCase();
    final otpRegex = RegExp(r'\b\d{6}\b');
    return upperBody.contains('OTP') && otpRegex.hasMatch(body);
  }

  // Lấy chuỗi 6 ký số OTP từ tin nhắn
  String? _extractOtpCode(String? body) {
    if (body == null) return null;
    final otpRegex = RegExp(r'\b\d{6}\b');
    final match = otpRegex.firstMatch(body);
    return match?.group(0);
  }

  // Áp dụng bộ lọc (Theo nhóm QC/OTP và theo Số điện thoại)
  void _applyFilters() {
    String query = _searchController.text.trim();

    setState(() {
      _filteredMessages = _allMessages.where((msg) {
        // Lọc theo nhóm
        bool matchesCategory = true;
        if (_selectedFilter == 'Quảng cáo') {
          matchesCategory = _isAdMessage(msg.body);
        } else if (_selectedFilter == 'OTP') {
          matchesCategory = _isOtpMessage(msg.body);
        }

        // Lọc theo số điện thoại
        bool matchesPhone = true;
        if (query.isNotEmpty) {
          matchesPhone = (msg.sender ?? '').contains(query);
        }

        return matchesCategory && matchesPhone;
      }).toList();
    });
  }

  // Thống kê tin nhắn theo ngày/tháng
  Map<String, int> _getSmsByDateStats() {
    Map<String, int> stats = {};
    for (var msg in _allMessages) {
      if (msg.date != null) {
        String dateStr =
            "${msg.date!.day.toString().padLeft(2, '0')}/${msg.date!.month.toString().padLeft(2, '0')}/${msg.date!.year}";
        stats[dateStr] = (stats[dateStr] ?? 0) + 1;
      }
    }
    return stats;
  }

  // Hiển thị Dialog thống kê theo ngày/tháng
  void _showDateStatsDialog() {
    final stats = _getSmsByDateStats();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thống kê theo Ngày/Tháng'),
          content: SizedBox(
            width: double.maxFinite,
            child: stats.isEmpty
                ? const Text('Không có dữ liệu')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      String dateKey = stats.keys.elementAt(index);
                      int count = stats[dateKey]!;
                      return ListTile(
                        dense: true,
                        title: Text('Ngày $dateKey'),
                        trailing: Text(
                          '$count tin nhắn',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  // Hiển thị chi tiết khi chọn tin nhắn OTP
  void _showOtpDetails(SmsMessage msg) {
    String? otpCode = _extractOtpCode(msg.body);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.security, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('Mã OTP Phát Hiện'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mã OTP 6 chữ số của bạn là:'),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  child: Text(
                    otpCode ?? 'Không tìm thấy',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Nội dung tin nhắn:\n${msg.body}',
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Analyzer'),
        backgroundColor: Colors.deepPurple.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Thống kê theo ngày',
            onPressed: _showDateStatsDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchSms,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Khối thống kê tổng quan
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.deepPurple.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Tổng số tin', '${_allMessages.length}'),
                      _buildStatCard('Đã lọc', '${_filteredMessages.length}'),
                    ],
                  ),
                ),

                // Lọc theo số điện thoại
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Lọc theo số điện thoại',
                      prefixIcon: const Icon(Icons.phone),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (val) => _applyFilters(),
                  ),
                ),

                // Chọn nhóm tin nhắn (Tất cả / Quảng cáo / OTP)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['Tất cả', 'Quảng cáo', 'OTP'].map((filter) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilter = filter;
                              _applyFilters();
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),

                const Divider(),

                // Danh sách tin nhắn
                Expanded(
                  child: _filteredMessages.isEmpty
                      ? const Center(child: Text('Không tìm thấy tin nhắn nào'))
                      : ListView.builder(
                          itemCount: _filteredMessages.length,
                          itemBuilder: (context, index) {
                            final msg = _filteredMessages[index];
                            final isOtp = _isOtpMessage(msg.body);
                            final isAd = _isAdMessage(msg.body);

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isOtp
                                      ? Colors.orange.shade100
                                      : isAd
                                          ? Colors.red.shade100
                                          : Colors.blue.shade100,
                                  child: Icon(
                                    isOtp
                                        ? Icons.security
                                        : isAd
                                            ? Icons.campaign
                                            : Icons.message,
                                    color: isOtp
                                        ? Colors.orange
                                        : isAd
                                            ? Colors.red
                                            : Colors.blue,
                                  ),
                                ),
                                title: Text(
                                  msg.sender ?? 'Không rõ người gửi',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  msg.body ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  msg.date != null
                                      ? "${msg.date!.day}/${msg.date!.month}"
                                      : '',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                onTap: () {
                                  if (isOtp) {
                                    _showOtpDetails(msg);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}