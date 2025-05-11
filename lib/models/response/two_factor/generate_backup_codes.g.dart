// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_backup_codes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateBackupCodes _$GenerateBackupCodesFromJson(Map<String, dynamic> json) => GenerateBackupCodes(
  status: json['status'] as bool,
  backupCodes: (json['backupCodes'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$GenerateBackupCodesToJson(GenerateBackupCodes instance) => <String, dynamic>{
  'status': instance.status,
  'backupCodes': instance.backupCodes,
};
