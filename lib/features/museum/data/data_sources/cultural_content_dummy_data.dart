import '../models/cultural_category_model.dart';
import '../models/cultural_content_model.dart';

/// Cultural Content Dummy Data
/// Provides data for cultural exploration section
class CulturalContentDummyData {
  static List<CulturalCategoryModel> getCategories() {
    return const [
      CulturalCategoryModel(
        id: '1',
        name: 'Grammar',
        iconName: 'book',
        description: 'Arabic grammar rules and structures',
      ),
      CulturalCategoryModel(
        id: '2',
        name: 'Traditions',
        iconName: 'celebration',
        description: 'Cultural traditions and celebrations',
      ),
      CulturalCategoryModel(
        id: '3',
        name: 'Food',
        iconName: 'restaurant',
        description: 'Traditional Arabic cuisine',
      ),
      CulturalCategoryModel(
        id: '4',
        name: 'Clothing',
        iconName: 'checkroom',
        description: 'Traditional Arabic attire',
      ),
      CulturalCategoryModel(
        id: '5',
        name: 'Holidays',
        iconName: 'event',
        description: 'Important Islamic holidays',
      ),
    ];
  }

  static List<CulturalContentModel> getContentByCategory(String categoryId) {
    final allContent = _getAllContent();
    return allContent.where((content) => content.categoryId == categoryId).toList();
  }

  static List<CulturalContentModel> _getAllContent() {
    return const [
      // Grammar
      CulturalContentModel(
        id: 'g1',
        title: 'Root System',
        description: 'Most Arabic words derive from three-letter roots (الجذر). Understanding roots helps you recognize word families and expand your vocabulary efficiently.',
        categoryId: '1',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?q=80&w=600',
      ),
      CulturalContentModel(
        id: 'g2',
        title: 'Verb Forms',
        description: 'Arabic has 10 main verb forms (الأوزان), each with specific meanings. Form I is the base form, while others add nuances like causation, reflexivity, or intensity.',
        categoryId: '1',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=600',
      ),

      // Traditions
      CulturalContentModel(
        id: 't1',
        title: 'Ramadan',
        description: 'The holy month of fasting (رمضان) is observed by Muslims worldwide. It\'s a time of spiritual reflection, prayer, and community.',
        categoryId: '2',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1564769662533-4f00a87b4056?q=80&w=600',
      ),
      CulturalContentModel(
        id: 't2',
        title: 'Eid Al-Fitr',
        description: 'The festival of breaking the fast (عيد الفطر) marks the end of Ramadan. Families gather, exchange gifts, and share special meals.',
        categoryId: '2',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1519810755548-39cd217da494?q=80&w=600',
      ),
      CulturalContentModel(
        id: 't3',
        title: 'Eid Al-Adha',
        description: 'The festival of sacrifice (عيد الأضحى) commemorates Prophet Ibrahim\'s willingness to sacrifice his son. It\'s celebrated with prayers and charitable acts.',
        categoryId: '2',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1563823251944-88484e554c96?q=80&w=600',
      ),

      // Food
      CulturalContentModel(
        id: 'f1',
        title: 'Koshary',
        description: 'Egypt\'s national dish (كشري) - a delicious mix of rice, lentils, pasta, and crispy onions topped with spicy tomato sauce.',
        categoryId: '3',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1541518763669-279f00ed42e5?q=80&w=600',
      ),
      CulturalContentModel(
        id: 'f2',
        title: 'Kabsa',
        description: 'A traditional Saudi Arabian dish (كبسة) featuring spiced rice with meat, vegetables, and aromatic spices like cardamom and saffron.',
        categoryId: '3',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?q=80&w=600',
      ),
      CulturalContentModel(
        id: 'f3',
        title: 'Mansaf',
        description: 'Jordan\'s national dish (منسف) - lamb cooked in fermented dried yogurt and served with rice or bulgur.',
        categoryId: '3',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1582046422723-2ecb13cb650a?q=80&w=600',
      ),
      CulturalContentModel(
        id: 'f4',
        title: 'Hummus',
        description: 'A popular Levantine dip (حمص) made from chickpeas, tahini, lemon juice, and garlic. Enjoyed throughout the Arab world.',
        categoryId: '3',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1574484284002-952d9295bb49?q=80&w=600',
      ),

      // Clothing
      CulturalContentModel(
        id: 'c1',
        title: 'Galabeya',
        description: 'Traditional loose-fitting robe (جلابية) worn by men across Egypt and Sudan, especially comfortable in hot climates.',
        categoryId: '4',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1584281722572-c020586e92c4?q=80&w=600',
      ),
      CulturalContentModel(
        id: 'c2',
        title: 'Keffiyeh',
        description: 'Traditional headdress (كوفية) worn by men in the Middle East, often held in place with an agal (rope band).',
        categoryId: '4',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1510168134327-0402b8006bf2?q=80&w=600',
      ),
      CulturalContentModel(
        id: 'c3',
        title: 'Abaya',
        description: 'A simple, loose over-garment (عباية) worn by women in many Arab countries, often black and flowing.',
        categoryId: '4',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1601611756209-4081ad349079?q=80&w=600',
      ),

      // Holidays
      CulturalContentModel(
        id: 'h1',
        title: 'Islamic New Year',
        description: 'Muharram (محرم) marks the beginning of the Islamic calendar. It\'s a time for reflection and remembrance.',
        categoryId: '5',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1551041777-ed071d3397bc?q=80&w=600',
      ),
      CulturalContentModel(
        id: 'h2',
        title: 'Mawlid An-Nabi',
        description: 'Celebration of the Prophet Muhammad\'s birthday (المولد النبوي), observed with prayers, recitations, and community gatherings.',
        categoryId: '5',
        mediaType: 'image',
        mediaUrl: 'https://images.unsplash.com/photo-1614051019183-5bc50b2848c2?q=80&w=600',
      ),
    ];
  }
}
