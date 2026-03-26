import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'lesson_letter_block.dart';
import 'lesson_sentence_block.dart';
import 'lesson_word_block.dart';

class LessonContentBlocksBuilder extends StatelessWidget {
  final List<ContentBlock> blocks;
  final String locale;
  final String? activeSpeakingId;
  final Future<void> Function(String, {String language, String? id}) onSpeak;
  final bool isWide;

  const LessonContentBlocksBuilder({
    super.key,
    required this.blocks,
    required this.locale,
    required this.activeSpeakingId,
    required this.onSpeak,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    if (blocks.isEmpty) return const SizedBox.shrink();

    if (isWide) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.w,
          mainAxisSpacing: 20.h,
          mainAxisExtent: 220.h,
        ),
        itemCount: blocks.length,
        itemBuilder: (context, index) {
          return _buildBlockWidget(blocks[index], index);
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: blocks.asMap().entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildBlockWidget(entry.value, entry.key),
        );
      }).toList(),
    );
  }

  Widget _buildBlockWidget(ContentBlock block, int index) {
    switch (block.type) {
      case ContentBlockType.letter:
        return LessonLetterBlockWidget(
          block: block as LetterBlock,
          index: index,
          locale: locale,
          activeSpeakingId: activeSpeakingId,
          onSpeak: onSpeak,
        );
      case ContentBlockType.word:
        return LessonWordBlockWidget(
          block: block as WordBlock,
          index: index,
          locale: locale,
          activeSpeakingId: activeSpeakingId,
          onSpeak: onSpeak,
        );
      case ContentBlockType.sentence:
        return LessonSentenceBlockWidget(
          block: block as SentenceBlock,
          index: index,
          locale: locale,
          activeSpeakingId: activeSpeakingId,
          onSpeak: onSpeak,
        );
    }
  }
}
