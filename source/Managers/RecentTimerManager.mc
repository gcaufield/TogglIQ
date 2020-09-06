//! RecentTimerManager.mc
//!
//! Copyright Greg Caufield 2020
using Toybox.WatchUi;
using Toybox.System;

module Toggl {
module Managers {

  //! Handles Managing the Ui State for restarting a recent timer
  class RecentTimerManager {

    private var _uiFactory;
    private var _apiService;

    private var _cancelled;

    public function getDependencies() {
      return [:UiFactory, :TogglApiService];
    }

    public function initialize(deps) {
      _uiFactory = deps[:UiFactory];
      _apiService = deps[:TogglApiService];
      _cancelled = false;
    }

    //! Start the process to show recent timers
    public function show() {
      // Push a progress view initially
      var delegate = _uiFactory.get(:ProgressDelegate);
      delegate.setCancellable(self);

      WatchUi.pushView(new WatchUi.ProgressBar("Updating...", null),
          delegate,
          WatchUi.SLIDE_IMMEDIATE);

      // Send request to Api to get recent timers
    }

    public function cancel() {
      System.println("Cancel");
      _cancelled = true;
    }
  }
}
}

