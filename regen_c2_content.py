import json

UNIT_REGEN_DATA = {
    # UNIT 1: ACADEMIC DISCOURSE
    "c2_u1_l1": { # Theory of Knowledge
        "words": [
            {"ar": "إبستمولوجيا", "en": "Epistemology", "fr": "Épistémologie", "de": "Epistemologie", "ru": "Эпистемология", "zh": "认识论"},
            {"ar": "منهجية", "en": "Methodology", "fr": "Méthodologie", "de": "Methodik", "ru": "Методология", "zh": "方法论"},
            {"ar": "برهان", "en": "Proof", "fr": "Preuve", "de": "Beweis", "ru": "Доказательство", "zh": "证明"},
            {"ar": "يقين", "en": "Certainty", "fr": "Certitude", "de": "Gewissheit", "ru": "Уверенность", "zh": "确定性"},
            {"ar": "شك", "en": "Doubt", "fr": "Doute", "de": "Zweifel", "ru": "Сомнение", "zh": "怀疑"},
            {"ar": "بديهية", "en": "Axiom", "fr": "Axiome", "de": "Axiom", "ru": "Аксиома", "zh": "公理"},
            {"ar": "استدلال", "en": "Reasoning", "fr": "Raisonnement", "de": "Schlussfolgerung", "ru": "Рассуждение", "zh": "推理"},
            {"ar": "نقد", "en": "Critique", "fr": "Critique", "de": "Kritik", "ru": "Критика", "zh": "批判"},
            {"ar": "وعي", "en": "Consciousness", "fr": "Conscience", "de": "Bewusstsein", "ru": "Сознание", "zh": "意识"},
            {"ar": "إدراك", "en": "Perception", "fr": "Perception", "de": "Wahrnehmung", "ru": "Восприятие", "zh": "感知"}
        ],
        "sentences": [
            {"ar": "تدرس الإبستمولوجيا طبيعة المعرفة وحدودها", "en": "Epistemology studies the nature and limits of knowledge", "fr": "L'épistémologie étudie la nature et les limites de la connaissance", "de": "Die Erkenntnistheorie untersucht das Wesen und die Grenzen des Wissens", "ru": "Эпистемология изучает природу и границы знания", "zh": "认识论研究知识的性质和局限性"},
            {"ar": "يعتمد اليقين الرياضي على البديهيات والمنطق", "en": "Mathematical certainty depends on axioms and logic", "fr": "La certitude mathématique dépend des axiomes et de la logique", "de": "Mathematische Gewissheit beruht auf Axiomen und Logik", "ru": "Математическая уверенность зависит от аксиом и логики", "zh": "数学确定性取决于公理 and 逻辑"},
            {"ar": "الشك المنهجي هو أداة للوصول إلى الحقيقة", "en": "Methodological doubt is a tool to reach the truth", "fr": "Le doute méthodologique est un outil pour atteindre la vérité", "de": "Methodischer Zweifel ist ein Werkzeug, um zur Wahrheit zu gelangen", "ru": "Методическое сомнение — это инструмент достижения истины", "zh": "方法论上的怀疑是达到真理的工具"},
            {"ar": "يتطلب النقد الفلسفي تحليلاً عميقاً للنصوص", "en": "Philosophical critique requires a deep analysis of texts", "fr": "La critique philosophique nécessite une analyse approfondie des textes", "de": "Philosophische Kritik erfordert eine tiefe Analyse von Texten", "ru": "Философская критика требует глубокого анализа текстов", "zh": "哲学批判需要对文本进行深入分析"},
            {"ar": "تختلف المنهجيات العلمية باختلاف مجالات البحث", "en": "Scientific methodologies vary across different research fields", "fr": "Les méthodologies scientifiques varient selon les domaines de recherche", "de": "Wissenschaftliche Methoden variieren je nach Forschungsgebiet", "ru": "Научные методологии различаются в зависимости от области исследования", "zh": "科学方法因研究领域而异"}
        ]
    },
    "c2_u1_l2": { # Critical Theory & Society
        "words": [
            {"ar": "هيمنة", "en": "Hegemony", "fr": "Hégémonie", "de": "Hegemonie", "ru": "Гегемония", "zh": "霸权"},
            {"ar": "اغتراب", "en": "Alienation", "fr": "Aliénation", "de": "Entfremdung", "ru": "Отчуждение", "zh": "异化"},
            {"ar": "أيديولوجيا", "en": "Ideology", "fr": "Idéologie", "de": "Ideologie", "ru": "Идеология", "zh": "意识形态"},
            {"ar": "تحرر", "en": "Emancipation", "fr": "Émancipation", "de": "Emanzipation", "ru": "Эмансипация", "zh": "解放"},
            {"ar": "بنية", "en": "Structure", "fr": "Structure", "de": "Struktur", "ru": "Структура", "zh": "结构"},
            {"ar": "تفكيك", "en": "Deconstruction", "fr": "Déconstruction", "de": "Dekonstruktion", "ru": "Деконструкция", "zh": "解构"},
            {"ar": "صراع", "en": "Conflict", "fr": "Conflit", "de": "Konflikt", "ru": "Конфликт", "zh": "冲突"},
            {"ar": "طبقة", "en": "Class", "fr": "Classe", "de": "Klasse", "ru": "Класс", "zh": "阶级"},
            {"ar": "استهلاك", "en": "Consumption", "fr": "Consommation", "de": "Konsum", "ru": "Потребление", "zh": "消费"},
            {"ar": "مادية", "en": "Materialism", "fr": "Matérialisme", "de": "Materialismus", "ru": "Материализм", "zh": "唯物主义"}
        ],
        "sentences": [
            {"ar": "تحلل النظرية النقدية آليات الهيمنة الثقافية", "en": "Critical theory analyzes the mechanisms of cultural hegemony", "fr": "La théorie critique analyse les mécanismes de l'hégémonie culturelle", "de": "Kritische Theorie analysiert die Mechanismen kultureller Hegemonie", "ru": "Критическая теория анализирует механизмы культурной гегемонии", "zh": "批判理论分析文化霸权的机制"},
            {"ar": "يؤدي الاغتراب إلى فقدان الصلة بالذات والمجتمع", "en": "Alienation leads to a loss of connection with self and society", "fr": "L'aliénation conduit à une perte de lien avec soi et la société", "de": "Entfremdung führt zum Verlust der Verbindung zu sich selbst und zur Gesellschaft", "ru": "Отчуждение ведет к потере связи с собой и обществом", "zh": "异化导致与自我和社会联系的丧失"},
            {"ar": "الأيديولوجيا هي نظام من الأفكار التي تشكل تصورنا للواقع", "en": "Ideology is a system of ideas that shapes our perception of reality", "fr": "L'idéologie est un système d'idées qui façonne notre perception de la réalité", "de": "Ideologie ist ein System von Ideen, das unsere Wahrnehmung der Realität prägt", "ru": "Идеология — это система идей, формирующая наше восприятие реальности", "zh": "意识形态是塑造我们对现实看法的思想体系"},
            {"ar": "يهدف التحرر الفكري إلى كسر القيود التقليدية", "en": "Intellectual emancipation aims to break traditional constraints", "fr": "L'émancipation intellectuelle vise à briser les contraintes traditionnelles", "de": "Geistige Emanzipation zielt darauf ab, traditionelle Zwänge zu brechen", "ru": "Интеллектуальная эмансипация направлена на разрушение традиционных ограничений", "zh": "思想解放旨在打破传统约束"},
            {"ar": "أصبحت ثقافة الاستهلاك سمة بارزة في العصر الحديث", "en": "Consumer culture has become a prominent feature in the modern era", "fr": "La culture de consommation est devenue une caractéristique marquante de l'ère moderne", "de": "Die Konsumkultur ist zu einem herausragenden Merkmal der Moderne geworden", "ru": "Потребительская культура стала заметной чертой современной эпохи", "zh": "消费文化已成为现代社会的一个显著特征"}
        ]
    },
    "c2_u1_l3": { # Epistemological Rupture
        "words": [
            {"ar": "قطيعة", "en": "Rupture", "fr": "Rupture", "de": "Bruch", "ru": "Разрыв", "zh": "断裂"},
            {"ar": "نموذج", "en": "Paradigm", "fr": "Paradigme", "de": "Paradigma", "ru": "Парадигма", "zh": "范式"},
            {"ar": "تجاوز", "en": "Transcendence", "fr": "Transcendance", "de": "Transzendenz", "ru": "Трансцендентность", "zh": "超越"},
            {"ar": "عقلانية", "en": "Rationality", "fr": "Rationalité", "de": "Rationalität", "ru": "Рациональность", "zh": "理性"},
            {"ar": "جوهر", "en": "Essence", "fr": "Essence", "de": "Essenz", "ru": "Сущность", "zh": "本质"},
            {"ar": "تصور", "en": "Conception", "fr": "Conception", "de": "Konzept", "ru": "Концепция", "zh": "构想"},
            {"ar": "ثورة", "en": "Revolution", "fr": "Révolution", "de": "Revolution", "ru": "Революция", "zh": "革命"},
            {"ar": "منطق", "en": "Logic", "fr": "Logique", "de": "Logik", "ru": "Логика", "zh": "逻辑"},
            {"ar": "موضوعية", "en": "Objectivity", "fr": "Objectivité", "de": "Objektivität", "ru": "Объективность", "zh": "客观性"},
            {"ar": "ذاتية", "en": "Subjectivity", "fr": "Subjectivité", "de": "Subjektivität", "ru": "Субъективность", "zh": "主观性"}
        ],
        "sentences": [
            {"ar": "تمثل القطيعة الابستمولوجية نقطة تحول في تاريخ العلم", "en": "The epistemological rupture represents a turning point in the history of science", "fr": "La rupture épistémologique représente un tournant dans l'histoire de la science", "de": "Der erkenntnistheoretische Bruch stellt einen Wendepunkt in der Wissenschaftsgeschichte dar", "ru": "Эпистемологический разрыв представляет собой поворотный момент в истории науки", "zh": "认识论断裂代表了科学史上的一个转折点"},
            {"ar": "يؤدي تغيير النموذج الفكري إلى فهم جديد للظواهر", "en": "Changing the intellectual paradigm leads to a new understanding of phenomena", "fr": "Changer le paradigme intellectuel conduit à une nouvelle compréhension des phénomènes", "de": "Ein Paradigmenwechsel führt zu einem neuen Verständnis von Phänomenen", "ru": "Смена интеллектуальной парадигмы ведет к новому пониманию явлений", "zh": "改变思想范式会导致对现象的新理解"},
            {"ar": "العقلانية هي أساس التفكير العلمي الحديث", "en": "Rationality is the basis of modern scientific thinking", "fr": "La rationalité est la base de la pensée scientifique moderne", "de": "Rationalität ist die Grundlage des modernen wissenschaftlichen Denkens", "ru": "Рациональность — это основа современного научного мышления", "zh": "理性是现代科学思维的基础"},
            {"ar": "يصعب أحياناً الفصل بين الموضوعية والذاتية في العلوم الإنسانية", "en": "It is sometimes difficult to separate objectivity and subjectivity in the humanities", "fr": "Il est parfois difficile de séparer l'objectivité et la subjectivité dans les sciences humaines", "de": "Es ist manchmal schwierig, Objektivität und Subjektivität in den Geisteswissenschaften zu trennen", "ru": "Иногда трудно отделить объективность от субъективности в гуманитарных науках", "zh": "在人文科学中，有时很难区分客观性和主观性"},
            {"ar": "تحدث الثورة العلمية عندما يعجز النموذج القديم عن التفسير", "en": "A scientific revolution occurs when the old paradigm fails to explain", "fr": "Une révolution scientifique se produit lorsque l'ancien paradigme ne parvient pas à expliquer", "de": "Eine wissenschaftliche Revolution findet statt, wenn das alte Paradigma die Erklärung schuldig bleibt", "ru": "Научная революция происходит, когда старая парадигма не справляется с объяснением", "zh": "当旧范式无法解释时，科学革命就会发生"}
        ]
    },
    "c2_u1_l4": { # Academic Integrity Policy
        "words": [
            {"ar": "نزاهة", "en": "Integrity", "fr": "Intégrité", "de": "Integrität", "ru": "Честность", "zh": "诚信"},
            {"ar": "انتحال", "en": "Plagiarism", "fr": "Plagiat", "de": "Plagiat", "ru": "Плагиат", "zh": "抄袭"},
            {"ar": "توثيق", "en": "Documentation", "fr": "Documentation", "de": "Dokumentation", "ru": "Документирование", "zh": "文献记录"},
            {"ar": "اقتباس", "en": "Citation", "fr": "Citation", "de": "Zitieren", "ru": "Цитирование", "zh": "引用"},
            {"ar": "أمانة", "en": "Honesty", "fr": "Honnêteté", "de": "Ehrlichkeit", "ru": "Честность", "zh": "诚实"},
            {"ar": "مصدر", "en": "Source", "fr": "Source", "de": "Quelle", "ru": "Источник", "zh": "来源"},
            {"ar": "مرجع", "en": "Reference", "fr": "Référence", "de": "Referenz", "ru": "Ссылка", "zh": "参考文献"},
            {"ar": "تزييف", "en": "Falsification", "fr": "Falsification", "de": "Fälschung", "ru": "Фальсификация", "zh": "伪造"},
            {"ar": "أخلاقيات", "en": "Ethics", "fr": "Éthique", "de": "Ethik", "ru": "Этика", "zh": "伦理"},
            {"ar": "معايير", "en": "Standards", "fr": "Normes", "de": "Standards", "ru": "Стандарты", "zh": "标准"}
        ],
        "sentences": [
            {"ar": "تعتبر النزاهة الأكاديمية حجر الزاوية في التعليم العالي", "en": "Academic integrity is considered the cornerstone of higher education", "fr": "L'intégrité académique est considérée comme la pierre angulaire de l'enseignement supérieur", "de": "Akademische Integrität gilt als Grundstein der Hochschulbildung", "ru": "Академическая честность считается краеугольным камнем высшего образования", "zh": "学术诚信被认为是高等教育的基石"},
            {"ar": "يؤدي الانتحال العلمي إلى عقوبات تأديبية صارمة", "en": "Scientific plagiarism leads to strict disciplinary sanctions", "fr": "Le plagiat scientifique entraîne des sanctions disciplinaires strictes", "de": "Wissenschaftliches Plagiat führt zu strengen Disziplinarstrafen", "ru": "Научный плагиат ведет к строгим дисциплинарным санкциям", "zh": "科学抄袭会导致严格的纪律处分"},
            {"ar": "يجب توثيق كافة المصادر المستخدمة في البحث بدقة", "en": "All sources used in research must be accurately documented", "fr": "Toutes les sources utilisées dans la recherche doivent être documentées avec précision", "de": "Alle in der Forschung verwendeten Quellen müssen genau dokumentiert werden", "ru": "Все источники, использованные в исследовании, должны быть точно задокументированы", "zh": "研究中使用的所有来源必须准确记录"},
            {"ar": "تحدد سياسة الجامعة معايير الاقتباس الصحيحة", "en": "University policy defines the correct citation standards", "fr": "La politique de l'université définit les normes de citation correctes", "de": "Die Universitätspolitik legt die korrekten Zitierstandards fest", "ru": "Политика университета определяет правильные стандарты цитирования", "zh": "大学政策定义了正确的引用标准"},
            {"ar": "يعزز الالتزام بأخلاقيات البحث جودة المخرجات العلمية", "en": "Adherence to research ethics enhances the quality of scientific outputs", "fr": "L'adhésion à l'éthique de la recherche améliore la qualité des résultats scientifiques", "de": "Die Einhaltung der Forschungsethik verbessert die Qualität der wissenschaftlichen Ergebnisse", "ru": "Соблюдение исследовательской этики повышает качество научных результатов", "zh": "遵守研究伦理可以提高科学产出的质量"}
        ]
    },
    "c2_u1_l5": { # Discourse Analysis Methods
        "words": [
            {"ar": "سياق", "en": "Context", "fr": "Contexte", "de": "Kontext", "ru": "Контекст", "zh": "语境"},
            {"ar": "نص", "en": "Text", "fr": "Texte", "de": "Text", "ru": "Текст", "zh": "文本"},
            {"ar": "خطاب", "en": "Discourse", "fr": "Discours", "de": "Diskurs", "ru": "Дискурс", "zh": "话语"},
            {"ar": "دلالة", "en": "Significance", "fr": "Signification", "de": "Bedeutung", "ru": "Значение", "zh": "意义"},
            {"ar": "تأويل", "en": "Interpretation", "fr": "Interprétation", "de": "Interpretation", "ru": "Интерпретация", "zh": "解释"},
            {"ar": "بلاغة", "en": "Rhetoric", "fr": "Rhétorique", "de": "Rhetorik", "ru": "Риторика", "zh": "修辞"},
            {"ar": "بناء", "en": "Construction", "fr": "Construction", "de": "Konstruktion", "ru": "Конструирование", "zh": "建构"},
            {"ar": "تفكيك", "en": "Deconstruction", "fr": "Déconstruction", "de": "Dekonstruktion", "ru": "Деконструкция", "zh": "解构"},
            {"ar": "معنى", "en": "Meaning", "fr": "Sens", "de": "Bedeutung", "ru": "Смысл", "zh": "语义"},
            {"ar": "سلطة", "en": "Authority", "fr": "Autorité", "de": "Autorität", "ru": "Власть", "zh": "权力"}
        ],
        "sentences": [
            {"ar": "يحلل منهج تحليل الخطاب العلاقة بين اللغة والسلطة", "en": "The discourse analysis method analyzes the relationship between language and power", "fr": "La méthode d'analyse du discours analyse la relation entre le langage et le pouvoir", "de": "Die Methode der Diskursanalyse untersucht die Beziehung zwischen Sprache und Macht", "ru": "Метод дискурс-анализа изучает связь между языком и властью", "zh": "话语分析方法分析语言与权力之间的关系"},
            {"ar": "لا يمكن فهم النص بمعزل عن سياقه الاجتماعي والتاريخي", "en": "A text cannot be understood in isolation from its social and historical context", "fr": "Un texte ne peut être compris isolément de son contexte social et historique", "de": "Ein Text kann nicht losgelöst von seinem sozialen und historischen Kontext verstanden werden", "ru": "Текст нельзя понять в отрыве от его социального и исторического контекста", "zh": "理解文本不能脱离其社会和历史语境"},
            {"ar": "تختلف التأويلات باختلاف الخلفيات الثقافية للقراء", "en": "Interpretations vary according to the cultural backgrounds of readers", "fr": "Les interprétations varient selon les origines culturelles des lecteurs", "de": "Interpretationen variieren je nach kulturellem Hintergrund der Leser", "ru": "Интерпретации различаются в зависимости от культурного бэкграунда читателей", "zh": "解释因读者的文化背景而异"},
            {"ar": "تستخدم البلاغة كأداة للإقناع والتأثير في الجمهور", "en": "Rhetoric is used as a tool for persuasion and influencing the audience", "fr": "La rhétorique est utilisée comme un outil de persuasion et d'influence sur le public", "de": "Rhetorik wird als Werkzeug zur Überzeugung und Beeinflussung des Publikums eingesetzt", "ru": "Риторика используется как инструмент убеждения и влияния на аудиторию", "zh": "修辞被用作说服 and 影响观众的工具"},
            {"ar": "يهدف التفكيك إلى كشف التناقضات الكامنة في الخطاب", "en": "Deconstruction aims to reveal the contradictions inherent in discourse", "fr": "La déconstruction vise à révéler les contradictions inhérentes au discours", "de": "Dekonstruktion zielt darauf ab, die dem Diskurs innewohnenden Widersprüche aufzudecken", "ru": "Деконструкция направлена на выявление противоречий, присущих дискурсу", "zh": "解构旨在揭示话语中固有的矛盾"}
        ]
    },
    "c2_u1_l6": { # The Ethics of AI Research
        "words": [
            {"ar": "خوارزمية", "en": "Algorithm", "fr": "Algorithme", "de": "Algorithmus", "ru": "Алгоритм", "zh": "算法"},
            {"ar": "انحياز", "en": "Bias", "fr": "Biais", "de": "Voreingenommenheit", "ru": "Предвзятость", "zh": "偏差"},
            {"ar": "خصوصية", "en": "Privacy", "fr": "Vie privée", "de": "Privatsphäre", "ru": "Конфиденциальность", "zh": "隐私"},
            {"ar": "مسؤولية", "en": "Responsibility", "fr": "Responsabilité", "de": "Verantwortung", "ru": "Ответственность", "zh": "责任"},
            {"ar": "شفافية", "en": "Transparency", "fr": "Transparence", "de": "Transparenz", "ru": "Прозрачность", "zh": "透明度"},
            {"ar": "عدالة", "en": "Justice", "fr": "Justice", "de": "Gerechtigkeit", "ru": "Справедливость", "zh": "公正"},
            {"ar": "تحكم", "en": "Control", "fr": "Contrôle", "de": "Kontrolle", "ru": "Контроль", "zh": "控制"},
            {"ar": "وعي", "en": "Awareness", "fr": "Conscience", "de": "Bewusstsein", "ru": "Осознание", "zh": "意识"},
            {"ar": "مخاطر", "en": "Risks", "fr": "Risques", "de": "Risiken", "ru": "Риски", "zh": "风险"},
            {"ar": "تطور", "en": "Evolution", "fr": "Évolution", "de": "Entwicklung", "ru": "Эволюция", "zh": "发展"}
        ],
        "sentences": [
            {"ar": "تثير أبحاث الذكاء الاصطناعي تساؤلات أخلاقية معقدة", "en": "AI research raises complex ethical questions", "fr": "La recherche en IA soulève des questions éthiques complexes", "de": "KI-Forschung wirft komplexe ethische Fragen auf", "ru": "Исследования в области ИИ поднимают сложные этические вопросы", "zh": "人工智能研究引发了复杂的伦理问题"},
            {"ar": "يجب أن تكون الخوارزميات خالية من الانحياز والتمييز", "en": "Algorithms must be free from bias and discrimination", "fr": "Les algorithmes doivent être exempts de biais et de discrimination", "de": "Algorithmen müssen frei von Voreingenommenheit und Diskriminierung sein", "ru": "Алгоритмы должны быть свободны от предвзятости и дискриминации", "zh": "算法必须没有偏见和歧视"},
            {"ar": "تعتبر الخصوصية حقاً أساسياً للمستخدمين في العصر الرقمي", "en": "Privacy is considered a fundamental right for users in the digital age", "fr": "La vie privée est considérée comme un droit fondamental pour les utilisateurs à l'ère numérique", "de": "Privatsphäre gilt als Grundrecht für Nutzer im digitalen Zeitalter", "ru": "Конфиденциальность считается фундаментальным правом пользователей в цифровую эпоху", "zh": "在数字时代，隐私被认为是用户的一项基本权利"},
            {"ar": "تحتاج الشركات التقنية إلى معايير شفافية عالية", "en": "Tech companies need high transparency standards", "fr": "Les entreprises technologiques ont besoin de normes de transparence élevées", "de": "Technologieunternehmen benötigen hohe Transparenzstandards", "ru": "Технологическим компаниям нужны высокие стандарты прозрачности", "zh": "科技公司需要高透明度标准"},
            {"ar": "تتحمل البشرية مسؤولية التحكم في تطور الآلات الذكية", "en": "Humanity bears the responsibility for controlling the evolution of smart machines", "fr": "L'humanité a la responsabilité de contrôler l'évolution des machines intelligentes", "de": "Die Menschheit trägt die Verantwortung für die Kontrolle der Entwicklung intelligenter Maschinen", "ru": "Человечество несет ответственность за контроль над эволюцией умных машин", "zh": "人类负有控制智能机器发展的责任"}
        ]
    },
    "c2_u1_l7": { # Academic Terms Review
        "words": [
            {"ar": "منشور", "en": "Publication", "fr": "Publication", "de": "Publikation", "ru": "Публикация", "zh": "出版物"},
            {"ar": "مراجعة", "en": "Review", "fr": "Révision", "de": "Überprüfung", "ru": "Обзор", "zh": "审查"},
            {"ar": "ندوة", "en": "Seminar", "fr": "Séminaire", "de": "Seminar", "ru": "Семинар", "zh": "研讨会"},
            {"ar": "مؤتمر", "en": "Conference", "fr": "Conférence", "de": "Konferenz", "ru": "Конференция", "zh": "会议"},
            {"ar": "منحة", "en": "Scholarship", "fr": "Bourse", "de": "Stipendium", "ru": "Стипендию", "zh": "奖学金"},
            {"ar": "بحث", "en": "Research", "fr": "Recherche", "de": "Forschung", "ru": "Исследование", "zh": "研究"},
            {"ar": "أطروحة", "en": "Thesis", "fr": "Thèse", "de": "Thesis", "ru": "Диссертация", "zh": "论文"},
            {"ar": "مقال", "en": "Article", "fr": "Article", "de": "Artikel", "ru": "Статья", "zh": "文章"},
            {"ar": "دورية", "en": "Journal", "fr": "Revue", "de": "Zeitschrift", "ru": "Журнал", "zh": "期刊"},
            {"ar": "اقتراح", "en": "Proposal", "fr": "Proposition", "de": "Vorschlag", "ru": "Предложение", "zh": "提案"}
        ],
        "sentences": [
            {"ar": "تعتبر المراجعة العلمية أداة لضمان جودة الأبحاث المنشورة", "en": "Scientific review is a tool to ensure the quality of published research", "fr": "La révision scientifique est un outil pour assurer la qualité des recherches publiées", "de": "Wissenschaftliche Begutachtung ist ein Werkzeug zur Sicherstellung der Qualität veröffentlichter Forschung", "ru": "Научный обзор — это инструмент обеспечения качества опубликованных исследований", "zh": "科学审查是确保出版研究质量的工具"},
            {"ar": "شارك الباحثون في ندوة دولية حول اللسانيات التطبيقية", "en": "Researchers participated in an international seminar on applied linguistics", "fr": "Des chercheurs ont participé à un séminaire international sur la linguistique appliquée", "de": "Forscher nahmen an einem internationalen Seminar über angewandte Linguistik teil", "ru": "Исследователи приняли участие в международном семинаре по прикладной лингвистике", "zh": "研究人员参加了一个关于应用语言学的国际研讨会"},
            {"ar": "يجب تقديم اقتراح بحث مفصل للحصول على المنحة", "en": "A detailed research proposal must be submitted to obtain the scholarship", "fr": "Une proposition de recherche détaillée doit être soumise pour obtenir la bourse", "de": "Ein detaillierter Forschungsantrag muss eingereicht werden, um das Stipendium zu erhalten", "ru": "Для получения стипендии необходимо подать подробное проектное предложение", "zh": "必须提交详细的研究提案才能获得奖学金"},
            {"ar": "تنشر الدوريات العلمية أحدث النتائج في مختلف المجالات", "en": "Scientific journals publish the latest findings in various fields", "fr": "Les revues scientifiques publient les dernières découvertes dans divers domaines", "de": "Wissenschaftliche Zeitschriften veröffentlichen die neuesten Erkenntnisse in verschiedenen Bereichen", "ru": "Научные журналы публикуют последние открытия в различных областях", "zh": "科学期刊发表各个领域的最新发现"},
            {"ar": "يهدف المؤتمر الأكاديمي إلى تبادل الخبرات بين العلماء", "en": "The academic conference aims to exchange experiences among scientists", "fr": "La conférence académique vise à échanger des expériences entre scientifiques", "de": "Die akademische Konferenz zielt auf den Erfahrungsaustausch zwischen Wissenschaftlern ab", "ru": "Академическая конференция направлена на обмен опытом между учеными", "zh": "学术会议旨在交流科学家之间的经验"}
        ]
    },
    "c2_u1_l8": { # Present a Theoretical Framework
        "words": [
            {"ar": "إطار", "en": "Framework", "fr": "Cadre", "de": "Rahmen", "ru": "Рамки", "zh": "框架"},
            {"ar": "نظرية", "en": "Theory", "fr": "Théorie", "de": "Theorie", "ru": "Теория", "zh": "理论"},
            {"ar": "فرضية", "en": "Hypothesis", "fr": "Hypothèse", "de": "Hypothese", "ru": "Гипотеза", "zh": "假设"},
            {"ar": "مفهوم", "en": "Concept", "fr": "Concept", "de": "Konzept", "ru": "Понятие", "zh": "概念"},
            {"ar": "تحليل", "en": "Analysis", "fr": "Analyse", "de": "Analyse", "ru": "Анализ", "zh": "分析"},
            {"ar": "تكامل", "en": "Integration", "fr": "Intégration", "de": "Integration", "ru": "Интеграция", "zh": "整合"},
            {"ar": "اتساق", "en": "Consistency", "fr": "Cohérence", "de": "Konsistenz", "ru": "Последовательность", "zh": "一致性"},
            {"ar": "تطبيق", "en": "Application", "fr": "Application", "de": "Anwendung", "ru": "Применение", "zh": "应用"},
            {"ar": "تفسير", "en": "Explanation", "fr": "Explication", "de": "Erklärung", "ru": "Объяснение", "zh": "解释"},
            {"ar": "استنتاج", "en": "Conclusion", "fr": "Conclusion", "de": "Schlussfolgerung", "ru": "Вывод", "zh": "结论"}
        ],
        "sentences": [
            {"ar": "يحدد الإطار النظري الأسس التي يبنى عليها البحث", "en": "The theoretical framework defines the foundations on which research is built", "fr": "Le cadre théorique définit les fondements sur lesquels la recherche est bâtie", "de": "Der theoretische Rahmen definiert die Grundlagen, auf denen die Forschung aufbaut", "ru": "Теоретическая база определяет основы, на которых строится исследование", "zh": "理论框架定义了研究建立的基础"},
            {"ar": "يجب أن تكون الفرضيات قابلة للاختبار والتحقق العلمي", "en": "Hypotheses must be testable and scientifically verifiable", "fr": "Les hypothèses doivent être testables et scientifiquement vérifiables", "de": "Hypothesen müssen testbar und wissenschaftlich verifizierbar sein", "ru": "Гипотезы должны быть тестируемыми и научно проверяемыми", "zh": "假设必须是可测试且科学可验证的"},
            {"ar": "يساعد تحليل المفاهيم على توضيح الرؤية البحثية", "en": "Concept analysis helps clarify the research vision", "fr": "L'analyse des concepts aide à clarifier la vision de la recherche", "de": "Die Konzeptanalyse hilft, die Forschungsvision zu klären", "ru": "Анализ понятий помогает прояснить видение исследования", "zh": "概念分析有助于阐明研究视野"},
            {"ar": "يعتبر الاتساق المنطقي شرطاً أساسياً لأي نظرية علمية", "en": "Logical consistency is a prerequisite for any scientific theory", "fr": "La cohérence logique est une condition préalable à toute théorie scientifique", "de": "Logische Konsistenz ist eine Voraussetzung für jede wissenschaftliche Theorie", "ru": "Логическая последовательность является обязательным условием для любой научной теории", "zh": "逻辑一致性是任何科学理论的前提条件"},
            {"ar": "يؤدي التكامل بين النظرية والتطبيق إلى نتائج أكثر دقة", "en": "Integration between theory and application leads to more accurate results", "fr": "L'intégration entre la théorie et l'application conduit à des résultats plus précis", "de": "Die Integration von Theorie und Anwendung führt zu genaueren Ergebnissen", "ru": "Интеграция теории и практики ведет к более точным результатам", "zh": "理论与应用的整合会导致更准确的结果"}
        ]
    },
    
    # UNIT 2: PROFESSIONAL DIPLOMACY
    "c2_u2_l1": { # Diplomatic Protocol
        "words": [
            {"ar": "بروتوكول", "en": "Protocol", "fr": "Protocole", "de": "Protokoll", "ru": "Протокол", "zh": "礼节"},
            {"ar": "مراسم", "en": "Ceremony", "fr": "Cérémonie", "de": "Zeremonie", "ru": "Церемония", "zh": "仪式"},
            {"ar": "استقبال", "en": "Reception", "fr": "Réception", "de": "Empfang", "ru": "Прием", "zh": "招待"},
            {"ar": "وفد", "en": "Delegation", "fr": "Délégation", "de": "Delegation", "ru": "Делегация", "zh": "代表团"},
            {"ar": "اعتماد", "en": "Accreditation", "fr": "Accréditation", "de": "Akkreditierung", "ru": "Аккредитация", "zh": "委任"},
            {"ar": "رسمي", "en": "Official", "fr": "Officiel", "de": "Offiziell", "ru": "Официальный", "zh": "官方"},
            {"ar": "حصانة", "en": "Immunity", "fr": "Immunité", "de": "Immunität", "ru": "Иммунитет", "zh": "豁免"},
            {"ar": "زيارة", "en": "Visit", "fr": "Visite", "de": "Besuch", "ru": "Визит", "zh": "访问"},
            {"ar": "مأدبة", "en": "Banquet", "fr": "Banquet", "de": "Bankett", "ru": "Банкет", "zh": "宴会"},
            {"ar": "توقيع", "en": "Signing", "fr": "Signature", "de": "Unterzeichnung", "ru": "Подписание", "zh": "签署"}
        ],
        "sentences": [
            {"ar": "يحدد البروتوكول الدبلوماسي قواعد التعامل بين الدول", "en": "Diplomatic protocol defines the rules of conduct between countries", "fr": "Le protocole diplomatique définit les règles de conduite entre les pays", "de": "Das diplomatische Protokoll legt die Verhaltensregeln zwischen Ländern fest", "ru": "Дипломатический протокол определяет правила поведения между странами", "zh": "外交礼节定义了国家之间的行为准则"},
            {"ar": "تم استقبال الوفد الرسمي في مراسم رفيعة المستوى", "en": "The official delegation was received in high-level ceremonies", "fr": "La délégation officielle a été reçue lors de cérémonies de haut niveau", "de": "Die offizielle Delegation wurde mit hochrangigen Zeremonien empfangen", "ru": "Официальная делегация была принята на церемонии высокого уровня", "zh": "官方代表团在高级别仪式上受到接待"},
            {"ar": "يتمتع الدبلوماسيون بحصانة كاملة وفقاً للقانون الدولي", "en": "Diplomats enjoy full immunity according to international law", "fr": "Les diplomates jouissent d'une immunité totale selon le droit international", "de": "Diplomaten genießen volle Immunität nach internationalem Recht", "ru": "Дипломаты пользуются полным иммунитетом в соответствии с международным правом", "zh": "根据国际法，外交官享有完全的豁免权"},
            {"ar": "تتطلب الزيارات الرسمية تنسيقاً دقيقاً بين وزارات الخارجية", "en": "Official visits require careful coordination between ministries of foreign affairs", "fr": "Les visites officielles nécessitent une coordination minutieuse entre les ministères des affaires étrangères", "de": "Offizielle Besuche erfordern eine sorgfältige Koordination zwischen den Außenministerien", "ru": "Официальные визиты требуют тщательной координации между министерствами иностранных дел", "zh": "官方访问需要外交部之间的仔细协调"},
            {"ar": "أقيمت مأدبة عشاء على شرف الضيوف المشاركين في المؤتمر", "en": "A dinner banquet was held in honor of the guests participating in the conference", "fr": "Un banquet a été organisé en l'honneur des invités participant à la conférence", "de": "Zu Ehren der am Kongress teilnehmenden Gäste wurde ein Abendessen veranstaltet", "ru": "В честь гостей, участвующих в конференции, был устроен торжественный ужин", "zh": "会议期间为参会嘉宾举行了晚宴"}
        ]
    },
    "c2_u2_l2": { # Consular Functions
        "words": [
            {"ar": "قنصلية", "en": "Consulate", "fr": "Consulat", "de": "Konsulat", "ru": "Консульство", "zh": "领事馆"},
            {"ar": "تأشيرة", "en": "Visa", "fr": "Visa", "de": "Visum", "ru": "Виза", "zh": "签证"},
            {"ar": "جواز", "en": "Passport", "fr": "Passeport", "de": "Reisepass", "ru": "Паспорт", "zh": "护照"},
            {"ar": "رعاية", "en": "Care", "fr": "Assistance", "de": "Betreuung", "ru": "Опека", "zh": "关怀"},
            {"ar": "مواطنين", "en": "Citizens", "fr": "Citoyens", "de": "Bürger", "ru": "Граждане", "zh": "公民"},
            {"ar": "توثيق", "en": "Notarization", "fr": "Légalisation", "de": "Beglaubigung", "ru": "Легализация", "zh": "公证"},
            {"ar": "حماية", "en": "Protection", "fr": "Protection", "de": "Schutz", "ru": "Защита", "zh": "保护"},
            {"ar": "ترحيل", "en": "Deportation", "fr": "Expulsion", "de": "Abschiebung", "ru": "Депортация", "zh": "驱逐"},
            {"ar": "لجوء", "en": "Asylum", "fr": "Asile", "de": "Asyl", "ru": "Убежище", "zh": "避难"},
            {"ar": "حقوق", "en": "Rights", "fr": "Droits", "de": "Rechte", "ru": "Права", "zh": "权利"}
        ],
        "sentences": [
            {"ar": "تقدم القنصلية خدماتها للمواطنين المقيمين في الخارج", "en": "The consulate provides its services to citizens residing abroad", "fr": "Le consulat fournit ses services aux citoyens résidant à l'étranger", "de": "Das Konsulat bietet seine Dienste für im Ausland lebende Bürger an", "ru": "Консульство предоставляет услуги гражданам, проживающим за границей", "zh": "领事馆为居住在国外的公民提供服务"},
            {"ar": "يتم إصدار التأشيرات وفقاً للشروط والقوانين الوطنية", "en": "Visas are issued according to national conditions and laws", "fr": "Les visas sont délivrés selon les conditions et les lois nationales", "de": "Visa werden gemäß den nationalen Bedingungen und Gesetzen ausgestellt", "ru": "Визы выдаются в соответствии с национальными условиями и законами", "zh": "签证根据国家条件和法律颁发"},
            {"ar": "تتكفل القنصلية بحماية حقوق رعاياها في الحالات الطارئة", "en": "The consulate ensures the protection of its nationals' rights in emergencies", "fr": "Le consulat assure la protection des droits de ses ressortissants en cas d'urgence", "de": "Das Konsulat gewährleistet den Schutz der Rechte seiner Staatsangehörigen in Notfällen", "ru": "Консульство обеспечивает защиту прав своих граждан в чрезвычайных ситуациях", "zh": "领事馆确保在紧急情况下保护其国民的权利"},
            {"ar": "تتم عملية توثيق العقود والوثائق الرسمية في القسم القنصلي", "en": "The process of notarizing contracts and official documents takes place in the consular section", "fr": "Le processus de légalisation des contrats et des documents officiels se déroule à la section consulaire", "de": "Die Beglaubigung von Verträgen und offiziellen Dokumenten erfolgt in der Konsularabteilung", "ru": "Процесс легализации контрактов и официальных документов происходит в консульском отделе", "zh": "合同和官方文件的公证过程在领事处进行"},
            {"ar": "يتطلب تجديد جواز السفر تقديم طلب رسمي للقنصلية العامة", "en": "Passport renewal requires submitting an official application to the Consulate General", "fr": "Le renouvellement du passeport nécessite la soumission d'une demande officielle au consulat général", "de": "Die Passerneuerung erfordert einen offiziellen Antrag beim Generalkonsulat", "ru": "Для продления паспорта необходимо подать официальное заявление в Генеральное консульство", "zh": "更换护照需要向总领事馆提交正式申请"}
        ]
    }
}

