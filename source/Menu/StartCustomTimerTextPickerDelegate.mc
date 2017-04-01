using Toybox.WatchUi as Ui;

class StartCustomTimerTextPickerDelegate extends Ui.TextPickerDelegate {
    hidden var _manager;

    function initialize( manager ) {
        _manager = manager;
    }

    function onTextEntered( text, changed ) {
        _manager.startTimer({
            "description" => text
        });
    }
}