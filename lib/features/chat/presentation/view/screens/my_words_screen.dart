import 'package:arabic/features/chat/presentation/manager/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/features/chat/presentation/manager/chat_state.dart';
import 'package:arabic/features/chat/data/models/chat_model.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:arabic/core/theme/style.dart';

class MyWordsScreen extends StatelessWidget {
  const MyWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(child: _buildVocabList()),
                  _buildReviewButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'My Vocabulary',
            style: AppTextStyles.h4.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabList() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoaded) {
          final words = state.myWords;
          if (words.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: words.length,
            itemBuilder: (context, index) => _buildVocabCard(words[index]),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_stories_rounded, color: Colors.white24, size: 64.w),
          SizedBox(height: 16.h),
          Text(
            'No words saved yet.',
            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white54),
          ),
          SizedBox(height: 8.h),
          Text(
            'Chat with the AI to extract new terms!',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabCard(VocabItem word) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                word.term,
                style: AppTextStyles.arabicBody.copyWith(
                  color: const Color(0xFFD4AF37),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  word.meaning,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            word.example,
            style: AppTextStyles.arabicBody.copyWith(
              color: Colors.white70,
              fontSize: 14.sp,
              fontStyle: FontStyle.italic,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }

  Widget _buildReviewButton() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37),
          foregroundColor: Colors.black,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 8,
        ),
        onPressed: () {
          // Launch Quick Review Quiz
        },
        child: const Text(
          'Start Quick Review',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
