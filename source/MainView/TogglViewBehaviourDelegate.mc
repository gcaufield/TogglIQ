using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class TogglViewBehaviourDelegate extends Ui.BehaviorDelegate {
    hidden var _manager;
    hidden var _timer;

    function initialize(manager, timer) {
        BehaviorDelegate.initialize();

        _manager = manager;
        _timer = timer;
    }

    function onSelect() {
        // Show the Menu
        Ui.pushView(new TogglMenu(_timer), new TogglMenuInputDelegate(_manager, _timer), Ui.SLIDE_RIGHT);

        return true;
    }
}