// import 'package:arabic/features/museum/data/models/culture_island/island_zone.dart';
// import 'package:arabic/features/museum/data/models/culture_island/zone_page.dart';
// import 'package:flutter/material.dart';

// /// Interactive Island Dummy Data - Ultra Rich Edition
// /// Contains 5+ high-quality pages for each cultural zone with detailed descriptions
// class IslandDummyData {
//   static List<IslandZone> getZones() {
//     return [
//       // 1. History Area (التاريخ)
//       const IslandZone(
//         id: 'history_area',
//         title: 'تاريخ اللغة',
//         description:
//             'استكشف الجدول الزمني للحضارة العربية وتطور لغتها العريقة عبر العصور.',
//         icon3DPath: 'history_icon',
//         position: Offset(0.5, 0.2),
//         pages: [
//           ZonePage(
//             title: 'الجذور النبطية',
//             titleLocalized: const {
//               'ar': 'الجذور النبطية',
//               'en': 'Nabataean Roots',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'The Arabic script evolved from the Nabataean alphabet, used in Petra and northern Arabia.',
//               'ar': 'تطورت الكتابة العربية من الأبجدية النبطية التي كانت تستخدم في البتراء وشمال الجزيرة العربية. تعتبر اللغة النبطية هي الأصل المباشر للخط العربي الحديث. نشأت في مملكة الأنباط وعاصمتها البتراء، حيث كانت تستخدم في التجارة والتدوين. مع مرور الزمن، بدأت الحروف النبطية في التحول والتبسيط حتى اتخذت الأشكال التي نعرفها اليوم في العربية، مما يظهر عبقرية التطور الحضاري اللغوي.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1541963463532-d68292c34b19',
//           ),
//           ZonePage(
//             title: 'عصور ما قبل الإسلام',
//             titleLocalized: const {
//               'ar': 'عصور ما قبل الإسلام',
//               'en': 'Pre-Islamic Era',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Arabic was a language of poetry and oral tradition, with the Mu\'allaqat being its finest examples.',
//               'ar': 'كانت العربية لغة الشعر والتقاليد الشفهية، وتعتبر المعلقات من أرقى أمثلة الإبداع اللغوي. في العصر الجاهلي، بلغت العربية ذروة بلاغتها من خلال الشعر. كانت القبائل تفتخر بشعرائها الذين صاغوا "المعلقات"، وهي قصائد علقت على أستار الكعبة لنفاستها. كانت اللغة وعاءً للقيم والكرم والفروسية، وتميزت بمخزون هائل من المترادفات والبيان الذي سبق عصر التدوين.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1578326457399-3b34dbfaf239',
//           ),
//           ZonePage(
//             title: 'العصر الذهبي للترجمة',
//             titleLocalized: const {
//               'ar': 'العصر الذهبي للترجمة',
//               'en': 'Golden Age of Translation',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'The Abbasid Era marked a revolution where Greek and Indian sciences were translated into Arabic.',
//               'ar': 'شكل العصر العباسي ثورة كبرى حيث تُرجمت العلوم اليونانية والهندية إلى العربية في بيت الحكمة. في بيت الحكمة ببغداد، قاد العرب نهضة علمية بفضل ترجمة أمهات الكتب في الطب والفلسفة والرياضيات. لم يكتفِ العرب بالترجمة، بل أضافوا وابتكروا، مما جعل العربية لغة العلم الأولى في العالم لعدة قرون، وأثرت مصطلحاتها في اللغات اللاتينية والأوروبية المعاصرة.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1519810755548-39de21758dff',
//           ),
//           ZonePage(
//             title: 'لغة العلم العالمية',
//             titleLocalized: const {
//               'ar': 'لغة العلم العالمية',
//               'en': 'Global Language of Science',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'For centuries, Arabic was the language of international diplomacy and scientific inquiry.',
//               'ar': 'لعدة قرون، كانت العربية لغة الدبلوماسية الدولية والبحث العلمي العالمي في الطب والفلك. سيطرت العربية على المشهد الثقافي العالمي، فكان طلاب العلم من أوروبا يشدون الرحال إلى قرطبة والقاهرة للدراسة بالعربية. إن معظم النجوم في السماء والعديد من المصطلحات الكيميائية والرياضية (مثل الكيمياء والجبر) لها أسماء عربية أصيلة تشهد على ريادة هذه اللغة وتفوق علمائها.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1588666309990-d68f08e3d4a6',
//           ),
//           ZonePage(
//             title: 'العصر الحديث والمعاصر',
//             titleLocalized: const {
//               'ar': 'العصر الحديث والمعاصر',
//               'en': 'Modern and Contemporary Era',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Today, Arabic is one of the six official languages of the United Nations, spoken by over 400 million people.',
//               'ar': 'اليوم، تعد اللغة العربية واحدة من اللغات الست الرسمية في الأمم المتحدة ورمزاً للهوية العربية. حافظت العربية على كيانها رغم التحديات، وهي اليوم تجمع تحت رايتها مئات الملايين. تم اعتمادها كبغة رسمية في الأمم المتحدة، وتتميز بكونها اللغة الوحيدة التي لم يتغير نموذجها الفصيح منذ أكثر من 1400 عام، مما يجعل قراءة النصوص القديمة والحديثة متاحاً بنفس السهولة واليسر.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1542810634-71277d95dcbb',
//           ),
//         ],
//       ),

