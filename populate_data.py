import json

def create_entry(arabic, en, fr, de, ru, zh, transliterations):
    return {
        "arabic": arabic,
        "translation": {
            "en": en,
            "fr": fr,
            "de": de,
            "ru": ru,
            "zh": zh
        },
        "transliteration": transliterations
    }

data = {}

# UNIT 1: ACADEMIC DISCOURSE
data["c2_u1_l1"] = {
    "words": [
        create_entry("إبستمولوجيا", "Epistemology", "Épistémologie", "Epistemologie", "Эпистемология", "认识论", 
                     {"en": "Epistemology", "ar": "إبستمولوجيا", "fr": "Épistémologie", "de": "Epistemologie", "ru": "эпистемология", "zh": "认识论"}),
        create_entry("منهجية", "Methodology", "Méthodologie", "Methodik", "Методология", "方法论", 
                     {"en": "Manhajeya", "ar": "منهجية", "fr": "Méthodologie", "de": "Methodik", "ru": "методология", "zh": "方法论"}),
        create_entry("برهان", "Proof", "Preuve", "Beweis", "Доказательство", "证明", 
                     {"en": "Borhan", "ar": "برهان", "fr": "Borhan", "de": "Borhan", "ru": "борхан", "zh": "博尔汗"}),
        create_entry("يقين", "Certainty", "Certitude", "Gewissheit", "Уверенность", "确定性", 
                     {"en": "Yaqin", "ar": "يقين", "fr": "Yaqin", "de": "Yaqin", "ru": "якин", "zh": "亚昆"}),
        create_entry("شك", "Doubt", "Doute", "Zweifel", "Сомнение", "怀疑", 
                     {"en": "Shakk", "ar": "شك", "fr": "Shakk", "de": "Schakk", "ru": "шакк", "zh": "沙克"}),
        create_entry("بديهية", "Axiom", "Axiome", "Axiom", "Аксиома", "公理", 
                     {"en": "Badihiyah", "ar": "بديهية", "fr": "Badihiyah", "de": "Badihija", "ru": "бадихия", "zh": "巴迪希亚"}),
        create_entry("استدلال", "Reasoning", "Raisonnement", "Schlussfolgerung", "Рассуждение", "推理", 
                     {"en": "Istidlal", "ar": "استدلال", "fr": "Istidlal", "de": "Istidlal", "ru": "истидляль", "zh": "伊斯特德拉尔"}),
        create_entry("نقد", "Critique", "Critique", "Kritik", "Критика", "批判", 
                     {"en": "Naqd", "ar": "نقد", "fr": "Naqd", "de": "Nakd", "ru": "накд", "zh": "纳克德"}),
        create_entry("وعي", "Consciousness", "Conscience", "Bewusstsein", "Сознание", "意识", 
                     {"en": "Wa'ey", "ar": "وعي", "fr": "Wa'ey", "de": "Wa'ey", "ru": "уаи", "zh": "瓦伊"}),
        create_entry("إدراك", "Perception", "Perception", "Wahrnehmung", "Восприятие", "感知", 
                     {"en": "Idrak", "ar": "إدراك", "fr": "إدراك", "de": "Idrak", "ru": "идрак", "zh": "伊德拉克"})
    ],
    "sentences": [
        create_entry("تدرس الإبستمولوجيا طبيعة المعرفة وحدودها", 
                     "Epistemology studies the nature and limits of knowledge", 
                     "L'épistémologie étudie la nature et les limites de la connaissance", 
                     "Die Erkenntnistheorie untersucht das Wesen und die Grenzen des Wissens", 
                     "Эпистемология изучает природу и границы знания", 
                     "认识论研究知识的性质和局限性",
                     {"en": "Tadrusu al-epistemologya tabiat al-ma'rifa wa hududaha", "ar": "تدرس الإبستمولوجيا طبيعة المعرفة وحدودها", "fr": "Tadrusu al-epistemologya tabiat al-ma'rifa wa hududaha", "de": "Tadrusu al-epistemologya tabiat al-ma'rifa wa hududaha", "ru": "тадрусу аль-эпистемология табиат аль-маарифа ва худудаха", "zh": "塔德鲁苏 阿尔-认识论 塔比亚特 阿尔-马里法 瓦 胡杜达哈"}),
        create_entry("يعتمد اليقين الرياضي على البديهيات والمنطق", "Mathematical certainty depends on axioms and logic", "La certitude mathématique dépend des axiomes et de la logique", "Mathematische Gewissheit beruht auf Axiomen und Logik", "Математическая уверенность зависит от аксиом и логики", "数学确定性取决于公理和逻辑", {"en": "Ya'tamid al-yaqin al-riyadi 'ala al-badihiyat wa al-mantiq", "ar": "يعتمد اليقين الرياضي على البديهيات والمنطق", "fr": "Ya'tamid al-yaqin al-riyadi 'ala al-badihiyat wa al-mantiq", "de": "Ya'tamid al-yaqin al-riyadi 'ala al-badihiyat wa al-mantiq", "ru": "ятамид аль-якин ар-рияди аля аль-бадихият ва аль-мантик", "zh": "亚塔米德 阿尔-亚昆 阿尔-里亚迪 亚拉 阿尔-巴迪希雅特 瓦 阿尔-曼蒂克"}),
        create_entry("الشك المنهجي هو أداة للوصول إلى الحقيقة", "Methodological doubt is a tool to reach the truth", "Le doute méthodologique est un outil pour atteindre la vérité", "Methodischer Zweifel ist ein Werkzeug, um zur Wahrheit zu gelangen", "Методическое сомнение — это инструмент достижения истины", "方法论上的怀疑是达到真理的工具", {"en": "Al-shakk al-manhaji huwa adat lil-wusul ila al-haqiqa", "ar": "الشك المنهجي هو أداة للوصول إلى الحقيقة", "fr": "Al-shakk al-manhaji huwa adat lil-wusul ila al-haqiqa", "de": "Al-shakk al-manhaji huwa adat lil-wusul ila al-haqiqa", "ru": "аль-шакк аль-манхаджи хува адат лиль-вусуль иля аль-хакика", "zh": "阿尔-沙克 阿尔-曼哈吉 胡瓦 阿达特 利尔-武苏尔 伊拉 阿尔-哈奇卡"}),
        create_entry("يتطلب النقد الفلسفي تحليلاً عميقاً للنصوص", "Philosophical critique requires a deep analysis of texts", "La critique philosophique nécessite une analyse approfondie des textes", "Philosophische Kritik erfordert eine tiefe Analyse von Texten", "Философская критика требует глубокого анализа текстов", "哲学批判需要对文本进行深入分析", {"en": "Yatatallabu al-naqd al-falsafi tahlilan amiqan lil-nusus", "ar": "يتطلب النقد الفلسفي تحليلاً عميقاً للنصوص", "fr": "Yatatallabu al-naqd al-falsafi tahlilan amiqan lil-nusus", "de": "Yatatallabu al-naqd al-falsafi tahlilan amiqan lil-nusus", "ru": "ятаталлябу аль-накд аль-фальсафи тахлилян амикан лиль-нусус", "zh": "亚塔塔拉布 阿尔-纳克德 阿尔-法尔萨非 塔赫利兰 阿米坎 利尔-努苏斯"}),
        create_entry("تختلف المنهجيات العلمية باختلاف مجالات البحث", "Scientific methodologies vary across different research fields", "Les méthodologies scientifiques varient selon les domaines de recherche", "Wissenschaftliche Methoden variieren je nach Forschungsgebiet", "Научные методологии различаются в зависимости от области исследования", "科学方法因研究领域而异", {"en": "Takhtalifu al-manhajiyat al-'ilmiya bi-khtilaf majalat al-bahth", "ar": "تختلف المنهجيات العلمية باختلاف مجالات البحث", "fr": "Takhtalifu al-manhajiyat al-'ilmiya bi-khtilaf majalat al-bahth", "de": "Takhtalifu al-manhajiyat al-'ilmiya bi-khtilaf majalat al-bahth", "ru": "тахталифу аль-манхадият аль-ильмия би-хтиляф маджалят аль-бахс", "zh": "塔赫塔利夫 阿尔-曼哈吉雅特 阿尔-伊尔米亚 毕-赫提拉夫 马贾拉特 阿尔-巴赫斯"})
    ]
}

