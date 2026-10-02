import 'dart:async';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

void main() {
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player UI',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFE0E5EC),
      ),
      home: const MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with SingleTickerProviderStateMixin {
  double _currentSeconds = 150.0;
  final double _maxSeconds = 262.0;
  bool _isPlaying = false;
  bool _isFavorite = true;
  bool _isShuffle = true;
  bool _isRepeat = false;

  Timer? _timer;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _rotationController.repeat();
        _startTimer();
      } else {
        _rotationController.stop();
        _timer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds < _maxSeconds) {
        setState(() => _currentSeconds += 1.0);
      } else {
        setState(() {
          _isPlaying = false;
          _rotationController.stop();
          _currentSeconds = 0.0;
        });
        _timer?.cancel();
      }
    });
  }

  String _formatDuration(double seconds) {
    final mins = (seconds / 60).floor();
    final secs = (seconds % 60).floor();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
              _buildAppBar(),
              const SizedBox(height: 16),
              _buildVinylAlbumCard(),
              const SizedBox(height: 20),
              _buildSongDetails(),
              const SizedBox(height: 20),
              _buildControlIconsRow(),
              const SizedBox(height: 10),
              _buildInteractiveProgressBar(),
              const Spacer(),
              _buildPlaybackControls(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NeuButton(
          size: 48,
          onTap: () {},
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF6A7B95), size: 18),
        ),
        const Text(
          'P L A Y I S T',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 3.0,
            color: Color(0xFF6A7B95),
          ),
        ),
        NeuButton(
          size: 48,
          onTap: () {},
          child: const Icon(Icons.tune_rounded, color: Color(0xFF6A7B95), size: 20),
        ),
      ],
    );
  }

  // Khung Đĩa Than kết hợp Album Art
  Widget _buildVinylAlbumCard() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Đĩa than nhô ra phía sau khi đang phát nhạc
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          top: _isPlaying ? 0 : 20,
          child: RotationTransition(
            turns: _rotationController,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E1E1E),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                ],
              ),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent.shade200,
                    border: Border.all(color: Colors.black, width: 8),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Khung Cover Art chính
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E5EC),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                offset: const Offset(-8, -8),
                blurRadius: 16,
              ),
              const BoxShadow(
                color: Color(0xFFA3B1C6),
                offset: Offset(8, 8),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1.05,
              child: Image.network(
                'https://picsum.photos/500?random=20',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSongDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: const [
            Text(
              'Kota The Friend',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF8E9AAF),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Birdie',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        NeuButton(
          size: 46,
          isPressed: _isFavorite,
          onTap: () => setState(() => _isFavorite = !_isFavorite),
          child: Icon(
            _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: _isFavorite ? const Color(0xFFFF5252) : const Color(0xFF718096),
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildControlIconsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatDuration(_currentSeconds),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF718096),
          ),
        ),
        Row(
          children: [
            NeuButton(
              size: 38,
              isPressed: _isShuffle,
              onTap: () => setState(() => _isShuffle = !_isShuffle),
              child: Icon(
                Icons.shuffle_rounded,
                color: _isShuffle ? const Color(0xFF00C853) : const Color(0xFF718096),
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            NeuButton(
              size: 38,
              isPressed: _isRepeat,
              onTap: () => setState(() => _isRepeat = !_isRepeat),
              child: Icon(
                Icons.repeat_rounded,
                color: _isRepeat ? const Color(0xFF00C853) : const Color(0xFF718096),
                size: 18,
              ),
            ),
          ],
        ),
        Text(
          _formatDuration(_maxSeconds),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveProgressBar() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final double width = box.size.width - 48;
        final double dx = details.localPosition.dx.clamp(0.0, width);
        setState(() {
          _currentSeconds = (dx / width) * _maxSeconds;
        });
      },
      child: Container(
        height: 14,
        width: double.infinity,
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E5EC),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFA3B1C6),
              offset: Offset(3, 3),
              blurRadius: 4,
              inset: true,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-3, -3),
              blurRadius: 4,
              inset: true,
            ),
          ],
        ),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: (_currentSeconds / _maxSeconds).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NeuButton(
          size: 62,
          onTap: () => setState(() => _currentSeconds = 0),
          child: const Icon(Icons.skip_previous_rounded, color: Color(0xFF2D3748), size: 28),
        ),
        // Nút Play/Pause thiết kế nổi bật Accent
        NeuButton(
          size: 76,
          isPressed: _isPlaying,
          accentColor: const Color(0xFF2E7D32),
          onTap: _togglePlayPause,
          child: Icon(
            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: _isPlaying ? Colors.white : const Color(0xFF2D3748),
            size: 38,
          ),
        ),
        NeuButton(
          size: 62,
          onTap: () {},
          child: const Icon(Icons.skip_next_rounded, color: Color(0xFF2D3748), size: 28),
        ),
      ],
    );
  }
}

class NeuButton extends StatefulWidget {
  final double size;
  final Widget child;
  final VoidCallback onTap;
  final bool isPressed;
  final Color? accentColor;

  const NeuButton({
    super.key,
    required this.size,
    required this.child,
    required this.onTap,
    this.isPressed = false,
    this.accentColor,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _isPointerDown = false;

  @override
  Widget build(BuildContext context) {
    final bool activePressed = widget.isPressed || _isPointerDown;
    final Color bgColor = (activePressed && widget.accentColor != null)
        ? widget.accentColor!
        : const Color(0xFFE0E5EC);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPointerDown = true),
      onTapUp: (_) {
        setState(() => _isPointerDown = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPointerDown = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.size / 3.2),
          boxShadow: activePressed
              ? [
                  const BoxShadow(
                    color: Color(0xFFA3B1C6),
                    offset: Offset(4, 4),
                    blurRadius: 6,
                    inset: true,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(-4, -4),
                    blurRadius: 6,
                    inset: true,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-5, -5),
                    blurRadius: 10,
                  ),
                  const BoxShadow(
                    color: Color(0xFFA3B1C6),
                    offset: Offset(5, 5),
                    blurRadius: 10,
                  ),
                ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}