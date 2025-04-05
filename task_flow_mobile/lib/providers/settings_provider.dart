import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  // Theme settings
  bool _isDarkMode = false;
  
  // Notification settings
  bool _enableNotifications = true;
  bool _enableSoundNotifications = true;
  bool _enableVibration = true;
  bool _enableLocationBasedReminders = false;
  
  // Privacy settings
  bool _useBiometricAuth = false;
  bool _enableDataSync = true;
  
  // Productivity settings
  bool _enableEnergyLevelTracking = true;
  bool _enableAutomaticBreaks = true;
  int _workSessionDuration = 25; // in minutes (Pomodoro-style)
  int _breakDuration = 5; // in minutes
  
  // Collaboration settings
  bool _showCollaboratorStatus = true;
  bool _autoAcceptTeamInvites = false;

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get enableNotifications => _enableNotifications;
  bool get enableSoundNotifications => _enableSoundNotifications;
  bool get enableVibration => _enableVibration;
  bool get enableLocationBasedReminders => _enableLocationBasedReminders;
  bool get useBiometricAuth => _useBiometricAuth;
  bool get enableDataSync => _enableDataSync;
  bool get enableEnergyLevelTracking => _enableEnergyLevelTracking;
  bool get enableAutomaticBreaks => _enableAutomaticBreaks;
  int get workSessionDuration => _workSessionDuration;
  int get breakDuration => _breakDuration;
  bool get showCollaboratorStatus => _showCollaboratorStatus;
  bool get autoAcceptTeamInvites => _autoAcceptTeamInvites;

  // Theme settings
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Notification settings
  void setEnableNotifications(bool value) {
    _enableNotifications = value;
    notifyListeners();
  }

  void setEnableSoundNotifications(bool value) {
    _enableSoundNotifications = value;
    notifyListeners();
  }

  void setEnableVibration(bool value) {
    _enableVibration = value;
    notifyListeners();
  }

  void setEnableLocationBasedReminders(bool value) {
    _enableLocationBasedReminders = value;
    notifyListeners();
  }

  // Privacy settings
  void setUseBiometricAuth(bool value) {
    _useBiometricAuth = value;
    notifyListeners();
  }

  void setEnableDataSync(bool value) {
    _enableDataSync = value;
    notifyListeners();
  }

  // Productivity settings
  void setEnableEnergyLevelTracking(bool value) {
    _enableEnergyLevelTracking = value;
    notifyListeners();
  }

  void setEnableAutomaticBreaks(bool value) {
    _enableAutomaticBreaks = value;
    notifyListeners();
  }

  void setWorkSessionDuration(int minutes) {
    if (minutes >= 1 && minutes <= 120) {
      _workSessionDuration = minutes;
      notifyListeners();
    }
  }

  void setBreakDuration(int minutes) {
    if (minutes >= 1 && minutes <= 60) {
      _breakDuration = minutes;
      notifyListeners();
    }
  }

  // Collaboration settings
  void setShowCollaboratorStatus(bool value) {
    _showCollaboratorStatus = value;
    notifyListeners();
  }

  void setAutoAcceptTeamInvites(bool value) {
    _autoAcceptTeamInvites = value;
    notifyListeners();
  }

  // Bulk settings update
  void updateSettings({
    bool? isDarkMode,
    bool? enableNotifications,
    bool? enableSoundNotifications,
    bool? enableVibration,
    bool? enableLocationBasedReminders,
    bool? useBiometricAuth,
    bool? enableDataSync,
    bool? enableEnergyLevelTracking,
    bool? enableAutomaticBreaks,
    int? workSessionDuration,
    int? breakDuration,
    bool? showCollaboratorStatus,
    bool? autoAcceptTeamInvites,
  }) {
    if (isDarkMode != null) _isDarkMode = isDarkMode;
    if (enableNotifications != null) _enableNotifications = enableNotifications;
    if (enableSoundNotifications != null) _enableSoundNotifications = enableSoundNotifications;
    if (enableVibration != null) _enableVibration = enableVibration;
    if (enableLocationBasedReminders != null) _enableLocationBasedReminders = enableLocationBasedReminders;
    if (useBiometricAuth != null) _useBiometricAuth = useBiometricAuth;
    if (enableDataSync != null) _enableDataSync = enableDataSync;
    if (enableEnergyLevelTracking != null) _enableEnergyLevelTracking = enableEnergyLevelTracking;
    if (enableAutomaticBreaks != null) _enableAutomaticBreaks = enableAutomaticBreaks;
    if (workSessionDuration != null && workSessionDuration >= 1 && workSessionDuration <= 120) {
      _workSessionDuration = workSessionDuration;
    }
    if (breakDuration != null && breakDuration >= 1 && breakDuration <= 60) {
      _breakDuration = breakDuration;
    }
    if (showCollaboratorStatus != null) _showCollaboratorStatus = showCollaboratorStatus;
    if (autoAcceptTeamInvites != null) _autoAcceptTeamInvites = autoAcceptTeamInvites;
    
    notifyListeners();
  }

  // Reset all settings to default
  void resetToDefaults() {
    _isDarkMode = false;
    _enableNotifications = true;
    _enableSoundNotifications = true;
    _enableVibration = true;
    _enableLocationBasedReminders = false;
    _useBiometricAuth = false;
    _enableDataSync = true;
    _enableEnergyLevelTracking = true;
    _enableAutomaticBreaks = true;
    _workSessionDuration = 25;
    _breakDuration = 5;
    _showCollaboratorStatus = true;
    _autoAcceptTeamInvites = false;
    
    notifyListeners();
  }
}