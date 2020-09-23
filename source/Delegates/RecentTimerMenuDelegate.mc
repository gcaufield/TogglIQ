//!
//!
//!

using Toybox.WatchUi;

module Toggl {
module Delegates {
  class RecentTimerMenuDelegate extends WatchUi.Menu2InputDelegate{
    private var _togglManager;

    public function getDependencies() {
      return [:TogglManager];
    }

    public function initialize(deps) {
      Menu2InputDelegate.initialize();

      _togglManager = deps[:TogglManager];
    }

    public function onSelect(item) {
      _togglManager.startTimer({
          "description" => item.getId().getDescription(),
          "pid" => item.getId().getProjectId()
          });

      WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
      return true;
    }
  }
}
}
