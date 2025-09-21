import 'package:get/get.dart';
import 'package:joblens_cv/data/models/user_profile.dart';

class ProfileController extends GetxController {
  final Rx<UserProfile?> _profile = Rx<UserProfile?>(null);

  UserProfile? get profile => _profile.value;

  void setBasicProfile(UserProfile basicProfile) {
    _profile.value = basicProfile;
    update();
  }

  void addEducation(Education education) {
    if (_profile.value != null) {
      final updated = _profile.value!.copyWith(
        education: [..._profile.value!.education, education],
      );
      _profile.value = updated;
      update();
    }
  }

  void addWorkExperience(Experience experience) {
    if (_profile.value != null) {
      final updated = _profile.value!.copyWith(
        workExperience: [..._profile.value!.workExperience, experience],
      );
      _profile.value = updated;
      update();
    }
  }

  // Diğer ekleme metodları (skills, projects vs.) de benzer şekilde eklenebilir.
}