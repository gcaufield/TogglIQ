// ServicesModule.mc
//
// Injection Module for services that are used
// Copyright Greg Caufield 2020

module Toggl {
module Injection {
  (:glance)
  class ServicesModule extends MonkeyInject.Module {
    function initialize() {
      Module.initialize();

      bind(:StorageService)
          .to(Toggl.Services.StorageService)
          .inSingletonScope();

      bind(:TogglTimer)
          .to(TogglTimer)
          .inSingletonScope();
    }
  }
}
}
