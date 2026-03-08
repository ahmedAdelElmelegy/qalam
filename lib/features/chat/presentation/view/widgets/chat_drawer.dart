import 'dart:io';
import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_cubit.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_state.dart';
import 'package:arabic/features/chat/data/models/chat_session_model.dart';

class ChatDrawer extends StatefulWidget {
  const ChatDrawer({super.key});

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  String? _localName;
  String? _localEmail;
  String? _localImage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final name = await LocalStorage.getUserFullName();
    final email = await LocalStorage.getUserEmail();
    final image = await LocalStorage.getUserProfileImage();
    final userId = await LocalStorage.getEmailId();

    if (mounted) {
      setState(() {
        _localName = name;
        _localEmail = email;
        _localImage = image;
      });

      // Trigger a fresh fetch if we have a userId
      if (userId != null && userId != 0) {
        context.read<GetProfileCubit>().getProfile(userId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent, // Let stack handle background
      width: 280.w,
      child: Stack(
        children: [
          // Deep slate solid background for the drawer itself
          Positioned.fill(child: Container(color: const Color(0xFF1E293B))),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                SizedBox(height: 10.h),
                _buildNewChatButton(context),
                SizedBox(height: 20.h),
                Expanded(
                  child: BlocBuilder<PenpalCubit, PenpalState>(
                    builder: (context, state) {
                      if (state.sessions.isEmpty) {
                        return _buildEmptyState();
                      }
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: state.sessions.length,
                        itemBuilder: (context, index) {
                          final session = state.sessions[index];
                          return _buildSessionTile(
                            context,
                            session,
                            state.activeSession?.id == session.id,
                          );
                        },
                      );
                    },
                  ),
                ),
                // Footer actions removed as per user request
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<GetProfileCubit, GetProfileState>(
      builder: (context, state) {
        String? displayName = _localName;
        String? displayEmail = _localEmail;
        ImageProvider? imageProvider;

        if (state is GetProfileSuccess) {
          displayName = state.profile.fullName;
          displayEmail = state.profile.email;

          if (state.profile.image != null && state.profile.image!.isNotEmpty) {
            imageProvider = NetworkImage(
              '${AppURL.imagePath}${state.profile.image}',
            );
          } else if (state.profile.imageFile != null &&
              state.profile.imageFile!.isNotEmpty) {
            imageProvider = FileImage(File(state.profile.imageFile!));
          }
        }

        // Fallback to local image if cubit hasn't loaded or doesn't have an image
        if (imageProvider == null &&
            _localImage != null &&
            _localImage!.isNotEmpty) {
          if (_localImage!.startsWith('http')) {
            imageProvider = NetworkImage(_localImage!);
          } else {
            imageProvider = FileImage(File(_localImage!));
          }
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accentGold.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  image: imageProvider != null
                      ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                      : const DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayName ?? 'profile'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.h4.copyWith(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      displayEmail ?? 'Qalam Learner',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white60,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewChatButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        onTap: () {
          context.read<PenpalCubit>().createNewSession();
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 22.sp),
              SizedBox(width: 12.w),
              Text(
                'new_chat'.tr(),
                style: AppTextStyles.buttonMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionTile(
    BuildContext context,
    ChatSessionModel session,
    bool isActive,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: () {
            context.read<PenpalCubit>().setActiveSession(session.id);
          },
          onLongPress: () => _showDeleteConfirmation(context, session),
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          tileColor: isActive
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.transparent,
          leading: Icon(
            isActive
                ? Icons.chat_bubble_rounded
                : Icons.chat_bubble_outline_rounded,
            color: isActive ? AppColors.accentGold : Colors.white38,
            size: 18.sp,
          ),
          title: Text(
            session.title.isEmpty || session.title == 'new_chat'
                ? 'ai_chat'.tr()
                : session.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isActive ? Colors.white : Colors.white70,
              fontSize: 14.sp,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          trailing: isActive
              ? IconButton(
                  onPressed: () => _showDeleteConfirmation(context, session),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white38,
                    size: 18.sp,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              : null,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ChatSessionModel session) {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            content: GlassContainer(
              width: 0.85.sw,
              padding: EdgeInsets.all(24.w),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE94560).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: const Color(0xFFE94560),
                      size: 32.w,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'delete_chat'.tr(),
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'delete_chat_confirm'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            'cancel'.tr(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white38,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<PenpalCubit>().deleteSession(
                              session.id,
                            );
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94560),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'delete'.tr(),
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'no_chats_yet'.tr(),
        style: AppTextStyles.bodySmall.copyWith(color: Colors.white30),
      ),
    );
  }
}
