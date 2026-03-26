import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/museum/data/models/museum_place_model.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_cubit.dart';

class AddSentenceDialog extends StatefulWidget {
  final MuseumPlaceModel place;

  const AddSentenceDialog({super.key, required this.place});

  @override
  State<AddSentenceDialog> createState() => _AddSentenceDialogState();
  
  static void show(BuildContext context, MuseumPlaceModel place) {
    showDialog(
      context: context,
      builder: (ctx) => AddSentenceDialog(place: place),
    );
  }
}

class _AddSentenceDialogState extends State<AddSentenceDialog> {
  final TextEditingController _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            controller: _promptController,
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
                onPressed: () => Navigator.pop(context),
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
                  final text = _promptController.text.trim();
                  if (text.isNotEmpty) {
                    context.read<MuseumCubit>().createSentenceForPlace(
                      widget.place,
                      text,
                    );
                    Navigator.pop(context);
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
    );
  }
}
