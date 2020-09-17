using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;
using Toybox.StringUtil as Util;
using Toybox.Math as Math;

class TogglView extends Ui.View {
  const NTFCTN_FONT = Gfx.FONT_XTINY;
  const NTFCTN_MARGIN = 6;

  const COLORS = {
    Toggl.TIMER_STATE_RUNNING=> Gfx.COLOR_GREEN,
    Toggl.TIMER_STATE_STOPPED=> Gfx.COLOR_RED
  };

  const NTFCTN_MESG = {
    Toggl.TIMER_NTFCTN_REQUEST_FAILED=> Rez.Strings.RequestFailed
  };

  hidden var _timer;
  hidden var _update;
  hidden var _timerFont;
  hidden var _timerView;

  //! Static Interface Dependency Retriever
  //!
  //! @returns Array of required interfaces
  function getDependencies() {
    return [:TogglTimer, :TickManager, :TimerView];
  }

  function initialize(deps) {
    View.initialize();
    _timer = deps[:TogglTimer];
    _timerView = deps[:TimerView];

    deps[:TickManager].addListener( method(:onTick), 1000 );
  }

  // Load your resources here
  function onLayout(dc) {
    _timerView.onLayout(dc);
  }

  function uiUpdate() {
    Ui.requestUpdate();
  }

  function onTick() {
    if( _update ) {
      uiUpdate();
    }
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() {
    Ui.requestUpdate();
    _update = true;
  }

  function updateTimerState(dc) {
    dc.setColor(Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK);
    dc.clear();

    _timerView.onUpdate(dc);
    drawNotification( dc );
  }

  //! Draws the notification box if there is a pending notification
  //!
  //! @param dc - Dc object for the current update
  hidden function drawNotification( dc ) {
    var notification = _timer.getNotification();
    if( null != notification ) {
      var width = dc.getWidth();
      var height = 60;

      dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_DK_GRAY);
      dc.fillRectangle( 0, 0, width, height );

      var ntfctnStr = Ui.loadResource( NTFCTN_MESG.get( notification ) );
      var ntfctnHeight = dc.getTextDimensions( ntfctnStr, NTFCTN_FONT )[1];
      dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_BLACK );
      dc.drawText( width / 2,
          height - ( ntfctnHeight + NTFCTN_MARGIN ),
          NTFCTN_FONT,
          ntfctnStr,
          Gfx.TEXT_JUSTIFY_CENTER);
    }
  }

  // Update the view
  function onUpdate(dc) {
    // Call the parent onUpdate function to redraw the layout
    updateTimerState(dc);
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() {
    _update = false;
  }
}
