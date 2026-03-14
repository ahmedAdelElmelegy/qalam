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
        'ة': 'a', 'ى': 'a', ' ': ' ', '،': ',', '؟': '?', ' ': ' ',
        'ا': 'a', 'آ': 'a', 'إ': 'i', 'ئ': 'y', 'ؤ': 'o', 'ء': "'"
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
    content_data_path = 'c2_content_data.json'
    c2_json_path = 'assets/data/c2.json'
    
    with open(content_data_path, 'r', encoding='utf-8') as f:
        regen_data = json.load(f)
        
    with open(c2_json_path, 'r', encoding='utf-8') as f:
        c2_data = json.load(f)

    # Unit Metadata
    UNIT_METADATA = {
        "c2_u1": {
            "title": {"en": "Diplomatic Communication", "ar": "التواصل الدبلوماسي", "fr": "Communication diplomatique", "de": "Diplomatische Kommunikation", "ru": "Дипломатическая коммуникация", "zh": "外交沟通"},
            "description": {"en": "Advanced diplomatic correspondence, negotiations, and formal communication.", "ar": "المراسلات الدبلوماسية المتقدمة والمفاوضات والتواصل الرسمي.", "fr": "Correspondance diplomatique avancée, négociations et communication formelle.", "de": "Fortgeschrittene diplomatische Korrespondenz, Verhandlungen und formelle Kommunikation.", "ru": "Продвинутая дипломатическая переписка, переговоры и официальное общение.", "zh": "高级外交信函、谈判和正式沟通。"}
        },
        "c2_u2": {
            "title": {"en": "Protocol and Consular Affairs", "ar": "البروتوكول والشؤون القنصلية", "fr": "Protocole et affaires consulaires", "de": "Protokoll und Konsularangelegenheiten", "ru": "Протокол и консульские вопросы", "zh": "礼宾与领事事务"},
            "description": {"en": "Formal protocols, consular functions, and state representational duties.", "ar": "البروتوكولات الرسمية والمهام القنصلية ومهام تمثيل الدولة.", "fr": "Protocoles formels, fonctions consulaires et fonctions de représentation de l'État.", "de": "Formelle Protokolle, konsularische Funktionen und staatliche Repräsentationspflichten.", "ru": "Официальные протоколы, консульские функции и обязанности по представительству государства.", "zh": "正式礼宾、领事职能及国家代表职责。"}
        },
        "c2_u3": {
            "title": {"en": "International Organizations", "ar": "المنظمات الدولية", "fr": "Organisations internationales", "de": "Internationale Organisationen", "ru": "Международные организации", "zh": "国际组织"},
            "description": {"en": "Structure and function of international bodies and global governance.", "ar": "هيكل وعمل الهيئات الدولية والحوكمة العالمية.", "fr": "Structure et fonction des organismes internationaux et gouvernance mondiale.", "de": "Struktur und Funktion internationaler Gremien und globale Governance.", "ru": "Структура и функционирование международных органов и глобальное управление.", "zh": "国际机构的结构与职能以及全球治理。"}
        },
        "c2_u4": {
            "title": {"en": "Geopolitics and National Security", "ar": "الجيوسياسية والأمن القومي", "fr": "Géopolitique et sécurité nationale", "de": "Geopolitik und nationale Sicherheit", "ru": "Геополитика и национальная безопасность", "zh": "地缘政治与国家安全"},
            "description": {"en": "Strategic assessment of global power and national security frameworks.", "ar": "التقييم الاستراتيجي للقوة العالمية وأطر الأمن القومي.", "fr": "Évaluation stratégique de la puissance mondiale et cadres de sécurité nationale.", "de": "Strategische Bewertung der globalen Macht und nationaler Sicherheitsrahmen.", "ru": "Стратегическая оценка глобальной мощи и основ национальной безопасности.", "zh": "全球力量和国家安全框架的战略评估。"}
        },
        "c2_u5": {
            "title": {"en": "Humanitarian Law and Justice", "ar": "القانون الإنساني والعدالة", "fr": "Droit humanitaire et justice", "de": "Humanitäres Recht und Gerechtigkeit", "ru": "Гуманитарное право и правосудие", "zh": "人道法与正义"},
            "description": {"en": "Application of human rights law and international justice mechanisms.", "ar": "تطبيق قانون حقوق الإنسان وآليات العدالة الدولية.", "fr": "Application du droit des droits de l'homme et des mécanismes de justice internationale.", "de": "Anwendung der Menschenrechte und internationaler Justizmechanismen.", "ru": "Применение норм в области прав человека и механизмов международного правосудия.", "zh": "人权法的应用和国际司法机制。"}
        },
        "c2_u6": {
            "title": {"en": "International Environmental Law", "ar": "القانون البيئي الدولي", "fr": "Droit international de l'environnement", "de": "Internationales Umweltrecht", "ru": "Международное экологическое право", "zh": "国际环境法"},
            "description": {"en": "Legal frameworks for global environmental protection and sustainability.", "ar": "الأطر القانونية لحماية البيئة العالمية والاستدامة.", "fr": "Cadres juridiques pour la protection de l'environnement mondial et la durabilité.", "de": "Rechtliche Rahmenbedingungen für den weltweiten Umweltschutz und Nachhaltigkeit.", "ru": "Правовые основы глобальной защиты окружающей среды и устойчивого развития.", "zh": "全球环境保护和可持续发展的法律框架。"}
        },
        "c2_u7": {
            "title": {"en": "Global Economy and Trade Law", "ar": "الاقتصاد العالمي وقانون التجارة", "fr": "Économie mondiale et droit commercial", "de": "Weltwirtschaft und Handelsrecht", "ru": "Мировая экономика и торговое право", "zh": "全球经济与贸易法"},
            "description": {"en": "Governance of global markets, trade disputes, and investment.", "ar": "حوكمة الأسواق العالمية والنزاعات التجارية والاستثمار.", "fr": "Gouvernance des marchés mondiaux, différends commerciaux et investissements.", "de": "Governance globaler Märkte, Handelsstreitigkeiten und Investitionen.", "ru": "Управление глобальными рынками, торговые споры и инвестиции.", "zh": "全球市场治理、贸易争端和投资。"}
        },
        "c2_u8": {
            "title": {"en": "Science, Technology, and Law", "ar": "العلم والتكنولوجيا والقانون", "fr": "Science, technologie et droit", "de": "Wissenschaft, Technologie und Recht", "ru": "Наука, технологии и право", "zh": "科学、技术与法律"},
            "description": {"en": "Legal challenges of space, cyber warfare, AI, and emerging tech.", "ar": "التحديات القانونية للفضاء والحرب السيبرانية والذكاء الاصطناعي والتقنيات الناشئة.", "fr": "Défis juridiques de l'espace, de la cyberguerre, de l'IA et des technologies émergentes.", "de": "Rechtliche Herausforderungen in den Bereichen Weltraum, Cyberkriegführung, KI und aufstrebende Technologien.", "ru": "Правовые проблемы космоса, кибервойн, ИИ и новых технологий.", "zh": "空间、网络战、人工智能和新兴技术的法律挑战。"}
        }
    }

    # Lesson Titles (simplified translations)
    LESSON_TITLES = {
        "c2_u1_l1": {"en": "Formal Greetings", "ar": "التحيات الرسمية", "fr": "Salutations formelles", "de": "Formelle Begrüßungen", "ru": "Официальные приветствия", "zh": "正式问候"},
        "c2_u1_l2": {"en": "Negotiation Strategies", "ar": "استراتيجيات التفاوض", "fr": "Stratégies de négociation", "de": "Verhandlungsstrategien", "ru": "Стратегии переговоров", "zh": "谈判策略"},
        "c2_u1_l3": {"en": "Treaty Drafting", "ar": "صياغة المعاهدات", "fr": "Rédaction de traités", "de": "Vertragsentwurf", "ru": "Составление договоров", "zh": "条约起草"},
        "c2_u1_l4": {"en": "Public Diplomacy", "ar": "الدبلوماسية العامة", "fr": "Diplomatie publique", "de": "Öffentliche Diplomatie", "ru": "Публичная дипломатия", "zh": "公共外交"},
        "c2_u1_l5": {"en": "Crisis Communication", "ar": "التواصل في الأزمات", "fr": "Communication de crise", "de": "Krisenkommunikation", "ru": "Кризисная коммуникация", "zh": "危机沟通"},
        "c2_u1_l6": {"en": "Intercultural Communication", "ar": "التواصل بين الثقافات", "fr": "Communication interculturelle", "de": "Interkulturelle Kommunikation", "ru": "Межкультурная коммуникация", "zh": "跨文化沟通"},
        "c2_u1_l7": {"en": "Diplomatic Immunity", "ar": "الحصانة الدبلوماسية", "fr": "Immunité diplomatique", "de": "Diplomatische Immunität", "ru": "Дипломатический иммунитет", "zh": "外交豁免权"},
        "c2_u1_l8": {"en": "Review and Case Study", "ar": "مراجعة ودراسة حالة", "fr": "Examen et étude de cas", "de": "Rückschau und Fallstudie", "ru": "Обзор и тематическое исследование", "zh": "复习与案例研究"},
        
        "c2_u2_l1": {"en": "Vienna Convention", "ar": "اتفاقية فيينا", "fr": "Convention de Vienne", "de": "Wiener Übereinkommen", "ru": "Венская конвенция", "zh": "维也纳公约"},
        "c2_u2_l2": {"en": "Consular Functions", "ar": "المهام القنصلية", "fr": "Fonctions consulaires", "de": "Konsularische Funktionen", "ru": "Консульские функции", "zh": "领事职能"},
	    "c2_u2_l3": {"en": "Protecting Citizens", "ar": "حماية المواطنين", "fr": "Protection des citoyens", "de": "Schutz der Bürger", "ru": "Защита граждан", "zh": "保护公民"},
        "c2_u2_l4": {"en": "Visa and Passport Services", "ar": "خدمات التأشيرات والجوازات", "fr": "Services de visa et passeport", "de": "Visa- und Passdienste", "ru": "Визовые и паспортные услуги", "zh": "签证和护照服务"},
	    "c2_u2_l5": {"en": "Legalization of Documents", "ar": "تصديق المستندات", "fr": "Légalisation de documents", "de": "Beglaubigung von Dokumenten", "ru": "Легализация документов", "zh": "证件认证"},
	    "c2_u2_l6": {"en": "Institutional Liaison", "ar": "التنسيق المؤسسي", "fr": "Liaison institutionnelle", "de": "Institutionelle Verbindung", "ru": "Институциональное взаимодействие", "zh": "机构联络"},
	    "c2_u2_l7": {"en": "Emergency Services", "ar": "خدمات الطوارئ", "fr": "Services d'urgence", "de": "Notfalldienste", "ru": "Экстренные службы", "zh": "紧急服务"},
	    "c2_u2_l8": {"en": "Unit Review", "ar": "مراجعة الوحدة", "fr": "Examen de l'unité", "de": "Rückschau der Einheit", "ru": "Обзор раздела", "zh": "单元复习"},

        "c2_u3_l1": {"en": "United Nations System", "ar": "منظومة الأمم المتحدة", "fr": "Système des Nations Unies", "de": "System der Vereinten Nationen", "ru": "Система ООН", "zh": "联合国系统"},
        "c2_u3_l2": {"en": "World Bank and IMF", "ar": "البنك الدولي وصندوق النقد", "fr": "Banque mondiale et FMI", "de": "Weltbank und IWF", "ru": "Всемирный банк и МВФ", "zh": "世界银行和国际货币基金组织"},
        "c2_u3_l3": {"en": "WTO and Global Trade", "ar": "المنظمة العالمية والتجارة", "fr": "OMC et commerce mondial", "de": "WTO und Welthandel", "ru": "ВТО и мировая торговля", "zh": "世贸组织与全球贸易"},
        "c2_u3_l4": {"en": "Regional Organizations", "ar": "المنظمات الإقليمية", "fr": "Organisations régionales", "de": "Regionalorganisationen", "ru": "Региональные организации", "zh": "区域组织"},
        "c2_u3_l5": {"en": "NGOs and Civil Society", "ar": "المنظمات غير الحكومية", "fr": "ONG et société civile", "de": "NGOs und Zivilgesellschaft", "ru": "НПО и гражданское общество", "zh": "非政府组织与公民社会"},
        "c2_u3_l6": {"en": "International Court of Justice", "ar": "محكمة العدل الدولية", "fr": "Cour internationale de justice", "de": "Internationaler Gerichtshof", "ru": "Международный суд", "zh": "国际法院"},
        "c2_u3_l7": {"en": "Global Policy Making", "ar": "صنع السياسات العالمية", "fr": "Élaboration des politiques mondiales", "de": "Globale Politikgestaltung", "ru": "Разработка глобальной политики", "zh": "全球政策制定"},
        "c2_u3_l8": {"en": "Case Study: Rule of Law", "ar": "دراسة حالة: سيادة القانون", "fr": "Étude de cas : État de droit", "de": "Fallstudie: Rechtsstaatlichkeit", "ru": "Тематическое исследование: Верховенство права", "zh": "案例研究：法治"},

        "c2_u4_l1": {"en": "National Security Frameworks", "ar": "أطر الأمن القومي", "fr": "Cadres de sécurité nationale", "de": "Nationale Sicherheitsrahmen", "ru": "Основы национальной безопасности", "zh": "国家安全框架"},
        "c2_u4_l2": {"en": "Intelligence Operations", "ar": "عمليات الاستخبارات", "fr": "Opérations de renseignement", "de": "Geheimdienstoperationen", "ru": "Разведывательные операции", "zh": "情报行动"},
        "c2_u4_l3": {"en": "Cyber Security Strategy", "ar": "استراتيجية الأمن السيبراني", "fr": "Stratégie de cybersécurité", "de": "Cyber-Sicherheitsstrategie", "ru": "Стратегия кибербезопасности", "zh": "网络安全战略"},
        "c2_u4_l4": {"en": "Counter-Terrorism", "ar": "مكافحة الإرهاب", "fr": "Lutte contre le terrorisme", "de": "Terrorismusbekämpfung", "ru": "Борьба с терроризмом", "zh": "反恐"},
        "c2_u4_l5": {"en": "Strategic Alliances", "ar": "التحالفات الاستراتيجية", "fr": "Alliances stratégiques", "de": "Strategische Allianzen", "ru": "Стратегические альянсы", "zh": "战略联盟"},
        "c2_u4_l6": {"en": "Conflict Resolution", "ar": "فض النزاعات", "fr": "Résolution de conflits", "de": "Konfliktlösung", "ru": "Разрешение конфликтов", "zh": "冲突解决"},
        "c2_u4_l7": {"en": "Resource Security", "ar": "أمن الموارد", "fr": "Sécurité des ressources", "de": "Ressourcensicherheit", "ru": "Ресурсная безопасность", "zh": "资源安全"},
        "c2_u4_l8": {"en": "Security Case Study", "ar": "دراسة حالة أمنية", "fr": "Étude de cas sur la sécurité", "de": "Fallstudie zur Sicherheit", "ru": "Тематическое исследование по безопасности", "zh": "安全案例研究"},

        "c2_u5_l1": {"en": "Geneva Conventions", "ar": "اتفاقيات جنيف", "fr": "Conventions de Genève", "de": "Genfer Konventionen", "ru": "Женевские конвенции", "zh": "日内瓦公约"},
        "c2_u5_l2": {"en": "Protection of Civilians", "ar": "حماية المدنيين", "fr": "Protection des civils", "de": "Schutz von Zivilpersonen", "ru": "Защита гражданского населения", "zh": "保护平民"},
        "c2_u5_l3": {"en": "War Crimes and Tribunals", "ar": "جرائم الحرب والمحاكم", "fr": "Crimes de guerre et tribunaux", "de": "Kriegsverbrechen und Tribunate", "ru": "Военные преступления и трибуналы", "zh": "战争罪与法庭"},
        "c2_u5_l4": {"en": "Human Rights Advocacy", "ar": "الدفاع عن حقوق الإنسان", "fr": "Défense des droits de l'homme", "de": "Menschenrechtsarbeit", "ru": "Защита прав человека", "zh": "人权倡导"},
        "c2_u5_l5": {"en": "International Criminal Court", "ar": "المحكمة الجنائية الدولية", "fr": "Cour pénale internationale", "de": "Internationaler Strafgerichtshof", "ru": "Международный уголовный суд", "zh": "国际刑事法院"},
        "c2_u5_l6": {"en": "Refugee Law", "ar": "قانون اللاجئين", "fr": "Droit des réfugiés", "de": "Flüchtlingsrecht", "ru": "Беженское право", "zh": "难民法"},
        "c2_u5_l7": {"en": "Transitional Justice", "ar": "العدالة الانتقالية", "fr": "Justice transitionnelle", "de": "Übergangsjustiz", "ru": "Переходное правосудие", "zh": "转型正义"},
        "c2_u5_l8": {"en": "Justice Case Study", "ar": "دراسة حالة في العدالة", "fr": "Étude de cas sur la justice", "de": "Fallstudie zur Gerechtigkeit", "ru": "Тематическое исследование правосудия", "zh": "司法案例研究"},

        "c2_u6_l1": {"en": "Climate Change Accords", "ar": "اتفاقيات تغير المناخ", "fr": "Accords sur le climat", "de": "Klimaschutzabkommen", "ru": "Климатические соглашения", "zh": "气候变化协议"},
        "c2_u6_l2": {"en": "Biodiversity Protection", "ar": "حماية التنوع البيولوجي", "fr": "Protection de la biodiversité", "de": "Schutz der Biodiversität", "ru": "Защита биоразнообразия", "zh": "生物多样性保护"},
        "c2_u6_l3": {"en": "Maritime Law and Oceans", "ar": "القانون البحري والمحيطات", "fr": "Droit maritime et océans", "de": "Seerecht und Ozeane", "ru": "Морское право и океаны", "zh": "海洋法与海洋"},
        "c2_u6_l4": {"en": "Sustainable Development", "ar": "التنمية المستدامة", "fr": "Développement durable", "de": "Nachhaltige Entwicklung", "ru": "Устойчивое развитие", "zh": "可持续发展"},
        "c2_u6_l5": {"en": "Waste and Pollution", "ar": "النفايات والتلوث", "fr": "Déchets et pollution", "de": "Abfall und Verschmutzung", "ru": "Отходы и загрязнение", "zh": "废物与污染"},
        "c2_u6_l6": {"en": "Renewable Energy Policy", "ar": "سياسة الطاقة المتجددة", "fr": "Politique énergétique", "de": "Energiepolitik", "ru": "Энергетическая политика", "zh": "可再生能源政策"},
        "c2_u6_l7": {"en": "Environmental Litigation", "ar": "التقاضي البيئي", "fr": "Litiges environnementaux", "de": "Umweltstreitigkeiten", "ru": "Экологические споры", "zh": "环境诉讼"},
        "c2_u6_l8": {"en": "Environment Case Study", "ar": "دراسة حالة بيئية", "fr": "Étude de cas environnementale", "de": "Fallstudie zur Umwelt", "ru": "Тематическое исследование по экологии", "zh": "环境案例研究"},

        "c2_u7_l1": {"en": "Global Market Regulation", "ar": "تنظيم الأسواق العالمية", "fr": "Régulation des marchés", "de": "Globale Marktregulierung", "ru": "Регулирование рынков", "zh": "全球市场监管"},
        "c2_u7_l2": {"en": "Trade Dispute Resolution", "ar": "تسوية النزاعات التجارية", "fr": "Règlement des différends", "de": "Handelsstreitbeilegung", "ru": "Разрешение торговых споров", "zh": "贸易争端解决"},
        "c2_u7_l3": {"en": "Intellectual Property", "ar": "الملكية الفكرية", "fr": "Propriété intellectuelle", "de": "Geistiges Eigentum", "ru": "Интеллектуальная собственность", "zh": "知识产权"},
        "c2_u7_l4": {"en": "Competition Law", "ar": "قانون المنافسة", "fr": "Droit de la concurrence", "de": "Wettbewerbsrecht", "ru": "Конкурентное право", "zh": "竞争法"},
        "c2_u7_l5": {"en": "Foreign Investment Law", "ar": "قانون الاستثمار الأجنبي", "fr": "Droit de l'investissement", "de": "Investitionsrecht", "ru": "Инвестиционное право", "zh": "外国投资法"},
        "c2_u7_l6": {"en": "International Tax Law", "ar": "قانون الضرائب الدولي", "fr": "Droit fiscal international", "de": "Internationales Steuerrecht", "ru": "Налоговое право", "zh": "国际税法"},
        "c2_u7_l7": {"en": "Digital Trade", "ar": "التجارة الرقمية", "fr": "Commerce numérique", "de": "Digitaler Handel", "ru": "Цифровая торговля", "zh": "数字贸易"},
        "c2_u7_l8": {"en": "Trade Case Study", "ar": "دراسة حالة تجارية", "fr": "Étude de cas commerciale", "de": "Fallstudie zum Handel", "ru": "Тематическое исследование по торговле", "zh": "贸易案例研究"},

        "c2_u8_l1": {"en": "Space Law", "ar": "قانون الفضاء", "fr": "Droit de l'espace", "de": "Weltraumrecht", "ru": "Космическое право", "zh": "空间法"},
        "c2_u8_l2": {"en": "Cyber Warfare and IHL", "ar": "الحرب السيبرانية والقانون", "fr": "Cyberguerre et DIH", "de": "Cyberkrieg und HVR", "ru": "Кибервойна и МГП", "zh": "网络战与国际人道法"},
        "c2_u8_l3": {"en": "AI Ethics and Law", "ar": "أخلاقيات الذكاء الاصطناعي", "fr": "Éthique de l'IA et droit", "de": "KI-Ethik und Recht", "ru": "Этика ИИ и право", "zh": "人工智能伦理与法律"},
        "c2_u8_l4": {"en": "Biotechnology Law", "ar": "قانون التكنولوجيا الحيوية", "fr": "Droit des biotechnologies", "de": "Biotechnologierecht", "ru": "Биотехнологическое право", "zh": "生物技术法"},
        "c2_u8_l5": {"en": "Emerging Technologies", "ar": "التكنولوجيات الناشئة", "fr": "Technologies émergentes", "de": "Aufstrebende Technologien", "ru": "Новые технологии", "zh": "新兴技术"},
        "c2_u8_l6": {"en": "Global Health Law", "ar": "قانون الصحة العالمية", "fr": "Droit de la santé mondiale", "de": "Weltgesundheitsrecht", "ru": "Право в области здравоохранения", "zh": "全球卫生法"},
        "c2_u8_l7": {"en": "Research Ethics", "ar": "أخلاقيات البحث", "fr": "Éthique de la recherche", "de": "Forschungsethik", "ru": "Этика исследований", "zh": "研究伦理"},
        "c2_u8_l8": {"en": "Future Case Study", "ar": "دراسة حالة مستقبلية", "fr": "Étude de cas futuriste", "de": "Zukunftsstudie", "ru": "Тематическое исследование будущего", "zh": "未来案例研究"}
    }

    prompts = {
        'en': 'Translate: ', 'ar': 'ترجم: ', 'fr': 'Traduire : ', 
        'de': 'Übersetzen: ', 'ru': 'Перевести: ', 'zh': '翻译: '
    }

    # Initialize New C2 Data Structure
    new_c2 = {
        "id": "c2",
        "title": c2_data["title"],
        "description": c2_data["description"],
        "isLocked": True,
        "units": []
    }

    def create_quiz(quiz_id, content_items, word_pool, sentence_pool, num_questions, localized_prompts, is_lesson=False):
        quiz_questions = []
        
        if is_lesson:
            # Lesson quiz: 10 words followed by 5 sentences
            words = [item for item in content_items if item["type"] == "word"]
            sentences = [item for item in content_items if item["type"] == "sentence"]
            
            # Types for words (10)
            word_types = ["multipleChoice", "audioOptions", "speaking", "listening", "multipleChoice", 
                          "audioOptions", "speaking", "listening", "multipleChoice", "audioOptions"]
            # Types for sentences (5)
            sentence_types = ["speaking", "listening", "multipleChoice", "audioOptions", "speaking"]
            
            # Process words
            for i in range(min(10, len(words))):
                item = words[i]
                arabic = item["arabic"]
                q_type = word_types[i]
                
                question = {
                    "id": f"{quiz_id}_{i+1}",
                    "type": q_type,
                    "correctAnswer": arabic,
                }
                if q_type in ["multipleChoice", "audioOptions", "listening"]:
                    opts_pool = [x for x in word_pool if x != arabic]
                    options = [arabic] + random.sample(opts_pool, min(len(opts_pool), 3))
                    random.shuffle(options)
                    question["options"] = options
                if q_type in ["audioOptions", "listening"]:
                    question["audioUrl"] = "true"
                if q_type == "multipleChoice":
                    question["text"] = {lang: f"{localized_prompts[lang]}{item['translation'][lang]}" for lang in localized_prompts}
                else:
                    question["text"] = arabic
                quiz_questions.append(question)
                
            # Process sentences
            for i in range(min(5, len(sentences))):
                item = sentences[i]
                arabic = item["arabic"]
                q_type = sentence_types[i]
                
                question = {
                    "id": f"{quiz_id}_{i+11}",
                    "type": q_type,
                    "correctAnswer": arabic,
                }
                if q_type in ["multipleChoice", "audioOptions", "listening"]:
                    opts_pool = [x for x in sentence_pool if x != arabic]
                    options = [arabic] + random.sample(opts_pool, min(len(opts_pool), 3))
                    random.shuffle(options)
                    question["options"] = options
                if q_type in ["audioOptions", "listening"]:
                    question["audioUrl"] = "true"
                if q_type == "multipleChoice":
                    question["text"] = {lang: f"{localized_prompts[lang]}{item['translation'][lang]}" for lang in localized_prompts}
                else:
                    question["text"] = arabic
                quiz_questions.append(question)
        else:
            # Unit and Level Quizzes (random sampling)
            sample_size = min(len(content_items), num_questions)
            quiz_items = random.sample(content_items, sample_size)
            
            for q_idx, item in enumerate(quiz_items, 1):
                arabic = item["arabic"]
                q_type = "multipleChoice"
                if q_idx % 4 == 0: q_type = "audioOptions"
                elif q_idx % 5 == 0: q_type = "listening"
                elif q_idx % 7 == 0: q_type = "speaking"
                
                question = {
                    "id": f"{quiz_id}_{q_idx}",
                    "type": q_type,
                    "correctAnswer": arabic,
                }
                if q_type in ["multipleChoice", "audioOptions", "listening"]:
                    pool = word_pool if item["type"] == "word" else sentence_pool
                    opts_pool = [x for x in pool if x != arabic]
                    options = [arabic] + random.sample(opts_pool, min(len(opts_pool), 3))
                    random.shuffle(options)
                    question["options"] = options
                if q_type in ["audioOptions", "listening"]:
                    question["audioUrl"] = "true"
                if q_type == "multipleChoice":
                    question["text"] = {lang: f"{localized_prompts[lang]}{item['translation'][lang]}" for lang in localized_prompts}
                else:
                    question["text"] = arabic
                quiz_questions.append(question)
        return quiz_questions

    # To build the level-wide pool
    level_words = []
    level_sentences = []
    level_all_items = []

    for u_idx in range(1, 9):
        u_id = f"c2_u{u_idx}"
        unit_meta = UNIT_METADATA[u_id]
        unit_obj = {
            "id": u_id,
            "title": unit_meta["title"],
            "description": unit_meta["description"],
            "isLocked": True,
            "lessons": []
        }
        
        unit_words = []
        unit_sentences = []
        unit_all_items = []
        
        for l_idx in range(1, 9):
            l_id = f"{u_id}_l{l_idx}"
            lesson_title = LESSON_TITLES[l_id]
            lesson_regen = regen_data.get(l_id, {"words": [], "sentences": []})
            
            lesson_obj = {
                "id": l_id,
                "title": lesson_title,
                "type": "vocabulary",
                "xpReward": 20,
                "estimatedMinutes": 5,
                "isLocked": False,
                "content": []
            }
            
            # Words
            lesson_words = []
            for w_idx, word in enumerate(lesson_regen["words"], 1):
                arabic_word = word["ar"]
                lesson_words.append(arabic_word)
                word_item = {
                    "id": f"{l_id}_w{w_idx}",
                    "type": "word",
                    "arabic": arabic_word,
                    "transliteration": {lang: get_transliteration(arabic_word, lang) for lang in ['en', 'fr', 'de', 'ru', 'zh']},
                    "translation": {lang: word[lang] for lang in ['en', 'fr', 'de', 'ru', 'zh']}
                }
                word_item["transliteration"]["ar"] = arabic_word
                word_item["translation"]["ar"] = arabic_word
                lesson_obj["content"].append(word_item)
                unit_all_items.append(word_item)
                unit_words.append(arabic_word)
                
            # Sentences
            lesson_sentences = []
            for s_idx, sent in enumerate(lesson_regen["sentences"], 1):
                arabic_sent = sent["ar"]
                lesson_sentences.append(arabic_sent)
                sent_item = {
                    "id": f"{l_id}_s{s_idx}",
                    "type": "sentence",
                    "arabic": arabic_sent,
                    "transliteration": {lang: get_transliteration(arabic_sent, lang) for lang in ['en', 'fr', 'de', 'ru', 'zh']},
                    "translation": {lang: sent[lang] for lang in ['en', 'fr', 'de', 'ru', 'zh']}
                }
                sent_item["transliteration"]["ar"] = arabic_sent
                sent_item["translation"]["ar"] = arabic_sent
                lesson_obj["content"].append(sent_item)
                unit_all_items.append(sent_item)
                unit_sentences.append(arabic_sent)
                
            # Lesson Quiz
            lesson_obj["quiz"] = {
                "id": f"q_{l_id}_quiz",
                "questions": create_quiz(f"q_{l_id}", lesson_obj["content"], lesson_words, lesson_sentences, 15, prompts, is_lesson=True)
            }
                
            unit_obj["lessons"].append(lesson_obj)
        
        # Unit Quiz
        unit_obj["unitQuiz"] = {
            "id": f"q_{u_id}",
            "passingScore": 80,
            "questions": create_quiz(f"q_{u_id}", unit_all_items, unit_words, unit_sentences, 25, prompts)
        }
            
        new_c2["units"].append(unit_obj)
        level_all_items.extend(unit_all_items)
        level_words.extend(unit_words)
        level_sentences.extend(unit_sentences)

    # Level Quiz
    new_c2["quiz"] = {
        "id": "q_c2_level",
        "questions": create_quiz("q_c2_level", level_all_items, level_words, level_sentences, 50, prompts)
    }
    new_c2["xpReward"] = 500

    with open(c2_json_path, 'w', encoding='utf-8') as f:
        json.dump(new_c2, f, ensure_ascii=False, indent=4)
        
    print("c2.json integration complete.")

if __name__ == "__main__":
    integrate()
