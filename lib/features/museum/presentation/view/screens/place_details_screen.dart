import 'package:arabic/core/helpers/show_snake_bar.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/museum/presentation/view/widgets/museum_error_dialog.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/features/museum/data/models/museum_place_model.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_cubit.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/add_sentence_dialog.dart';
import '../widgets/place_description.dart';
import '../widgets/place_details_app_bar.dart';
import '../widgets/place_load_more_button.dart';
import '../widgets/place_sentences_list.dart';

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
        listener: (context, state) async {
          if (state is MuseumLoaded && state.sentenceError != null) {
            final hasConnection = await NetworkChecker.hasConnection();
            if (!context.mounted) return;

            if (!hasConnection) {
              NetworkChecker.showNoNetworkDialog(context);
            } else {
              // Decide between Dialog and SnackBar based on list completeness
              final currentPlace = (state.selectedPlace?.id == widget.place.id)
                  ? state.selectedPlace!
                  : widget.place;

              if (currentPlace.objects.isEmpty) {
                MuseumErrorDialog.show(
                  context,
                  state.sentenceError!,
                  onRetry: () {
                    context.read<MuseumCubit>().loadSentencesForPlace(currentPlace.id);
                  },
                );
              } else {
                AppSnakeBar.showErrorMessage(context, state.sentenceError!);
              }
            }
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
              PlaceDetailsAppBar(
                place: currentPlace,
                onAddPressed: () => AddSentenceDialog.show(context, currentPlace),
              ),
              PlaceDescription(place: currentPlace),
              PlaceSentencesList(
                place: currentPlace,
                ttsService: _ttsService,
              ),
              PlaceLoadMoreButton(
                isLoading: state is MuseumLoaded && state.isGeneratingSentences,
                onLoadMore: _loadMoreSentences,
              ),
              SliverPadding(padding: EdgeInsets.only(bottom: 30.h)),
            ],
          );
        },
      ),
    );
  }
}
