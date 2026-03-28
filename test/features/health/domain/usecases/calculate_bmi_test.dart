import 'package:flutter_test/flutter_test.dart';
import 'package:hesapps/features/health/domain/usecases/calculate_bmi.dart';

void main() {
  group('CalculateBmiUseCase', () {
    late CalculateBmiUseCase useCase;

    setUp(() {
      useCase = CalculateBmiUseCase();
    });

    test('should calculate exact BMI and enhanced BMR with calories', () {
      final result = useCase.execute(
        heightCm: 180,
        weightKg: 80,
        age: 30,
        gender: Gender.male,
        activityLevel: ActivityLevel.active, // multiplier 1.725
      );

      // BMI check: 80 / (1.8*1.8) = 24.69
      expect(result.bmi, closeTo(24.69, 0.01));
      expect(result.category, BmiCategory.normal);
      
      // BMR check: 10*80(800) + 6.25*180(1125) - 5*30(150) + 5 = 1780
      expect(result.bmr, 1780.0);

      // Daily Cal check: 1780 * 1.725 = 3070.5
      expect(result.dailyCalories, 3070.5);
    });
  });
}
