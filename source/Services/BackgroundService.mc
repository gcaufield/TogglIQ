using Toybox.System;
using Toybox.Application.Properties;
using Toybox.Application.Storage;

module Toggl {
  (:background)
  class BackgroundService extends System.ServiceDelegate {
    hidden var _apiService;

    function initialize(apiService) {
      _apiService = apiService;
    }

    function onTemporalEvent() {
      var apiKey = Properties.getValue("apiKey");

      if(apiKey == "" || apiKey == null) {
        // No Key Has been set... no real use for trying to set things
        System.println("No Key configured");
        Background.exit(null);
      } else {
        _apiService.setApiKey(apiKey);

        update();
      }
    }

    function onCurrentComplete(responseCode, data) {
      // Request completed. Store the data if the timer has changed...
      System.println("Recived " + data);

      // Todo Figure out how we want to pass this onto the application
      Background.exit(null);
    }

    function update() {
      _apiService.getCurrent( method(:onCurrentComplete) );
    }
  }
}