data["c2_u1_l2"] = {
    "words": [
        create_entry("هيمنة", "Hegemony", "Hégémonie", "Hegemonie", "Гегемония", "霸权", {"en": "Haymanah", "ar": "هيمنة", "fr": "Haymanah", "de": "Haymanah", "ru": "хаймяна", "zh": "海马纳"}),
        create_entry("اغتراب", "Alienation", "Aliénation", "Entfremdung", "Отчуждение", "异化", {"en": "Ightirab", "ar": "اغتراب", "fr": "Ightirab", "de": "Ightirab", "ru": "игтраб", "zh": "伊格特拉布"}),
        create_entry("أيديولوجيا", "Ideology", "Idéologie", "Ideologie", "Идеология", "意识形态", {"en": "Ideologya", "ar": "أيديولوجيا", "fr": "Ideologya", "de": "Ideologya", "ru": "идеология", "zh": "意识形态"}),
        create_entry("تحرر", "Emancipation", "Émancipation", "Emanzipation", "Эмансипация", "解放", {"en": "Taharrur", "ar": "تحرر", "fr": "Taharrur", "de": "Taharrur", "ru": "тахаррур", "zh": "塔哈鲁尔"}),
        create_entry("بنية", "Structure", "Structure", "Struktur", "Структура", "结构", {"en": "Binyah", "ar": "بنية", "fr": "Binyah", "de": "Binyah", "ru": "бинья", "zh": "宾亚"}),
        create_entry("تفكيك", "Deconstruction", "Déconstruction", "Dekonstruktion", "Деконструкция", "解构", {"en": "Tafkeek", "ar": "تفكيك", "fr": "Tafkeek", "de": "Tafkeek", "ru": "тафкик", "zh": "塔夫基克"}),
        create_entry("صراع", "Conflict", "Conflit", "Konflikt", "Конфликт", "冲突", {"en": "Sira'", "ar": "صراع", "fr": "Sira'", "de": "Sira'", "ru": "сира", "zh": "西拉"}),
        create_entry("طبقة", "Class", "Classe", "Klasse", "Класс", "阶级", {"en": "Tabaqah", "ar": "طبقة", "fr": "Tabaqah", "de": "Tabaqah", "ru": "табака", "zh": "塔巴卡"}),
        create_entry("استهلاك", "Consumption", "Consommation", "Konsum", "Потребление", "消费", {"en": "Istihlak", "ar": "استهلاك", "fr": "Istihlak", "de": "Istihlak", "ru": "истихляк", "zh": "伊斯特赫拉克"}),
        create_entry("مادية", "Materialism", "Matérialisme", "Materialismus", "Материализм", "唯物主义", {"en": "Madiya", "ar": "مادية", "fr": "Madiya", "de": "Madiya", "ru": "мадия", "zh": "马迪亚"})
    ],
    "sentences": [
        create_entry("تحلل النظرية النقدية آليات الهيمنة الثقافية", "Critical theory analyzes the mechanisms of cultural hegemony", "La théorie critique analyse les mécanismes de l'hégémonie culturelle", "Kritische Theorie analysiert die Mechanismen kultureller Hegemonie", "Критическая теория анализирует механизмы культурной гегемонии", "批判理论分析文化霸权的机制", {"en": "Tuhallilu al-nazariya al-naqdiya آliyat al-haymana al-thaqafiya", "ar": "تحلل النظرية النقدية آليات الهيمنة الثقافية", "fr": "Tuhallilu al-nazariya al-naqdiya āliyāt al-haymana al-thaqafiya", "de": "Tuhallilu al-nazariya al-naqdiya alijat al-haymana al-thaqafiya", "ru": "тухаллилю ан-назария ан-накдия алийят аль-хаймяна ас-сакафия", "zh": "图哈利卢 阿尔-纳扎里亚 阿尔-纳克迪亚 阿里亚特 阿尔-海马纳 阿尔-萨卡菲亚"})
    ]
}

