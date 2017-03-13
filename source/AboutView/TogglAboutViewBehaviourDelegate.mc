using Toybox.WatchUi as Ui;

class TogglAboutViewBehaviourDelegate extends Ui.BehaviorDelegate {

    function initialize() {
    }

    function onBack() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}