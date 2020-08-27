// BackgroundModule.mc
//
// Copyright 2020 Greg Caufield

using Toybox.System;

module Toggl {
module Injection {
  (:background)
  class BackgroundModule extends Module {
    function initialize() {
      Module.initialize();
      bind(:ServiceDelegate,
          [:TogglApiService, :SettingsService],
          :buildTogglBackgroundService);
    }

    function buildTogglBackgroundService(deps) {
      return new BackgroundService(deps[:TogglApiService], deps[:SettingsService]);
    }
  }
}
}
