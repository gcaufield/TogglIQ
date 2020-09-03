// ForegroundModule.mc
//
// Copyright 2020 Greg Caufield

using Toybox.System;

module Toggl {
module Injection {
  class ForegroundModule extends Module {
    function initialize() {
      Module.initialize();

      // Configure the modules used to drive interaction with Toggl and the UI
      bind(:TickManager)
           .to(TickManager)
           .inSingletonScope();

      bind(:TogglTimer)
          .to(TogglTimer)
          .inSingletonScope();

      bind(:TogglManager)
          .to(TogglManager)
          .inSingletonScope();

      // Bind the View interface based on the screen shape.
      var screenType = System.getDeviceSettings().screenShape;
      if( System.SCREEN_SHAPE_SEMI_ROUND == screenType ) {
        bind(:View)
            .to(TogglSemiRoundView);
      }
      else {
        bind(:View)
            .to(TogglRoundView);
       }

      // Bind the behaviour delegate for the view
      bind(:ViewBehaviourDelegate)
          .to(TogglViewBehaviourDelegate);
    }

  }
}
}
