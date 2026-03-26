// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:arabic/core/theme/style.dart';
// import 'package:arabic/features/chat/data/models/chat_model.dart';

// class ChatMessageBubble extends StatelessWidget {
//   final ChatMessage message;
//   final void Function(String) onSpeak;

//   const ChatMessageBubble({
//     super.key,
//     required this.message,
//     required this.onSpeak,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isUser = message.role == MessageRole.user;
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child:
//           Column(
//             crossAxisAlignment: isUser
//                 ? CrossAxisAlignment.end
//                 : CrossAxisAlignment.start,
//             children: [
//               Container(
//                 constraints: BoxConstraints(maxWidth: 0.75.sw),
//                 margin: EdgeInsets.only(bottom: 8.h),
//                 padding: EdgeInsets.all(16.w),
//                 decoration: BoxDecoration(
//                   color: isUser
//                       ? const Color(0xFF6366F1).withValues(alpha: 0.2)
//                       : Colors.white.withValues(alpha: 0.08),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(24.r),
//                     topRight: Radius.circular(24.r),
//                     bottomLeft: isUser ? Radius.circular(24.r) : Radius.zero,
//                     bottomRight: isUser ? Radius.zero : Radius.circular(24.r),
//                   ),
//                   border: Border.all(
//                     color: isUser
//                         ? const Color(0xFF6366F1).withValues(alpha: 0.3)
//                         : Colors.white12,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             message.content,
//                             style: AppTextStyles.arabicBody.copyWith(
//                               color: Colors.white,
//                               fontSize: 16.sp,
//                               height: 1.5,
//                             ),
//                             textDirection: TextDirection.rtl,
//                           ),
//                         ),
//                         if (!isUser)
//                           IconButton(
//                             icon: const Icon(
//                               Icons.volume_up_rounded,
//                               color: Color(0xFFD4AF37),
//                               size: 20,
//                             ),
//                             onPressed: () => onSpeak(message.content),
//                             padding: EdgeInsets.zero,
//                             constraints: const BoxConstraints(),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ).animate().fadeIn().slideY(
//             begin: 0.1,
//             end: 0,
//             curve: Curves.easeOutQuad,
//           ),
//     );
//   }
// }
