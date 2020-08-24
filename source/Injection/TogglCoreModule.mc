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

      bind(:TogglApiService,
          [],
          :buildTogglApiService);
    }

    function buildTogglApiService(deps) {
      return new Toggl.ApiService();
    }
  }
}
}
