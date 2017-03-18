using Toybox.WatchUi as Ui;
using Toggl;

class TogglMenuInputDelegate extends Ui.MenuInputDelegate {
    hidden var _manager;

    function initialize(manager, timer) {
        MenuInputDelegate.initialize();

        _manager = manager;
    }

    function onMenuItem(item) {
        if( item == :about ) {
            Ui.pushView(new TogglAboutView(), new TogglAboutViewBehaviourDelegate(), Ui.SLIDE_IMMEDIATE);
        }
        else if( item == :stopTimer ) {
            _manager.stopTimer();
        }

        return false;
    }
}