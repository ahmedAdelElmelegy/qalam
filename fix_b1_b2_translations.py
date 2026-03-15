import json
import os

def fix_translations(file_path):
    print(f"Processing {file_path}...")
    if not os.path.exists(file_path):
        print(f"File {file_path} not found.")
        return

    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # 1. Build Translation Map from lesson content
    translation_map = {
        "بناء السلام": {"en": "Peacebuilding", "fr": "Consolidation de la paix", "de": "Friedenskonsolidierung", "ru": "Миростроительство", "zh": "和平建设"},
        "سياحة التطوع": {"en": "Voluntourism", "fr": "Volontourisme", "de": "Voluntourismus", "ru": "Волонтерский туризм", "zh": "义工旅行"},
        "الوعي العاطفي": {"en": "Emotional Awareness", "fr": "Conscience émotionnelle", "de": "Emotionales Bewusstsein", "ru": "Эмоциональная осознанность", "zh": "情感意识"},
        "تكنولوجيا": {"en": "Technology", "fr": "Technologie", "de": "Technologie", "ru": "Технология", "zh": "技术"}
    }
    for unit in data.get('units', []):
        for lesson in unit.get('lessons', []):
            for item in lesson.get('content', []):
                arabic = item.get('arabic')
                translation = item.get('translation')
                if arabic and translation:
                    translation_map[arabic] = translation

    prompts = {
        'en': 'Translate: ',
        'ar': 'ترجم: ',
        'fr': 'Traduire : ',
        'de': 'Übersetzen: ',
        'ru': 'Перевести: ',
        'zh': '翻译: '
    }

    def process_questions(questions):
        fixed_count = 0
        for q in questions:
            if q.get('type') == 'multipleChoice':
                ans = q.get('correctAnswer')
                trans = translation_map.get(ans, {})
                
                new_text = {}
                for lang, prompt in prompts.items():
                    # Fallback chain: translation map -> the answer itself
                    val = trans.get(lang, ans)
                    
                    # Sanity check: if val is still empty or somehow corrupted
                    if not val: val = ans
                    
                    new_text[lang] = f"{prompt}{val}"
                
                q['text'] = new_text
                fixed_count += 1
        return fixed_count

    # 2. Fix Unit Lesson Quizzes
    total_fixed = 0
    for unit in data.get('units', []):
        for lesson in unit.get('lessons', []):
            quiz = lesson.get('quiz', {})
            total_fixed += process_questions(quiz.get('questions', []))

    # 3. Fix levelQuiz
    if 'levelQuiz' in data:
        total_fixed += process_questions(data['levelQuiz'].get('questions', []))

    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
    
    print(f"Successfully updated {file_path}. Fixed {total_fixed} questions.")

if __name__ == "__main__":
    fix_translations('assets/data/b1.json')
    fix_translations('assets/data/b2.json')
