import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_cubit.dart';

class AddCustomPlaceDialog extends StatefulWidget {
  const AddCustomPlaceDialog({super.key});

  @override
  State<AddCustomPlaceDialog> createState() => _AddCustomPlaceDialogState();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const AddCustomPlaceDialog(),
    );
  }
}

class _AddCustomPlaceDialogState extends State<AddCustomPlaceDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryNavy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "generate_custom_place".tr(),
        style: AppTextStyles.h3.copyWith(color: AppColors.accentGold),
      ),
      content: TextField(
        controller: _controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "custom_place_hint".tr(),
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.accentGold),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("cancel".tr(), style: const TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGold,
          ),
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isNotEmpty) {
              context.read<MuseumCubit>().createPlace(text);
              Navigator.pop(context);
            }
          },
          child: Text("generate".tr(), style: const TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
