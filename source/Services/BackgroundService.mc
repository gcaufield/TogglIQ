using Toybox.System;
using Toybox.Application.Properties;
using Toybox.Application.Storage;

module Toggl {
  (:background)
  class BackgroundService extends System.ServiceDelegate {
    private var _apiService;
    private var _settingsService;

    function getDependencies() {
      return [:TogglApiService, :SettingsService];
    }

    function initialize(deps) {
      ServiceDelegate.initialize();
      _apiService = deps[:TogglApiService];
      _settingsService = deps[:SettingsService];
    }

    function onTemporalEvent() {
      var apiKey = _settingsService.getApiToken();

      if(apiKey == "" || apiKey == null) {
        // No Key Has been set... no real use for trying to set things
        System.println("No Key configured");
        Background.exit(null);
      } else {
        _apiService.setApiKey(apiKey);

        _apiService.getCurrent( method(:onCurrentComplete) );
      }
    }

    function onCurrentComplete(responseCode, data) {
      // Request completed. Store the data if the timer has changed...
      System.println("Received " + data);
      if(responseCode == 200) {
        Background.exit(data["data"]);
      }
      else {
        // Exit without passing, any data.
        System.exit();
      }
    }
  }
}
