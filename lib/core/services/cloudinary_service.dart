import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service to upload images to Cloudinary using the [cloudinary_public] package.
///
/// Setup:
///   1. Go to https://cloudinary.com → Dashboard → copy your **Cloud Name**
///   2. Go to Settings → Upload → Upload Presets → Add Preset
///      Set Signing Mode = **Unsigned**, save → copy the preset name
///   3. Replace the constants below with your values.
class CloudinaryService {
  // ──────────────────────────────────────────────
  // 🔑 Replace these with your Cloudinary details
  static const String _cloudName = 'djr9wbmet';
  static const String _uploadPreset = 'virsual gallery';
  // ──────────────────────────────────────────────

  late final CloudinaryPublic _cloudinary;

  CloudinaryService() {
    _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);
  }

  /// Downloads the image at [imageUrl] and uploads it to Cloudinary.
  ///
  /// Returns the permanent Cloudinary [secure_url], or the
  /// original [imageUrl] as a fallback if the upload fails.
  Future<String> uploadFromUrl(String imageUrl) async {
    if (imageUrl.isEmpty) return imageUrl;

    // Already a Cloudinary URL – skip re-upload
    if (imageUrl.contains('res.cloudinary.com')) return imageUrl;

    try {
      // 1️⃣  Download image bytes from the temporary URL
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        debugPrint(
          '☁️  Failed to download image for Cloudinary: ${response.statusCode}',
        );
        return imageUrl;
      }

      // 2️⃣  Upload bytes to Cloudinary
      final cloudinaryResponse = await _cloudinary.uploadFile(
        CloudinaryFile.fromByteData(
          response.bodyBytes.buffer.asByteData(),
          identifier: 'gallery_ai_${DateTime.now().millisecondsSinceEpoch}',
          resourceType: CloudinaryResourceType.Image,
          folder: 'gallery_ai',
        ),
      );

      debugPrint('☁️  Cloudinary upload OK → ${cloudinaryResponse.secureUrl}');
      return cloudinaryResponse.secureUrl;
    } on CloudinaryException catch (e) {
      debugPrint('☁️  Cloudinary upload failed: ${e.message}');
    } catch (e) {
      debugPrint('☁️  Cloudinary upload error: $e');
    }

    // Fallback: return original URL so the app doesn't break
    return imageUrl;
  }
}
