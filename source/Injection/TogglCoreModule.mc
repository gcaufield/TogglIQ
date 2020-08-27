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

      bind(:SettingsService,
          [],
          :buildSettingsService);

      bind(:TogglApiService,
          [],
          :buildTogglApiService);
    }

    function buildSettingsService(deps) {
      return new Toggl.Services.SettingsService();
    }

    function buildTogglApiService(deps) {
      return new Toggl.ApiService();
    }
  }
}
}
