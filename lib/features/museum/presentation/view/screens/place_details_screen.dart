import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/museum/data/models/museum_place_model.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_cubit.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final MuseumPlaceModel place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final TtsService _ttsService = TtsService();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load sentences from API on screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MuseumCubit>().loadSentencesForPlace(widget.place.id);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Trigger at 70% of scroll extent
    if (maxScroll > 0 && currentScroll >= maxScroll * 0.7) {
      _loadMoreSentences();
    }
  }

  void _loadMoreSentences() {
    final state = context.read<MuseumCubit>().state;
    if (state is MuseumLoaded &&
        !state.isGeneratingSentences &&
        !state.isLoadingSentencesFromApi) {
      final currentPlace = (state.selectedPlace?.id == widget.place.id)
          ? state.selectedPlace!
          : widget.place;

      context.read<MuseumCubit>().loadMoreSentences(currentPlace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: BlocConsumer<MuseumCubit, MuseumState>(
        listener: (context, state) {
          if (state is MuseumLoaded && state.sentenceError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.sentenceError!),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          // Use the latest version of the place from the state if available
          final currentPlace =
              (state is MuseumLoaded &&
                  state.selectedPlace?.id == widget.place.id)
              ? state.selectedPlace!
              : widget.place;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(currentPlace),
              _buildDescription(currentPlace),
              _buildSentencesList(currentPlace),
              _buildLoadMoreButton(state, currentPlace),
              SliverPadding(padding: EdgeInsets.only(bottom: 30.h)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(MuseumPlaceModel place) {
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      backgroundColor: AppColors.primaryNavy,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: CircleAvatar(
          backgroundColor: Colors.black.withValues(alpha: 0.4),
          child: const BackButton(color: AppColors.accentGold),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.4),
            child: IconButton(
              icon: const Icon(Icons.add, color: AppColors.accentGold),
              onPressed: () => _showAddSentenceDialog(context, place),
              tooltip: 'add_custom_sentence'.tr(),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          place.localizedNames['ar'] ?? place.name,
          style: AppTextStyles.arabicTitle.copyWith(
            fontSize: 20.sp,
            shadows: [
              Shadow(
                blurRadius: 15.0,
                color: Colors.black,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'place_${place.id}',
              child: CachedNetworkImage(
                imageUrl: place.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.primaryNavy,
                  highlightColor: AppColors.primaryDeep,
                  child: Container(color: AppColors.primaryNavy),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.primaryNavy,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white24,
                    size: 50,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    AppColors.primaryDark.withValues(alpha: 0.6),
                    AppColors.primaryDark,
                  ],
                  stops: const [0.0, 0.4, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(MuseumPlaceModel place) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
        child: Column(
          children: [
            Text(
              place.localizedNames[context.locale.languageCode]
                      ?.toUpperCase() ??
                  '',
              style: AppTextStyles.displayMedium.copyWith(
                fontSize: 24.sp,
                color: AppColors.accentGold,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),

            SizedBox(height: 20.h),

            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    place.localizedDescriptions['ar'] ?? place.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      height: 1.8,
                      color: Colors.white.withValues(alpha: 0.95),
                      fontFamily: 'NotoKufiArabic',
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    thickness: 1,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    place.localizedDescriptions[context.locale.languageCode] ??
                        '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),

            SizedBox(height: 30.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.accentCyan,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  "interactive_learning".tr(),
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.accentCyan,
                    fontSize: 16.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSentencesList(MuseumPlaceModel place) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final object = place.objects[index];
        final arText = object.localizedNames['ar'] ?? object.arabicName;
        final translatedText =
            object.localizedNames[context.locale.languageCode] ??
            object.englishTranslation;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(
                  height: 180.h,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: object.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.primaryDeep,
                          child: const Center(
                            child: CustomLoadingWidget(size: 30),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primaryDeep,
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80.h,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12.h,
                        left: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: AppColors.accentGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              arText,
                              textAlign: TextAlign.right,

                              style: AppTextStyles.arabicTitle.copyWith(
                                fontSize: 22.sp,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildAudioButton(
                            () => _ttsService.speak(arText, language: 'ar-SA'),
                            AppColors.accentGold,
                            Colors.black,
                          ),
                        ],
                      ),

                      Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        height: 30.h,
                      ),

                      Row(
                        children: [
                          _buildAudioButton(
                            () => _ttsService.speak(
                              translatedText,
                              language: _ttsService.getTtsLanguage(
                                context.locale.languageCode,
                              ),
                            ),
                            Colors.white.withValues(alpha: 0.1),
                            AppColors.accentCyan,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              translatedText,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white70,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0);
      }, childCount: place.objects.length),
    );
  }

  Widget _buildAudioButton(
    VoidCallback onPressed,
    Color bgColor,
    Color iconColor,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.volume_up_rounded, color: iconColor, size: 24.sp),
      ),
    );
  }

  Widget _buildLoadMoreButton(MuseumState state, MuseumPlaceModel place) {
    final isLoading = (state is MuseumLoaded && state.isGeneratingSentences);

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
        child: isLoading
            ? const Center(child: CustomLoadingWidget())
            : OutlinedButton.icon(
                onPressed: () => _loadMoreSentences(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.accentGold),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: AppColors.primaryNavy.withValues(alpha: 0.5),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.accentGold,
                ),
                label: Text(
                  "load_more".tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.accentGold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }

  void _showAddSentenceDialog(BuildContext context, MuseumPlaceModel place) {
    final TextEditingController promptController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.primaryNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Center(
          child: Text(
            "add_custom_action".tr(),
            style: AppTextStyles.h3.copyWith(color: AppColors.accentGold),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "type_action_hint".tr(),
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            TextField(
              controller: promptController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "action_hint_example".tr(),
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.3),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 16.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.accentGold),
                ),
              ),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    "cancel".tr(),
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onPressed: () {
                    final text = promptController.text.trim();
                    if (text.isNotEmpty) {
                      context.read<MuseumCubit>().createSentenceForPlace(
                        place,
                        text,
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(
                    "generate".tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
