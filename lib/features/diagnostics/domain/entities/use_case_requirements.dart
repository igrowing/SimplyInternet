import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Stable identifier for an everyday activity the diagnosis reports on.
///
/// Kept separate from the display name so the decision logic can compare
/// identities while the wording is resolved per locale (see `useCaseName` in
/// the ARB files and `AppLocalizations`).
enum UseCaseId {
  musicStreaming,
  voiceCalls,
  webBrowsing,
  losslessMusic,
  videoCalls720,
  teamGames,
  videoCallsHd,
  hdVideo,
  fastGames,
  video4k,
}

/// What one everyday activity needs from the connection.
///
/// Throughput answers only "is this enough for X?" — it can never prove
/// degradation, because we do not know what line the user pays for. The
/// latency/jitter/loss limits are what make a verdict possible on any plan.
/// A null limit means the activity is insensitive to that metric.
@immutable
class UseCaseRequirement extends Equatable {
  const UseCaseRequirement({
    required this.id,
    required this.name,
    required this.downMbps,
    required this.upMbps,
    this.maxRttMs,
    this.maxJitterMs,
    this.maxLossPercent,
  });

  /// Stable identity, used by the decision logic and to resolve the localized
  /// display name.
  final UseCaseId id;

  /// English fallback name. User-facing text now comes from `AppLocalizations`
  /// via [id]; this is kept for tests and non-localized contexts.
  final String name;

  final double downMbps;
  final double upMbps;
  final double? maxRttMs;
  final double? maxJitterMs;
  final double? maxLossPercent;

  @override
  List<Object?> get props => [
    id,
    name,
    downMbps,
    upMbps,
    maxRttMs,
    maxJitterMs,
    maxLossPercent,
  ];
}

/// The activities the diagnosis reports on, ordered from least to most
/// demanding so "the worst affected" reads naturally.
///
/// Deliberate choices: browsing is judged at 2 Mbps because 5–10 Mbps describes
/// *comfortable* rather than *possible*; call packet loss is capped near 1%
/// because loss above that is already audible; and the audio-only row exists so
/// the app can advise switching the camera off when a video call cannot fit.
const List<UseCaseRequirement> kUseCaseRequirements = [
  UseCaseRequirement(
    id: UseCaseId.musicStreaming,
    name: 'music streaming',
    downMbps: 0.5,
    upMbps: 0.05,
    maxLossPercent: 2,
  ),
  UseCaseRequirement(
    id: UseCaseId.voiceCalls,
    name: 'voice calls',
    downMbps: 0.1,
    upMbps: 0.1,
    maxRttMs: 200,
    maxJitterMs: 30,
    maxLossPercent: 1,
  ),
  UseCaseRequirement(
    id: UseCaseId.webBrowsing,
    name: 'web browsing',
    downMbps: 2,
    upMbps: 0.5,
    maxRttMs: 250,
    maxJitterMs: 100,
    maxLossPercent: 2,
  ),
  UseCaseRequirement(
    id: UseCaseId.losslessMusic,
    name: 'lossless music',
    downMbps: 2,
    upMbps: 0.05,
    maxLossPercent: 2,
  ),
  UseCaseRequirement(
    id: UseCaseId.videoCalls720,
    name: 'video calls (720p)',
    downMbps: 2.6,
    upMbps: 1.8,
    maxRttMs: 150,
    maxJitterMs: 40,
    maxLossPercent: 1.5,
  ),
  UseCaseRequirement(
    id: UseCaseId.teamGames,
    name: 'team games',
    downMbps: 3,
    upMbps: 1,
    maxRttMs: 100,
    maxJitterMs: 20,
    maxLossPercent: 1,
  ),
  UseCaseRequirement(
    id: UseCaseId.videoCallsHd,
    name: 'video calls (HD)',
    downMbps: 4,
    upMbps: 3,
    maxRttMs: 100,
    maxJitterMs: 30,
    maxLossPercent: 1,
  ),
  UseCaseRequirement(
    id: UseCaseId.hdVideo,
    name: 'HD video (1080p)',
    downMbps: 6,
    upMbps: 0.1,
    maxRttMs: 500,
    maxJitterMs: 100,
    maxLossPercent: 1,
  ),
  UseCaseRequirement(
    id: UseCaseId.fastGames,
    name: 'fast online games',
    downMbps: 5,
    upMbps: 1,
    maxRttMs: 50,
    maxJitterMs: 10,
    maxLossPercent: 0.5,
  ),
  UseCaseRequirement(
    id: UseCaseId.video4k,
    name: '4K video',
    downMbps: 20,
    upMbps: 0.1,
    maxJitterMs: 100,
    maxLossPercent: 1,
  ),
];

/// The activity used for the "turn your camera off" fallback.
const UseCaseId kVoiceCallUseCase = UseCaseId.voiceCalls;

/// Activities that are video calls, so the camera-off advice knows when to
/// appear.
const List<UseCaseId> kVideoCallUseCases = [
  UseCaseId.videoCalls720,
  UseCaseId.videoCallsHd,
];
