//!
//!
//!

using Toybox.WatchUi;
using Toybox.System;

module Toggl {
module Views {
  class RecentTimerMenu extends WatchUi.Menu2 {

    private var _items;
    private var _iterator;

    private var _projectManager;

    public function getDependencies() {
      return [:RecentTimerManager, :ProjectManager];
    }

    public function initialize(deps) {
      Menu2.initialize({:title => WatchUi.loadResource(Rez.Strings.StartRecentTimer)});

      _projectManager = deps[:ProjectManager];

      _items = deps[:RecentTimerManager].getRecentTimers();
      _iterator = _items.getIterator();

      populateNextItem();
    }

    function onNameRetrieved(id, projectName) {
      populateNextItem();
      WatchUi.requestUpdate();
    }

    private function populateNextItem() {
      // For each item in items, add a menu item for it.
      for(; _iterator != null; _iterator = _iterator.next()) {
        var projectName = "";
        if(_iterator.get().getProjectId() != null) {
          projectName = _projectManager.getProjectName(_iterator.get().getProjectId(),
                                                       method(:onNameRetrieved));
          if(projectName == null) {
            // Manager needs to do a lookup on this name;
            return;
          }
        }

        addItem(new WatchUi.MenuItem(
              _iterator.get().getShortDescription(),
              projectName,
              _iterator.get(),
              null
              ));
      }
    }
  }
}
}
