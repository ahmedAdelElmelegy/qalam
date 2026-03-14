import json
import random

def update_quizzes():
    try:
        with open('assets/data/c2.json', 'r', encoding='utf-8') as f:
            data = json.load(f)

        for unit in data.get('units', []):
            for lesson in unit.get('lessons', []):
                content = lesson.get('content', [])
                words = [item for item in content if item.get('type') == 'word']
                sentences = [item for item in content if item.get('type') == 'sentence']

                # We need 10 words and 5 sentences for the format
                if len(words) < 10 or len(sentences) < 5:
                    print(f"Warning: Lesson {lesson['id']} has insufficient content (W:{len(words)}, S:{len(sentences)})")
                    # Use what we have, but ideally they should have enough
                
                questions = []
                # Combine them: first 10 questions are words, next 5 are sentences
                quiz_items = words[:10] + sentences[:5]

                for i, item in enumerate(quiz_items):
                    idx = i + 1  # 1-indexed for logic
                    q_id = f"q_{lesson['id']}_{idx}"
                    q_type = ""
                    
                    # Sequence: MCQ (1, 5, 9, 13), Audio (2, 6, 10, 14), Speaking (3, 7, 11, 15), Listening (4, 8, 12)
                    if idx in [1, 5, 9, 13]:
                        q_type = "multipleChoice"
                    elif idx in [2, 6, 10, 14]:
                        q_type = "audioOptions"
                    elif idx in [3, 7, 11, 15]:
                        q_type = "speaking"
                    elif idx in [4, 8, 12]:
                        q_type = "listening"

                    correct_ans = item['arabic']
                    
                    # Generate options
                    options = []
                    if q_type != "speaking":
                        # Pool for distractors: same type (word/sentence) from the same lesson
                        pool = words if item['type'] == 'word' else sentences
                        distractors = [p['arabic'] for p in pool if p['arabic'] != correct_ans]
                        
                        # If pool is too small, fallback to the other type
                        if len(distractors) < 3:
                            other_pool = sentences if item['type'] == 'word' else words
                            distractors += [p['arabic'] for p in other_pool if p['arabic'] not in distractors and p['arabic'] != correct_ans]
                        
                        # Final selection
                        final_options = random.sample(distractors, min(len(distractors), 3))
                        options = final_options + [correct_ans]
                        random.shuffle(options)

                    question = {
                        "id": q_id,
                        "type": q_type,
                        "correctAnswer": correct_ans
                    }

                    if options:
                        question["options"] = options

                    # Handle 'text' field
                    if q_type == "multipleChoice":
                        # MCQ needs the translation prompt
                        trans = item.get('translation', {})
                        question["text"] = {
                            "en": f"Translate: {trans.get('en', '')}",
                            "ar": f"ترجم: {correct_ans}",
                            "fr": f"Traduire : {trans.get('fr', '')}",
                            "de": f"Übersetzen: {trans.get('de', '')}",
                            "ru": f"Перевести: {trans.get('ru', '')}",
                            "zh": f"翻译: {trans.get('zh', '')}"
                        }
                    else:
                        # Others just the Arabic string
                        question["text"] = correct_ans

                    # Audio URL for specific types
                    if q_type in ["audioOptions", "listening"]:
                        question["audioUrl"] = "true"

                    questions.append(question)

                lesson['quiz'] = {
                    "id": f"q_{lesson['id']}_quiz",
                    "questions": questions
                }

        with open('assets/data/c2.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4, ensure_ascii=False)
        print("Successfully updated all quizzes in c2.json")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    update_quizzes()
