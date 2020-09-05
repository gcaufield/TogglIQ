using Toybox.WatchUi as Ui;
using Toggl;

class TogglMenu extends Ui.Menu {
    function getDependencies() {
      return [:TogglTimer];
    }

    function initialize(deps) {
        Menu.initialize();

        var timer = deps[:TogglTimer];

        setTitle(Ui.loadResource(Rez.Strings.AppName));

        if( timer.getWarnings().isEmpty() ) {
            if( timer.getTimerState() == Toggl.TIMER_STATE_RUNNING ) {
                addItem(Ui.loadResource(Rez.Strings.StopTimer), :stopTimer);
            }
            else {
                addItem(Ui.loadResource(Rez.Strings.StartEmptyTimer), :startEmptyTimer);

                if(Ui has :TextPicker) {
                    addItem(Ui.loadResource(Rez.Strings.StartCustomTimer), :startCustomTimer);
                }
            }
        }

        addItem(Ui.loadResource(Rez.Strings.About), :about);
    }
}
