import json
from collections import defaultdict

def check_duplicates():
    try:
        with open('assets/data/c2.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        content_groups = defaultdict(list)
        
        for unit in data.get('units', []):
            for lesson in unit.get('lessons', []):
                content = lesson.get('content', [])
                arabic_strings = tuple(sorted([item.get('arabic', '') for item in content]))
                if arabic_strings:
                    content_groups[arabic_strings].append(f"{unit['id']} - {lesson['id']} ({lesson['title']['en']})")
        
        duplicates_found = False
        for arabic_set, lessons in content_groups.items():
            if len(lessons) > 1:
                duplicates_found = True
                print(f"Duplicate Content Found in {len(lessons)} lessons:")
                for l in lessons:
                    print(f"  - {l}")
                print("-" * 20)
        
        if not duplicates_found:
            print("No duplicate content sets found across lessons.")
            
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_duplicates()
