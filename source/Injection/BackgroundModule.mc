// BackgroundModule.mc
//
// Copyright 2020 Greg Caufield

using Toybox.System;
using MonkeyInject;

module Toggl {
module Injection {
  (:background)
  class BackgroundModule extends MonkeyInject.Module {
    function initialize() {
      Module.initialize();
      bind(:ServiceDelegate)
          .to(BackgroundService);
    }

  }
}
}
