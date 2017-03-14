using Toybox.WatchUi as Ui;
using Toggl;

class TogglMenu extends Ui.Menu {
    function initialize(timer) {
        Menu.initialize();

        addItem(Ui.loadResource(Rez.Strings.About), :about);
    }
}