// SettingsService.mc
//
// A service for accessing application settings
//
// Copyright Greg Caufield 2020

using Toybox.Application as App;
using Toybox.System as Sys;

module Toggl {
module Services {

/// Provides access to the settings for the application
(:background)
class SettingsService {
  private var listeners_;

  function initialize() {
    listeners_ = new List();
  }

  function registerForSettingsUpdated(listener) {
    listeners_.pushBack(listener.weak());
  }

  function getApiToken() {
    if(Toybox.Application has :Properties) {
      return App.Properties.getValue("apiKey");
    } else {
      // For backwards compatibility we will do this if on a device that doesn't
      // support Properties
      return App.getApp().getProperty("apiKey");
    }
  }

  function onSettingsUpdated() {
    var it = listeners_.getIterator();

    while(it != null) {
      var listener = it.get().get();
      if(listener != null) {
        listener.onSettingsUpdated();
      }
      it = it.next();
    }
  }
}

} // Services
} // Toggl