//!
//!
//!

using Toybox.WatchUi;

module Toggl {
module Views {
  class RecentTimerMenu extends WatchUi.Menu2 {

    public function getDependencies() {
      return [:RecentTimerManager];
    }

    public function initialize(deps) {
      Menu2.initialize(null);

      var items = deps[:RecentTimerManager].getRecentTimers();

      // For each item in items, add a menu item for it.
      for(var it = items.getIterator(); it != null; it = it.next()) {
        addItem(new MenuItem(
              it.get().getShortDescription(),
              "",
              it.get(),
              null
              ));
      }
    }
  }
}
}
