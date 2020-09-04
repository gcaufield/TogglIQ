using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class TogglViewBehaviourDelegate extends Ui.BehaviorDelegate {
  private var _manager;
  private var _timer;
  private var _uiFactory;

  //! Static Interface Dependency Retriever
  //!
  //! @returns Array of required interfaces
  function getDependencies() {
    return [:TogglManager, :TogglTimer, :UiFactory];
  }

  function initialize(deps) {
    BehaviorDelegate.initialize();

    _manager = deps[:TogglManager];
    _timer = deps[:TogglTimer];
    _uiFactory = deps[:UiFactory];
  }

  function onSelect() {
    // Show the Menu
    Ui.pushView(_uiFactory.get(:TogglMenu), _uiFactory.get(:TogglMenuDelegate), Ui.SLIDE_RIGHT);

    return true;
  }
}
