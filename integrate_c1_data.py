import json
import os
import re
import random

def get_transliteration(arabic_text, lang):
    # Mapping based on scripty.py logic
    mapping = {
        'أ': 'a', 'ب': 'b', 'ت': 't', 'ث': 'th', 'ج': 'j', 'ح': 'h', 'خ': 'kh',
        'د': 'd', 'ذ': 'dh', 'ر': 'r', 'ز': 'z', 'س': 's', 'ش': 'sh', 'ص': 's',
        'ض': 'd', 'ط': 't', 'ظ': 'z', 'ع': "'a", 'غ': 'gh', 'ف': 'f', 'ق': 'q',
        'ك': 'k', 'ل': 'l', 'م': 'm', 'ن': 'n', 'ه': 'h', 'و': 'w', 'ي': 'y',
        'ة': 'a', 'ى': 'a', ' ': ' ', '،': ',', '؟': '?', 
        'ا': 'a', 'آ': 'a', 'إ': 'i', 'ئ': 'y', 'ؤ': 'o', 'ء': "'",
        'ّ': '', 'َ': 'a', 'ُ': 'u', 'ِ': 'i', 'ً': 'an', 'ٌ': 'un', 'ٍ': 'in', 'ْ': ''
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
            if char in zh_map:
                res += zh_map[char]
            elif char == ' ':
                res += ' '
        return res
        
    return latin

def integrate():
    content_data_path = 'c1_content_data.json'
    c1_json_path = 'assets/data/c1.json'
    
    with open(content_data_path, 'r', encoding='utf-8') as f:
        regen_data = json.load(f)["c1"]
        
    # Read original metadata for structure
    # However, we will rebuild c1 to match c2 format
    
    UNIT_METADATA = {
        "c1_u1": {
            "title": {"en": "Classical Literature", "ar": "الأدب الكلاسيكي", "fr": "Littérature classique", "de": "Klassische Literatur", "ru": "Классическая литература", "zh": "古典文学"},
            "description": {"en": "Analysis of aesthetics and arts in ancient Arabic literature.", "ar": "تحليل الجماليات والفنون في الأدب العربي القديم.", "fr": "Analyse de l'esthétique et des arts dans la littérature arabe ancienne.", "de": "Analyse von Ästhetik und Kunst in der alten arabischen Literatur.", "ru": "Анализ эстетики и искусства древней арабской литературы.", "zh": "古代阿拉伯文学中的美学和艺术分析。"}
        },
        "c1_u2": {
            "title": {"en": "Arabic Philosophy", "ar": "الفلسفة العربية", "fr": "Philosophie arabe", "de": "Arabische Philosophie", "ru": "Арабская философия", "zh": "阿拉伯哲学"},
            "description": {"en": "Exploring logic, theology, and ethical thought in Islamic civilization.", "ar": "استكشاف المنطق وعلم الكلام والفكر الأخلاقي في الحضارة الإسلامية.", "fr": "Explorer la logique, la théologie et la pensée éthique dans la civilisation islamique.", "de": "Erkundung von Logik, Theologie und ethischem Denken in der islamischen Zivilisation.", "ru": "Изучение логики, теологии и этической мысли в исламской цивилизации.", "zh": "探索伊斯兰文明中的逻辑、神学和伦理思想。"}
        },
        "c1_u3": {
            "title": {"en": "Economics and Finance", "ar": "الاقتصاد والتمويل", "fr": "Économie et finance", "de": "Wirtschaft und Finanzen", "ru": "Экономика и финансы", "zh": "经济与金融"},
            "description": {"en": "Advanced financial systems, banking, and macroeconomics.", "ar": "الأنظمة المالية المتقدمة والصيرفة والاقتصاد الكلي.", "fr": "Systèmes financiers avancés, banque et macroéconomie.", "de": "Fortgeschrittene Finanzsysteme, Bankwesen und Makroökonomie.", "ru": "Продвинутые финансовые системы, банковское дело и макроэкономика.", "zh": "高级金融系统、银行业和宏观经济学。"}
        },
        "c1_u4": {
            "title": {"en": "Law and Justice", "ar": "القانون والعدالة", "fr": "Droit et justice", "de": "Recht und Gerechtigkeit", "ru": "Закон и правосудие", "zh": "法律与正义"},
            "description": {"en": "International legal frameworks, human rights, and arbitration.", "ar": "الأطر القانونية الدولية وحقوق الإنسان والتحكيم.", "fr": "Cadres juridiques internationaux, droits de l'homme et arbitrage.", "de": "Internationale rechtliche Rahmenbedingungen, Menschenrechte und Schiedsgerichtsbarkeit.", "ru": "Международно-правовые основы, права человека и арбитраж.", "zh": "国际法律框架、人权和仲裁。"}
        },
        "c1_u5": {
            "title": {"en": "Religious Discourse", "ar": "الخطاب الديني", "fr": "Discours religieux", "de": "Religiöser Diskurs", "ru": "Религиозный дискурс", "zh": "宗教话语"},
            "description": {"en": "Interpretation, comparative religions, and interfaith dialogue.", "ar": "التفسير ومقارنة الأديان وحوار الأديان.", "fr": "Interprétation, religions comparées et dialogue interreligieux.", "de": "Interpretation, vergleichende Religionswissenschaft und interreligiöser Dialog.", "ru": "Интерпретация, сравнительное религиоведение и межконфессиональный диалог.", "zh": "解释、比较宗教和宗教间对话。"}
        },
        "c1_u6": {
            "title": {"en": "History and Heritage", "ar": "التاريخ والتراث", "fr": "Histoire et patrimoine", "de": "Geschichte und Erbe", "ru": "История и наследие", "zh": "历史与遗产"},
            "description": {"en": "Archeology, manuscripts, and preservation of historical memory.", "ar": "علم الآثار والمخطوطات والحفاظ على الذاكرة التاريخية.", "fr": "Archéologie, manuscrits et préservation de la mémoire historique.", "de": "Archäologie, Manuskripte und Bewahrung des historischen Gedächtnisses.", "ru": "Археология, рукописи и сохранение исторической памяти.", "zh": "考古学、手稿和历史记忆的保护。"}
        },
        "c1_u7": {
            "title": {"en": "Linguistics and Language Science", "ar": "اللغويات وعلم اللغة", "fr": "Linguistique et science du langage", "de": "Linguistik und Sprachwissenschaft", "ru": "Лингвистика и наука о языке", "zh": "语言学与语言科学"},
            "description": {"en": "Deep dive into morphology, syntax, and sociolinguistics.", "ar": "غوص عميق في الصرف والنحو وعلم اللغة الاجتماعي.", "fr": "Plongée profonde dans la morphologie, la syntaxe et la sociolinguistique.", "de": "Tiefes Eintauchen in Morphologie, Syntax und Soziolinguistik.", "ru": "Глубокое погружение в морфологию, синтаксис и социолингвистику.", "zh": "深入研究形态学、句法和社会语言学。"}
        },
        "c1_u8": {
            "title": {"en": "Cultural Diversity and Global Dialogue", "ar": "التنوع الثقافي والحوار العالمي", "fr": "Diversité culturelle et dialogue mondial", "de": "Kulturelle Vielfalt und globaler Dialog", "ru": "Культурное разнообразие и глобальный диалог", "zh": "文化多样性与全球对话"},
            "description": {"en": "Globalization, identity, and integration in a multicultural world.", "ar": "العولمة والهوية والتكامل في عالم متعدد الثقافات.", "fr": "Mondialisation, identité et intégration dans un monde multiculturel.", "de": "Globalisierung, Identität und Integration in einer multikulturellen Welt.", "ru": "Глобализация, идентичность и интеграция в мультикультурном мире.", "zh": "多元文化世界中的全球化、身份和融合。"}
        },
        "c1_u9": {
            "title": {"en": "Psychology and Mental Health", "ar": "علم النفس والصحة النفسية", "fr": "Psychologie et santé mentale", "de": "Psychologie und psychische Gesundheit", "ru": "Психология и психическое здоровье", "zh": "心理学与心理健康"},
            "description": {"en": "Understanding human behavior, intelligence, and psychological resilience.", "ar": "فهم السلوك البشري والذكاء والمرونة النفسية.", "fr": "Comprendre le comportement humain, l'intelligence et la résilience psychologique.", "de": "Verständnis des menschlichen Verhaltens, der Intelligenz und der psychischen Resilienz.", "ru": "Понимание человеческого поведения, интеллекта и психологической устойчивости.", "zh": "了解人类行为、智力和心理复原力。"}
        },
        "c1_u10": {
            "title": {"en": "Politics and International Relations", "ar": "السياسة والعلاقات الدولية", "fr": "Politique et relations internationales", "de": "Politik und internationale Beziehungen", "ru": "Политика и международные отношения", "zh": "政治与国际关系"},
            "description": {"en": "Political systems, diplomacy, and global geopolitical shifts.", "ar": "الأنظمة السياسية والدبلوماسية والتحولات الجيوسياسية العالمية.", "fr": "Systèmes politiques, diplomatie et changements géopolitiques mondiaux.", "de": "Politische Systeme, Diplomatie und globale geopolitische Veränderungen.", "ru": "Политические системы, дипломатия и глобальные геополитические сдвиги.", "zh": "政治体制、外交和全球地缘政治转变。"}
        }
    }

    # Lesson Titles (mapped to our content structure)
    LESSON_TITLES = {
        "c1_u1": [
            {"en": "Aesthetics of Poetry", "ar": "جماليات الشعر", "fr": "Esthétique de la poésie", "de": "Ästhetik der Lyrik", "ru": "Эстетика поэзии", "zh": "诗歌美学"},
            {"en": "The Art of Maqamat", "ar": "فن المقامات", "fr": "L'art des Maqamât", "de": "Die Kunst der Maqamat", "ru": "Искусство макаматов", "zh": "玛卡马特艺术"},
            {"en": "Classical Prose", "ar": "النثر الكلاسيكي", "fr": "Prose classique", "de": "Klassische Prosa", "ru": "Классическая проза", "zh": "古典散文"},
            {"en": "Metaphor and Imagery", "ar": "الاستعارة والخيال", "fr": "Métaphore et imagerie", "de": "Metapher und Bildsprache", "ru": "Метафора и изобразительность", "zh": "隐喻与意象"},
            {"en": "Literary Criticism", "ar": "النقد الأدبي", "fr": "Critique littéraire", "de": "Literaturkritik", "ru": "Литературная критика", "zh": "文学批评"},
            {"en": "Andalusian Literature", "ar": "الأدب الأندلسي", "fr": "Littérature andalouse", "de": "Andalusische Literatur", "ru": "Андалузская литература", "zh": "安达卢西亚文学"},
            {"en": "Vocabulary Review", "ar": "مراجعة المفردات", "fr": "Révision du vocabulaire", "de": "Wortschatzwiederholung", "ru": "Повторение лексики", "zh": "词汇复习"},
            {"en": "Literary Analysis", "ar": "التحليل الأدبي", "fr": "Analyse littéraire", "de": "Literarische Analyse", "ru": "Литературный анализ", "zh": "文学分析"}
        ],
        "c1_u2": [
            {"en": "Ibn Rushd's Philosophy", "ar": "فلسفة ابن رشد", "fr": "La philosophie d'Ibn Rushd", "de": "Die Philosophie von Ibn Rushd", "ru": "Философия Ибн Рушда", "zh": "伊本·鲁世德的哲学"},
            {"en": "House of Wisdom", "ar": "بيت الحكمة", "fr": "Maison de la sagesse", "de": "Haus der Weisheit", "ru": "Дом мудрости", "zh": "智慧宫"},
            {"en": "Logic and Theology", "ar": "المنطق وعلم الكلام", "fr": "Logique et théologie", "de": "Logik und Theologie", "ru": "Логика и теология", "zh": "逻辑与神学"},
            {"en": "The Virtuous City", "ar": "المدينة الفاضلة", "fr": "La cité vertueuse", "de": "Die tugendhafte Stadt", "ru": "Добродетельный город", "zh": "理想城市"},
            {"en": "Mysticism and Sufism", "ar": "التصوف والروحانية", "fr": "Mysticisme et soufisme", "de": "Mystik und Sufismus", "ru": "Мистицизм и суфизм", "zh": "神秘主义与苏非主义"},
            {"en": "Ethical Thought", "ar": "الفكر الأخلاقي", "fr": "Pensée éthique", "de": "Ethisches Denken", "ru": "Этическая мысль", "zh": "伦理思想"},
            {"en": "Terminology Review", "ar": "مراجعة المصطلحات", "fr": "Révision de la terminologie", "de": "Terminologiewiederholung", "ru": "Повторение терминологии", "zh": "术语复习"},
            {"en": "Philosophical Discussion", "ar": "مناقشة فلسفية", "fr": "Discussion philosophique", "de": "Philosophische Diskussion", "ru": "Философская дискуссия", "zh": "哲学讨论"}
        ],
        "c1_u3": [
            {"en": "Islamic Banking", "ar": "الصيرفة الإسلامية", "fr": "Banque islamique", "de": "Islamisches Bankwesen", "ru": "Исламский банкинг", "zh": "伊斯兰银行业务"},
            {"en": "Fiscal Policy", "ar": "السياسة المالية", "fr": "Politique budgétaire", "de": "Fiskalpolitik", "ru": "Фискальная политика", "zh": "财政政策"},
            {"en": "Global Markets", "ar": "الأسواق العالمية", "fr": "Marchés mondiaux", "de": "Globale Märkte", "ru": "Мировые рынки", "zh": "全球市场"},
            {"en": "Wealth Management", "ar": "إدارة الثروات", "fr": "Gestion de patrimoine", "de": "Vermögensverwaltung", "ru": "Управление благосостоянием", "zh": "财富管理"},
            {"en": "Trade Law", "ar": "قانون التجارة", "fr": "Droit commercial", "de": "Handelsrecht", "ru": "Коммерческое право", "zh": "贸易法"},
            {"en": "Economic Integration", "ar": "التكامل الاقتصادي", "fr": "Intégration économique", "de": "Wirtschaftliche Integration", "ru": "Экономическая интеграция", "zh": "经济一体化"},
            {"en": "Terminology Review", "ar": "مراجعة المصطلحات", "fr": "Révision de la terminologie", "de": "Terminologiewiederholung", "ru": "Повторение терминологии", "zh": "术语复习"},
            {"en": "Economic Article", "ar": "مقال اقتصادي", "fr": "Article économique", "de": "Wirtschaftsartikel", "ru": "Экономическая статья", "zh": "经济文章"}
        ],
        "c1_u4": [
            {"en": "International Law", "ar": "القانون الدولي", "fr": "Droit international", "de": "Internationales Recht", "ru": "Международное право", "zh": "国际法"},
            {"en": "Diplomatic Immunity", "ar": "الحصانة الدبلوماسية", "fr": "Immunité diplomatique", "de": "Diplomatische Immunität", "ru": "Дипломатический иммунитет", "zh": "外交豁免权"},
            {"en": "Law of the Seas", "ar": "قانون البحار", "fr": "Droit de la mer", "de": "Seerecht", "ru": "Морское право", "zh": "海洋法"},
            {"en": "Human Rights", "ar": "حقوق الإنسان", "fr": "Droits de l'homme", "de": "Menschenrechte", "ru": "Права человека", "zh": "人权"},
            {"en": "War Crimes", "ar": "جرائم الحرب", "fr": "Crimes de guerre", "de": "Kriegsverbrechen", "ru": "Военные преступления", "zh": "战争罪"},
            {"en": "Dispute Resolution", "ar": "تسوية النزاعات", "fr": "Règlement des différends", "de": "Streitbeilegung", "ru": "Разрешение споров", "zh": "争端解决"},
            {"en": "Legal Terms", "ar": "مصطلحات قانونية", "fr": "Termes juridiques", "de": "Rechtliche Begriffe", "ru": "Юридические термины", "zh": "法律术语"},
            {"en": "Legal Opinion", "ar": "رأي قانوني", "fr": "Avis juridique", "de": "Rechtsgutachten", "ru": "Юридическое заключение", "zh": "法律意见"}
        ],
        "c1_u5": [
            {"en": "Principles of Interpretation", "ar": "أصول التفسير", "fr": "Principes d'interprétation", "de": "Prinzipien der Interpretation", "ru": "Принципы толкования", "zh": "解释原则"},
            {"en": "Hadith Science", "ar": "علم الحديث", "fr": "Science du Hadith", "de": "Hadith-Wissenschaft", "ru": "Наука о хадисах", "zh": "圣训科学"},
            {"en": "Comparative Religions", "ar": "مقارنة الأديان", "fr": "Religions comparées", "de": "Vergleichende Religionswissenschaft", "ru": "Сравнительное религиоведение", "zh": "比较宗教"},
            {"en": "The Concept of Ijtihad", "ar": "مفهوم الاجتهاد", "fr": "Le concept d'Ijtihad", "de": "Das Konzept des Ijtihad", "ru": "Концепция иджтихада", "zh": "伊智提哈德的概念"},
            {"en": "Interfaith Dialogue", "ar": "حوار الأديان", "fr": "Dialogue interreligieux", "de": "Interreligiöser Dialog", "ru": "Межрелигиозный диалог", "zh": "宗教间对话"},
            {"en": "Spirituality in Sufism", "ar": "الروحانية في التصوف", "fr": "Spiritualité dans le soufisme", "de": "Spiritualität im Sufismus", "ru": "Духовность в суфизме", "zh": "苏非主义中的灵性"},
            {"en": "Review of Terms", "ar": "مراجعة المصطلحات", "fr": "Révision des termes", "de": "Begriffsüberprüfung", "ru": "Повторение терминов", "zh": "术语复习"},
            {"en": "Text Analysis", "ar": "تحليل النصوص", "fr": "Analyse de texte", "de": "Textanalyse", "ru": "Анализ текста", "zh": "文本分析"}
        ],
        "c1_u6": [
            {"en": "Paleography", "ar": "علم الكتابات القديمة", "fr": "Paléographie", "de": "Paläographie", "ru": "Палеография", "zh": "古文字学"},
            {"en": "Manuscript Restoration", "ar": "ترميم المخطوطات", "fr": "Restauration de manuscrits", "de": "Restaurierung von Manuskripten", "ru": "Реставрация рукописей", "zh": "手稿修复"},
            {"en": "History of Libraries", "ar": "تاريخ المكتبات", "fr": "Histoire des bibliothèques", "de": "Geschichte der Bibliotheken", "ru": "История библиотек", "zh": "图书馆史"},
            {"en": "Codicology", "ar": "علم المخطوطات", "fr": "Codicologie", "de": "Kodikologie", "ru": "Кодикология", "zh": "码籍学"},
            {"en": "Digital Archiving", "ar": "الأرشفة الرقمية", "fr": "Archivage numérique", "de": "Digitale Archivierung", "ru": "Цифровое архивирование", "zh": "数字存档"},
            {"en": "Heritage Management", "ar": "إدارة التراث", "fr": "Gestion du patrimoine", "de": "Kulturerbemanagement", "ru": "Управление наследием", "zh": "遗产管理"},
            {"en": "Terminology Review", "ar": "مراجعة المصطلحات", "fr": "Révision de la terminologie", "de": "Terminologiewiederholung", "ru": "Повторение терминологиي", "zh": "术语复习"},
            {"en": "Manuscript Study", "ar": "دراسة المخطوطات", "fr": "Étude de manuscrits", "de": "Manuskriptstudie", "ru": "Изучение рукописей", "zh": "手稿研究"}
        ],
        "c1_u7": [
            {"en": "Morphology", "ar": "علم الصرف", "fr": "Morphologie", "de": "Morphologie", "ru": "Морфология", "zh": "形态学"},
            {"en": "Syntax and Parsing", "ar": "النحو والإعراب", "fr": "Syntaxe et analyse", "de": "Syntax und Analyse", "ru": "Синтаксис и разбор", "zh": "句法与解析"},
            {"en": "Semantics", "ar": "علم الدلالة", "fr": "Sémantique", "de": "Semantik", "ru": "Семантика", "zh": "语义学"},
            {"en": "Phonetics", "ar": "علم الأصوات", "fr": "Phonétique", "de": "Phonetik", "ru": "Фонетика", "zh": "语音学"},
            {"en": "Sociolinguistics", "ar": "علم اللغة الاجتماعي", "fr": "Sociolinguistique", "de": "Soziolinguistik", "ru": "Социолингвистика", "zh": "社会语言学"},
            {"en": "Lexicography", "ar": "صناعة المعاجم", "fr": "Lexicographie", "de": "Lexikographie", "ru": "Лексикография", "zh": "词典编纂"},
            {"en": "Review of Terms", "ar": "مراجعة المصطلحات", "fr": "Révision des termes", "de": "Begriffsüberprüfung", "ru": "Повторение терминов", "zh": "术语复习"},
            {"en": "Linguistic Analysis", "ar": "التحليل اللغوي", "fr": "Analyse linguistique", "de": "Linguistische Analyse", "ru": "Лингвистический анализ", "zh": "语言分析"}
        ],
        "c1_u8": [
            {"en": "National Identity", "ar": "الهوية الوطنية", "fr": "Identité nationale", "de": "Nationale Identität", "ru": "Национальная идентичность", "zh": "国家认同"},
            {"en": "Global Citizenship", "ar": "المواطنة العالمية", "fr": "Citoyenneté mondiale", "de": "Weltbürgerschaft", "ru": "Глобальное гражданство", "zh": "全球公民"},
            {"en": "Cultural Interaction", "ar": "التفاعل الثقافي", "fr": "Interaction culturelle", "de": "Kulturelle Interaktion", "ru": "Культурное взаимодействие", "zh": "文化交流"},
            {"en": "Pluralism", "ar": "التعددية", "fr": "Pluralisme", "de": "Pluralismus", "ru": "Плюрализм", "zh": "多元主义"},
            {"en": "Multiculturalism", "ar": "التعددية الثقافية", "fr": "Multiculturalisme", "de": "Multikulturalismus", "ru": "Мультикультурализм", "zh": "多元文化主义"},
            {"en": "Identity Crisis", "ar": "أزمة الهوية", "fr": "Crise d'identité", "de": "Identitätskrise", "ru": "Кризис идентичности", "zh": "身份危机"},
            {"en": "Terminology Review", "ar": "مراجعة المصطلحات", "fr": "Révision de la terminologie", "de": "Terminologiewiederholung", "ru": "Повторение терминологиي", "zh": "术语复习"},
            {"en": "Cultural Essay", "ar": "مقال ثقافي", "fr": "Essai culturel", "de": "Cultureller Essay", "ru": "Культурное эссе", "zh": "文化文章"}
        ],
        "c1_u9": [
            {"en": "Mental Health", "ar": "الصحة النفسية", "fr": "Santé mentale", "de": "Psychische Gesundheit", "ru": "Психическое здоровье", "zh": "心理健康"},
            {"en": "Depression and Anxiety", "ar": "الاكتئاب والقلق", "fr": "Dépression et anxiété", "de": "Depression und Angst", "ru": "Депрессия и тревога", "zh": "抑郁与焦虑"},
            {"en": "Emotional Intelligence", "ar": "الذكاء العاطفي", "fr": "Intelligence émotionnelle", "de": "Emotionale Intelligenz", "ru": "Эмоциональный интеллект", "zh": "情绪智力"},
            {"en": "Psychological Resilience", "ar": "المرونة النفسية", "fr": "Résilience psychologique", "de": "Psychologische Résilience", "ru": "Психологическая устойчивость", "zh": "心理韧性"},
            {"en": "Child Psychology", "ar": "علم نفس الطفل", "fr": "Psychologie de l'enfant", "de": "Kinderpsychologie", "ru": "Детская психология", "zh": "儿童心理学"},
            {"en": "Addiction and Recovery", "ar": "الإدمان والتعافي", "fr": "Addiction et rétablissement", "de": "Sucht und Genesung", "ru": "Зависимость и выздоровление", "zh": "成瘾与康复"},
            {"en": "Field Review", "ar": "مراجعة ميدانية", "fr": "Révision sur le terrain", "de": "Feldüberprüfung", "ru": "Полевой обзор", "zh": "现场复习"},
            {"en": "Case Study", "ar": "دراسة حالة", "fr": "Étude de cas", "de": "Fallstudie", "ru": "Тематическое исследование", "zh": "案例研究"}
        ],
        "c1_u10": [
            {"en": "Political Systems", "ar": "الأنظمة السياسية", "fr": "Systèmes politiques", "de": "Politische Systeme", "ru": "Политические системы", "zh": "政治制度"},
            {"en": "International Organizations", "ar": "المنظمات الدولية", "fr": "Organisations internationales", "de": "Internationale Organisationen", "ru": "Международные организации", "zh": "国际组织"},
            {"en": "Diplomacy", "ar": "الدبلوماسية", "fr": "Diplomatie", "de": "Diplomatie", "ru": "Дипломатия", "zh": "外交"},
            {"en": "Globalization", "ar": "العولمة", "fr": "Mondialisation", "de": "Globalisierung", "ru": "Глобализация", "zh": "全球化"},
            {"en": "International Law", "ar": "القانون الدولي", "fr": "Droit international", "de": "Internationales Recht", "ru": "Международное право", "zh": "国际法"},
            {"en": "Geopolitical Shifts", "ar": "التحولات الجيوسياسية", "fr": "Changements géopolitiques", "de": "Geopolitische Verschiebungen", "ru": "Геополитические сдвиги", "zh": "地缘政治转变"},
            {"en": "Terminology Review", "ar": "مراجعة المصطلحات", "fr": "Révision de la terminologie", "de": "Terminologiewiederholung", "ru": "Повторение терминологиي", "zh": "术语复习"},
            {"en": "Political Article", "ar": "مقال سياسي", "fr": "Article politique", "de": "Politischer Artikel", "ru": "Политическая статья", "zh": "政治文章"}
        ]
    }

    prompts = {
        'en': 'Translate: ', 'ar': 'ترجم: ', 'fr': 'Traduire : ', 
        'de': 'Übersetzen: ', 'ru': 'Перевести: ', 'zh': '翻译: '
    }

    def create_quiz(quiz_id, content_items, word_pool, sentence_pool, num_questions, localized_prompts, is_lesson=False):
        quiz_questions = []
        
        if is_lesson:
            words = [item for item in content_items if item["type"] == "word"]
            sentences = [item for item in content_items if item["type"] == "sentence"]
            
            # Word Questions (10)
            word_types = ["multipleChoice", "audioOptions", "speaking", "listening", "multipleChoice", 
                          "audioOptions", "speaking", "listening", "multipleChoice", "audioOptions"]
            # Sentence Questions (5)
            sentence_types = ["speaking", "listening", "multipleChoice", "audioOptions", "speaking"]
            
            for i in range(min(10, len(words))):
                item = words[i]
                arabic = item["arabic"]
                q_type = word_types[i]
                question = {"id": f"{quiz_id}_{i+1}", "type": q_type, "correctAnswer": arabic}
                if q_type in ["multipleChoice", "audioOptions", "listening"]:
                    opts_pool = [x for x in word_pool if x != arabic]
                    options = [arabic] + random.sample(opts_pool, min(len(opts_pool), 3))
                    random.shuffle(options)
                    question["options"] = options
                if q_type in ["audioOptions", "listening"]: question["audioUrl"] = "true"
                if q_type == "multipleChoice":
                    question["text"] = {lang: f"{localized_prompts[lang]}{item['translation'][lang]}" for lang in localized_prompts}
                else: question["text"] = arabic
                quiz_questions.append(question)
                
            for i in range(min(5, len(sentences))):
                item = sentences[i]
                arabic = item["arabic"]
                q_type = sentence_types[i]
                question = {"id": f"{quiz_id}_{i+11}", "type": q_type, "correctAnswer": arabic}
                if q_type in ["multipleChoice", "audioOptions", "listening"]:
                    opts_pool = [x for x in sentence_pool if x != arabic]
                    options = [arabic] + random.sample(opts_pool, min(len(opts_pool), 3))
                    random.shuffle(options)
                    question["options"] = options
                if q_type in ["audioOptions", "listening"]: question["audioUrl"] = "true"
                if q_type == "multipleChoice":
                    question["text"] = {lang: f"{localized_prompts[lang]}{item['translation'][lang]}" for lang in localized_prompts}
                else: question["text"] = arabic
                quiz_questions.append(question)
        else:
            sample_size = min(len(content_items), num_questions)
            quiz_items = random.sample(content_items, sample_size)
            for q_idx, item in enumerate(quiz_items, 1):
                arabic = item["arabic"]
                q_type = "multipleChoice"
                if q_idx % 4 == 0: q_type = "audioOptions"
                elif q_idx % 5 == 0: q_type = "listening"
                elif q_idx % 7 == 0: q_type = "speaking"
                question = {"id": f"{quiz_id}_{q_idx}", "type": q_type, "correctAnswer": arabic}
                if q_type in ["multipleChoice", "audioOptions", "listening"]:
                    pool = word_pool if item["type"] == "word" else sentence_pool
                    opts_pool = [x for x in pool if x != arabic]
                    options = [arabic] + random.sample(opts_pool, min(len(opts_pool), 3))
                    random.shuffle(options)
                    question["options"] = options
                if q_type in ["audioOptions", "listening"]: question["audioUrl"] = "true"
                if q_type == "multipleChoice":
                    question["text"] = {lang: f"{localized_prompts[lang]}{item['translation'][lang]}" for lang in localized_prompts}
                else: question["text"] = arabic
                quiz_questions.append(question)
        return quiz_questions

    new_c1 = {
        "id": "c1",
        "title": {"en": "C1 Level", "ar": "مستوى C1", "fr": "Niveau C1", "de": "C1 Niveau", "ru": "Уровень C1", "zh": "C1 级别"},
        "description": {"en": "Advanced language proficiency and professional academic discourse.", "ar": "إتقان اللغة المتقدم والخطاب الأكاديمي المهني.", "fr": "Maîtrise avancée de la langue et discours académique professionnel.", "de": "Fortgeschrittene Sprachkenntnisse und professioneller akademischer Diskurs.", "ru": "Продвинутое владение языком и профессиональный академический дискурс.", "zh": "高级语言水平和专业学术话语。"},
        "isLocked": True,
        "units": []
    }

    level_words, level_sentences, level_all_items = [], [], []

    for u_idx in range(1, 11):
        u_id = f"c1_u{u_idx}"
        unit_meta = UNIT_METADATA[u_id]
        unit_obj = {"id": u_id, "title": unit_meta["title"], "description": unit_meta["description"], "isLocked": True, "lessons": []}
        unit_words, unit_sentences, unit_all_items = [], [], []
        
        for l_idx in range(1, 9):
            l_id = f"l{l_idx}"
            lesson_titles = LESSON_TITLES[u_id]
            lesson_title_meta = lesson_titles[l_idx-1]
            # Use the full translation dictionary for the title
            lesson_title = lesson_title_meta
            
            curr_unit_key = u_id.replace("c1_", "")
            lesson_data = regen_data[curr_unit_key].get(l_id, {"words": [], "sentences": []})
            lesson_f_id = f"{u_id}_l{l_idx}"
            
            lesson_obj = {
                "id": lesson_f_id,
                "title": lesson_title,
                "type": "vocabulary", "xpReward": 25, "estimatedMinutes": 6, "isLocked": False, "content": []
            }
            
            l_w, l_s = [], []
            for w_idx, word in enumerate(lesson_data["words"], 1):
                ar = word.get("arabic") or word.get("ar")
                l_w.append(ar)
                
                # Translations might be direct top-level keys or in a 'translation' object
                translations = word.get("translation", word)
                
                item = {
                    "id": f"{lesson_f_id}_w{w_idx}", "type": "word", "arabic": ar,
                    "transliteration": {lang: get_transliteration(ar, lang) for lang in ['en', 'fr', 'de', 'ru', 'zh']},
                    "translation": {lang: translations.get(lang, "FIXME") for lang in ['en', 'fr', 'de', 'ru', 'zh']}
                }
                item["transliteration"]["ar"] = ar
                item["translation"]["ar"] = ar
                lesson_obj["content"].append(item)
                unit_all_items.append(item)
                unit_words.append(ar)
                
            for s_idx, sent in enumerate(lesson_data["sentences"], 1):
                ar = sent.get("arabic") or sent.get("ar")
                l_s.append(ar)
                
                # Translations might be direct top-level keys or in a 'translation' object
                translations = sent.get("translation", sent)
                
                item = {
                    "id": f"{lesson_f_id}_s{s_idx}", "type": "sentence", "arabic": ar,
                    "transliteration": {lang: get_transliteration(ar, lang) for lang in ['en', 'fr', 'de', 'ru', 'zh']},
                    "translation": {lang: translations.get(lang, "FIXME") for lang in ['en', 'fr', 'de', 'ru', 'zh']}
                }
                item["transliteration"]["ar"] = ar
                item["translation"]["ar"] = ar
                lesson_obj["content"].append(item)
                unit_all_items.append(item)
                unit_sentences.append(ar)
                
            lesson_obj["quiz"] = {
                "id": f"q_{lesson_f_id}_quiz",
                "questions": create_quiz(f"q_{lesson_f_id}", lesson_obj["content"], l_w, l_s, 15, prompts, is_lesson=True)
            }
            unit_obj["lessons"].append(lesson_obj)
            
        unit_obj["unitQuiz"] = {
            "id": f"q_{u_id}", "passingScore": 80,
            "questions": create_quiz(f"q_{u_id}", unit_all_items, unit_words, unit_sentences, 30, prompts)
        }
        new_c1["units"].append(unit_obj)
        level_all_items.extend(unit_all_items); level_words.extend(unit_words); level_sentences.extend(unit_sentences)

    new_c1["quiz"] = {"id": "q_c1_level", "questions": create_quiz("q_c1_level", level_all_items, level_words, level_sentences, 50, prompts)}
    new_c1["xpReward"] = 600

    with open(c1_json_path, 'w', encoding='utf-8') as f:
        json.dump(new_c1, f, ensure_ascii=False, indent=4)
    print("c1.json integration complete.")

if __name__ == "__main__":
    integrate()
