/// Shared string formatting helpers.
library;

/// Formats a list of member names for display, e.g.
/// "Alex Johnson, Maria Garcia and 3 more".
///
/// - Empty list → "No members"
/// - 1-2 names → joined with ", "
/// - 3+ names → first two names + "and N more"
String formatMemberNames(List<String> names) {
  if (names.isEmpty) return 'No members';
  if (names.length <= 2) return names.join(', ');
  return '${names.take(2).join(', ')} and ${names.length - 2} more';
}

/// Formats a date as e.g. "15 Jun 2025".
String formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}