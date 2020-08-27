using Toybox.System;
using Toybox.Application.Properties;
using Toybox.Application.Storage;

module Toggl {
  (:background)
  class BackgroundService extends System.ServiceDelegate {
    private var _apiService;
    private var _settingsService;

    function initialize(apiService, settingsService) {
      ServiceDelegate.initialize();
      _apiService = apiService;
      _settingsService = settingsService;
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
      System.println("Recived " + data);

      // Todo Figure out how we want to pass this onto the application
      Background.exit(null);
    }
  }
}
