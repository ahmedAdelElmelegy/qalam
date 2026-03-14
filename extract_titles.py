import json

def extract():
    try:
        with open('assets/data/c2.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        results = []
        for unit in data.get('units', []):
            unit_info = {
                'unit_id': unit.get('id'),
                'unit_title': unit.get('title', {}).get('en'),
                'unit_desc': unit.get('description', {}).get('en'),
                'lessons': []
            }
            for lesson in unit.get('lessons', []):
                unit_info['lessons'].append({
                    'lesson_id': lesson.get('id'),
                    'lesson_title': lesson.get('title', {}).get('en')
                })
            results.append(unit_info)
        
        with open('extracted_metadata.json', 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)
        print("Successfully extracted metadata to extracted_metadata.json")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    extract()