//       // 2. Grammar Area (القواعد)
//       const IslandZone(
//         id: 'grammar_area',
//         title: 'قواعد اللغة',
//         description: 'أتقن أسرار النحو والصرف العربي وجماليات بناء الجملة.',
//         icon3DPath: 'book_icon',
//         position: Offset(0.2, 0.4),
//         pages: [
//           ZonePage(
//             title: 'نظام الجذور الثلاثية',
//             titleLocalized: const {
//               'ar': 'نظام الجذور الثلاثية',
//               'en': 'Triconsonantal Root System',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Most Arabic words are derived from a 3-letter root which carries the core meaning.',
//               'ar': 'نظام الجذور الثلاثية هو العمود الفقري للعربية؛ حيث يشتق منه مئات الكلمات المترابطة. تعتمد العربية على نظام رياضي مذهل يسمى "الاشتقاق". فمن الكاف والتاء والباء (ك-ت-ب) نشتق: كتب، كاتب، كتاب، مكتوب، ومكتبة. كل هذه الكلمات تدور حول معنى الكتابة. هذا النظام يتيح للغة إيجاد مصطلحات جديدة باستمرار والحفاظ على ترابطها المعنوي العميق.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1541963463532-d68292c34b19',
//           ),
//           ZonePage(
//             title: 'الجملة الاسمية',
//             titleLocalized: const {
//               'ar': 'الجملة الاسمية',
//               'en': 'The Nominal Sentence',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'A Nominal sentence starts with a noun and consists of a subject and predicate.',
//               'ar': 'الجملة الاسمية هي التي تبدأ باسم، وتتكون من المبتدأ والخبر اللذان يكملان المعنى. الجملة الاسمية هي أولى خطواتك في التحدث بطلاقة. هي جملة "ثابتة" تصف الحقائق. ففي (العلمُ نورٌ)، المبتدأ هو العلم، والخبر هو نور. لاحظ أن اللغة العربية لا تحتاج لفعل "يكون" (is) في هذا النوع من الجمل، مما يجعلها موجزة وقوية في بلاغتها.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b',
//           ),
//           ZonePage(
//             title: 'الجملة الفعلية',
//             titleLocalized: const {
//               'ar': 'الجملة الفعلية',
//               'en': 'The Verbal Sentence',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'A Verbal sentence starts with a verb and typically follows the Verb-Subject-Object order.',
//               'ar': 'الجملة الفعلية تبدأ بفعل، وتتكون من الفعل والفاعل، وتصف الأحداث بدقة زمنية. عكس الجملة الاسمية، تركز الجملة الفعلية على الحركة والزمن. الترتيب الشائع هو (فعل + فاعل). وتتميز الأفعال العربية بقدرتها على تضمين الفاعل بداخلها كضمير مستتر، مما يمنح الجملة مرونة هائلة وسرعة في التعبير عن الأحداث المتعاقبة.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8',
//           ),
//           ZonePage(
//             title: 'الضمائر المتصلة',
//             titleLocalized: const {
//               'ar': 'الضمائر المتصلة',
//               'en': 'Attached Pronouns',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Arabic uses suffixes attached to nouns, verbs, and prepositions to indicate ownership or action.',
//               'ar': 'تستخدم العربية الضمائر المتصلة في نهاية الأسماء والأفعال للتعبير عن الملكية والمفعولية. الضمائر المتصلة هي اختصار ذكي جداً. فبدلاً من قول (كتاب لي)، نقول (كتابي). وبدلاً من (رأى هو أنا)، نقول (رآني). هذه الزوائد الصغيرة في نهايات الكلمات تقوم بعمل جمل كاملة، وهي من أهم وأروع ميزات اللغة العربية في الإيجاز والبيان.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6',
//           ),
//           ZonePage(
//             title: 'الإعراب والحركات',
//             titleLocalized: const {
//               'ar': 'الإعراب والحركات',
//               'en': 'I\'rab and Vowel Marks',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Case endings (I\'rab) are short vowels at the end of words that determine their grammatical role.',
//               'ar': 'الإعراب هو تغيير حركات أواخر الكلمات لتحديد وظيفتها النحوية في الجملة. الحركات الإعرابية (الضمة، الفتحة، الكسرة) ليست مجرد زينة، بل هي بوصلة تفهم من خلالها المعنى. فالحركة تخبرك من هو الفاعل ومن هو المفعول به حتى لو تغير ترتيب الكلمات. هذا ما يمنح العربية قدرتها الفائقة على ترتيب الكلمات بطرق مختلفة مع الحفاظ على وضوح المعنى.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1516979187457-637abb4f9353',
//           ),
//         ],
//       ),

