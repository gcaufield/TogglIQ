using Toybox.WatchUi as Ui;
using Toggl;

class TogglMenuInputDelegate extends Ui.MenuInputDelegate {
  private var _manager;
  private var _uiFactory;

  function getDependencies() {
    return [:TogglManager, :UiFactory];
  }

  function initialize(deps) {
    MenuInputDelegate.initialize();

    _manager = deps[:TogglManager];
    _uiFactory = deps[:UiFactory];
  }

  function onMenuItem(item) {
    if( item == :about ) {
      Ui.pushView(_uiFactory.get(:AboutView),
                  _uiFactory.get(:AboutViewDelegate),
                  Ui.SLIDE_DOWN);
    }
    else if( item == :stopTimer ) {
      _manager.stopTimer();
    }
    else if( item == :startEmptyTimer ) {
      _manager.startTimer(null);
    }
    else if( item == :startCustomTimer ) {
      Ui.popView( Ui.SLIDE_IMMEDIATE );
      Ui.pushView(new Ui.TextPicker( "" ),
                  _uiFactory.get(:StartCustomTimerDelegate),
                  Ui.SLIDE_DOWN);
    }

    return false;
  }
}
