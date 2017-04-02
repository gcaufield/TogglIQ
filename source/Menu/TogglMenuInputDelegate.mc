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
            Ui.pushView(new TogglAboutView(), new TogglAboutViewBehaviourDelegate(), Ui.SLIDE_DOWN);
        }
        else if( item == :stopTimer ) {
            _manager.stopTimer();
        }
        else if( item == :startEmptyTimer ) {
            _manager.startTimer(null);
        }
        else if( item == :startCustomTimer ) {
            Ui.popView( Ui.SLIDE_IMMEDIATE );
            Ui.pushView( new Ui.TextPicker( "" ), new StartCustomTimerTextPickerDelegate( _manager ), Ui.SLIDE_DOWN);
        }

        return false;
    }
}