//       // 3. Vocabulary Area (المفرادت)
//       const IslandZone(
//         id: 'vocabulary_area',
//         title: 'عالم المفردات',
//         description:
//             'قم بتوسيع قاموسك بمفردات من واقع الحياة اليومية والمشاهد الثقافية.',
//         icon3DPath: 'translate_icon',
//         position: Offset(0.8, 0.4),
//         pages: [
//           ZonePage(
//             title: 'عناصر الطبيعة',
//             titleLocalized: const {
//               'ar': 'عناصر الطبيعة',
//               'en': 'Elements of Nature',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Master the names of natural elements like the sun, moon, and rivers in Arabic.',
//               'ar': 'تعلم أسماء عناصر الطبيعة الخلابة مثل الشمس والقمر والجبال والأنهار باللغة العربية. تحتفي اللغة العربية بالطبيعة وألهمت الشعراء كثيراً. ستتعلم هنا كلمات مثل (شمس، قمر، بحر، جبل، وادٍ). للأرض في العربية معانٍ عميقة، فمثلاً توجد عشرات الكلمات لوصف المطر حسب شدته، مما يعكس ارتباط الإنسان العربي الوثيق ببيئته وتغيراتها.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e',
//           ),
//           ZonePage(
//             title: 'أدوات العلم',
//             titleLocalized: const {
//               'ar': 'أدوات العلم',
//               'en': 'Tools of Knowledge',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Essential words for learners, including books, pens, and modern learning tools.',
//               'ar': 'كلمات أساسية للطلاب من الكتاب والقلم إلى الأدوات الرقمية والتقنيات الحديثة. تاريخ العربية مرتبط بالتدوين. ستكتشف مفردات (كتاب، قلم، دفتر، سبورة، حاسوب). لاحظ أن كلمة "كتاب" مشتقة من "كتب"، و"مدرسة" من "درس". الربط بين المفردات وجذورها سيجعل تعلم الكلمات الجديدة أسهل بمرتين وأكثر متعة.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173',
//           ),
//           ZonePage(
//             title: 'المائدة العربية',
//             titleLocalized: const {
//               'ar': 'المائدة العربية',
//               'en': 'The Arabic Dining Table',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Explore the names of delicious Arabic dishes and dining essentials.',
//               'ar': 'استكشف أسماء الأطباق العربية الشهيرة ومفردات الطعام والمائدة والكرم. الطعام في الثقافة العربية يرتبط بالضيافة. ستتعلم أسماء مثل (خبز، ماء، أرز، تمر) وأدوات (ملعقة، شوكة، سكين). كما ستعرف مصطلحات الكرم مثل "تفضل" و "صحتين"، فاللغة حول المائدة لا تقتصر على الطعام بل تمتد لمشاعر الود والترحيب.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
//           ),
//           ZonePage(
//             title: 'رحلة السفر',
//             titleLocalized: const {
//               'ar': 'رحلة السفر',
//               'en': 'Travel Journey',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Common travel vocabulary for planes, trains, and navigation in Arabic speaking cities.',
//               'ar': 'مفردات السفر الشائعة ولغة المطارات والفنادق وكيفية طلب الاتجاهات في المدن. السفر رحلة استكشاف. تعلم مفردات (طائرة، فندق، جواز سفر، شارع، خريطة). ستتعلم كيف تسأل "أين..؟" وكيف تفهم الأرقام والأسعار. هذه الكلمات هي مفتاحك لتعامل يومي ناجح خلال رحلتك في أي بلد عربي وتجعلك تتواصل كالسكان المحليين.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800',
//           ),
//           ZonePage(
//             title: 'روابط العائلة',
//             titleLocalized: const {
//               'ar': 'روابط العائلة',
//               'en': 'Family Ties',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Arabic language has precise terms for family members and social relationships.',
//               'ar': 'تحتوي اللغة العربية على مصطلحات دقيقة لأفراد العائلة والأقارب في المجتمع العربي. العائلة هي قلب المجتمع العربي. تفرق العربية بدقة بين (الخال والعم) و (الخالة والعمة). ستعرف معاني (أب، أم، أخ، أخت، جد). كما ستلمس الدفء في مناداة الأقارب بمصطلحات تظهر الاحترام والتقدير، مما يعكس بنية المجتمع المتماسكة.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1511895426328-dc8714191300',
//           ),
//         ],
//       ),

