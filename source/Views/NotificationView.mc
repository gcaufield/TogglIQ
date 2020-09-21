//! NotificationView.mc
//!
//! Copyright Greg Caufield 2020

using Toybox.WatchUi;
using Toybox.Graphics;

module Toggl {
  class NotificationView {
    const NTFCTN_FONT = Graphics.FONT_XTINY;
    const NTFCTN_MARGIN = 6;

    const NTFCTN_MESG = {
      Toggl.TIMER_NTFCTN_REQUEST_FAILED => Rez.Strings.RequestFailed
    };

    //! Static Dependency Lookup Function
    function getDependencies() {
      return [:NotificationModel];
    }

    private var _notification;

    //!
    function initialize(deps) {
      _notification = deps[:NotificationModel];
    }

    //! Draws the notification box if there is a pending notification
    //!
    //! @param dc - Dc object for the current update
    function onUpdate(dc) {
      var notification = _notification.getNotification();
      if( null != notification ) {
        var width = dc.getWidth();
        var height = 60;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_DK_GRAY);
        dc.fillRectangle( 0, 0, width, height );

        var ntfctnStr = WatchUi.loadResource( NTFCTN_MESG.get( notification ) );
        var ntfctnHeight = dc.getTextDimensions( ntfctnStr, NTFCTN_FONT )[1];
        dc.setColor( Graphics.COLOR_WHITE, Graphics.COLOR_BLACK );
        dc.drawText( width / 2,
            height - ( ntfctnHeight + NTFCTN_MARGIN ),
            NTFCTN_FONT,
            ntfctnStr,
            Graphics.TEXT_JUSTIFY_CENTER);
      }
    }
  }
}
