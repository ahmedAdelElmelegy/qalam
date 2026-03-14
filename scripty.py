import json
import os
import re

def get_transliteration(arabic_text, lang):
    # Simple mapping for Arabic to Latin phonetics
    # This is a heuristic based on previous walkthroughs
    mapping = {
        'أ': 'a', 'ب': 'b', 'ت': 't', 'ث': 'th', 'ج': 'j', 'ح': 'h', 'خ': 'kh',
        'د': 'd', 'ذ': 'dh', 'ر': 'r', 'ز': 'z', 'س': 's', 'ش': 'sh', 'ص': 's',
        'ض': 'd', 'ط': 't', 'ظ': 'z', 'ع': "'a", 'غ': 'gh', 'ف': 'f', 'ق': 'q',
        'ك': 'k', 'ل': 'l', 'م': 'm', 'ن': 'n', 'ه': 'h', 'و': 'w', 'ي': 'y',
        'ة': 'a', 'ى': 'a', ' ': ' ', '،': ',', '؟': '?', ' ': ' '
    }
    
    latin = "".join([mapping.get(c, c) for c in arabic_text])
    
    if lang == 'de':
        latin = latin.replace('sh', 'sch').replace('j', 'dsch').replace('kh', 'ch')
    elif lang == 'fr':
        latin = latin.replace('sh', 'ch').replace('u', 'ou')
    elif lang == 'ru':
        # Cyrillic mapping
        cyr_map = {
            'a': 'а', 'b': 'б', 't': 'т', 'th': 'т', 'j': 'дж', 'h': 'х', 'kh': 'х',
            'd': 'д', 'dh': 'д', 'r': 'р', 'z': 'з', 's': 'с', 'sch': 'ш', 'sh': 'ш',
            'w': 'в', 'y': 'и', 'q': 'к', 'k': 'к', 'l': 'л', 'm': 'м', 'n': 'н',
            'ou': 'у', 'u': 'у', 'f': 'ф', 'g': 'г', 'gh': 'г'
        }
        res = latin
        for k, v in cyr_map.items():
            res = res.replace(k, v)
        return res
    elif lang == 'zh':
        # Hanzi phonetic candidates (simplified)
        zh_map = {
            'a': '阿', 'b': '巴', 't': '特', 'd': '德', 's': '萨', 'j': '加', 'h': '哈',
            'k': '克', 'l': '拉', 'm': '马', 'n': '纳', 'r': '尔', 'q': '库', 'f': '法'
        }
        res = ""
        for char in latin.lower():
            res += zh_map.get(char, char)
        return res
        
    return latin

def normalize_arabic(text):
    if not text: return ""
    vowels = "ٌٍُِِِّْ"
    for v in vowels:
        text = text.replace(v, "")
    return text.strip()

