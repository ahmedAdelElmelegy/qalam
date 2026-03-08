import '../models/culture_zone_model.dart';
import '../models/culture_page_model.dart';

/// Culture Dummy Data
/// Provides content for the Arabic Culture Island feature
class CultureDummyData {
  /// Get all cultural zones (categories)
  static List<CultureZone> getZones() {
    return [

      const CultureZone(
        id: 'cities',
        title: 'culture_cities_title',
        titleAr: 'مدن شهيرة',
        description: 'culture_cities_desc',
        iconName: 'location_city',
        imageUrl: 'https://images.unsplash.com/photo-1548013146-72479768bada?q=80&w=400',
      ),
      const CultureZone(
        id: 'food',
        title: 'culture_food_title',
        titleAr: 'الأطعمة الشهيرة',
        description: 'culture_food_desc',
        iconName: 'restaurant',
        imageUrl: 'https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=400',
      ),
      const CultureZone(
        id: 'clothing',
        title: 'culture_clothing_title',
        titleAr: 'الملابس التقليدية',
        description: 'culture_clothing_desc',
        iconName: 'checkroom',
        imageUrl: 'https://images.unsplash.com/photo-1583089892943-e02e5b017b6a?q=80&w=400',
      ),
      const CultureZone(
        id: 'traditions',
        title: 'culture_traditions_title',
        titleAr: 'التقاليد والعادات',
        description: 'culture_traditions_desc',
        iconName: 'people_outline',
        imageUrl: 'assets/images/traditions/arabic_hospitality_coffee.jpg',
      ),
      const CultureZone(
        id: 'history',
        title: 'culture_history_title',
        titleAr: 'التاريخ العربي',
        description: 'culture_history_desc',
        iconName: 'history_edu',
        imageUrl: 'https://images.unsplash.com/photo-1578326457399-3b34dbfaf239?q=80&w=400',
      ),
    ];
  }

  /// Get all pages for a specific zone
  static List<CulturePage> getPagesByZone(String zoneId) {
    final allPages = [
      // === Traditions Pages ===
      const CulturePage(
        id: 't1',
        zoneId: 'traditions',
        title: 'Arabic Hospitality',
        contentLocalized: {
          'en': 'Hospitality is a core value. Guests are often welcomed with Arabic coffee and dates.',
          'ar': 'الكرم قيمة أساسية. غالباً ما يُرحب بالضيوف بالقهوة العربية والتمر.',
        },
        imageUrl: 'https://images.unsplash.com/photo-1519750783826-e2420f4d687f?q=80&w=600',
        audioUrl: 'tradition_hospitality_audio',
      ),
      const CulturePage(
        id: 't2',
        zoneId: 'traditions',
        title: 'Ramadan Daily Life',
        contentLocalized: {
          'en': 'During Ramadan, Muslims fast from dawn to sunset, focusing on prayer and charity.',
          'ar': 'خلال شهر رمضان، يصوم المسلمون من الفجر حتى غروب الشمس، مع التركيز على الصلاة والصدقة.',
        },
        imageUrl: 'https://images.unsplash.com/photo-1542332213-31f87348057f?q=80&w=600',
        audioUrl: 'tradition_ramadan_audio',
      ),

      // === Holidays Pages ===
      const CulturePage(
        id: 'h1',
        zoneId: 'holidays',
        title: 'Eid Al-Fitr',
        contentLocalized: {
          'en': 'Eid Al-Fitr marks the end of Ramadan. People celebrate with family feasts and new clothes.',
          'ar': 'عيد الفطر يمثل نهاية شهر رمضان. يحتفل الناس بولائم عائلية وملابس جديدة.',
        },
        imageUrl: 'https://images.unsplash.com/photo-1542661942-80976150240d?q=80&w=600',
        audioUrl: 'holiday_fitr_audio',
      ),
      const CulturePage(
        id: 'h2',
        zoneId: 'holidays',
        title: 'Eid Al-Adha',
        contentLocalized: {
          'en': 'Eid Al-Adha honors the willingness of Ibrahim to sacrifice his son. It involves the Hajj pilgrimage.',
          'ar': 'عيد الأضحى يكرم استعداد إبراهيم للتضحية بابنه. وهو يتزامن مع فريضة الحج.',
        },
        imageUrl: 'https://images.unsplash.com/photo-1563245372-f2172081498b?q=80&w=600',
        audioUrl: 'holiday_adha_audio',
      ),

      // === Food Pages ===
      const CulturePage(
        id: 'f1',
        zoneId: 'food',
        title: 'Kabsa (Saudi Arabia)',
        contentLocalized: {
          'en': 'Kabsa is a mixed rice dish made with meat, vegetables, and a distinct blend of spices.',
          'ar': 'الكبسة هي طبق أرز مختلط يُصنع من اللحم والخضروات ومزيج مميز من البهارات.',
        },
        imageUrl: 'https://images.unsplash.com/photo-1541544741938-0af808871cc0?q=80&w=600',
        audioUrl: 'food_kabsa_audio',
      ),
      const CulturePage(
        id: 'f2',
        zoneId: 'food',
        title: 'Koshary (Egypt)',
        contentLocalized: {
          'en': 'Koshary is Egypt\'s national dish, combining pasta, rice, lentils, and a spicy tomato sauce.',
          'ar': 'الكشري هو الطبق الوطني لمصر، يجمع بين المكرونة والأرز والعدس وصلصة الطماطم الحارة.',
        },
        imageUrl: 'https://images.unsplash.com/photo-1590593162211-f982137d04fd?q=80&w=600',
        audioUrl: 'food_koshary_audio',
      ),

      // === Clothing Pages ===
      const CulturePage(
        id: 'c1',
        zoneId: 'clothing',
        title: 'The Thobe / Galabeya',
        contentLocalized: {
          'en': 'The Thobe is a long robe worn by men. It is often white and helps stay cool in the heat.',
          'ar': 'الثوب هو رداء طويل يرتديه الرجال. غالباً ما يكون أبيض اللون ويساعد على البقاء بارداً في الحر.',
        },
        imageUrl: 'https://images.unsplash.com/photo-1583089892943-e02e5b017b6a?q=80&w=600',
        audioUrl: 'clothing_thobe_audio',
      ),
      const CulturePage(
        id: 'c2',
        zoneId: 'clothing',
        title: 'The Keffiyeh',
        contentLocalized: {
          'en': 'The Keffiyeh is a traditional headdress. Different patterns often represent different regions.',
          'ar': 'الكوفية هي غطاء رأس تقليدي. غالباً ما تمثل النقاط المختلفة مناطق مختلفة.',
        },
        imageUrl: 'https://images.unsplash.com/photo-1519750783826-e2420f4d687f?q=80&w=600',
        audioUrl: 'clothing_keffiyeh_audio',
      ),

      // === Traditions ===
      const CulturePage(
        id: 'tr1',
        zoneId: 'traditions',
        title: 'Arabic Hospitality',
        contentLocalized: {
          'en': 'Hospitality is a core value in Arab culture, deeply rooted in its history.',
          'ar': 'الكرم والضيافة من القيم الأساسية في الثقافة العربية، وهي متجذرة بعمق في تاريخها.',
        },
        imageUrl: 'assets/images/traditions/arabic_hospitality_coffee.jpg',
        audioUrl: 'tradition_hospitality_audio',
      ),
    ];

    return allPages.where((page) => page.zoneId == zoneId).toList();
  }
}
