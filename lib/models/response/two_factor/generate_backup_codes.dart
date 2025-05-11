import 'package:better_auth_client/models/response/status_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generate_backup_codes.g.dart';

@JsonSerializable()
class GenerateBackupCodes extends StatusResponse {
  final List<String> backupCodes;

  GenerateBackupCodes({required super.status, required this.backupCodes});

  factory GenerateBackupCodes.fromJson(Map<String, dynamic> json) => _$GenerateBackupCodesFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GenerateBackupCodesToJson(this);
}
