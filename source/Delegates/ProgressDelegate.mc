using Toybox.WatchUi;
using Toybox.System;

module Toggl {
module Delegates {

  //! Handles processing events during a progress event.
  class ProgressDelegate extends WatchUi.BehaviorDelegate {

    private var _cancellable;

    public function initialize() {
      _cancellable = null;
    }

    public function setCancellable(cancellable) {
      _cancellable = cancellable.weak();
    }

    public function onBack() {
      System.println("On Back");
      var cancellable = _cancellable.get();

      if(cancellable != null) {
        cancellable.cancel();
      }

      return false;
    }
  }

}
}
