import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/traditions/presentation/cubit/tradition_cubit.dart';
import 'package:arabic/features/traditions/presentation/cubit/tradition_state.dart';

class TraditionsError extends StatelessWidget {
  final String errorMessage;
  final TraditionState traditionState;

  const TraditionsError({
    super.key,
    required this.errorMessage,
    required this.traditionState,
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
              'Error loading traditions data',
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              traditionState.errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () =>
                  context.read<TraditionCubit>().loadTraditions('en'),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
