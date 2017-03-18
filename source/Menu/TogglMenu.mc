using Toybox.WatchUi as Ui;
using Toggl;

class TogglMenu extends Ui.Menu {
    function initialize(timer) {
        Menu.initialize();

        setTitle(Ui.loadResource(Rez.Strings.AppName));

        if( ( timer.getTimerState() == Toggl.TIMER_STATE_RUNNING ) &&
            timer.getWarnings().isEmpty() ) {
            addItem(Ui.loadResource(Rez.Strings.StopTimer), :stopTimer);
        }

        addItem(Ui.loadResource(Rez.Strings.About), :about);
    }
}