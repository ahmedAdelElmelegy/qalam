import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/chat/presentation/manager/chat_cubit.dart';
import 'package:arabic/features/chat/data/models/chat_model.dart'; // Ensure RoleplayScenario is imported, might need to adjust import if not here

class ChatToolsRow extends StatelessWidget {
  const ChatToolsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          SizedBox(width: 8.w),
          _buildToolChip(
            label: 'Scenarios',
            isActive: false,
            onTap: () => _showScenarioSelector(context),
            icon: Icons.theater_comedy_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildToolChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isActive ? const Color(0xFFD4AF37) : Colors.white12,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFD4AF37) : Colors.white70,
              size: 16,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFD4AF37) : Colors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScenarioSelector(BuildContext context) {
    final scenarios = [
      RoleplayScenario(
        id: 'restaurant',
        title: 'At the Restaurant',
        description: 'Order your favorite meal and ask for the bill.',
        roleAi: 'The Waiter',
        roleUser: 'The Customer',
        initialMessage: 'أهلاً بك في مطعمنا! ماذا تحب أن تأكل اليوم؟',
        goal: 'Order food and pay the check.',
        targetVocab: ['قائمة الطعام', 'الحساب', 'لذيذ', 'أريد'],
      ),
      RoleplayScenario(
        id: 'airport',
        title: 'At the Airport',
        description: 'Check in for your flight and ask about your gate.',
        roleAi: 'Airport Staff',
        roleUser: 'Passenger',
        initialMessage: 'مرحباً! هل يمكنني رؤية جواز سفرك من فضلك؟',
        goal: 'Check-in and find the boarding gate.',
        targetVocab: ['جواز سفر', 'بوابة', 'رحلة', 'حقيبة'],
      ),
      RoleplayScenario(
        id: 'doctor',
        title: 'Visiting the Doctor',
        description: 'Explain your symptoms and get a prescription.',
        roleAi: 'The Doctor',
        roleUser: 'The Patient',
        initialMessage: 'سلامتك! مم تشكو اليوم؟',
        goal: 'Describe health issues and get advice.',
        targetVocab: ['ألم', 'دواء', 'حرارة', 'أشعر بـ'],
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          border: const Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose a Scenario', style: AppTextStyles.h4),
            SizedBox(height: 16.h),
            ...scenarios.map(
              (s) => ListTile(
                title: Text(
                  s.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  s.description,
                  style: const TextStyle(color: Colors.white54),
                ),
                trailing: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFFD4AF37),
                ),
                onTap: () {
                  context.read<ChatCubit>().startScenario(s);
                  Navigator.pop(bottomSheetContext);
                },
              ),
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(
                Icons.add_circle_outline_rounded,
                color: Color(0xFFD4AF37),
              ),
              title: const Text(
                'Custom Scenario',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Describe any situation (e.g., "At the barbershop")',
                style: TextStyle(color: Colors.white54),
              ),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _showCustomScenarioDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomScenarioDialog(BuildContext context) {
    final TextEditingController customController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
            side: const BorderSide(color: Colors.white12),
          ),
          title: Text('Custom AI Scenario', style: AppTextStyles.h4),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tell the AI where you want to be or who you want to talk to.',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: customController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g., Buying a plane ticket...',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                if (customController.text.trim().isNotEmpty) {
                  context.read<ChatCubit>().generateAndStartScenario(
                    customController.text.trim(),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text(
                'Generate',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
