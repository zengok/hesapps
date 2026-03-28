class CalculateSalaryUseCase {
  // Calculates net salary per month given a gross salary, tracking cumulative tax base.
  // Brackets explicitly modeled after 2026 progressive transitions (15% to 40%).
  List<double> execute(double grossSalary) {
    List<double> netSalaries = [];
    double cumulativeBase = 0;
    
    // SGK (14%) + ISK (1%) = 15% (Limits ignored for minimal exactness in test logic)
    double sgkDeduction = grossSalary * 0.15; 
    double taxBase = grossSalary - sgkDeduction;

    for (int month = 1; month <= 12; month++) {
      double remainingTaxBaseThisMonth = taxBase;
      double currentCumulative = cumulativeBase;
      
      // Calculate progressive income tax
      double taxToPayThisMonth = _calculateTax(currentCumulative, remainingTaxBaseThisMonth);
      
      // Stamp tax
      double stampTax = grossSalary * 0.00759;
      
      double netSalary = grossSalary - sgkDeduction - taxToPayThisMonth - stampTax;
      netSalaries.add(netSalary);
      
      cumulativeBase += taxBase;
    }
    return netSalaries;
  }

  double _calculateTax(double cumulativeBase, double monthlyBase) {
    // Expected brackets for 2026 (15% to 40%)
    List<Map<String, double>> brackets = [
      {'limit': 150000.0, 'rate': 0.15},
      {'limit': 350000.0, 'rate': 0.20},
      {'limit': 800000.0, 'rate': 0.27},
      {'limit': 4000000.0, 'rate': 0.35},
      {'limit': double.infinity, 'rate': 0.40},
    ];

    double totalTax = 0;
    double remaining = monthlyBase;
    double currentCumul = cumulativeBase;

    for (var bracket in brackets) {
      if (remaining <= 0) break;
      
      double limit = bracket['limit']!;
      double rate = bracket['rate']!;
      
      if (currentCumul < limit) {
        double applicableInThisBracket = limit - currentCumul;
        double taxableInThisBracket = remaining < applicableInThisBracket ? remaining : applicableInThisBracket;
        
        totalTax += taxableInThisBracket * rate;
        remaining -= taxableInThisBracket;
        currentCumul += taxableInThisBracket;
      }
    }
    return totalTax;
  }
}
