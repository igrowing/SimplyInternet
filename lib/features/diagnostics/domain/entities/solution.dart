import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// The kinds of remediation the app can offer for a verdict.
///
/// Some actions are things the app can perform on the device (opening a
/// system settings panel, launching the captive-portal page); others are
/// purely advisory guidance shown to the user.
enum SolutionActionType {
  /// Offer to enable Wi-Fi (opens the Wi-Fi settings/panel on Android).
  enableWifi,

  /// Offer to leave flight mode (opens the airplane-mode settings panel).
  disableAirplane,

  /// Offer to enable mobile data (opens the data settings panel).
  enableMobileData,

  /// Open the captive-portal sign-in page in the browser.
  openCaptivePortal,

  /// Open the Private DNS settings so the user can switch resolver.
  changeDns,

  /// Re-run the whole diagnosis (after the user changed something).
  retry,

  /// No device action — purely informational guidance.
  advisory,
}

/// A single suggested remediation. When [confirmBeforeAct] is true the UI must
/// ask [confirmationPrompt] and only run the action once the user confirms.
@immutable
class SolutionAction extends Equatable {
  const SolutionAction({
    required this.type,
    required this.label,
    this.confirmBeforeAct = false,
    this.confirmationPrompt,
    this.payload,
  });

  final SolutionActionType type;

  /// Button label, e.g. "Turn on Wi-Fi".
  final String label;

  /// Whether the UI must confirm before performing the action.
  final bool confirmBeforeAct;

  /// The yes/no question shown before acting, e.g.
  /// "Wi-Fi is off. Should I turn it on?".
  final String? confirmationPrompt;

  /// Optional data the action needs (e.g. the captive-portal URL).
  final String? payload;

  @override
  List<Object?> get props => [
    type,
    label,
    confirmBeforeAct,
    confirmationPrompt,
    payload,
  ];
}

/// The remediation proposal attached to a non-healthy verdict: a plain-language
/// explanation of what to do plus zero or more concrete [actions].
@immutable
class Solution extends Equatable {
  const Solution({required this.message, this.actions = const []});

  /// What the user should do, in non-technical language.
  final String message;

  final List<SolutionAction> actions;

  @override
  List<Object?> get props => [message, actions];
}
