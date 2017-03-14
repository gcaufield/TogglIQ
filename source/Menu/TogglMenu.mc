using Toybox.WatchUi as Ui;
using Toggl;

class TogglMenu extends Ui.Menu {
    function initialize(timer) {
        Menu.initialize();

        if(!timer.getWarnings().isEmpty()) {
            addItem(Ui.loadResource(Rez.Strings.Warnings), :warnings);
        }

        addItem(Ui.loadResource(Rez.Strings.About), :about);
    }
}