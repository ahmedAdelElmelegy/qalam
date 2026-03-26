import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/history/presentation/cubit/history_cubit.dart';
import 'package:arabic/features/history/presentation/cubit/history_state.dart';

class HistoryError extends StatelessWidget {
  final String errorMessage;
  final HistoryState historyState;

  const HistoryError({
    super.key,
    required this.errorMessage,
    required this.historyState,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48.w),
            SizedBox(height: 16.h),
            Text(
              'Error loading history data',
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              historyState.errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.read<HistoryCubit>().loadHistory(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
