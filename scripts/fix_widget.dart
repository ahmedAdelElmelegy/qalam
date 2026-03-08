import 'dart:io';

void main() {
  final file = File('lib/features/curriculum/presentation/view/screens/lesson_content_screen.dart');
  String content = file.readAsStringSync();

  final regex = RegExp(r'Widget _buildListCard\(\{[\s\S]*?\}\)\.animate\(\)\.fadeIn\(delay: Duration\(milliseconds: 300 \+ \(index \* 100\)\)\)\)\.slideY\(begin: 0\.1, end: 0\);\n  \}');
  
  final replacement = '''
  Widget _buildListCard({
    required String arabic,
    required String transliteration,
    required String translation,
    String? explanation,
    bool isSentence = false,
    int index = 0,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  arabic,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.arabicBody.copyWith(
                    color: Colors.white,
                    fontSize: isSentence ? 22.sp : 38.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.6,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              IconButton(
                onPressed: () => _speak(arabic, language: "ar-SA"),
                icon: Icon(
                  Icons.volume_up_rounded,
                  color: const Color(0xFFD4AF37),
                  size: 28.w,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (!isSentence && transliteration.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                transliteration,
                textAlign: TextAlign.right,
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFFD4AF37).withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
          SizedBox(height: 20.h),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.white.withOpacity(0.1),
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => _speak(translation, language: "en-US"),
                icon: Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white.withOpacity(0.6),
                  size: 24.w,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  translation,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w600,
                    fontSize: isSentence ? 16.sp : 20.sp,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          if (explanation != null && explanation.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: const Color(0xFFD4AF37),
                    size: 16.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      explanation,
                      textAlign: TextAlign.left,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                        fontSize: 13.sp,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 300 + (index * 100))).slideY(begin: 0.1, end: 0);
  }
''';

  content = content.replaceFirst(regex, replacement);
  file.writeAsStringSync(content);
}
