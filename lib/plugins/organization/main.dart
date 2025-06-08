import 'package:better_auth_client/helpers/dio.dart';
import 'package:better_auth_client/models/response/status_response.dart';
import 'package:better_auth_client/models/response/success_response.dart';
import 'package:better_auth_client/plugins/organization/request/update_organization.dart';
import 'package:better_auth_client/plugins/organization/response/accept_invitation.dart';
import 'package:better_auth_client/plugins/organization/response/create_organization.dart';
import 'package:better_auth_client/plugins/base.dart';
import 'package:better_auth_client/plugins/organization/response/get_invitation.dart';
import 'package:better_auth_client/plugins/organization/response/invitation.dart';
import 'package:better_auth_client/plugins/organization/response/member_partial.dart';
import 'package:better_auth_client/plugins/organization/response/organization.dart';
import 'package:better_auth_client/plugins/organization/response/reject_invitation.dart';
import 'package:better_auth_client/plugins/organization/response/remove_member.dart';
import 'package:better_auth_client/plugins/organization/response/update_member_role.dart';
import 'package:better_auth_client/plugins/organization/response/update_organization.dart';

class OrganizationPlugin extends BasePlugin {
  OrganizationPlugin();

  /// Create an organization
  ///
  /// [name] The name of the organization
  /// [slug] The slug of the organization
  /// [logo] The logo of the organization
  /// [metadata] The metadata of the organization
  /// [keepCurrentActiveOrganization] Whether to keep the current active organization active after creating a new one
  Future<CreateOrganizationResponse> create({
    required String name,
    required String slug,
    String? logo,
    Map<String, dynamic>? metadata,
    bool? keepCurrentActiveOrganization,
  }) async {
    try {
      final response = await dio.post(
        "/organization/create",
        data: {
          "name": name,
          "slug": slug,
          "logo": logo,
          "metadata": metadata,
          "keepCurrentActiveOrganization": keepCurrentActiveOrganization,
        }..removeWhere((key, value) => value == null),
        options: await getOptions(isTokenRequired: true),
      );
      return CreateOrganizationResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Update an organization
  ///
  /// [name] The name of the organization
  /// [logo] The logo of the organization
  /// [metadata] The metadata of the organization
  /// [slug] The slug of the organization
  Future<UpdateOrganizationResponse> update({
    required UpdateOrganizationRequest request,
    required String organizationId,
  }) async {
    try {
      final response = await dio.post(
        "/organization/update",
        data: {
          "organizationId": organizationId,
          "data": request.toJson(),
        },
        options: await getOptions(isTokenRequired: true),
      );
      return UpdateOrganizationResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Delete an organization
  ///
  /// [organizationId] The ID of the organization to delete
  Future<void> delete({required String organizationId}) async {
    try {
      await dio.post(
        "/organization/delete",
        data: {"organizationId": organizationId},
        options: await getOptions(isTokenRequired: true),
      );
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Set an organization as active
  ///
  /// [organizationId] The ID of the organization to set as active
  /// [organizationSlug] The slug of the organization to set as active
  Future<void> setActive({String? organizationId, String? organizationSlug}) async {
    assert(
      organizationId != null || organizationSlug != null,
      "Either organizationId or organizationSlug must be provided",
    );
    try {
      await dio.post(
        "/organization/set-active",
        data: {
          "organizationId": organizationId,
          "organizationSlug": organizationSlug,
        }..removeWhere((key, value) => value == null),
        options: await getOptions(isTokenRequired: true),
      );
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Get full organization details
  ///
  /// [organizationId] The ID of the organization to get, optional.
  ///
  /// [organizationSlug] The slug of the organization to get, optional.
  ///
  /// Uses current active organization if no organizationId or organizationSlug is provided.
  Future<Organization> getFullOrganization({
    String? organizationId,
    String? organizationSlug,
  }) async {
    try {
      final response = await dio.get(
        "/organization/get-full-organization",
        data: {
          "organizationId": organizationId,
          "organizationSlug": organizationSlug,
        }..removeWhere((key, value) => value == null),
        options: await getOptions(isTokenRequired: true),
      );
      return Organization.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Get all organizations
  Future<List<Organization>> getAllOrganizations() async {
    try {
      final response = await dio.get(
        "/organization/list",
        options: await getOptions(isTokenRequired: true),
      );
      return response.data.map((e) => Organization.fromJson(e)).toList();
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Invite a member to an organization
  ///
  /// [email] The email of the member to invite
  /// [role] The role of the member to invite
  /// [organizationId] The ID of the organization to invite the member to, optional.
  /// [resend] Whether to resend the invitation, optional.
  /// [teamId] The ID of the team to invite the member to, optional.
  Future<Invitation> inviteMember({
    required String email,
    required String role,
    String? organizationId,
    bool? resend,
    String? teamId,
  }) async {
    try {
      final response = await dio.post(
        "/organization/invite-member",
        data: {
          "email": email,
          "role": role,
          "organizationId": organizationId,
          "resend": resend,
          "teamId": teamId,
        }..removeWhere((key, value) => value == null),
        options: await getOptions(isTokenRequired: true),
      );
      return Invitation.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Cancel an invitation
  ///
  /// [invitationId] The ID of the invitation to cancel
  Future<void> cancelInvitation({required String invitationId}) async {
    try {
      await dio.post(
        "/organization/cancel-invitation",
        data: {"invitationId": invitationId},
        options: await getOptions(isTokenRequired: true),
      );
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Accept an invitation
  ///
  /// [invitationId] The ID of the invitation to accept
  Future<AcceptInvitationResponse> acceptInvitation({required String invitationId}) async {
    try {
      final response = await dio.post(
        "/organization/accept-invitation",
        data: {"invitationId": invitationId},
        options: await getOptions(isTokenRequired: true),
      );
      return AcceptInvitationResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Get an invitation
  ///
  /// [invitationId] The ID of the invitation to get
  Future<GetInvitationResponse> getInvitation({required String invitationId}) async {
    try {
      final response = await dio.get(
        "/organization/get-invitation?invitationId=$invitationId",
        options: await getOptions(isTokenRequired: true),
      );
      return GetInvitationResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Reject an invitation
  ///
  /// [invitationId] The ID of the invitation to reject
  Future<RejectInvitationResponse> rejectInvitation({required String invitationId}) async {
    try {
      final response = await dio.post(
        "/organization/reject-invitation",
        data: {"invitationId": invitationId},
        options: await getOptions(isTokenRequired: true),
      );
      return RejectInvitationResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Check if a slug is available
  ///
  /// [slug] The slug to check
  Future<StatusResponse> checkSlug({required String slug}) async {
    try {
      final response = await dio.get(
        "/organization/check-slug",
        data: {"slug": slug},
      );
      return StatusResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Remove a member from an organization
  ///
  /// [memberIdOrEmail] The ID or email of the member to remove
  /// [organizationId] The ID of the organization to remove the member from, optional.
  Future<RemoveMemberResponse> removeMember({required String memberIdOrEmail, String? organizationId}) async {
    try {
      final response = await dio.post(
        "/organization/remove-member",
        data: {
          "memberId": memberIdOrEmail,
          "organizationId": organizationId,
        }..removeWhere((key, value) => value == null),
        options: await getOptions(isTokenRequired: true),
      );
      return RemoveMemberResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Update a member's role
  ///
  /// [role] The role to update the member to
  /// [memberId] The ID of the member to update
  /// [organizationId] The ID of the organization to update the member in, optional.
  Future<UpdateMemberRoleResponse> updateMemberRole({
    required String role,
    required String memberId,
    String? organizationId,
  }) async {
    try {
      final response = await dio.post(
        "/organization/update-member-role",
        data: {"role": role, "memberId": memberId, "organizationId": organizationId},
        options: await getOptions(isTokenRequired: true),
      );
      return UpdateMemberRoleResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Get the active member
  Future<MemberPartial> getActiveMember() async {
    try {
      final response = await dio.get(
        "/organization/get-active-member",
        options: await getOptions(isTokenRequired: true),
      );
      return MemberPartial.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Leave an organization
  ///
  /// [organizationId] The ID of the organization to leave
  Future<void> leaveOrganization({required String organizationId}) async {
    try {
      await dio.post(
        "/organization/leave-organization",
        data: {"organizationId": organizationId},
        options: await getOptions(isTokenRequired: true),
      );
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Get all invitations
  Future<List<Invitation>> getAllInvitations() async {
    try {
      final response = await dio.get(
        "/organization/list-invitations",
        options: await getOptions(isTokenRequired: true),
      );
      return response.data.map((e) => Invitation.fromJson(e)).toList();
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }

  /// Check if user has a permission
  ///
  /// [permissions] The permissions to check for
  Future<SuccessResponse> userHasPermission({
    required List<Map<String, dynamic>> permissions,
  }) async {
    try {
      final response = await dio.post(
        "/organization/has-permission",
        data: {"permissions": permissions},
        options: await getOptions(isTokenRequired: true),
      );
      return SuccessResponse.fromJson(response.data);
    } catch (e) {
      final message = getErrorMessage(e);
      if (message == null) rethrow;
      throw message;
    }
  }
}
