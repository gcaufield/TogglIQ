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
(:glance)
class StorageService {
  function initialize() {
  }

  function setTimer(timer) {
    if(Toybox.Application has :Storage) {
      App.Storage.setValue("timer", timer);
    } else {
      // For backwards compatibility we will do this if on a device that doesn't
      // support Storage
      App.getApp().setProperty("timer", timer);
    }
  }

  function getTimer() {
    if(Toybox.Application has :Storage) {
      return App.Storage.getValue("timer");
    } else {
      // For backwards compatibility we will do this if on a device that doesn't
      // support Properties
      return App.getApp().getProperty("timer");
    }
  }

  function setProject(project) {
    if(Toybox.Application has :Storage) {
      App.Storage.setValue("project", project);
    } else {
      // For backwards compatibility we will do this if on a device that doesn't
      // support Storage
      App.getApp().setProperty("project", project);
    }
  }

  function getProject() {
    if(Toybox.Application has :Storage) {
      return App.Storage.getValue("project");
    } else {
      // For backwards compatibility we will do this if on a device that doesn't
      // support Properties
      return App.getApp().getProperty("project");
    }
  }
}

} // Services
} // Toggl