def generate_transliteration(text):
    return {
        "en": text,
        "ar": text,
        "fr": text,
        "de": text,
        "ru": text,
        "zh": text
    }

def update_c2_content():
    try:
        with open('assets/data/c2.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        for unit in data.get('units', []):
            for lesson in unit.get('lessons', []):
                l_id = lesson['id']
                if l_id in UNIT_REGEN_DATA:
                    new_data = UNIT_REGEN_DATA[l_id]
                    content = []
                    
                    # Words
                    for i, w in enumerate(new_data['words']):
                        content.append({
                            "id": f"{l_id}_w{i+1}",
                            "type": "word",
                            "arabic": w['ar'],
                            "transliteration": generate_transliteration(w['ar']),
                            "translation": {
                                "en": w['en'], "ar": w['ar'], "fr": w['fr'],
                                "de": w['de'], "ru": w['ru'], "zh": w['zh']
                            }
                        })
                    
                    # Sentences
                    for i, s in enumerate(new_data['sentences']):
                        content.append({
                            "id": f"{l_id}_s{i+1}",
                            "type": "sentence",
                            "arabic": s['ar'],
                            "transliteration": generate_transliteration(s['ar']),
                            "translation": {
                                "en": s['en'], "ar": s['ar'], "fr": s['fr'],
                                "de": s['de'], "ru": s['ru'], "zh": s['zh']
                            }
                        })
                    
                    lesson['content'] = content
                    print(f"Updated content for {l_id}")
        
        with open('assets/data/c2.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=4, ensure_ascii=False)
        print("Successfully saved regenerated content to c2.json")
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    update_c2_content()
