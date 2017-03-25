using Toybox.WatchUi as Ui;
using Toggl;

class TogglMenu extends Ui.Menu {
    function initialize(timer) {
        Menu.initialize();

        setTitle(Ui.loadResource(Rez.Strings.AppName));

        if( timer.getWarnings().isEmpty() ) {
            if( timer.getTimerState() == Toggl.TIMER_STATE_RUNNING ) {
                addItem(Ui.loadResource(Rez.Strings.StopTimer), :stopTimer);
            }
            else {
                addItem(Ui.loadResource(Rez.Strings.StartTimer), :startTimer);
            }
        }

        addItem(Ui.loadResource(Rez.Strings.About), :about);
    }
}