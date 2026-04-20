/// Data lokasi lapangan, termasuk alamat dan koordinat.
class FieldLocationData {
  final String fieldName;
  final String shortLocation;
  final String fullAddress;
  final double? latitude;
  final double? longitude;

  const FieldLocationData({
    required this.fieldName,
    required this.shortLocation,
    required this.fullAddress,
    this.latitude,
    this.longitude,
  });

  String get mapsQuery => '$fieldName, $fullAddress';

  String get coordinateLabel {
    if (latitude == null || longitude == null) {
      return 'Koordinat tersedia di Maps';
    }

    return '${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}';
  }
}

/// Registry statis lokasi lapangan.
///
/// Dipakai untuk alamat lapangan, Google Maps, dan hitung jarak user.
class FieldLocationRegistry {
  static const Map<String, FieldLocationData> byName = {
    'Dekings Arena': FieldLocationData(
      fieldName: 'Dekings Arena',
      shortLocation: 'Lubang Buaya',
      fullAddress:
          'Jl. Manunggal XVII No.70 5, RT.5/RW.5, Lubang Buaya, Cipayung, Jakarta Timur 13810',
      latitude: -6.297126,
      longitude: 106.894443,
    ),
    'Pancoran Soccer Field': FieldLocationData(
      fieldName: 'Pancoran Soccer Field',
      shortLocation: 'Jakarta Selatan',
      fullAddress:
          'Jl. Gatot Subroto No.72, Pancoran, Jakarta Selatan 12780',
      latitude: -6.243497,
      longitude: 106.843191,
    ),
    'Lapangan Sepakbola C': FieldLocationData(
      fieldName: 'Lapangan Sepakbola C',
      shortLocation: 'Senayan',
      fullAddress:
          'Lapangan C, Gelora Bung Karno, Senayan, Jakarta Pusat 10270',
      latitude: -6.218906,
      longitude: 106.801962,
    ),
    'F7 MINISOCCER ARENA': FieldLocationData(
      fieldName: 'F7 MINISOCCER ARENA',
      shortLocation: 'Cilandak',
      fullAddress: 'Cilandak, Jakarta Selatan',
      latitude: -6.290245,
      longitude: 106.799389,
    ),
    'Social Padel House Menteng': FieldLocationData(
      fieldName: 'Social Padel House Menteng',
      shortLocation: 'Menteng',
      fullAddress:
          'Jl. K.H. Wahid Hasyim No.148-150, Menteng, Jakarta Pusat 10250',
      latitude: -6.187553,
      longitude: 106.824992,
    ),
    'BBC Bali': FieldLocationData(
      fieldName: 'BBC Bali',
      shortLocation: 'Denpasar, Bali',
      fullAddress: 'BBC Bali Mini Soccer, Kota Denpasar, Bali',
      latitude: -8.670458,
      longitude: 115.212629,
    ),
    'Alfa Rooftop Mini Soccer Tamini Square': FieldLocationData(
      fieldName: 'Alfa Rooftop Mini Soccer Tamini Square',
      shortLocation: 'TMII',
      fullAddress:
          'Tamini Square, Jakarta Timur',
      latitude: -6.291289,
      longitude: 106.882851,
    ),
    'Halim Futsal Badminton': FieldLocationData(
      fieldName: 'Halim Futsal Badminton',
      shortLocation: 'Halim',
      fullAddress:
          'Jl. Raya Pd. Gede No.3, Halim Perdana Kusumah, Makasar, Jakarta Timur 13610',
      latitude: -6.267916,
      longitude: 106.887996,
    ),
    'Talenta Court': FieldLocationData(
      fieldName: 'Talenta Court',
      shortLocation: 'Jakarta',
      fullAddress: 'Talenta Court, Jakarta',
      latitude: -6.224215,
      longitude: 106.836247,
    ),
    'Arena Dirgantara Mini Soccer': FieldLocationData(
      fieldName: 'Arena Dirgantara Mini Soccer',
      shortLocation: 'Jatinegara',
      fullAddress: 'Jl. D.I. Panjaitan, Jatinegara, Jakarta Timur',
      latitude: -6.243246,
      longitude: 106.870634,
    ),
  };

  static FieldLocationData fallbackFor({
    required String fieldName,
    required String shortLocation,
  }) {
    return FieldLocationData(
      fieldName: fieldName,
      shortLocation: shortLocation,
      fullAddress: shortLocation,
    );
  }

  static FieldLocationData resolve({
    required String fieldName,
    required String shortLocation,
  }) {
    return byName[fieldName] ??
        fallbackFor(fieldName: fieldName, shortLocation: shortLocation);
  }
}
