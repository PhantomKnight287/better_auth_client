import 'package:better_auth_client/better_auth_client.dart';
import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/success_response.dart';
import 'package:better_auth_client/plugins/admin/enum.dart';
import 'package:better_auth_client/plugins/admin/response/ban_user_response.dart';
import 'package:better_auth_client/plugins/admin/response/create_user.dart';
import 'package:better_auth_client/plugins/admin/response/impersonate_user.dart';
import 'package:better_auth_client/plugins/admin/response/list_user_sessions.dart';
import 'package:better_auth_client/plugins/admin/response/list_users.dart';
import 'package:better_auth_client/plugins/admin/response/set_role.dart';
import 'package:better_auth_client/plugins/base.dart';

class AdminPlugin<T extends User> extends BasePlugin<T> {
  AdminPlugin();

  /// Set the role of a user
  ///
  /// [userId] The ID of the user to set the role for
  /// [role] The role to set for the user
  Future<SetRoleResponse<T>> setRole({
    required String userId,
    required String role,
  }) async {
    try {
      final response = await super.dio.post(
        "/admin/set-role",
        data: {
          "userId": userId,
          "role": role,
        },
        options: await super.getOptions(isTokenRequired: true),
      );
      return SetRoleResponse<T>.fromJson(response.data, super.fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Create a new user
  ///
  /// [email] The email of the user
  /// [password] The password of the user
  /// [name] The name of the user
  /// [role] The role of the user
  /// [data] Any additional data to be stored in the user
  Future<CreateUserResponse<T>> createUser({
    required String email,
    required String password,
    required String name,
    String? role,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await super.dio.post(
        "/admin/create-user",
        data: {
          "email": email,
          "password": password,
          "name": name,
          "role": role,
          "data": data,
        }..removeWhere((key, value) => value == null),
        options: await super.getOptions(isTokenRequired: true),
      );
      return CreateUserResponse<T>.fromJson(response.data, super.fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// List all users
  ///
  /// [searchValue] The value to search for
  /// [searchField] The field to search in
  /// [searchOperator] The operator to use for the search
  /// [limit] The number of users to return
  /// [offset] The offset to start from
  /// [sortBy] The field to sort by
  /// [sortDirection] The direction to sort in
  /// [filterField] The field to filter by
  /// [filterOperator] The operator to use for the filter
  /// [filterValue] The value to filter by
  Future<ListUsersResponse<T>> listUsers({
    String? searchValue,
    String? searchField,
    SearchOperator? searchOperator,
    int? limit,
    int? offset,
    String? sortBy,
    String? sortDirection,
    String? filterField,
    String? filterOperator,
    String? filterValue,
  }) async {
    try {
      final response = await super.dio.get(
        "/admin/list-users",
        data: {
          "searchValue": searchValue,
          "searchField": searchField,
          "searchOperator": searchOperator?.value,
          "limit": limit,
          "offset": offset,
          "sortBy": sortBy,
          "sortDirection": sortDirection,
          "filterField": filterField,
          "filterOperator": filterOperator,
          "filterValue": filterValue,
        }..removeWhere((key, value) => value == null),
        options: await super.getOptions(isTokenRequired: true),
      );
      return ListUsersResponse<T>.fromJson(response.data, super.fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// List all sessions for a user
  ///
  /// [userId] The ID of the user to list sessions for
  Future<ListUserSessionsResponse> listUserSessions({
    required String userId,
  }) async {
    try {
      final response = await super.dio.post(
        "/admin/list-user-sessions",
        data: {
          "userId": userId,
        },
        options: await super.getOptions(isTokenRequired: true),
      );
      return ListUserSessionsResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Ban a user
  ///
  /// [userId] The ID of the user to ban
  /// [banReason] The reason for banning the user
  /// [banExpiresIn] The number of seconds to ban the user for
  Future<BanUserResponse<T>> banUser({
    required String userId,
    String? banReason,
    int? banExpiresIn,
  }) async {
    try {
      final response = await super.dio.post(
        "/admin/ban-user",
        data: {
          "userId": userId,
          "banReason": banReason,
          "banExpiresIn": banExpiresIn,
        }..removeWhere((key, value) => value == null),
        options: await super.getOptions(isTokenRequired: true),
      );
      return BanUserResponse<T>.fromJson(response.data, super.fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Unban a user
  ///
  /// [userId] The ID of the user to unban
  Future<UnbanUserResponse<T>> unbanUser({
    required String userId,
  }) async {
    try {
      final response = await super.dio.post(
        "/admin/unban-user",
        data: {"userId": userId},
        options: await super.getOptions(isTokenRequired: true),
      );
      return UnbanUserResponse<T>.fromJson(response.data, super.fromJsonUser);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Impersonate a user
  ///
  /// [userId] The ID of the user to impersonate
  Future<ImpersonateUserResponse<T>> impersonateUser({
    required String userId,
  }) async {
    try {
      final response = await super.dio.post(
        "/admin/impersonate-user",
        data: {
          "userId": userId,
        },
        options: await super.getOptions(isTokenRequired: true),
      );
      final impersonateUserResponse = ImpersonateUserResponse<T>.fromJson(response.data, super.fromJsonUser);
      final adminToken = await super.tokenStore.getToken(); // Get the existing "admin" user token
      assert(adminToken.isNotEmpty, "Admin token is empty");
      await super.tokenStore.saveAdminToken(adminToken); // Save the "admin" user token
      await super.tokenStore.saveToken(
        impersonateUserResponse.session.token,
      ); // Replace the "admin" user token with the impersonated user token
      return impersonateUserResponse;
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Stop impersonating a user
  Future<void> stopImpersonating() async {
    try {
      await super.dio.post(
        "/admin/stop-impersonating",
        options: await super.getOptions(isTokenRequired: true),
      );
      final adminToken = await super.tokenStore.getAdminToken(); // Get the saved "admin" user token
      assert(adminToken.isNotEmpty, "Admin token is empty");
      await super.tokenStore.saveToken(adminToken); // Replace the "admin" user token with the saved "admin" user token
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Revoke a user session
  ///
  /// [sessionToken] The token of the session to revoke
  Future<SuccessResponse> revokeUserSession({
    required String sessionToken,
  }) async {
    try {
      final response = await super.dio.post(
        "/admin/revoke-user-session",
        data: {"sessionToken": sessionToken},
        options: await super.getOptions(isTokenRequired: true),
      );
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Remove all sessions for a user
  ///
  /// [userId] The ID of the user to remove sessions for
  Future<SuccessResponse> removeUserSessions({
    required String userId,
  }) async {
    try {
      final response = await super.dio.post(
        "/admin/remove-user-sessions",
        data: {"userId": userId},
        options: await super.getOptions(isTokenRequired: true),
      );
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Delete a user and all their sessions and accounts. Cannot be undone.
  ///
  /// [userId] The ID of the user to delete
  Future<SuccessResponse> removeUser({required String userId}) async {
    try {
      final response = await super.dio.post(
        "/admin/remove-user",
        data: {"userId": userId},
        options: await super.getOptions(isTokenRequired: true),
      );
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Set the password of a user
  ///
  /// [userId] The ID of the user to set the password for
  /// [newPassword] The new password to set for the user
  Future<SuccessResponse> setUserPassword({
    required String userId,
    required String newPassword,
  }) async {
    try {
      final response = await super.dio.post(
        "/admin/set-user-password",
        data: {"userId": userId, "newPassword": newPassword},
        options: await super.getOptions(isTokenRequired: true),
      );
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Check if a user has a permission
  ///
  /// [permissions] The permissions to check for
  Future<SuccessResponse> hasPermission({required List<Map<String, dynamic>> permissions}) async {
    try {
      final response = await super.dio.post(
        "/admin/has-permission",
        data: {"permissions": permissions},
        options: await super.getOptions(isTokenRequired: true),
      );
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Check if a user has a permission
  ///
  /// [userId] The ID of the user to check the permission for
  /// [role] The role to check the permission for
  /// [permissions] The permissions to check for
  Future<SuccessResponse> userHasPermission({
    String? userId,
    String? role,
    required List<Map<String, dynamic>> permissions,
  }) async {
    assert(userId != null || role != null, "Either userId or role must be provided");
    try {
      final response = await super.dio.post(
        "/admin/user-has-permission",
        data: {
          "userId": userId,
          "role": role,
          "permissions": permissions,
        }..removeWhere((key, value) => value == null),
        options: await super.getOptions(isTokenRequired: true),
      );
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
