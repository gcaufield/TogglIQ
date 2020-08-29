// ForegroundModule.mc
//
// Copyright 2020 Greg Caufield

using Toybox.System;

module Toggl {
module Injection {

  (:background)
  class TogglCoreModule extends Module {
    function initialize() {
      Module.initialize();

      if( Toybox.System has :ServiceDelegate) {
        bind(:BackgroundScheduler,
            [],
            :buildBackgroundScheduler);
      }

      bind(:SettingsService,
          [],
          :buildSettingsService);

      bind(:StorageService,
          [],
          :buildStorageService);

      bind(:TogglApiService,
          [],
          :buildTogglApiService);
    }

    function buildBackgroundScheduler(deps) {
      return new Toggl.Services.BackgroundScheduler();
    }

    function buildSettingsService(deps) {
      return new Toggl.Services.SettingsService();
    }

    function buildStorageService(deps){
      return new Toggl.Services.StorageService();
    }

    function buildTogglApiService(deps) {
      return new Toggl.ApiService();
    }
  }
}
}
