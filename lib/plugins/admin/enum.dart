enum SearchOperator {
  contains("contains"),
  startsWith("starts_with"),
  endsWith("ends_with");

  final String value;

  const SearchOperator(this.value);
}
