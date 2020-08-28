// ForegroundModule.mc
//
// Copyright 2020 Greg Caufield

using Toybox.System;

module Toggl {
module Injection {
  class ForegroundModule extends Module {
    function initialize() {
      Module.initialize();

      bind(:StorageService,
          [],
          :buildStorageService);

      // Configure the modules used to drive interaction with Toggl and the UI
      bind(:TickManager,
           [],
           :buildTickManager);

      bind(:TogglTimer,
          [:TickManager],
          :buildTogglTimer);

      bind(:TogglManager,
          [:TogglTimer, :TogglApiService, :SettingsService, :StorageService],
          :buildTogglManager);

      // Bind the View interface based on the screen shape.
      var screenType = System.getDeviceSettings().screenShape;
      if( System.SCREEN_SHAPE_SEMI_ROUND == screenType ) {
        bind(:View,
            [:TogglTimer, :TickManager],
            :buildToggSemiRoundView);
      }
      else {
        bind(:View,
            [:TogglTimer, :TickManager],
            :buildTogglRoundView);
       }

      // Bind the behaviour delegate for the view
      bind(:ViewBehaviourDelegate,
          [:TogglTimer, :TogglManager],
          :buildTogglViewBehaviourDelegate);
    }

    function buildStorageService(deps){
      return new Toggl.Services.StorageService();
    }

    function buildTogglManager(deps) {
      return new TogglManager(deps[:TogglTimer],
                              deps[:TogglApiService],
                              deps[:SettingsService],
                              deps[:StorageService]);
    }

    function buildTickManager(deps) {
      return new TickManager();
    }

    function buildTogglTimer(deps) {
      return new TogglTimer(deps[:TickManager]);
    }

    function buildTogglViewBehaviourDelegate(deps) {
      return new TogglViewBehaviourDelegate(deps[:TogglTimer], deps[:TogglManager]);
    }

    function buildTogglRoundView(deps) {
      return new TogglRoundView(deps[:TogglTimer], deps[:TickManager]);
    }

    function buildToggSemiRoundView(deps) {
      return new TogglSemiRoundView(deps[:TogglTimer], deps[:TickManager]);
    }
  }
}
}