//       // 4. Lessons Area (الدروس التفاعلية)
//       const IslandZone(
//         id: 'lessons_area',
//         title: 'دروس تفاعلية',
//         description:
//             'شارك في تحديات تعليمية ممتعة وطور مهاراتك في الاستماع والتحدث.',
//         icon3DPath: 'school_icon',
//         position: Offset(0.3, 0.7),
//         pages: [
//           ZonePage(
//             title: 'موسيقى الحروف',
//             titleLocalized: const {
//               'ar': 'موسيقى الحروف',
//               'en': 'Music of Letters',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Practice identifying unique Arabic phonetic sounds and letter pronunciations.',
//               'ar': 'تدرب على تمييز مخارج الحروف، والفرق بين الحروف المرققة والمفخمة بدقة. مخارج الحروف في العربية فن قائم بذاته. ستتمرن هنا على نطق الحروف التي تميز العربية (مثل الضاد والعين والحاء). التدريب الصوتي التفاعلي سيساعدك على إتقان النطق الصحيح وتذوق "جرس" الكلمات وموسيقاها الخاصة التي تجعل العربية لغة شاعرة.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1516280440614-37939bbacd81',
//           ),
//           ZonePage(
//             title: 'حوار التعارف',
//             titleLocalized: const {
//               'ar': 'حوار التعارف',
//               'en': 'Introductory Dialogue',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Interactive scripts to practice greeting people and introducing yourself in social meetings.',
//               'ar': 'حوارات تفاعلية للتدرب على إلقاء التحية والتعريف بنفسك في اللقاءات الأولى. اللقاء الأول يترك انطباعاً دائماً. ستتعلم كيف تبدأ بـ "السلام عليكم" وكيف ترد "وعليكم السلام". ستتمرن على عبارات (اسمي، تشرفت بمعرفتك، كيف حالك؟). هذه المحادثات التفاعلية مصممة لتبني ثقتك بنفسك لتتحدث العربية منذ يومك الأول.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1521791136064-7986c29596ad',
//           ),
//           ZonePage(
//             title: 'واحة القصص',
//             titleLocalized: const {
//               'ar': 'واحة القصص',
//               'en': 'Story Oasis',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Improve your reading skills with simple, engaging stories from Arabic folklore.',
//               'ar': 'طور طلاقة قراءتك من خلال قصص مشوقة بسيطة مستوحاة من التراث العربي. القراءة هي نافذتك للثقافة. في هذه الواحة، سنقرأ قصصاً قصيرة بكلمات مألوفة. ستبدأ بفهم الجمل البسيطة حتى تصل لاستخلاص العبر من الحكم العربية القديمة. القراءة بانتظام هي أسرع وسيلة لإثراء حصيلتك اللغوية وتعلم تراكيب الجمل الصحيحة.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1512820790803-83ca734da794',
//           ),
//           ZonePage(
//             title: 'ألغاز نحوية',
//             titleLocalized: const {
//               'ar': 'ألغاز نحوية',
//               'en': 'Grammar Puzzles',
//             },
//             detailedDescriptionLocalized:  {
//               'en': 'Fun grammar puzzles and quizzes to check your understanding of language rules.',
//               'ar': 'حل ألغازاً نحوية ممتعة واختبر فهمك للقواعد بأسلوب ذكي بعيد عن الجمود. النحو ليس جافاً إذا تحول إلى لعبة! ستقوم بحل ألغاز حول ترتيب الجمل واختيار الحركات الإعرابية الصحيحة. هذه التحديات الذكية تقيس سرعة بديهتك اللغوية وتساعدك على تذكر القواعد المعقدة بأسلوب بصري وتفاعلي لا ينسى.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1510070112810-d4e9a46d9e91',
//           ),
//           ZonePage(
//             title: 'التعبير الإبداعي',
//             titleLocalized:  {
//               'ar': 'التعبير الإبداعي',
//               'en': 'Creative Expression',
//             },
//             detailedDescriptionLocalized:  {
//               'en': 'Creative assignments to use your learned words for everyday expression.',
//               'ar': 'وحدات إبداعية تستخدم فيها ما تعلمته من كلمات للتعبير عن مشاعرك وأفكارك. الهدف النهائي هو التعبير عن نفسك. هنا ستحاول كتابة جمل تصف بها صوراً أو تعبر عن يومك. ستستخدم القواعد والمفردات التي تعلمتها في سياقاتك الشخصية. الإبداع باللغة هو أفضل دليل على أنك بدأت تفكر بالعربية وتستوعب جمالياتها بدقة.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f',
//           ),
//         ],
//       ),