data["c2_u1_l3"] = {
    "words": [
        create_entry("قطيعة", "Rupture", "Rupture", "Bruch", "Разрыв", "断裂", {"en": "Qati'ah", "ar": "قطيعة", "fr": "Qati'ah", "de": "Qati'ah", "ru": "катиа", "zh": "卡蒂阿"}),
        create_entry("نموذج", "Paradigm", "Paradigme", "Paradigma", "Парадигма", "范式", {"en": "Namudhaj", "ar": "نموذج", "fr": "Namudhaj", "de": "Namudhaj", "ru": "намузадж", "zh": "纳穆扎杰"}),
        create_entry("تجاوز", "Transcendence", "Transcendance", "Transzendenz", "Трансцендентность", "超越", {"en": "Tajawuz", "ar": "تجاوز", "fr": "Tajawuz", "de": "Tajawuz", "ru": "таджавуз", "zh": "塔扎武兹"}),
        create_entry("عقلانية", "Rationality", "Rationalité", "Rationalität", "Рациональность", "理性", {"en": "Aqlaniya", "ar": "عقلانية", "fr": "Aqlaniya", "de": "Aqlaniya", "ru": "акляния", "zh": "阿克拉尼亚"}),
        create_entry("جوهر", "Essence", "Essence", "Essenz", "Сущность", "本质", {"en": "Jawhar", "ar": "جوهر", "fr": "Jawhar", "de": "Jawhar", "ru": "джаухар", "zh": "扎哈尔"}),
        create_entry("تصور", "Conception", "Conception", "Konzept", "Концепция", "构想", {"en": "Tasawwur", "ar": "تصور", "fr": "Tasawwur", "de": "Tasawwur", "ru": "тасаввур", "zh": "塔萨武尔"}),
        create_entry("ثورة", "Revolution", "Révolution", "Revolution", "Революция", "革命", {"en": "Thawrah", "ar": "ثورة", "fr": "Thawrah", "de": "Thawrah", "ru": "савра", "zh": "萨瓦拉"}),
        create_entry("منطق", "Logic", "Logique", "Logik", "Логика", "逻辑", {"en": "Mantiq", "ar": "منطق", "fr": "Mantiq", "de": "Mantik", "ru": "мантик", "zh": "曼蒂克"}),
        create_entry("موضوعية", "Objectivity", "Objectivité", "Objektivität", "Объективность", "客观性", {"en": "Mawdu'iya", "ar": "موضوعية", "fr": "Mawdu'iya", "de": "Mawdu'iya", "ru": "мавдуия", "zh": "马夫杜亚"}),
        create_entry("ذاتية", "Subjectivity", "Subjectivity", "Subjektivität", "Субъективность", "主观性", {"en": "Dhatiya", "ar": "ذاتية", "fr": "Dhatiya", "de": "Dhatiya", "ru": "затия", "zh": "扎提亚"})
    ],
    "sentences": []
}

