import 'package:flutter/services.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:shimmer/shimmer.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;

  const CustomVideoPlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.looping = false,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  // Common state
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isYouTube = false;

  // YouTube state
  YoutubePlayerController? _youtubeController;
  bool _wasFullScreen = false;

  // Video Player state
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _isYouTube = YoutubePlayer.convertUrlToId(widget.videoUrl) != null;
  }

  void _youtubeOrientationListener() {
    final isFullScreen = _youtubeController?.value.isFullScreen ?? false;
    if (_wasFullScreen && !isFullScreen) {
      // User just exited full-screen — force portrait immediately
    // Allow all orientations and handle rotation naturally
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    }
    _wasFullScreen = isFullScreen;
  }

  @override
  void dispose() {
    _youtubeController?.removeListener(_youtubeOrientationListener);
    _youtubeController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    // Safety reset to portrait on dispose
    // Reset to include all orientations on dispose if needed, or just let it stay flexible
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });

    if (_isYouTube) {
      _initializeYouTube();
    } else {
      _initializeVideoPlayer();
    }
  }

  void _initializeYouTube() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid YouTube URL";
      });
      return;
    }

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true, // Auto-play once user taps
        mute: false,
        loop: widget.looping,
        disableDragSeek: false,
        useHybridComposition: true,
      ),
    );

    // Listen to full-screen changes and reset orientation on exit
    _youtubeController!.addListener(_youtubeOrientationListener);

    setState(() {
      _isLoading = false;
      _isInitialized = true;
    });
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true, // Auto-play once user taps
        looping: widget.looping,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        // Orientation management for Chewie
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
        ],
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.accentGold),
          ),
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.accentGold,
          handleColor: AppColors.accentGold,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white54,
        ),
        cupertinoProgressColors: ChewieProgressColors(
          playedColor: AppColors.accentGold,
          handleColor: AppColors.accentGold,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white54,
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.accentGold,
                  size: 32.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Error playing video',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized && !_isLoading) {
      return _buildPlayOverlay();
    }

    if (_isLoading) {
      return _buildLoadingPlaceholder();
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    if (_isYouTube && _youtubeController != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: AppColors.accentGold,
            onEnded: (o) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
            },
            progressColors: const ProgressBarColors(
              playedColor: AppColors.accentGold,
              handleColor: AppColors.accentGold,
            ),
          ),
        ),
      );
    }

    if (_chewieController != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: Chewie(controller: _chewieController!),
          ),
        ),
      );
    }

    return _buildErrorWidget();
  }

  Widget _buildPlayOverlay() {
    return GestureDetector(
      onTap: _startLoading,
      child: Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.accentGold.withValues(alpha: 0.3),
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/video_placeholder.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: AppColors.accentGold,
                size: 50.sp,
              ),
            ),
            Positioned(
              bottom: 16.h,
              child: Text(
                'Tap to load video',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryNavy,
      highlightColor: AppColors.primaryNavy.withValues(alpha: 0.5),
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.accentGold),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.accentGold.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image, color: Colors.white54, size: 40.sp),
            SizedBox(height: 8.h),
            Text(
              _errorMessage ?? 'Could not load video',
              style: TextStyle(color: Colors.white54, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
