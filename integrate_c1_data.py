import json
import os
import re
import random

def clean_text(text):
    if isinstance(text, str):
        return text.replace('.', '')
    if isinstance(text, dict):
        return {k: clean_text(v) for k, v in text.items()}
    if isinstance(text, list):
        return [clean_text(i) for i in text]
    return text

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
        
    return clean_text(latin)

def integrate():
    content_data_path = 'c1_content_data.json'
    c1_json_path = 'assets/data/c1.json'
    
    with open(content_data_path, 'r', encoding='utf-8') as f:
        regen_data = json.load(f)["c1"]
        
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
            "title": {"en": "Identity and Culture", "ar": "الهوية والثقافة", "fr": "Identité et culture", "de": "Identität und Kultur", "ru": "Идентичность и культура", "zh": "身份与文化"},
            "description": {"en": "National and global identity, pluralism, and cultural interaction.", "ar": "الهوية الوطنية والعالمية والتعددية والتفاعل الثقافي.", "fr": "Identité nationale et mondiale, pluralisme et interaction culturelle.", "de": "Nationale und globale Identität, Pluralismus und kulturelle Interaktion.", "ru": "Национальная и глобальная идентичность, плюрализм и культурное взаимодействие.", "zh": "国家与全球认同、多元主义及文化交流。"}
        },
        "c1_u9": {
            "title": {"en": "Psychology and Society", "ar": "علم النفس والمجتمع", "fr": "Psychologie et société", "de": "Psychologie und Gesellschaft", "ru": "Психология и общество", "zh": "心理学与社会"},
            "description": {"en": "Mental health, emotional intelligence, and social psychology.", "ar": "الصحة النفسية والذكاء العاطفي وعلم النفس الاجتماعي.", "fr": "Santé mentale, intelligence émotionnelle et psychologie sociale.", "de": "Psychische Gesundheit, emotionale Intelligenz und Sozialpsychologie.", "ru": "Психическое здоровье, эмоциональный интеллект и социальная психология.", "zh": "心理健康、情绪智力及社会心理学。"}
        },
        "c1_u10": {
            "title": {"en": "Politics and Governance", "ar": "السياسة والحوكمة", "fr": "Politique et gouvernance", "de": "Politik und Governance", "ru": "Политика и управление", "zh": "政治与治理"},
            "description": {"en": "Political systems, diplomacy, and global geopolitical shifts.", "ar": "الأنظمة السياسية والدبلوماسية والتحولات الجيوسياسية العالمية.", "fr": "Systèmes politiques, diplomatie et changements géopolitiques mondiaux.", "de": "Politische Systeme, Diplomatie und globale geopolitische Veränderungen.", "ru": "Политические системы, дипломатия и глобальные геополитические сдвиги.", "zh": "政治制度、外交及全球地缘政治转变。"}
        }
    }

    LESSON_TITLES = {
        "c1_u1": [
            {"en": "Aesthetics of Poetry", "ar": "جماليات الشعر", "fr": "Esthétique de la poésie", "de": "Ästhetik der Poesie", "ru": "Эстетика поэзии", "zh": "诗歌美学"},
            {"en": "Literary Criticism", "ar": "النقد الأدبي", "fr": "Critique littéraire", "de": "Literaturkritik", "ru": "Литературная критика", "zh": "文学评论"},
            {"en": "Ancient Manuscripts", "ar": "المخطوطات القديمة", "fr": "Manuscrits anciens", "de": "Alte Manuskripte", "ru": "Древние рукописи", "zh": "古代手稿"},
            {"en": "Classic Prose", "ar": "النثر الكلاسيكي", "fr": "Prose classique", "de": "Klassische Prosa", "ru": "Классическая проза", "zh": "古典散文"},
            {"en": "Rhetoric", "ar": "البلاغة", "fr": "Rhétorique", "de": "Rhetorik", "ru": "Риторика", "zh": "修辞学"},
            {"en": "Literary Genres", "ar": "الأنواع الأدبية", "fr": "Genres littéraires", "de": "Literarische Genres", "ru": "Литературные жанры", "zh": "文学流派"},
            {"en": "Unit Review", "ar": "مراجعة الوحدة", "fr": "Révision de l'unité", "de": "Wiederholung der Einheit", "ru": "Обзор раздела", "zh": "单元复习"},
            {"en": "Classic Essay", "ar": "مقال كلاسيكي", "fr": "Essai classique", "de": "Klassischer Essay", "ru": "Классическое эссе", "zh": "经典文章"}
        ],
        "c1_u2": [
            {"en": "Logic and Reasoning", "ar": "المنطق والاستدلال", "fr": "Logique et raisonnement", "de": "Logik und Argumentation", "ru": "Логика и рассуждение", "zh": "逻辑与推理"},
            {"en": "Islamic Theology", "ar": "علم الكلام", "fr": "Théologie islamique", "de": "Islamische Theologie", "ru": "Исламская теология", "zh": "伊斯兰神学"},
            {"en": "Ethical Frameworks", "ar": "الأطر الأخلاقية", "fr": "Cadres éthiques", "de": "Ethische Rahmen", "ru": "Этические основы", "zh": "伦理框架"},
            {"en": "Rationalism", "ar": "النزعة العقلانية", "fr": "Rationalisme", "de": "Rationalismus", "ru": "Рационализм", "zh": "理性主义"},
            {"en": "Sufi Thought", "ar": "الفكر الصوفي", "fr": "Pensée soufie", "de": "Sufi-Denken", "ru": "Суфийская мысль", "zh": "苏菲思想"},
            {"en": "Existence and Being", "ar": "الوجود والموجود", "fr": "Existence et être", "de": "Existenz und Sein", "ru": "Существование и бытие", "zh": "存在与生命"},
            {"en": "Review of Ideas", "ar": "مراجعة الأفكار", "fr": "Révision des idées", "de": "Ideenüberprüfung", "ru": "Обзор идей", "zh": "思想复习"},
            {"en": "Philosophical Text", "ar": "نص فلسفي", "fr": "Texte philosophique", "de": "Philosophischer Text", "ru": "Философский текст", "zh": "哲学文本"}
        ],
        "c1_u3": [
            {"en": "Macroeconomic Trends", "ar": "الاتجاهات الاقتصادية الكلية", "fr": "Tendances macroéconomiques", "de": "Makroökonomische Trends", "ru": "Макроэкономические тенденции", "zh": "宏观经济趋势"},
            {"en": "Banking Regulations", "ar": "أنظمة البنوك", "fr": "Réglementations bancaires", "de": "Bankenvorschriften", "ru": "Банковское регулирование", "zh": "银行监管"},
            {"en": "Stock Markets", "ar": "أسواق الأسهم", "fr": "Marchés boursiers", "de": "Aktienmärkte", "ru": "Фондовые рынки", "zh": "股票市场"},
            {"en": "Investment Strategies", "ar": "استراتيجيات الاستثمار", "fr": "Stratégies d'investissement", "de": "Investitionsstrategien", "ru": "Инвестиционные стратегии", "zh": "投资策略"},
            {"en": "Fiscal Policy", "ar": "السياسة المالية", "fr": "Politique fiscale", "de": "Fiskalpolitik", "ru": "Фискальная политика", "zh": "财政政策"},
            {"en": "Global Trade", "ar": "التجارة العالمية", "fr": "Commerce mondial", "de": "Welthandel", "ru": "Мировая торговля", "zh": "全球贸易"},
            {"en": "Finance Review", "ar": "مراجعة مالية", "fr": "Révision financière", "de": "Finanzrückschau", "ru": "Финансовый обзор", "zh": "金融复习"},
            {"en": "Economic Analysis", "ar": "تحليل اقتصادي", "fr": "Analyse économique", "de": "Wirtschaftsanalyse", "ru": "Экономический анализ", "zh": "经济分析"}
        ],
        "c1_u4": [
            {"en": "International Treaties", "ar": "المعاهدات الدولية", "fr": "Traités internationaux", "de": "Internationale Verträge", "ru": "Международные договоры", "zh": "国际条约"},
            {"en": "Human Rights Law", "ar": "قانون حقوق الإنسان", "fr": "Droit des droits de l'homme", "de": "Menschenrechte", "ru": "Право в области прав человека", "zh": "人权法"},
            {"en": "Corporate Law", "ar": "القانون المؤسسي", "fr": "Droit des sociétés", "de": "Gesellschaftsrecht", "ru": "Корпоративное право", "zh": "公司法"},
            {"en": "Criminal Justice", "ar": "العدالة الجنائية", "fr": "Justice pénale", "de": "Strafjustiz", "ru": "Уголовное правосудие", "zh": "刑事司法"},
            {"en": "Legal Procedures", "ar": "الإجراءات القانونية", "fr": "Procédures juridiques", "de": "Rechtliche Verfahren", "ru": "Юридические процедуры", "zh": "法律程序"},
            {"en": "Arbitration", "ar": "التحكيم", "fr": "Arbitrage", "de": "Schiedsgerichtsbarkeit", "ru": "Арбитраж", "zh": "仲裁"},
            {"en": "Legal Review", "ar": "مراجعة قانونية", "fr": "Révision juridique", "de": "Rechtliche Überprüfung", "ru": "Юридический обзор", "zh": "法律复习"},
            {"en": "Case Law", "ar": "قانون السوابق القضائية", "fr": "Jurisprudence", "de": "Fallrecht", "ru": "Прецедентное право", "zh": "判例法"}
        ],
        "c1_u5": [
            {"en": "Scriptural Interpretation", "ar": "تفسير النصوص", "fr": "Interprétation scripturale", "de": "Bibelinterpretation", "ru": "Толкование Писания", "zh": "经文解释"},
            {"en": "Comparative Religions", "ar": "مقارنة الأديان", "fr": "Religions comparées", "de": "Vergleichende Religionswissenschaft", "ru": "Сравнительное религиоведение", "zh": "比较宗教"},
            {"en": "Theological Disputes", "ar": "النزاعات العقائدية", "fr": "Disputes théologiques", "de": "Theologische Streitfalle", "ru": "Теологические споры", "zh": "神学争议"},
            {"en": "Spiritual Practices", "ar": "الممارسات الروحية", "fr": "Pratiques spirituelles", "de": "Spirituelle Praktiken", "ru": "Духовные практики", "zh": "精神修行"},
            {"en": "Secularism and Faith", "ar": "العلمانية والإيمان", "fr": "Sécularisme et foi", "de": "Säkularismus und Glaube", "ru": "Секуляризм и вера", "zh": "世俗主义与信仰"},
            {"en": "Interfaith Dialogue", "ar": "حوار الأديان", "fr": "Dialogue interreligieux", "de": "Interreligiöser Dialog", "ru": "Межконфессиональный диалог", "zh": "宗教间对话"},
            {"en": "Religious Terms", "ar": "مصطلحات دينية", "fr": "Termes religieux", "de": "Religiöse Begriffe", "ru": "Религиозные термины", "zh": "宗教术语"},
            {"en": "Theological Article", "ar": "مقال عقائدي", "fr": "Article théologique", "de": "Theologischer Artikel", "ru": "Теологическая статья", "zh": "神学文章"}
        ],
        "c1_u6": [
            {"en": "Ancient Civilizations", "ar": "الحضارات القديمة", "fr": "Civilisations anciennes", "de": "Alte Zivilisationen", "ru": "Древние цивилизации", "zh": "古代文明"},
            {"en": "Archaeological Methods", "ar": "أساليب علم الآثار", "fr": "Méthodes archéologiques", "de": "Archäologische Methoden", "ru": "Археологические методы", "zh": "考古学方法"},
            {"en": "Medieval History", "ar": "تاريخ العصور الوسطى", "fr": "Histoire médiévale", "de": "Mittelalterliche Geschichte", "ru": "Средневековая история", "zh": "中世纪历史"},
            {"en": "Historiography", "ar": "تأريخ", "fr": "Historiographie", "de": "Historiographie", "ru": "Историография", "zh": "史学"},
            {"en": "Cultural Heritage", "ar": "التراث الثقافي", "fr": "Patrimoine culturel", "de": "Kulturerbe", "ru": "Культурное наследие", "zh": "文化遗产"},
            {"en": "Manuscript Restoration", "ar": "ترميم المخطوطات", "fr": "Restauration de manuscrits", "de": "Manuskriptrestaurierung", "ru": "Реставрация рукописей", "zh": "手稿修复"},
            {"en": "Heritage Review", "ar": "مراجعة التراث", "fr": "Révision du patrimoine", "de": "Kulturerberückschau", "ru": "Обзор наследия", "zh": "遗产复习"},
            {"en": "Historical Text", "ar": "نص تاريخي", "fr": "Texte historique", "de": "Historischer Text", "ru": "Исторический текст", "zh": "历史文本"}
        ],
        "c1_u7": [
            {"en": "Phonology", "ar": "علم وظائف الأصوات", "fr": "Phonologie", "de": "Phonologie", "ru": "Фонология", "zh": "音系学"},
            {"en": "Advanced Syntax", "ar": "النحو المتقدم", "fr": "Syntaxe avancée", "de": "Fortgeschrittene Syntax", "ru": "Продвинутый синтаксис", "zh": "高级句法"},
            {"en": "Morphology", "ar": "علم الصرف", "fr": "Morphologie", "de": "Morphologie", "ru": "Морфология", "zh": "形态学"},
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
            {"en": "Depression and Anxiety", "ar": "الاكتئاب والقلق", "fr": "Dépression et anxiété", "de": "Depression und angst", "ru": "Депрессия и тревога", "zh": "抑郁与焦虑"},
            {"en": "Emotional Intelligence", "ar": "الذكاء العاطفي", "fr": "Intelligence émotionnelle", "de": "Emotionale Intelligenz", "ru": "Эмоциональный интеллект", "zh": "情绪智力"},
            {"en": "Psychological Resilience", "ar": "المرونة النفسية", "fr": "Résilience psychologique", "de": "Psychologische Resilienz", "ru": "Психологическая устойчивость", "zh": "心理韧性"},
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
        "title": clean_text({"en": "C1 Level", "ar": "مستوى C1", "fr": "Niveau C1", "de": "C1 Niveau", "ru": "Уровень C1", "zh": "C1 级别"}),
        "description": clean_text({"en": "Advanced language proficiency and professional academic discourse.", "ar": "إتقان اللغة المتقدم والخطاب الأكاديمي المهني.", "fr": "Maîtrise avancée de la langue et discours académique professionnel.", "de": "Fortgeschrittene Sprachkenntnisse und professioneller akademischer Diskurs.", "ru": "Продвинутое владение языком и профессиональный академический дискурс.", "zh": "高级语言水平和专业学术话语。"}),
        "isLocked": True,
        "units": []
    }

    level_words, level_sentences, level_all_items = [], [], []

    # Clean metadata
    UNIT_METADATA = clean_text(UNIT_METADATA)
    LESSON_TITLES = clean_text(LESSON_TITLES)

    for u_idx in range(1, 11):
        u_id = f"c1_u{u_idx}"
        unit_meta = UNIT_METADATA[u_id]
        unit_obj = {"id": u_id, "title": unit_meta["title"], "description": unit_meta["description"], "isLocked": True, "lessons": []}
        unit_words, unit_sentences, unit_all_items = [], [], []
        
        for l_idx in range(1, 9):
            l_id = f"l{l_idx}"
            lesson_titles = LESSON_TITLES[u_id]
            lesson_title_meta = lesson_titles[l_idx-1]
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
                ar = clean_text(word.get("arabic") or word.get("ar"))
                l_w.append(ar)
                translations = word.get("translation", word)
                item = {
                    "id": f"{lesson_f_id}_w{w_idx}", "type": "word", "arabic": clean_text(ar),
                    "transliteration": {lang: get_transliteration(ar, lang) for lang in ['en', 'fr', 'de', 'ru', 'zh']},
                    "translation": clean_text({lang: translations.get(lang, "FIXME") for lang in ['en', 'fr', 'de', 'ru', 'zh']})
                }
                item["transliteration"]["ar"] = clean_text(ar)
                item["translation"]["ar"] = clean_text(ar)
                lesson_obj["content"].append(item)
                unit_all_items.append(item)
                unit_words.append(ar)
                
            for s_idx, sent in enumerate(lesson_data["sentences"], 1):
                ar = clean_text(sent.get("arabic") or sent.get("ar"))
                l_s.append(ar)
                translations = sent.get("translation", sent)
                item = {
                    "id": f"{lesson_f_id}_s{s_idx}", "type": "sentence", "arabic": clean_text(ar),
                    "transliteration": {lang: get_transliteration(ar, lang) for lang in ['en', 'fr', 'de', 'ru', 'zh']},
                    "translation": clean_text({lang: translations.get(lang, "FIXME") for lang in ['en', 'fr', 'de', 'ru', 'zh']})
                }
                item["transliteration"]["ar"] = clean_text(ar)
                item["translation"]["ar"] = clean_text(ar)
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

    # Level Quiz
    new_c1["levelQuiz"] = {
        "id": "c1_final_exam",
        "passingScore": 0.8,
        "questions": create_quiz("q_c1_final_exam", level_all_items, level_words, level_sentences, 50, prompts)
    }
    new_c1["xpReward"] = 600

    with open(c1_json_path, 'w', encoding='utf-8') as f:
        json.dump(new_c1, f, ensure_ascii=False, indent=4)
    print("c1.json integration complete.")

if __name__ == "__main__":
    integrate()