data["c2_u1_l4"] = {
    "words": [
        create_entry("نزاهة", "Integrity", "Intégrité", "Integrität", "Честность", "诚信", {"en": "Nazahah", "ar": "نزاهة", "fr": "Nazahah", "de": "Nazahah", "ru": "назаха", "zh": "纳扎哈"}),
        create_entry("انتحال", "Plagiarism", "Plagiat", "Plagiat", "Плагиат", "抄袭", {"en": "Intihal", "ar": "انتحال", "fr": "Intihal", "de": "Intihal", "ru": "интихаль", "zh": "因蒂哈尔"}),
        create_entry("توثيق", "Documentation", "Documentation", "Dokumentation", "Документирование", "文献记录", {"en": "Tawtheeq", "ar": "توثيق", "fr": "Tawtheeq", "de": "Tawtheeq", "ru": "тавсик", "zh": "塔夫斯克"}),
        create_entry("اقتباس", "Citation", "Citation", "Zitieren", "Цитирование", "引用", {"en": "Iqtibas", "ar": "اقتباس", "fr": "Iqtibas", "de": "Iktibas", "ru": "иктибас", "zh": "伊克提巴斯"}),
        create_entry("أمانة", "Honesty", "Honnêteté", "Ehrlichkeit", "Честность", "诚实", {"en": "Amanah", "ar": "أمانة", "fr": "Amanah", "de": "Amanah", "ru": "амана", "zh": "阿玛纳"}),
        create_entry("مصدر", "Source", "Source", "Quelle", "Источник", "来源", {"en": "Masdar", "ar": "مصدر", "fr": "Masdar", "de": "Masdar", "ru": "масдар", "zh": "马斯达尔"}),
        create_entry("مرجع", "Reference", "Référence", "Referenz", "Ссылка", "参考文献", {"en": "Marja'", "ar": "مرجع", "fr": "Marja'", "de": "Marja'", "ru": "марджа", "zh": "马尔贾"}),
        create_entry("تزييف", "Falsification", "Falsification", "Fälschung", "Фальсификация", "伪造", {"en": "Tazyif", "ar": "تزييف", "fr": "Tazyif", "de": "Tasijf", "ru": "тазийф", "zh": "塔齐夫"}),
        create_entry("أخلاقيات", "Ethics", "Éthique", "Ethik", "Этика", "伦理", {"en": "Akhlaqiyat", "ar": "أخلاقيات", "fr": "Akhlaqiyat", "de": "Achlakiyat", "ru": "ахлакият", "zh": "阿赫拉基亚特"}),
        create_entry("معايير", "Standards", "Normes", "Standards", "Стандарты", "标准", {"en": "Ma'ayeer", "ar": "معايير", "fr": "Ma'ayeer", "de": "Ma'ayir", "ru": "маяиир", "zh": "马里亚尔"})
    ],
    "sentences": []
}

data["c2_u1_l5"] = {
    "words": [
        create_entry("سياق", "Context", "Contexte", "Kontext", "Контекст", "语境", {"en": "Siyaq", "ar": "سياق", "fr": "Siyaq", "de": "Siyak", "ru": "сияк", "zh": "西雅克"}),
        create_entry("خطاب", "Discourse", "Discours", "Diskurs", "Дискурс", "话语", {"en": "Khitab", "ar": "خطاب", "fr": "Khitab", "de": "Chitab", "ru": "хитаб", "zh": "希塔布"}),
        create_entry("تأويل", "Interpretation", "Interprétation", "Interpretation", "Интерпретация", "解释", {"en": "Ta'weel", "ar": "تأويل", "fr": "Ta'weel", "de": "Ta'wil", "ru": "тавиль", "zh": "塔维尔"}),
        create_entry("بلاغة", "Rhetoric", "Rhétorique", "Rhetorik", "Риторика", "修辞", {"en": "Balaghah", "ar": "بلاغة", "fr": "Balaghah", "de": "Balaghah", "ru": "баляга", "zh": "巴拉加"}),
        create_entry("سلطة", "Authority", "Autorité", "Autorität", "Власть", "权力", {"en": "Sultah", "ar": "سلطة", "fr": "Sultah", "de": "Sultah", "ru": "сульта", "zh": "苏尔塔"}),
        create_entry("دلالة", "Significance", "Signification", "Bedeutung", "Значение", "意义", {"en": "Dalalah", "ar": "دلالة", "fr": "Dalalah", "de": "Dalalah", "ru": "даляля", "zh": "达拉拉"}),
        create_entry("بناء", "Construction", "Construction", "Konstruktion", "Конструирование", "建构", {"en": "Bina'", "ar": "بناء", "fr": "Bina'", "de": "Bina'", "ru": "бина", "zh": "比纳"}),
        create_entry("معنى", "Meaning", "Sens", "Bedeutung", "Смысл", "语义", {"en": "Ma'na", "ar": "معنى", "fr": "Ma'na", "de": "Ma'na", "ru": "маана", "zh": "马亚纳"}),
        create_entry("نص", "Text", "Texte", "Text", "Текст", "文本", {"en": "Nass", "ar": "نص", "fr": "Nass", "de": "Nass", "ru": "насс", "zh": "纳斯"}),
        create_entry("تحليل", "Analysis", "Analyse", "Analyse", "Анализ", "分析", {"en": "Tahlil", "ar": "تحليل", "fr": "Tahlil", "de": "Tahlil", "ru": "тахлиль", "zh": "塔赫利尔"})
    ],
    "sentences": []
}

