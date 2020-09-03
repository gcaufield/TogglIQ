using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class TogglViewBehaviourDelegate extends Ui.BehaviorDelegate {
  hidden var _manager;
  hidden var _timer;

  //! Static Interface Dependency Retriever
  //!
  //! @returns Array of required interfaces
  function getDependencies() {
    return [:TogglManager, :TogglTimer];
  }

  function initialize(deps) {
    BehaviorDelegate.initialize();

    _manager = deps[:TogglManager];
    _timer = deps[:TogglTimer];
  }

  function onSelect() {
    // Show the Menu
    Ui.pushView(new TogglMenu(_timer), new TogglMenuInputDelegate(_manager, _timer), Ui.SLIDE_RIGHT);

    return true;
  }
}