//       // 5. Culture Area (الثقافة العربية)
//       const IslandZone(
//         id: 'culture_area',
//         title: 'ثقافة وعادات',
//         description:
//             'غص في أعماق التقاليد الغنية والعمارة الإسلامية والفنون العربية الأصيلة.',
//         icon3DPath: 'lantern_icon',
//         position: Offset(0.7, 0.7),
//         pages: [
//           ZonePage(
//             title: 'تقاليد الضيافة',
//             titleLocalized:  {
//               'ar': 'تقاليد الضيافة',
//               'en': 'Traditions of Hospitality',
//             },
//             detailedDescriptionLocalized:  {
//               'en': 'Learn about the core values of Arab generosity and welcoming strangers.',
//               'ar': 'تعرف على قيم الكرم العربي المتأصلة وتقاليد الترحيب بالضيف وإكرامه. الضيف في البيت العربي هو "صاحب المحل". ستعرف كيف يتم تقديم القهوة باليد اليمنى، وكيف يستقبل العرب جيرانهم. الضيافة ليست مجرد طعام، بل هي جمل من الترحيب والأدب والود جعلت للعرب سمعة عالمية في الكرم والشهامة والترحاب بكل قادم.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1519810755548-39de21758dff',
//           ),
//           ZonePage(
//             title: 'تراث الأزياء',
//             titleLocalized: const {
//               'ar': 'تراث الأزياء',
//               'en': 'Heritage of Fashion',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Discover the elegant traditional garments across the diverse Arab world.',
//               'ar': 'اكتشف تنوع وأناقة الأزياء التقليدية التي تعبر عن هوية كل منطقة عربية. الأزياء العربية هي لوحات مطرزة. من الكفتان المغربي بلمساته الأندلسية، إلى الثوب والعباءة والعمامة في الخليج والمشرق. كل ثوب يحكي قصة الجغرافيا والمناخ والتاريخ، ويتميز بتطريزات يدوية فريدة جعلته يصل للعالمية كرمز للأناقة الممزوجة بالحشمة والجمال.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1583922650041-d96049539d9e',
//           ),
//           ZonePage(
//             title: 'روائع العمارة',
//             titleLocalized: const {
//               'ar': 'روائع العمارة',
//               'en': 'Architectural Masterpieces',
//             },
//             detailedDescriptionLocalized:  {
//               'en': 'Explore the stunning Islamic patterns, calligraphy, and architectural wonders of mosques.',
//               'ar': 'استكشف روعة الزخارف الإسلامية والخط العربي وتصاميم المساجد التاريخية المذهلة. العمارة الإسلامية هي تجسيد للجمال الروحي. ستشاهد روعة الأرابيسك والمقرنصات والقباب الشاهقة. الخط العربي ليس مجرد كتابة، بل هو فن تشكيلي يزين الجدران والقباب، ويجعل من المبنى قصيدة بصرية تسبح في عالم من التناغم الهندسي والدقة المتناهية.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1554188248-986adbb73be4',
//           ),
//           ZonePage(
//             title: 'إيقاع التراث',
//             titleLocalized:  {
//               'ar': 'إيقاع التراث',
//               'en': 'The Rhythm of Heritage',
//             },
//             detailedDescriptionLocalized:  {
//               'en': 'The rich history of Arabic music instruments like the Oud and the deep tradition of poetry.',
//               'ar': 'تعرف على تاريخ الآلات الموسيقية العربية العريكة وألحان المقامات والقصائد الخالدة. الموسيقى العربية تعتمد على المقامات التي تلمس المشاعر. ستعرف عن "العود" سلطان الآلات العربية، و"الناي" وصوته الشجي. يقترن الطرب العربي دائماً بالشعر، فكانت الأغاني قصائد منسوجة ببراعة، تعبر عن الحب والحنين والفخر، وتطرب المسامع بألحان لا يمحوها الزمن.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1511379938547-c1f69419868d',
//           ),
//           ZonePage(
//             title: 'أجواء الأعياد',
//             titleLocalized: const {
//               'ar': 'أجواء الأعياد',
//               'en': 'Holiday Atmosphere',
//             },
//             detailedDescriptionLocalized: const {
//               'en': 'Celebrations in the Arab world are vibrant, filled with unique customs, food, and family gatherings.',
//               'ar': 'الاحتفالات والأعياد العربية نابضة بالحياة، مليئة بالبهجة والمأكولات والجمعات الدافئة. في الأعياد، تضاء الشوارع وتلبس المدن أبهى حللها. من عيد الفطر وعيد الأضحى إلى المناسبات الوطنية والكرنفالات. يتميز العيد بالزيارات العائلية و"العيدية" للأطفال، وتناول أشهى الحلويات كالمعمول والحلويات الشرقية، مما يجعلها أوقاتاً لا تنسى تجدد الروابط الاجتماعية.',
//             },
//             imageUrl:
//                 'https://images.unsplash.com/photo-1533777857889-4be7c70b33f7',
//           ),
//         ],
//       ),
//     ];
//   }
// }