data["c2_u1_l6"] = {
    "words": [
        create_entry("خوارزمية", "Algorithm", "Algorithme", "Algorithmus", "Алгоритм", "算法", {"en": "Khawarizmiya", "ar": "خوارزمية", "fr": "Khawarizmiya", "de": "Chawarizmija", "ru": "хаваризмия", "zh": "哈瓦里兹米亚"}),
        create_entry("انحياز", "Bias", "Biais", "Voreingenommenheit", "Предвзятость", "偏差", {"en": "Inhiyaz", "ar": "انحياز", "fr": "Inhiyaz", "de": "Inhijaz", "ru": "инхияз", "zh": "因希亚兹"}),
        create_entry("خصوصية", "Privacy", "Vie privée", "Privatsphäre", "Конфиденциальность", "隐私", {"en": "Khususiyah", "ar": "خصوصية", "fr": "Khususiyah", "de": "Chususija", "ru": "хусусия", "zh": "胡苏西亚"}),
        create_entry("شفافية", "Transparency", "Transparence", "Transparenz", "Прозрачность", "透明度", {"en": "Shafafiya", "ar": "شفافية", "fr": "Shafafiya", "de": "Schafafija", "ru": "шафафия", "zh": "沙法菲亚"}),
        create_entry("مسؤولية", "Responsibility", "Responsabilité", "Verantwortung", "Ответственность", "责任", {"en": "Mas'ouliya", "ar": "مسؤولية", "fr": "Mas'ouliya", "de": "Mas'ulija", "ru": "масулия", "zh": "马苏里亚"}),
        create_entry("بيانات", "Data", "Données", "Daten", "Данные", "数据", {"en": "Bayanat", "ar": "بيانات", "fr": "Bayanat", "de": "Bajanat", "ru": "баянат", "zh": "巴亚纳特"}),
        create_entry("أمان", "Security", "Sécurité", "Sicherheit", "Безопасность", "安全", {"en": "Aman", "ar": "أمان", "fr": "Aman", "de": "Aman", "ru": "аман", "zh": "阿曼"}),
        create_entry("تشفير", "Encryption", "Chiffrement", "Verschlüsselung", "Шифрование", "加密", {"en": "Tashfeer", "ar": "تشفير", "fr": "Tashfeer", "de": "Taschfir", "ru": "ташфир", "zh": "塔什菲尔"}),
        create_entry("ذكاء", "Intelligence", "Intelligence", "Intelligenz", "Интеллект", "智能", {"en": "Dhaka'", "ar": "ذكاء", "fr": "Dhaka'", "de": "Daka'", "ru": "зака", "zh": "扎卡"}),
        create_entry("تعلم", "Learning", "Apprentissage", "Lernen", "Обучение", "学习", {"en": "Ta'allum", "ar": "تعلم", "fr": "Ta'allum", "de": "Ta'allum", "ru": "тааллюм", "zh": "塔阿鲁姆"})
    ],
    "sentences": []
}

data["c2_u1_l7"] = {
    "words": [
        create_entry("منشور", "Publication", "Publication", "Publikation", "Публикация", "出版物", {"en": "Manshur", "ar": "منشور", "fr": "Manshur", "de": "Manschur", "ru": "маншур", "zh": "曼舒尔"}),
        create_entry("ندوة", "Seminar", "Séminaire", "Seminar", "Семинар", "研讨会", {"en": "Nadwah", "ar": "ندوة", "fr": "Nadwah", "de": "Nadwa", "ru": "надва", "zh": "纳德瓦"}),
        create_entry("أطروحة", "Thesis", "Thèse", "Thesis", "Диссертация", "论文", {"en": "Atrouha", "ar": "أطروحة", "fr": "Atrouha", "de": "Atruha", "ru": "атруха", "zh": "阿特鲁哈"}),
        create_entry("مراجعة", "Review", "Révision", "Überprüfung", "Обзор", "审查", {"en": "Muraja'ah", "ar": "مراجعة", "fr": "Muraja'ah", "de": "Muraja'a", "ru": "мураджаа", "zh": "穆拉贾阿"}),
        create_entry("مقال", "Article", "Article", "Artikel", "Статья", "文章", {"en": "Maqal", "ar": "مقال", "fr": "Maqal", "de": "Makal", "ru": "макаль", "zh": "马卡尔"}),
        create_entry("بحث", "Research", "Recherche", "Forschung", "Исследование", "研究", {"en": "Bahth", "ar": "بحث", "fr": "Bahth", "de": "Baht", "ru": "бахс", "zh": "巴赫斯"}),
        create_entry("استنتاج", "Conclusion", "Conclusion", "Schlussfolgerung", "Заключение", "结论", {"en": "Istintaj", "ar": "استنتاج", "fr": "Istintaj", "de": "Istintaj", "ru": "истинтадж", "zh": "伊斯特因塔杰"}),
        create_entry("مناقشة", "Discussion", "Discussion", "Diskussion", "Обсуждение", "讨论", {"en": "Munaqashah", "ar": "مناقشة", "fr": "Munaqashah", "de": "Munakascha", "ru": "мунакаша", "zh": "穆纳卡沙"}),
        create_entry("نتائج", "Results", "Résultats", "Ergebnisse", "Результаты", "结果", {"en": "Nata'ij", "ar": "نتائج", "fr": "Nata'ij", "de": "Nata'ij", "ru": "натаидж", "zh": "纳塔伊杰"}),
        create_entry("ملخص", "Abstract", "Résumé", "Zusammenfassung", "Аннотация", "摘要", {"en": "Mulakhass", "ar": "ملخص", "fr": "Mulakhass", "de": "Mulachass", "ru": "мулахасс", "zh": "穆拉哈斯"})
    ],
    "sentences": []
}

