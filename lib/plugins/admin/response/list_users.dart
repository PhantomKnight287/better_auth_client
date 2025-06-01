class ListUsersResponse<T> {
  final int total;
  final int limit;
  final int offset;
  final List<T> users;

  ListUsersResponse({
    required this.total,
    required this.limit,
    required this.offset,
    required this.users,
  });

  factory ListUsersResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic> json) fromJsonT) {
    return ListUsersResponse(
      total: json["total"],
      limit: json["limit"],
      offset: json["offset"],
      users: json["users"].map((e) => fromJsonT(e)).toList(),
    );
  }

  @override
  String toString() {
    return "ListUsersResponse(total: $total, limit: $limit, offset: $offset, users: $users)";
  }
}
