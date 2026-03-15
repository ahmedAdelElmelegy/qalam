import json
import re

def check_b2_json(file_path):
    issues = {
        "missing_translations": [],
        "placeholder_dots": [],
        "option_parity_mismatch": [],
        "trailing_periods": [],
        "duplicate_ids": set(),
        "all_ids": set()
    }
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        return f"Error loading JSON: {e}"

    def check_question(q, context):
        # Check for placeholder dots or incomplete translations
        if isinstance(q.get('text'), dict):
            for lang, val in q['text'].items():
                if "..." in val or val.strip().endswith(":"):
                    issues["placeholder_dots"].append(f"ID: {q.get('id')} - {lang}: {val} ({context})")
        
        # Check option parity (Word vs Sentence)
        if 'options' in q and q.get('correctAnswer'):
            ans = q['correctAnswer']
            ans_is_sentence = ' ' in ans.strip()
            for opt in q['options']:
                opt_is_sentence = ' ' in opt.strip()
                if ans_is_sentence != opt_is_sentence:
                    issues["option_parity_mismatch"].append(f"ID: {q.get('id')} - Ans: '{ans}' vs Opt: '{opt}' ({context})")
                    break

        # Check for trailing periods in Arabic or English
        if isinstance(q.get('text'), dict):
             for lang, val in q['text'].items():
                 if val.strip().endswith('.'):
                     issues["trailing_periods"].append(f"ID: {q.get('id')} - {lang}: {val} ({context})")
        elif isinstance(q.get('text'), str):
            if q['text'].strip().endswith('.'):
                issues["trailing_periods"].append(f"ID: {q.get('id')} - {q['text']} ({context})")

        # Duplicate ID check
        qid = q.get('id')
        if qid:
            if qid in issues["all_ids"]:
                issues["duplicate_ids"].add(qid)
            issues["all_ids"].add(qid)

    # Traverse Data
    for unit in data.get('units', []):
        for lesson in unit.get('lessons', []):
            quiz = lesson.get('quiz', {})
            for q in quiz.get('questions', []):
                check_question(q, f"Lesson: {lesson.get('id')}")
        
        unit_quiz = unit.get('unitQuiz', {})
        for q in unit_quiz.get('questions', []):
            check_question(q, f"Unit Quiz: {unit.get('id')}")

    if 'levelQuiz' in data:
        for q in data['levelQuiz'].get('questions', []):
            check_question(q, "Level Quiz")

    return issues

if __name__ == "__main__":
    results = check_b2_json('assets/data/b2.json')
    
    print("--- Diagnostic Results for b2.json ---")
    print(f"Total Questions Checked: {len(results['all_ids'])}")
    print(f"Duplicate IDs: {len(results['duplicate_ids'])}")
    if results['duplicate_ids']:
        print(f" - {list(results['duplicate_ids'])[:10]}")
    
    print(f"Placeholder Dots/Incomplete: {len(results['placeholder_dots'])}")
    if results['placeholder_dots']:
        for p in results['placeholder_dots'][:10]: print(f" - {p}")
        
    print(f"Option Parity Mismatches: {len(results['option_parity_mismatch'])}")
    if results['option_parity_mismatch']:
        for m in results['option_parity_mismatch'][:10]: print(f" - {m}")

    print(f"Trailing Periods: {len(results['trailing_periods'])}")
    if results['trailing_periods']:
        for tp in results['trailing_periods'][:10]: print(f" - {tp}")