data["c2_u1_l8"] = {
    "words": [
        create_entry("إطار", "Framework", "Cadre", "Rahmen", "Рамки", "框架", {"en": "Itar", "ar": "إطار", "fr": "Itar", "de": "Itar", "ru": "итар", "zh": "伊塔尔"}),
        create_entry("نظرية", "Theory", "Théorie", "Theorie", "Теория", "理论", {"en": "Nazariya", "ar": "نظرية", "fr": "Nazariya", "de": "Nasarija", "ru": "назария", "zh": "纳扎里亚"}),
        create_entry("فرضية", "Hypothesis", "Hypothèse", "Hypothese", "Гипотеза", "假设", {"en": "Faradiya", "ar": "فرضية", "fr": "Faradiya", "de": "Faradija", "ru": "фарадия", "zh": "法拉迪亚"}),
        create_entry("مفهوم", "Concept", "Concept", "Konzept", "Понятие", "概念", {"en": "Mafhoum", "ar": "مفهوم", "fr": "Mafhoum", "de": "Mafhum", "ru": "мафхум", "zh": "马夫胡姆"}),
        create_entry("تحليل", "Analysis", "Analyse", "Analyse", "Анализ", "分析", {"en": "Tahlil", "ar": "تحليل", "fr": "Tahlil", "de": "Tahlil", "ru": "тахлиль", "zh": "塔赫利尔"}),
        create_entry("تطبيق", "Application", "Application", "Anwendung", "Применение", "应用", {"en": "Tatbiq", "ar": "تطبيق", "fr": "Tatbiq", "de": "Tatbik", "ru": "татбик", "zh": "塔特比克"}),
        create_entry("تقييم", "Evaluation", "Évaluation", "Bewertung", "Оценка", "评估", {"en": "Taqyeem", "ar": "تقييم", "fr": "Taqyeem", "de": "Takyim", "ru": "такйим", "zh": "塔克伊姆"}),
        create_entry("منهج", "Curriculum/Approach", "Approche", "Ansatz", "Подход", "方法", {"en": "Manhaj", "ar": "منهج", "fr": "Manhaj", "de": "Manhadj", "ru": "манхадж", "zh": "曼哈杰"}),
        create_entry("أدبيات", "Literature", "Littérature", "Literatur", "Литература", "文献", {"en": "Adabiyat", "ar": "أدبيات", "fr": "Adabiyat", "de": "Adabiyat", "ru": "адабият", "zh": "阿达比亚特"}),
        create_entry("مساهمة", "Contribution", "Contribution", "Beitrag", "Вклад", "贡献", {"en": "Musahamah", "ar": "مساهمة", "fr": "Musahamah", "de": "Musahama", "ru": "мусахама", "zh": "穆萨哈马"})
    ],
    "sentences": []
}

