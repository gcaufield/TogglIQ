// TogglCoreModule.mc
//
// Copyright 2020 Greg Caufield

using Toybox.System;
using Toggl;
using MonkeyInject;

module Toggl {
module Injection {

  (:background)
  class TogglCoreModule extends MonkeyInject.Module {
    function initialize() {
      Module.initialize();

      bind(:Communications)
        .to(Toggl.Communications)
        .inSingletonScope();

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
