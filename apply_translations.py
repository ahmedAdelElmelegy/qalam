import json

# Translation Map for Units and Lessons
UNIT_DATA = {
    "c2_u1": {
        "title": {"en": "Academic Discourse", "ar": "الخطاب الأكاديمي", "fr": "Discours académique", "de": "Akademischer Diskurs", "ru": "Академический дискурс", "zh": "学术话语"},
        "desc": {"en": "Epistemology, critical theory, and academic integrity.", "ar": "الابستمولوجيا، النظرية النقدية، والنزاهة الأكاديمية.", "fr": "Épistémologie, théorie critique et intégrité académique.", "de": "Erkenntnistheorie, kritische Theorie und akademische Integrität.", "ru": "Эпистемология, критическая теория и академическая честность.", "zh": "认识论、批判理论和学术诚信。"},
        "lessons": {
            "c2_u1_l1": {"en": "Theory of Knowledge", "ar": "نظرية المعرفة", "fr": "Théorie de la connaissance", "de": "Wissenstheorie", "ru": "Теория познания", "zh": "知识论"},
            "c2_u1_l2": {"en": "Critical Theory & Society", "ar": "النظرية النقدية والمجتمع", "fr": "Théorie critique et société", "de": "Kritische Theorie und Gesellschaft", "ru": "Критическая теория и общество", "zh": "批判理论与社会"},
            "c2_u1_l3": {"en": "Epistemological Rupture", "ar": "القطيعة الابستمولوجية", "fr": "Rupture épistémologique", "de": "Epistemologischer Bruch", "ru": "Эпистемологический разрыв", "zh": "认识论断裂"},
            "c2_u1_l4": {"en": "Academic Integrity Policy", "ar": "سياسة النزاهة الأكاديمية", "fr": "Politique d'intégrité académique", "de": "Richtlinien zur akademischen Integrität", "ru": "Политика академической честности", "zh": "学术诚信政策"},
            "c2_u1_l5": {"en": "Discourse Analysis Methods", "ar": "مناهج تحليل الخطاب", "fr": "Méthodes d'analyse du discours", "de": "Methoden der Diskursanalyse", "ru": "Методы дискурс-анализа", "zh": "话语分析方法"},
            "c2_u1_l6": {"en": "The Ethics of AI Research", "ar": "أخلاقيات أبحاث الذكاء الاصطناعي", "fr": "Éthique de la recherche en IA", "de": "Ethik der KI-Forschung", "ru": "Этика исследований в области ИИ", "zh": "人工智能研究伦理"},
            "c2_u1_l7": {"en": "Academic Terms Review", "ar": "مراجعة المصطلحات الأكاديمية", "fr": "Révision des termes académiques", "de": "Wiederholung akademischer Fachbegriffe", "ru": "Обзор академических терминов", "zh": "学术术语复习"},
            "c2_u1_l8": {"en": "Present a Theoretical Framework", "ar": "تقديم إطار نظري", "fr": "Présenter un cadre théorique", "de": "Einen theoretischen Rahmen präsentieren", "ru": "Представление теоретической базы", "zh": "展示理论框架"}
        }
    },
    "c2_u2": {
        "title": {"en": "Professional Diplomacy", "ar": "الدبلوماسية المهنية", "fr": "Diplomatie professionnelle", "de": "Berufliche Diplomatie", "ru": "Профессиональная дипломатия", "zh": "专业外交"},
        "desc": {"en": "Consular roles, diplomatic protocol, and international norms.", "ar": "الأدوار القنصلية، البروتوكول الدبلوماسي، والمعايير الدولية.", "fr": "Rôles consulaires, protocole diplomatique et normes internationales.", "de": "Konsularische Aufgaben, diplomatisches Protokoll und internationale Normen.", "ru": "Консульские роли, дипломатический протокол и международные нормы.", "zh": "领事角色、外交礼节和国际规范。"},
        "lessons": {
            "c2_u2_l1": {"en": "Diplomatic Protocol", "ar": "البروتوكول الدبلوماسي", "fr": "Protocole diplomatique", "de": "Diplomatisches Protokoll", "ru": "Дипломатический протокол", "zh": "外交礼节"},
            "c2_u2_l2": {"en": "Consular Functions", "ar": "المهام القنصلية", "fr": "Fonctions consulaires", "de": "Konsularische Funktionen", "ru": "Консульские функции", "zh": "领事职能"},
            "c2_u2_l3": {"en": "Multilateralism Future", "ar": "مستقبل التعددية", "fr": "L'avenir du multilatéralisme", "de": "Zukunft des Multilateralismus", "ru": "Будущее многосторонности", "zh": "多边主义的未来"},
            "c2_u2_l4": {"en": "Crisis Diplomacy", "ar": "دبلوماسية الأزمات", "fr": "Diplomatie de crise", "de": "Krisendiplomatie", "ru": "Кризисная дипломатия", "zh": "危机外交"},
            "c2_u2_l5": {"en": "Economic Statecraft", "ar": "فن إدارة الدولة اقتصادياً", "fr": "Gestion économique de l'État", "de": "Wirtschaftliche Staatskunst", "ru": "Экономическое искусство управления государством", "zh": "经济治国方略"},
            "c2_u2_l6": {"en": "Public Diplomacy (PD)", "ar": "الدبلوماسية العامة", "fr": "Diplomatie publique", "de": "Öffentliche Diplomatie", "ru": "Публичная дипломатия", "zh": "公共外交"},
            "c2_u2_l7": {"en": "Diplomacy Review", "ar": "مراجعة الدبلوماسية", "fr": "Révision de la diplomatie", "de": "Wiederholung der Diplomatie", "ru": "Обзор дипломатии", "zh": "外交复习"},
            "c2_u2_l8": {"en": "Simulate a UN Security Meeting", "ar": "محاكاة اجتماع مجلس الأمن", "fr": "Simuler une réunion de sécurité de l'ONU", "de": "Simulation einer UN-Sicherheitsratssitzung", "ru": "Моделирование заседания СБ ООН", "zh": "模拟联合国安理会会议"}
        }
    },
    "c2_u3": {
        "title": {"en": "Advanced Law", "ar": "القانون المتقدم", "fr": "Droit avancé", "de": "Fortgeschrittenes Recht", "ru": "Продвинутое право", "zh": "高等法律"},
        "desc": {"en": "Comparative law, constitutional theory, and jurisprudence.", "ar": "القانون المقارن، النظرية الدستورية، والفقه القانوني.", "fr": "Droit comparé, théorie constitutionnelle et jurisprudence.", "de": "Rechtsvergleichung, Verfassungstheorie und Rechtswissenschaft.", "ru": "Сравнительное правоведение, конституционная теория и юриспруденция.", "zh": "比较法、宪法理论和法理学。"},
        "lessons": {
            "c2_u3_l1": {"en": "Comparative Legal Systems", "ar": "الأنظمة القانونية المقارنة", "fr": "Systèmes juridiques comparés", "de": "Vergleichende Rechtssysteme", "ru": "Сравнительные правовые системы", "zh": "比较法律体系"},
            "c2_u3_l2": {"en": "Constitutional Theory", "ar": "النظرية الدستورية", "fr": "Théorie constitutionnelle", "de": "Verfassungstheorie", "ru": "Конституционная теория", "zh": "宪法理论"},
            "c2_u3_l3": {"en": "Legal Philosophy (Jurisprudence)", "ar": "فلسفة القانون (الفقه)", "fr": "Philosophie du droit (Jurisprudence)", "de": "Rechtsphilosophie (Jurisprudenz)", "ru": "Философия права (юриспруденция)", "zh": "法律哲学（法理学）"},
            "c2_u3_l4": {"en": "Administrative Law", "ar": "القانون الإداري", "fr": "Droit administratif", "de": "Verwaltungsrecht", "ru": "Административное право", "zh": "行政法"},
            "c2_u3_l5": {"en": "Corporate Governance Law", "ar": "قانون حوكمة الشركات", "fr": "Droit de la gouvernance d'entreprise", "de": "Corporate-Governance-Recht", "ru": "Закон о корпоративном управлении", "zh": "公司治理法"},
            "c2_u3_l6": {"en": "Intellectual Property Law", "ar": "قانون الملكية الفكرية", "fr": "Droit de la propriété intellectuelle", "de": "Recht des geistigen Eigentums", "ru": "Закон об интеллектуальной собственности", "zh": "知识产权法"},
            "c2_u3_l7": {"en": "Advanced Legal Review", "ar": "مراجعة قانونية متقدمة", "fr": "Révision juridique avancée", "de": "Fortgeschrittene rechtliche Wiederholung", "ru": "Продвинутый юридический обзор", "zh": "高级法律复习"},
            "c2_u3_l8": {"en": "Draft a Constitutional Amendment", "ar": "صياغة تعديل دستوري", "fr": "Rédiger un amendement constitutionnel", "de": "Einen Verfassungszusatz entwerfen", "ru": "Составление поправки к конституции", "zh": "起草宪法修正案"}
        }
    },
    "c2_u4": {
        "title": {"en": "Theoretical Linguistics", "ar": "اللسانيات النظرية", "fr": "Linguistique théorique", "de": "Theoretische Linguistik", "ru": "Теоретическая лингвистика", "zh": "理论语言学"},
        "desc": {"en": "Semiotics, generative grammar, and computational linguistics.", "ar": "السيميائيات، النحو التوليدي، واللسانيات الحاسوبية.", "fr": "Sémiotique, grammaire générative et linguistique informatique.", "de": "Semiotik, generative Grammatik und Computerlinguistik.", "ru": "Семиотика, генеративная грамматика и компьютерная лингвистика.", "zh": "符号学、生成语法和计算语言学。"},
        "lessons": {
            "c2_u4_l1": {"en": "Generative Grammar", "ar": "النحو التوليدي", "fr": "Grammaire générative", "de": "Generative Grammatik", "ru": "Генеративная грамматика", "zh": "生成语法"},
            "c2_u4_l2": {"en": "Semiotics of the Text", "ar": "سيميائيات النص", "fr": "Sémiotique du texte", "de": "Textsemiotik", "ru": "Семиотика текста", "zh": "文本符号学"},
            "c2_u4_l3": {"en": "Computational Linguistics", "ar": "اللسانيات الحاسوبية", "fr": "Linguistique informatique", "de": "Computerlinguistik", "ru": "Компьютерная лингвистика", "zh": "计算语言学"},
            "c2_u4_l4": {"en": "Cognitive Linguistics", "ar": "اللسانيات المعرفية", "fr": "Linguistique cognitive", "de": "Kognitive Linguistik", "ru": "Когнитивная лингвистика", "zh": "认知语言学"},
            "c2_u4_l5": {"en": "Historical Linguistics", "ar": "اللسانيات التاريخية", "fr": "Linguistique historique", "de": "Historische Linguistik", "ru": "Историческая лингвистика", "zh": "历史语言学"},
            "c2_u4_l6": {"en": "The Science of Dictionaries", "ar": "علم القواميس (المعجمية)", "fr": "La science des dictionnaires", "de": "Lexikographie", "ru": "Лексикография", "zh": "词典科学"},
            "c2_u4_l7": {"en": "Theoretical Linguistics Review", "ar": "مراجعة اللسانيات النظرية", "fr": "Révision de la linguistique théorique", "de": "Wiederholung der theoretischen Linguistik", "ru": "Обзор теоретической лингвистики", "zh": "理论语言学复习"},
            "c2_u4_l8": {"en": "Analyze a Semiotic Structure", "ar": "تحليل بنية سيميائية", "fr": "Analyser une structure sémiotique", "de": "Eine semiotische Struktur analysieren", "ru": "Анализ семиотической структуры", "zh": "分析符号结构"}
        }
    },
    "c2_u5": {
        "title": {"en": "Classical Philosophy", "ar": "الفلسفة الكلاسيكية", "fr": "Philosophie classique", "de": "Klassische Philosophie", "ru": "Классическая философия", "zh": "古典哲学"},
        "desc": {"en": "Neoplatonism, dialectics, and medieval logic.", "ar": "الأفلاطونية المحدثة، الجدلية، والمنطق في العصور الوسطى.", "fr": "Néoplatonisme, dialectique et logique médiévale.", "de": "Neuplatonismus, Dialektik und mittelalterliche Logik.", "ru": "Неоплатонизм, диалектика и средневековая логика.", "zh": "新柏拉图主义、辩证法和中世纪逻辑。"},
        "lessons": {
            "c2_u5_l1": {"en": "Neoplatonism in Arabic", "ar": "الأفلاطونية المحدثة بالعربية", "fr": "Néoplatonisme en arabe", "de": "Neuplatonismus auf Arabisch", "ru": "Неоплатонизм на арабском языке", "zh": "阿拉伯语中的新柏拉图主义"},
            "c2_u5_l2": {"en": "Aristotelian Dialectics", "ar": "الجدليات الأرسطية", "fr": "Dialectique aristotélicienne", "de": "Aristotelische Dialektik", "ru": "Аристотелевская диалектика", "zh": "亚里士多德辩证法"},
            "c2_u5_l3": {"en": "Medieval Logic Systems", "ar": "أنظمة المنطق في العصور الوسطى", "fr": "Systèmes de logique médiévale", "de": "Mittelalterliche Logiksysteme", "ru": "Средневековые логические системы", "zh": "中世纪逻辑系统"},
            "c2_u5_l4": {"en": "The Problem of Universals", "ar": "مشكلة الكليات", "fr": "Le problème des universaux", "de": "Das Universalienproblem", "ru": "Проблема универсалий", "zh": "共相问题"},
            "c2_u5_l5": {"en": "Metaphysics of Existence", "ar": "ميتافيزيقا الوجود", "fr": "Métaphysique de l'existence", "de": "Metaphysik des Daseins", "ru": "Метафизика существования", "zh": "存在的形而上学"},
            "c2_u5_l6": {"en": "Reason vs. Revelation", "ar": "العقل مقابل الوحي", "fr": "Raison contre révélation", "de": "Vernunft vs. Offenbarung", "ru": "Разум против Откровения", "zh": "理性与启示"},
            "c2_u5_l7": {"en": "Advanced Philosophy Review", "ar": "مراجعة فلسفية متقدمة", "fr": "Révision philosophique avancée", "de": "Fortgeschrittene philosophische Wiederholung", "ru": "Продвинутый философский обзор", "zh": "高级哲学复习"},
            "c2_u5_l8": {"en": "Critique a Philosophical Fragment", "ar": "نقد شذرة فلسفية", "fr": "Critiquer un fragment philosophique", "de": "Ein philosophisches Fragment kritisieren", "ru": "Критика философского фрагмента", "zh": "评论哲学片段"}
        }
    },
    "c2_u6": {
        "title": {"en": "Global Strategic Policy", "ar": "السياسة الاستراتيجية العالمية", "fr": "Politique stratégique mondiale", "de": "Globale strategische Politik", "ru": "Глобальная стратегическая политика", "zh": "全球战略政策"},
        "desc": {"en": "Geopolitics, sustainability goals, and global governance.", "ar": "الجغرافيا السياسية، أهداف الاستدامة، والحوكمة العالمية.", "fr": "Géopolitique, objectifs de durabilité et gouvernance mondiale.", "de": "Geopolitik, Nachhaltigkeitsziele und Global Governance.", "ru": "Геополитика, цели устойчивого развития и глобальное управление.", "zh": "地缘政治、可持续发展目标和全球治理。"},
        "lessons": {
            "c2_u6_l1": {"en": "Geopolitics of the Middle East", "ar": "الجغرافيا السياسية للشرق الأوسط", "fr": "Géopolitique du Moyen-Orient", "de": "Geopolitik des Nahen Ostens", "ru": "Геополитика Ближнего Востока", "zh": "中东地缘政治"},
            "c2_u6_l2": {"en": "UN Sustainable Goals", "ar": "أهداف الأمم المتحدة المستدامة", "fr": "Objectifs durables de l'ONU", "de": "Nachhaltige UN-Ziele", "ru": "Цели устойчивого развития ООН", "zh": "联合国可持续发展目标"},
            "c2_u6_l3": {"en": "Global Governance Architect", "ar": "معمار الحوكمة العالمية", "fr": "Architecte de la gouvernance mondiale", "de": "Architektur der Global Governance", "ru": "Архитектура глобального управления", "zh": "全球治理架构"},
            "c2_u6_l4": {"en": "Cyber Warfare Policy", "ar": "سياسة الحروب الإلكترونية", "fr": "Politique de guerre cybernétique", "de": "Strategie zur Cyberkriegsführung", "ru": "Политика кибервойны", "zh": "网络战争政策"},
            "c2_u6_l5": {"en": "Resource Scarcity Security", "ar": "أمن ندرة الموارد", "fr": "Sécurité de la rareté des ressources", "de": "Sicherheit bei Ressourcenknappheit", "ru": "Безопасность в условиях дефицита ресурсов", "zh": "资源稀缺安全"},
            "c2_u6_l6": {"en": "Non-State Actors Roles", "ar": "أدوار الفاعلين من غير الدول", "fr": "Rôles des acteurs non étatiques", "de": "Rollen nichtstaatlicher Akteure", "ru": "Роли негосударственных субъектов", "zh": "非国家行为者的角色"},
            "c2_u6_l7": {"en": "Strategic Policy Review", "ar": "مراجعة السياسة الاستراتيجية", "fr": "Révision de la politique stratégique", "de": "Wiederholung der strategischen Politik", "ru": "Обзор стратегической политики", "zh": "战略政策复习"},
            "c2_u6_l8": {"en": "Draft a Strategic Forecast", "ar": "صياغة توقع استراتيجي", "fr": "Rédiger une prévision stratégique", "de": "Einen strategischen Ausblick entwerfen", "ru": "Составление стратегического прогноза", "zh": "起草战略预测"}
        }
    },
    "c2_u7": {
        "title": {"en": "High Literature", "ar": "الأدب الرفيع", "fr": "Haute littérature", "de": "Hohe Literatur", "ru": "Высокая литература", "zh": "高等文学"},
        "desc": {"en": "Mu'allaqat analysis, modern realism, and post-modernism.", "ar": "تحليل المعلقات، والواقعية الحديثة، وما بعد الحداثة.", "fr": "Analyse des Mu'allaqat, réalisme moderne et post-modernisme.", "de": "Mu'allaqat-Analyse, moderner Realismus und Postmoderne.", "ru": "Анализ Муаллакат, современный реализм и постмодернизм.", "zh": "悬诗分析、现代现实主义和后现代主义。"},
        "lessons": {
            "c2_u7_l1": {"en": "Exegesis of the Mu'allaqat", "ar": "شرح المعلقات", "fr": "Exégèse des Mu'allaqat", "de": "Exegese der Mu'allaqat", "ru": "Толкование Муаллакат", "zh": "悬诗注释"},
            "c2_u7_l2": {"en": "Modern Arab Realism", "ar": "الواقعية العربية الحديثة", "fr": "Réalisme arabe moderne", "de": "Moderner arabischer Realismus", "ru": "Современный арабский реализм", "zh": "现代阿拉伯现实主义"},
            "c2_u7_l3": {"en": "Post-Modernist Narratives", "ar": "سرديات ما بعد الحداثة", "fr": "Récits post-modernes", "de": "Postmoderne Erzählungen", "ru": "Постмодернистские повествования", "zh": "后现代主义叙事"},
            "c2_u7_l4": {"en": "Symbolism in Poetry", "ar": "الرمزية في الشعر", "fr": "Symbolisme en poésie", "de": "Symbolismus in der Poesie", "ru": "Символизм в поэзии", "zh": "诗歌中的象征主义"},
            "c2_u7_l5": {"en": "Theatre of the Absurd", "ar": "مسرح العبث", "fr": "Théâtre de l'absurde", "de": "Theater des Absurden", "ru": "Театр абсурда", "zh": "荒诞派戏剧"},
            "c2_u7_l6": {"en": "Literary Hermeneutics", "ar": "التأويلية الأدبية", "fr": "Herméneutique littéraire", "de": "Literarische Hermeneutik", "ru": "Литературная герменевтика", "zh": "文学诠释学"},
            "c2_u7_l7": {"en": "High Literature Review", "ar": "مراجعة الأدب الرفيع", "fr": "Révision de la haute littérature", "de": "Wiederholung der hohen Literatur", "ru": "Обзор высокой литературы", "zh": "高等文学复习"},
            "c2_u7_l8": {"en": "Perform a Literary Deconstruction", "ar": "إجراء تفكيك أدبي", "fr": "Effectuer une déconstruction littéraire", "de": "Eine literarische Dekonstruktion durchführen", "ru": "Проведение литературной деконструкции", "zh": "进行文学解构"}
        }
    },
    "c2_u8": {
        "title": {"en": "Intercultural Hermeneutics", "ar": "التأويلية الثقافية", "fr": "Herméneutique interculturelle", "de": "Interkulturelle Hermeneutik", "ru": "Межкультурная герменевтика", "zh": "跨文化诠释学"},
        "desc": {"en": "Translation theory, cultural studies, and orientalism.", "ar": "نظرية الترجمة، والدراسات الثقافية، والاستشراق.", "fr": "Théorie de la traduction, études culturelles et orientalisme.", "de": "Übersetzungstheorie, Kulturstudien und Orientalismus.", "ru": "Теория перевода, культурология и ориентализм.", "zh": "翻译理论、文化研究和东方学。"},
        "lessons": {
            "c2_u8_l1": {"en": "Theories of Translation", "ar": "نظريات الترجمة", "fr": "Théories de la traduction", "de": "Übersetzungstheorien", "ru": "Теории перевода", "zh": "翻译理论"},
            "c2_u8_l2": {"en": "Orientalism & Representation", "ar": "الاستشراق والتمثيل", "fr": "Orientalisme et représentation", "de": "Orientalismus und Repräsentation", "ru": "Ориентализм и репрезентация", "zh": "东方学与表现"},
            "c2_u8_l3": {"en": "Cultural Hybridity", "ar": "الهجين الثقافي", "fr": "Hybridité culturelle", "de": "Kulturelle Hybridität", "ru": "Культурная гибридность", "zh": "文化混杂性"},
            "c2_u8_l4": {"en": "Translation Ethics", "ar": "أخلاقيات الترجمة", "fr": "Éthique de la traduction", "de": "Übersetzungsethik", "ru": "Этика перевода", "zh": "翻译伦理"},
            "c2_u8_l5": {"en": "The Dialogue of Civilizations", "ar": "حوار الحضارات", "fr": "Le dialogue des civilisations", "de": "Dialog der Zivilisationen", "ru": "Диалог цивилизаций", "zh": "文明对话"},
            "c2_u8_l6": {"en": "Decolonizing Knowledge", "ar": "إنهاء استعمار المعرفة", "fr": "Décoloniser le savoir", "de": "Dekolonisierung von Wissen", "ru": "Деколонизация знаний", "zh": "知识去殖民化"},
            "c2_u8_l7": {"en": "Hermeneutics Review", "ar": "مراجعة التأويلية", "fr": "Révision de l'herméneutique", "de": "Wiederholung der Hermeneutik", "ru": "Обзор герменевтики", "zh": "诠释学复习"},
            "c2_u8_l8": {"en": "Translate a Technical Abstract", "ar": "ترجمة ملخص تقني", "fr": "Traduire un résumé technique", "de": "Einen technischen Abstract übersetzen", "ru": "Перевод технической аннотации", "zh": "翻译技术摘要"}
        }
    },
    "c2_u9": {
        "title": {"en": "Complex Data Analysis", "ar": "تحليل البيانات المعقدة", "fr": "Analyse de données complexes", "de": "Komplexe Datenanalyse", "ru": "Сложный анализ данных", "zh": "复杂数据分析"},
        "desc": {"en": "Quantitative methods, social statistics, and research design.", "ar": "الأساليب الكمية، والإحصاءات الاجتماعية، وتصميم البحوث.", "fr": "Méthodes quantitatives, statistiques sociales et conception de recherche.", "de": "Quantitative Methoden, Sozialstatistik und Forschungsdesign.", "ru": "Количественные методы, социальная статистика и дизайн исследований.", "zh": "定量方法、社会统计和研究设计。"},
        "lessons": {
            "c2_u9_l1": {"en": "Advanced Statistics in Social Science", "ar": "الإحصاء المتقدم في العلوم الاجتماعية", "fr": "Statistiques avancées en sciences sociales", "de": "Fortgeschrittene Statistik in Sozialwissenschaften", "ru": "Продвинутая статистика в социальных науках", "zh": "社会科学中的高级统计学"},
            "c2_u9_l2": {"en": "Research Design Optimization", "ar": "تحسين تصميم البحوث", "fr": "Optimisation du design de recherche", "de": "Optimierung des Forschungsdesigns", "ru": "Оптимизация дизайна исследований", "zh": "研究设计优化"},
            "c2_u9_l3": {"en": "Data Ethics & Governance", "ar": "أخلاقيات وحوكمة البيانات", "fr": "Éthique et gouvernance des données", "de": "Datenethik und Governance", "ru": "Этика и управление данными", "zh": "数据伦理与治理"},
            "c2_u9_l4": {"en": "Algorithmic Bias Case Study", "ar": "دراسة حالة عن انحياز الخوارزميات", "fr": "Étude de cas sur le biais algorithmique", "de": "Fallstudie zu algorithmischer Voreingenommenheit", "ru": "Кейс-стади алгоритмической предвзятости", "zh": "算法偏差案例研究"},
            "c2_u9_l5": {"en": "Big Data in Public Policy", "ar": "البيانات الضخمة في السياسة العامة", "fr": "Big Data dans la politique publique", "de": "Big Data in der öffentlichen Ordnung", "ru": "Большие данные в государственной политике", "zh": "公共政策中的大数据"},
            "c2_u9_l6": {"en": "Mastering Research Tools", "ar": "إتقان أدوات البحث", "fr": "Maîtriser les outils de recherche", "de": "Forschungswerkzeuge beherrschen", "ru": "Освоение инструментов исследования", "zh": "掌握研究工具"},
            "c2_u9_l7": {"en": "Data Terms Review", "ar": "مراجعة مصطلحات البيانات", "fr": "Révision des termes de données", "de": "Wiederholung von Datenbegriffen", "ru": "Обзор терминов данных", "zh": "数据术语复习"},
            "c2_u9_l8": {"en": "Design a Longitudinal Study", "ar": "تصميم دراسة طولية", "fr": "Concevoir une étude longitudinale", "de": "Eine Langzeitstudie entwerfen", "ru": "Разработка лонгитюдного исследования", "zh": "设计一项纵向研究"}
        }
    },
    "c2_u10": {
        "title": {"en": "Mastery Capstone", "ar": "مشروع التخرج للإتقان", "fr": "Projet de maîtrise", "de": "Mastery Capstone", "ru": "Мастерский проект", "zh": "精通毕业设计"},
        "desc": {"en": "Academic thesis defense and professional debate.", "ar": "مناقشة الرسالة الأكاديمية والمناظرة المهنية.", "fr": "Soutenance de thèse académique et débat professionnel.", "de": "Akademische Verteidigung und professionelle Debatte.", "ru": "Защита диссертации и профессиональные дебаты.", "zh": "学术论文答辩和专业辩论。"},
        "lessons": {
            "c2_u10_l1": {"en": "The Academic Thesis (Overview)", "ar": "الرسالة الأكاديمية (نظرة عامة)", "fr": "La thèse académique (Aperçu)", "de": "Die akademische Thesis (Übersicht)", "ru": "Академическая диссертация (обзор)", "zh": "学术论文（概述）"},
            "c2_u10_l2": {"en": "Argumentation & Debate", "ar": "الحجاج والمناظرة", "fr": "Argumentation et débat", "de": "Argumentation und Debatte", "ru": "Аргументация и дебаты", "zh": "辩论与争论"},
            "c2_u10_l3": {"en": "Public Oratory Skills", "ar": "مهارات الخطابة العامة", "fr": "Compétences en oratoire public", "de": "Öffentliche Redekunst", "ru": "Навыки публичных выступлений", "zh": "公共演讲技巧"},
            "c2_u10_l4": {"en": "Professional Mentoring", "ar": "التوجيه المهني", "fr": "Mentorat professionnel", "de": "Professionelles Mentoring", "ru": "Профессиональное менторство", "zh": "专业指导"},
            "c2_u10_l5": {"en": "Writing for High Impact", "ar": "الكتابة ذات التأثير العالي", "fr": "Écrire pour un impact élevé", "de": "Schreiben für hohe Wirkung", "ru": "Написание текстов с высоким влиянием", "zh": "高影响力写作"},
            "c2_u10_l6": {"en": "Global Networking Mastery", "ar": "إتقان الشبكات العالمية", "fr": "Maîtrise du réseautage mondial", "de": "Meisterung des globalen Networkings", "ru": "Мастерство глобального нетворкинга", "zh": "全球网络精通"},
            "c2_u10_l7": {"en": "Mastery Review", "ar": "مراجعة الإتقان", "fr": "Révision de la maîtrise", "de": "Wiederholung der Meisterschaft", "ru": "Обзор мастерства", "zh": "精重复习"},
            "c2_u10_l8": {"en": "Defend Your Capstone Thesis", "ar": "الدفاع عن رسالة التخرج", "fr": "Soutenir votre thèse de fin d'études", "de": "Ihre Abschlussarbeit verteidigen", "ru": "Защита вашей дипломной работы", "zh": "答辩你的毕业论文"}
        }
    }
}

def update():
    try:
        with open('assets/data/c2.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        for unit in data.get('units', []):
            u_id = unit.get('id')
            if u_id in UNIT_DATA:
                u_map = UNIT_DATA[u_id]
                # Update Unit Title
                unit['title'] = u_map['title']
                # Update Unit Description
                unit['description'] = u_map['desc']
                
                # Update Lessons
                for lesson in unit.get('lessons', []):
                    l_id = lesson.get('id')
                    if l_id in u_map['lessons']:
                        lesson['title'] = u_map['lessons'][l_id]
        
        with open('assets/data/c2.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4, ensure_ascii=False)
        print("Successfully applied translations to c2.json")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    update()