# UNIT 2: PROFESSIONAL DIPLOMACY
data["c2_u2_l1"] = {
    "words": [
        create_entry("بروتوكول", "Protocol", "Protocole", "Protokoll", "Протокол", "礼节", {"en": "Brwtwkwl", "ar": "بروتوكول", "fr": "Brwtwkwl", "de": "Brwtwkwl", "ru": "брвтвквл", "zh": "巴尔特克拉"}),
        create_entry("مراسم", "Ceremony", "Cérémonie", "Zeremonie", "Церемония", "仪式", {"en": "Mrasm", "ar": "مراسم", "fr": "Mrasm", "de": "Mrasm", "ru": "мрасм", "zh": "姆拉斯姆"}),
        create_entry("استقبال", "Reception", "Réception", "Empfang", "Прием", "招待", {"en": "Astqbal", "ar": "استقبال", "fr": "Astqbal", "de": "Astqbal", "ru": "асткбал", "zh": "阿斯特克巴尔"}),
        create_entry("وفد", "Delegation", "Délégation", "Delegation", "Делегация", "代表团", {"en": "Wfd", "ar": "وفد", "fr": "Wfd", "de": "Wfd", "ru": "вфд", "zh": "沃夫德"}),
        create_entry("حصانة", "Immunity", "Immunité", "Immunität", "Иммунитет", "豁免", {"en": "Hsana", "ar": "حصانة", "fr": "Hsana", "de": "Hsana", "ru": "хсана", "zh": "哈萨纳"}),
        create_entry("اعتماد", "Accreditation", "Accréditation", "Akkreditierung", "Аккредитация", "委任", {"en": "A'tmad", "ar": "اعتماد", "fr": "A'tmad", "de": "A'tmad", "ru": "атмад", "zh": "阿特马德"}),
        create_entry("رسمي", "Official", "Officiel", "Offiziell", "Официальный", "官方", {"en": "Rsmi", "ar": "رسمي", "fr": "Rsmi", "de": "Rsmi", "ru": "рсми", "zh": "伊斯米"}),
        create_entry("زيارة", "Visit", "Visite", "Besuch", "Визит", "访问", {"en": "Zyara", "ar": "زيارة", "fr": "Zyara", "de": "Zyara", "ru": "зяра", "zh": "齐亚拉"}),
        create_entry("مأدبة", "Banquet", "Banquet", "Bankett", "Банкет", "宴会", {"en": "Ma'dba", "ar": "مأدبة", "fr": "Ma'dba", "de": "Ma'dba", "ru": "мадба", "zh": "马德巴"}),
        create_entry("توقيع", "Signing", "Signature", "Unterzeichnung", "Подписание", "签署", {"en": "Tawqi'", "ar": "توقيع", "fr": "Tawqi'", "de": "Tawki'", "ru": "тавки", "zh": "塔基"})
    ],
    "sentences": []
}
data["c2_u2_l2"] = { # Consular Functions
    "words": [
        create_entry("قنصلية", "Consulate", "Consulat", "Konsulat", "Консульство", "领事馆", {"en": "Qunsuliya", "ar": "قنصلية", "fr": "Qunsuliya", "de": "Kunsulija", "ru": "кунсулия", "zh": "昆苏利亚"}),
        create_entry("تأشيرة", "Visa", "Visa", "Visum", "Виза", "签证", {"en": "Ta'shira", "ar": "تأشيرة", "fr": "Ta'shira", "de": "Ta'schira", "ru": "ташира", "zh": "塔希拉"}),
        create_entry("جواز", "Passport", "Passeport", "Reisepass", "Паспорт", "护照", {"en": "Jawaz", "ar": "جواز", "fr": "Jawaz", "de": "Jawaz", "ru": "джаваз", "zh": "扎瓦兹"}),
        create_entry("رعاية", "Care/Nationals", "Ressortissants", "Staatsangehörige", "Граждане", "公民", {"en": "Ri'aya", "ar": "رعاية", "fr": "Ri'aya", "de": "Ri'aja", "ru": "риая", "zh": "瑞亚"}),
        create_entry("توثيق", "Notarization", "Légalisation", "Beglaubigung", "Легализация", "公证", {"en": "Tawtheeq", "ar": "توثيق", "fr": "Tawtheeq", "de": "Tawtheeq", "ru": "тавсик", "zh": "塔夫斯克"}),
        create_entry("حماية", "Protection", "Protection", "Schutz", "Защита", "保护", {"en": "Himaya", "ar": "حماية", "fr": "Himaya", "de": "Himaja", "ru": "химая", "zh": "希马雅"}),
        create_entry("ترحيل", "Deportation", "Expulsion", "Abschiebung", "Депортация", "驱逐", {"en": "Tarheel", "ar": "ترحيل", "fr": "Tarheel", "de": "Tarhil", "ru": "тархиль", "zh": "塔赫尔"}),
        create_entry("لجوء", "Asylum", "Asile", "Asyl", "Убежище", "避难", {"en": "Lujou'", "ar": "لجوء", "fr": "Lujou'", "de": "Ludju'", "ru": "луджу", "zh": "鲁朱"}),
        create_entry("حقوق", "Rights", "Droits", "Rechte", "Права", "权利", {"en": "Huquq", "ar": "حقوق", "fr": "Huquq", "de": "Hukuk", "ru": "хукук", "zh": "胡库к"}),
        create_entry("مواطنين", "Citizens", "Citoyens", "Bürger", "Граждане", "公民", {"en": "Muwatinin", "ar": "مواطنين", "fr": "Muwatinin", "de": "Muwatinin", "ru": "муватинин", "zh": "穆瓦蒂宁"})
    ],
    "sentences": [
        create_entry("تقدم القنصلية خدماتها للمواطنين المقيمين في الخارج", "The consulate provides its services to citizens residing abroad", "Le consulat fournit ses services aux citoyens résidant à l'étranger", "Das Konsulat bietet seine Dienste für im Ausland lebende Bürger an", "Консульство предоставляет услуги гражданам, проживающим за границей", "领事馆为居住在国外的公民提供服务", {"en": "Tuqaddimu al-qunsuliya khidamatiha lil-muwatinin al-muqimin fi al-kharij", "ar": "تقدم القنصلية خدماتها للمواطنين المقيمين في الخارج", "fr": "Tuqaddimu al-qunsuliya khidamatiha lil-muwatinin al-muqimin fi al-kharij", "de": "Tuqaddimu al-qunsuliya khidamatiha lil-muwatinin al-muqimin fi al-kharij", "ru": "тукаддиму аль-кунсулия хидаматиха лиль-муватинин аль-мукимин фи аль-харидж", "zh": "图卡迪穆 阿尔-昆苏利亚 希达马蒂哈 利尔-穆瓦蒂宁 阿尔-穆基明 费 阿尔-哈里杰"})
    ]
}

