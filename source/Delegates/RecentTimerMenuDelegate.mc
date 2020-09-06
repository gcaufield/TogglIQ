//!
//!
//!

using Toybox.WatchUi;

module Toggl {
module Delegates {
  class RecentTimerMenuDelegate extends WatchUi.Menu2InputDelegate{
    private var _recentTimerManager;

    public function getDependencies() {
      return [:RecentTimerManager];
    }

    public function intialize(deps) {
      Menu2InputDelegate.initialize();

      _recentTimerManager = deps[:RecentTimerManager];
    }

    public function onSelect(item) {
      _recentTimerManager.startTimer(item.getId());
    }
  }
}
}
