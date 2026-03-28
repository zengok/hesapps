enum BmiCategory {
  underweight,
  normal,
  overweight,
  obese
}

enum Gender { male, female }
enum ActivityLevel { sedentary, light, moderate, active, extraActive }

class CalculateBmiResult {
  final double bmi;
  final BmiCategory category;
  final String categoryText;
  final double bmr;
  final double dailyCalories;

  CalculateBmiResult({
    required this.bmi, 
    required this.category, 
    required this.categoryText,
    required this.bmr,
    required this.dailyCalories,
  });
}

class CalculateBmiUseCase {
  CalculateBmiResult execute({
    required double heightCm, 
    required double weightKg, 
    required int age, 
    required Gender gender,
    required ActivityLevel activityLevel
  }) {
    double height = heightCm;
    if (height > 3) {
      height = height / 100;
    }
    double bmi = weightKg / (height * height);
    BmiCategory category;
    String categoryText;

    if (bmi < 18.5) {
      category = BmiCategory.underweight;
      categoryText = "Zayıf";
    } else if (bmi < 25) {
      category = BmiCategory.normal;
      categoryText = "Normal";
    } else if (bmi < 30) {
      category = BmiCategory.overweight;
      categoryText = "Fazla Kilolu";
    } else {
      category = BmiCategory.obese;
      categoryText = "Obez";
    }

    // BMR Calculation (Mifflin-St Jeor)
    double bmr;
    if (gender == Gender.male) {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }

    double multiplier;
    switch (activityLevel) {
      case ActivityLevel.sedentary: multiplier = 1.2; break;
      case ActivityLevel.light: multiplier = 1.375; break;
      case ActivityLevel.moderate: multiplier = 1.55; break;
      case ActivityLevel.active: multiplier = 1.725; break;
      case ActivityLevel.extraActive: multiplier = 1.9; break;
    }

    double dailyCalories = bmr * multiplier;

    return CalculateBmiResult(
      bmi: bmi, 
      category: category, 
      categoryText: categoryText,
      bmr: bmr,
      dailyCalories: dailyCalories
    );
  }
}
