/// A worker's professional profile captured during onboarding.
///
/// This is intentionally simple for the onboarding step; later sections can
/// extend it with portfolio items, certifications and badges.
class WorkerProfile {
  const WorkerProfile({
    this.trade,
    this.bio,
    this.location,
    this.yearsExperience = 0,
    this.hourlyRate,
    this.skills = const <String>[],
  });

  final String? trade;
  final String? bio;
  final String? location;
  final int yearsExperience;
  final double? hourlyRate;
  final List<String> skills;

  bool get isComplete =>
      (trade?.isNotEmpty ?? false) &&
      (bio?.isNotEmpty ?? false) &&
      (location?.isNotEmpty ?? false) &&
      skills.isNotEmpty;

  WorkerProfile copyWith({
    String? trade,
    String? bio,
    String? location,
    int? yearsExperience,
    double? hourlyRate,
    List<String>? skills,
  }) {
    return WorkerProfile(
      trade: trade ?? this.trade,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      skills: skills ?? this.skills,
    );
  }
}
