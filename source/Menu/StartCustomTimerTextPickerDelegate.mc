using Toybox.WatchUi as Ui;

class StartCustomTimerTextPickerDelegate extends Ui.TextPickerDelegate {
  hidden var _manager;

  function getDependencies() {
    return [:TogglManager];
  }

  function initialize(deps) {
    TextPickerDelegate.initialize();
    _manager = deps[:TogglManager];
  }

  function onTextEntered( text, changed ) {
    _manager.startTimer({
        "description" => text
        });
  }
}
