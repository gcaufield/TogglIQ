using Toybox.Communications as Comms;
using Toybox.StringUtil;
using Toybox.System as Sys;
using Toybox.Timer as Timer;
using Toybox.Time as Time;

module Toggl {
  class TogglManager {
    private var _state;
    private var _updateTimer;
    private var _requestPending;
    private var _apiService;
    private var _settingsService;
    private var _storageService;

    private var _togglTimer;
    private var _notificationModel;

    //! Static Interface Dependency Retriever
    //!
    //! @returns Array of required interfaces
    function getDependencies() {
      return [:TogglApiService,
              :TogglTimer,
              :NotificationModel,
              :SettingsService,
              :StorageService];
    }

    function initialize(deps) {
      _apiService = deps[:TogglApiService];
      _togglTimer = deps[:TogglTimer];
      _notificationModel = deps[:NotificationModel];
      _settingsService = deps[:SettingsService];
      _storageService = deps[:StorageService];

      _settingsService.registerForSettingsUpdated(self);
      updateApiToken();
      restoreTimer();
      _updateTimer = new Timer.Timer();
      _requestPending = false;

      startUpdate();
    }

    function onRequestComplete(responseCode, data) {
      _requestPending = false;

      if( responseCode == 200 ) {
        _togglTimer.setTimer( null );
      }
      else {
        Sys.println( "Request Failed: " + responseCode );
        _notificationModel.setNotification(Toggl.TIMER_NTFCTN_REQUEST_FAILED);
      }

      update();
    }

    function onCurrentComplete(responseCode, data) {
      if( responseCode == 200 ) {
        _togglTimer.clearWarning(Toggl.TIMER_WARNING_INVALID_API_KEY);

        _storageService.setTimer(data["data"]);
        _togglTimer.setTimer(data["data"]);
      }
      else {
        _togglTimer.setWarning(Toggl.TIMER_WARNING_INVALID_API_KEY);
      }

      _updateTimer.start(method(:update), 2000, false);
    }

    function onSettingsUpdated() {
      updateApiToken();
    }

    function update() {
      _apiService.getCurrent( method(:onCurrentComplete) );
    }

    private function updateApiToken() {
      var apiKey = _settingsService.getApiToken();

      if(apiKey == "" || apiKey == null) {
        _togglTimer.setWarning(Toggl.TIMER_WARNING_NO_API_KEY);
        _apiService.setApiKey("");
      } else {
        _togglTimer.clearWarning(Toggl.TIMER_WARNING_NO_API_KEY);
        _apiService.setApiKey(apiKey);
      }
    }

    //! Starts a new Timer
    //!
    //! @param data (Dictionary) Data Related to the new timer
    function startTimer(data) {
      if( ( _togglTimer.getTimerState() == Toggl.TIMER_STATE_RUNNING ) ||
          _requestPending ) {
        return;
      }

      _updateTimer.stop();
      _requestPending = true;
      _apiService.startNewTimer( Time.now(), data, method(:onRequestComplete) );
    }

    //! Stops a running timer
    function stopTimer() {
      if( ( _togglTimer.getTimerState() != Toggl.TIMER_STATE_RUNNING ) ||
          _requestPending ) {
        return;
      }

      _updateTimer.stop();
      _requestPending = true;
      _apiService.stopTimer( _togglTimer.getTimer()["id"], method(:onRequestComplete) );
    }

    //! Stops the update timer
    function stopUpdate() {
      _updateTimer.stop();
    }

    //! Begins Updating the timer
    //! Adds a slight delay before updating, to allow for app to scroll
    function startUpdate() {
      // Request an update in 50 ms, to allow for quick scrolling without wasting data
      _updateTimer.start( method(:update), 50, false );
    }

    private function restoreTimer() {
      var timer = _storageService.getTimer();

      if(timer != null && timer != "") {
        _togglTimer.setTimer(timer);
      }
    }

  }
}
