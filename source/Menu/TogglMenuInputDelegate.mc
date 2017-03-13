using Toybox.WatchUi as Ui;
using Toggl;

class TogglMenuInputDelegate extends Ui.MenuInputDelegate {
    function initialize(manager, timer) {
    }

    function onMenuItem(item) {
        if( item == :about ) {
            Ui.pushView(new TogglAboutView(), new TogglAboutViewBehaviourDelegate(), Ui.SLIDE_IMMEDIATE );
        }
    }
}