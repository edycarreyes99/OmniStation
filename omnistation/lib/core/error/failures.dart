import '../l10n/generated/app_localizations.dart';

sealed class AppFailure {
  final String messageKey;
  final String? technicalDetails;

  const AppFailure(this.messageKey, [this.technicalDetails]);

  String get message => technicalDetails ?? messageKey;

  String toLocalizedMessage(AppLocalizations l10n) {
    if (this is UnknownFailure && technicalDetails != null && technicalDetails!.isNotEmpty) {
      return technicalDetails!;
    }
    switch (messageKey) {
      case 'errorDiscRead':
        return l10n.errorDiscRead;
      case 'errorUdfFs':
        return l10n.errorUdfFs;
      case 'errorIsoDecryption':
        return l10n.errorIsoDecryption;
      case 'errorParamSfo':
        return l10n.errorParamSfo;
      case 'errorSelfDecryption':
        return l10n.errorSelfDecryption;
      case 'errorPkgRapMissing':
        return l10n.errorPkgRapMissing;
      case 'errorFirmwareMissing':
        return l10n.errorFirmwareMissing;
      case 'errorMemoryCardCorrupt':
        return l10n.errorMemoryCardCorrupt;
      case 'errorPs3SaveDataSignature':
        return l10n.errorPs3SaveDataSignature;
      case 'errorSaveStateVersion':
        return l10n.errorSaveStateVersion;
      case 'errorAudioInit':
        return l10n.errorAudioInit;
      case 'errorGpuInit':
        return l10n.errorGpuInit;
      case 'errorJitAllocation':
        return l10n.errorJitAllocation;
      default:
        return l10n.errorUnknown;
    }
  }

  @override
  String toString() => 'AppFailure($messageKey, details: $technicalDetails)';
}

final class DiscReadFailure extends AppFailure {
  const DiscReadFailure([String? details]) : super('errorDiscRead', details);
}

final class UdfFsFailure extends AppFailure {
  const UdfFsFailure([String? details]) : super('errorUdfFs', details);
}

final class IsoDecryptionFailure extends AppFailure {
  const IsoDecryptionFailure([String? details]) : super('errorIsoDecryption', details);
}

final class ParamSfoFailure extends AppFailure {
  const ParamSfoFailure([String? details]) : super('errorParamSfo', details);
}

final class SelfDecryptionFailure extends AppFailure {
  const SelfDecryptionFailure([String? details]) : super('errorSelfDecryption', details);
}

final class PkgRapMissingFailure extends AppFailure {
  const PkgRapMissingFailure([String? details]) : super('errorPkgRapMissing', details);
}

final class FirmwareMissingFailure extends AppFailure {
  const FirmwareMissingFailure([String? details]) : super('errorFirmwareMissing', details);
}

final class MemoryCardCorruptFailure extends AppFailure {
  const MemoryCardCorruptFailure([String? details]) : super('errorMemoryCardCorrupt', details);
}

final class Ps3SaveDataSignatureFailure extends AppFailure {
  const Ps3SaveDataSignatureFailure([String? details]) : super('errorPs3SaveDataSignature', details);
}

final class SaveStateVersionFailure extends AppFailure {
  const SaveStateVersionFailure([String? details]) : super('errorSaveStateVersion', details);
}

final class AudioInitFailure extends AppFailure {
  const AudioInitFailure([String? details]) : super('errorAudioInit', details);
}

final class GpuInitFailure extends AppFailure {
  const GpuInitFailure([String? details]) : super('errorGpuInit', details);
}

final class JitAllocationFailure extends AppFailure {
  const JitAllocationFailure([String? details]) : super('errorJitAllocation', details);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([String? details]) : super('errorUnknown', details);
}
