// TogglCoreModule.mc
//
// Copyright 2020 Greg Caufield

using Toybox.System;
using Toggl;


module Toggl {
module Injection {

  (:background)
  class TogglCoreModule extends Module {
    function initialize() {
      Module.initialize();

      if( Toybox.System has :ServiceDelegate) {
        bind(:BackgroundScheduler)
          .to(Toggl.Services.BackgroundScheduler)
          .inSingletonScope();
      }

      bind(:SettingsService)
          .to(Toggl.Services.SettingsService)
          .inSingletonScope();

      bind(:StorageService)
          .to(Toggl.Services.StorageService)
          .inSingletonScope();

      bind(:TogglApiService)
          .to(Toggl.ApiService)
          .inSingletonScope();
    }

  }
}
}
