import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_cubit.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_state.dart';

class PenpalErrorBanner extends StatelessWidget {
  const PenpalErrorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PenpalCubit, PenpalState>(
      buildWhen: (prev, current) => prev.error != current.error,
      builder: (context, state) {
        if (state.error == null) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(
              alpha: 0.9,
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.2,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  state.error!.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
                onPressed: () => context.read<PenpalCubit>().clearError(),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }
}