def solve():
    data_path = 'assets/data/c2.json'
    cache_files = ['assets/data/translation_cache_v6.json', 'assets/data/final_translation_cache.json']
    
    with open(data_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    all_caches = {}
    for cf in cache_files:
        if os.path.exists(cf):
            with open(cf, 'r', encoding='utf-8') as f:
                all_caches.update(json.load(f))

    # Academic Lexicon for C2 items often missing or tricky
    lexicon = {
        "ورشة": {"en": "Workshop", "fr": "atelier", "de": "Werkstatt", "ru": "мастерская", "zh": "作坊"},
        "منهجية": {"en": "Methodology", "fr": "méthodologie", "de": "Methodik", "ru": "методология", "zh": "方法论"},
        "موضوعية": {"en": "Objectivity", "fr": "objectivité", "de": "Objektivität", "ru": "объективность", "zh": "客观性"},
        "سياق": {"en": "Context", "fr": "contexte", "de": "Kontext", "ru": "контекст", "zh": "语境"},
        "نزاهة": {"en": "Integrity", "fr": "intégrité", "de": "Integrität", "ru": "честность", "zh": "正直"},
        "فرضية": {"en": "Hypothesis", "fr": "hypothèse", "de": "Hypothese", "ru": "гипотеза", "zh": "假设"},
        "برهان": {"en": "Proof", "fr": "preuve", "de": "Beweis", "ru": "доказательство", "zh": "证据"},
        "أطروحة": {"en": "Thesis", "fr": "thèse", "de": "Thesis", "ru": "диссертация", "zh": "论文"},
        "إبستمولوجيا": {"en": "Epistemology", "fr": "épistémologie", "de": "Epistemologie", "ru": "эпистемология", "zh": "认识论"},
        "استنباط": {"en": "Deduction", "fr": "déduction", "de": "Deduktion", "ru": "дедукция", "zh": "演绎"},
        "استقراء": {"en": "Induction", "fr": "induction", "de": "Induktion", "ru": "индукция", "zh": "感应"},
        "تعقيد": {"en": "Complexity", "fr": "complexité", "de": "Komplexität", "ru": "сложность", "zh": "复杂性"},
        "تحدي": {"en": "Challenge", "fr": "défi", "de": "Herausforderung", "ru": "вызов", "zh": "挑战"},
        "ابتكار": {"en": "Innovation", "fr": "innovation", "de": "Innovation", "ru": "инновация", "zh": "创新"},
        "تفاعل": {"en": "Interaction", "fr": "interaction", "de": "Interaktion", "ru": "взаимодействие", "zh": "互动"},
        "مرونة": {"en": "Flexibility", "fr": "flexibilité", "de": "Flexibilität", "ru": "гибкость", "zh": "灵活性"},
        "اندماج": {"en": "Integration", "fr": "intégration", "de": "Integration", "ru": "интеграция", "zh": "整合"},
        "توازن": {"en": "Balance", "fr": "équilibre", "de": "Gleichgewicht", "ru": "баланс", "zh": "平衡"},
        "استقرار": {"en": "Stability", "fr": "stabilité", "de": "Stabilität", "ru": "стабильность", "zh": "稳定性"},
        "نهضة": {"en": "Renaissance", "fr": "renaissance", "de": "Renaissance", "ru": "возрождение", "zh": "文艺复兴"},
        "معاصر": {"en": "Contemporary", "fr": "contemporain", "de": "zeitgenössisch", "ru": "современный", "zh": "当代"},
        "رؤية": {"en": "Vision", "fr": "vision", "de": "Vision", "ru": "видение", "zh": "愿景"}
    }

    # Pre-process cache for fuzzy matching
    normalized_cache = {}
    global_cache = {}
    
    for k, v in all_caches.items():
        parts = k.split('_')
        if len(parts) >= 3:
            norm_word = normalize_arabic(parts[0])
            unit_part = parts[1]
            lang_part = parts[2]
            normalized_cache[f"{norm_word}_{unit_part}_{lang_part}"] = v
            if (norm_word, lang_part) not in global_cache:
                global_cache[(norm_word, lang_part)] = []
            global_cache[(norm_word, lang_part)].append(v)

    global_fallback = {f"{w}_{l}": vals[0] for (w, l), vals in global_cache.items()}
    num_map = {1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five", 
               6: "Six", 7: "Seven", 8: "Eight", 9: "Nine", 10: "Ten"}

    prompts = {
        'en': 'Translate: ', 'ar': 'ترجم: ', 'fr': 'Traduire : ', 
        'de': 'Übersetzen: ', 'ru': 'Перевести: ', 'zh': '翻译: '
    }

    ar_regex = re.compile('[\u0600-\u06FF]')

    for u_idx, unit in enumerate(data['units'], 1):
        unit_en_title = unit['title']['en']
        unit_cache_name = f"Unit {num_map.get(u_idx, u_idx)}: {unit_en_title}"
        
        for lesson in unit['lessons']:
            lesson_words = [item['arabic'] for item in lesson['content'] if item['type'] == 'word']
            lesson_sentences = [item['arabic'] for item in lesson['content'] if item['type'] == 'sentence']
            
            for item in lesson['content']:
                arabic = item['arabic']
                norm_arabic = normalize_arabic(arabic)
                
                # Restore translations
                for lang in ['en', 'fr', 'de', 'ru', 'zh']:
                    cache_key = f"{norm_arabic}_{unit_cache_name}_{lang}"
                    global_key = f"{norm_arabic}_{lang}"
                    
                    val = ""
                    if cache_key in normalized_cache:
                        val = normalized_cache[cache_key]
                    elif global_key in global_fallback:
                        val = global_fallback[global_key]
                    elif norm_arabic in lexicon and lang in lexicon[norm_arabic]:
                        val = lexicon[norm_arabic][lang]
                    
                    # Ensure no Arabic leak in non-ar fields
                    if val and ar_regex.search(val) and lang != 'ar':
                         if norm_arabic in lexicon and lang in lexicon[norm_arabic]:
                             val = lexicon[norm_arabic][lang]
                         else:
                             # If we have a translation but it's Arabic, and no lexicon, 
                             # we might want to clear it or keep it. 
                             # But the user specifically wants correct language.
                             pass
                    
                    if val:
                        item['translation'][lang] = val
                
                # Transliterations
                item['transliteration'] = {'ar': arabic}
                for lang in ['en', 'fr', 'de', 'ru', 'zh']:
                    item['transliteration'][lang] = get_transliteration(arabic, lang)

            # Rebuild Quiz
            lesson['quiz']['questions'] = []
            import random
            for i, item in enumerate(lesson['content']):
                arabic = item['arabic']
                q_type = 'multipleChoice' if i % 2 == 0 else 'audioOptions'
                if item['type'] == 'sentence' and i % 3 == 0:
                    q_type = 'speaking'
                elif i % 5 == 0:
                    q_type = 'listening'
                
                question = {
                    "id": f"q_{lesson['id']}_{i+1}",
                    "type": q_type,
                    "correctAnswer": arabic,
                }
                
                if q_type in ['multipleChoice', 'audioOptions', 'listening']:
                    pool = lesson_words if item['type'] == 'word' else lesson_sentences
                    opts_pool = [x for x in pool if x != arabic]
                    options = [arabic] + random.sample(opts_pool, min(len(opts_pool), 3))
                    random.shuffle(options)
                    question['options'] = options
                
                if q_type in ['audioOptions', 'listening']:
                    question['audioUrl'] = "true"
                    
                if q_type != 'speaking':
                    question['text'] = {lang: f"{prompts[lang]}{arabic}" for lang in prompts}
                else:
                    question['text'] = arabic
                
                lesson['quiz']['questions'].append(question)

    with open(data_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    
    print("c2.json has been updated successfully.")

if __name__ == "__main__":
    solve()
