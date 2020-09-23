using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;
using Toybox.StringUtil as Util;
using Toybox.Math as Math;

class TogglView extends Ui.View {
  private var _update;
  private var _timerView;
  private var _notificationView;

  //! Static Interface Dependency Retriever
  //!
  //! @returns Array of required interfaces
  function getDependencies() {
    return [:TickManager, :TimerView, :NotificationView];
  }

  function initialize(deps) {
    View.initialize();
    _timerView = deps[:TimerView];
    _notificationView = deps[:NotificationView];

    deps[:TickManager].addListener( method(:onTick), 1000 );
  }

  // Load your resources here
  function onLayout(dc) {
    _timerView.onLayout(dc);
  }

  function onTick() {
    if( _update ) {
      Ui.requestUpdate();
    }
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {
    Ui.requestUpdate();
    _update = true;
  }

  // Update the view
  function onUpdate(dc) {
    dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
    dc.clear();

    _timerView.onUpdate(dc);
    _notificationView.onUpdate(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() {
    _update = false;
  }
}
