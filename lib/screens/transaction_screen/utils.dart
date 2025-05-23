import 'package:intl/intl.dart';
import 'package:spending_income/models/transaction.dart' as model;

/// Utility functions for the transaction screen

/// Updates date range based on selected time period
void updateDateRange(String? selectedTimePeriod, DateTime Function() getNow,
    void Function(DateTime? start, DateTime? end) setRange) {
  final now = getNow();
  
  DateTime? startDate;
  DateTime? endDate;
  
  switch (selectedTimePeriod) {
    case 'day':
      // Today: start is beginning of day, end is end of day
      startDate = DateTime(now.year, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      break;
    case 'week':
      // This week: start is beginning of week (Monday), end is end of week (Sunday)
      final weekday = now.weekday;
      startDate = DateTime(now.year, now.month, now.day - (weekday - 1));
      endDate = DateTime(now.year, now.month, now.day + (7 - weekday), 23, 59, 59);
      break;
    case 'month':
      // This month: start is 1st of month, end is last day of month
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      break;
    case 'year':
      // This year: start is Jan 1, end is Dec 31
      startDate = DateTime(now.year, 1, 1);
      endDate = DateTime(now.year, 12, 31, 23, 59, 59);
      break;
    default:
      // Default to showing last 6 months for the chart
      startDate = DateTime(now.year, now.month - 5, 1);
      endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  }
  
  setRange(startDate, endDate);
}

/// Groups transactions by month for chart display
Map<String, double> groupTransactionsByMonth(List<model.Transaction> transactions) {
  final Map<String, double> result = {};
  
  // Get the last 6 months
  final now = DateTime.now();
  for (int i = 0; i < 6; i++) {
    final month = now.month - i;
    final year = now.year - (month <= 0 ? 1 : 0);
    final adjustedMonth = month <= 0 ? month + 12 : month;
    
    final monthName = DateFormat('MMM').format(DateTime(year, adjustedMonth));
    result[monthName] = 0;
  }
  
  // Sum up expenses by month
  for (final transaction in transactions) {
    if (transaction.type == model.TransactionType.expense) {
      final monthName = DateFormat('MMM').format(transaction.date);
      result.update(monthName, (value) => value + transaction.amount, 
                   ifAbsent: () => transaction.amount);
    }
  }
  
  // Reverse to show chronological order (oldest to newest)
  return Map.fromEntries(result.entries.toList().reversed);
}

/// Maps time filter display names to internal period identifiers
String mapTimeFilterToPeriod(String timeFilter) {
  switch (timeFilter) {
    case 'Daily':
      return 'day';
    case 'Weekly':
      return 'week';
    case 'Monthly':
      return 'month';
    case 'Yearly':
      return 'year';
    default:
      return 'month'; // Default to month
  }
} 