data["c2_u2_l3"] = { # Multilateralism
    "words": [
        create_entry("تعددية", "Multilateralism", "Multilatéralisme", "Multilateralismus", "Многосторонность", "多边主义", {"en": "Ta'adudiya", "ar": "تعددية", "fr": "Ta'adudiya", "de": "Ta'adudija", "ru": "таадудия", "zh": "塔杜迪亚"}),
        create_entry("تحالف", "Alliance", "Alliance", "Allianz", "Альянс", "联盟", {"en": "Tahaluf", "ar": "تحالف", "fr": "Tahaluf", "de": "Tahaluf", "ru": "тахалюф", "zh": "塔哈鲁夫"}),
        create_entry("تعاون", "Cooperation", "Coopération", "Kooperation", "Сотрудничество", "合作", {"en": "Ta'awun", "ar": "تعاون", "fr": "Ta'awun", "de": "Ta'awun", "ru": "таавун", "zh": "塔文"}),
        create_entry("تكتل", "Bloc", "Bloc", "Block", "Блок", "集团", {"en": "Takattul", "ar": "تكتل", "fr": "Takattul", "de": "Takattul", "ru": "такаттуль", "zh": "塔卡图尔"}),
        create_entry("توازن", "Balance", "Équilibre", "Gleichgewicht", "Баланс", "平衡", {"en": "Tawazun", "ar": "توازن", "fr": "Tawazun", "de": "Tawazun", "ru": "тавазун", "zh": "塔瓦尊"}),
        create_entry("قطبية", "Polarity", "Polarité", "Polarität", "Полярность", "极性", {"en": "Qutbiya", "ar": "قطبية", "fr": "Qutbiya", "de": "Kutbija", "ru": "кутбия", "zh": "库特比亚"}),
        create_entry("اتفاقية", "Agreement", "Accord", "Abkommen", "Соглашение", "协议", {"en": "Ittifaqiya", "ar": "اتفاقية", "fr": "Ittifaqiya", "de": "Ittifakija", "ru": "иттифакия", "zh": "伊蒂法基亚"}),
        create_entry("شراكة", "Partnership", "Partenariat", "Partnerschaft", "Партнерство", "伙伴关系", {"en": "Sharaka", "ar": "شراكة", "fr": "Sharaka", "de": "Scharaka", "ru": "шарака", "zh": "沙拉卡"}),
        create_entry("انقسام", "Division", "Division", "Teilung", "Разделение", "分裂", {"en": "Inqisam", "ar": "انقسام", "fr": "Inqisam", "de": "Inkisam", "ru": "инкисам", "zh": "因基萨姆"}),
        create_entry("إجماع", "Consensus", "Consensus", "Konsens", "Консенсус", "共识", {"en": "Ijma'", "ar": "إجماع", "fr": "Ijma'", "de": "Idjma'", "ru": "иджма", "zh": "伊德马"})
    ],
    "sentences": []
}

data["c2_u2_l4"] = { # Crisis Management
    "words": [
        create_entry("أزمة", "Crisis", "Crise", "Krise", "Кризис", "危机", {"en": "Azmah", "ar": "أزمة", "fr": "Azmah", "de": "Asma", "ru": "азма", "zh": "阿兹玛"}),
        create_entry("توسط", "Mediation", "Médiation", "Vermittlung", "Посредничество", "调解", {"en": "Tawassut", "ar": "توسط", "fr": "Tawassut", "de": "Tawassut", "ru": "тавассут", "zh": "塔瓦苏特"}),
        create_entry("نزاع", "Conflict", "Conflit", "Konflikt", "Конфликт", "冲突", {"en": "Niza'", "ar": "نزاع", "fr": "Niza'", "de": "Niza'", "ru": "низа", "zh": "尼扎"}),
        create_entry("تهدئة", "De-escalation", "Désescalade", "Deeskalation", "Разрядка", "缓和", {"en": "Tahdi'ah", "ar": "تهدئة", "fr": "Tahdi'ah", "de": "Tahdi'a", "ru": "тахдиа", "zh": "塔赫迪亚"}),
        create_entry("هدنة", "Truce", "Trêve", "Waffenruhe", "Перемирие", "休战", {"en": "Hudnah", "ar": "هدنة", "fr": "Hudnah", "de": "Hudna", "ru": "худна", "zh": "胡德纳"})
    ],
    "sentences": []
}

data["c2_u2_l5"] = { # Economic Statecraft
    "words": [
        create_entry("عقوبات", "Sanctions", "Sanctions", "Sanktionen", "Санкции", "制裁", {"en": "Uqubat", "ar": "عقوبات", "fr": "Uqubat", "de": "Ukubat", "ru": "укубат", "zh": "乌库巴特"}),
        create_entry("تبادل", "Exchange/Trade", "Échange", "Handel", "Торговля", "贸易", {"en": "Tabadul", "ar": "تبادل", "fr": "Tabadul", "de": "Tabadul", "ru": "табадуль", "zh": "塔巴杜尔"}),
        create_entry("استثمار", "Investment", "Investissement", "Investition", "Инвестиции", "投资", {"en": "Istithmar", "ar": "استثمار", "fr": "Istithmar", "de": "Istithmar", "ru": "истисмар", "zh": "伊斯特思马尔"}),
        create_entry("نمو", "Growth", "Croissance", "Wachstum", "Рост", "增长", {"en": "Numuw", "ar": "نمو", "fr": "Numuw", "de": "Numuw", "ru": "нуму", "zh": "努姆"}),
        create_entry("تضخم", "Inflation", "Inflation", "Inflation", "Инфляция", "通货膨胀", {"en": "Tadakhum", "ar": "تضخم", "fr": "Tadakhum", "de": "Tadachum", "ru": "тадахум", "zh": "塔达胡姆"})
    ],
    "sentences": []
}
