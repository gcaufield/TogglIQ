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

      bind(:UiFactory)
          .toFactory();

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

      // Bind the Menu and its delegate
      bind(:TogglMenu)
          .to(TogglMenu);
      bind(:TogglMenuDelegate)
          .to(TogglMenuInputDelegate);

      // Bind the about view
      bind(:AboutView)
          .to(TogglAboutView);
      bind(:AboutViewDelegate)
          .to(TogglAboutViewBehaviourDelegate);

      bind(:StartCustomTimerDelegate)
          .to(StartCustomTimerTextPickerDelegate);
    }
  }
}
}
