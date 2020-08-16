using Toybox.System;
using Toybox.Background;
using Toybox.Communications;
using Toybox.Time;

module Toggl {

(:background, :minSdk("2.3.0"))
class  TogglBackground extends System.ServiceDelegate {

    function initialize() {
        ServiceDelegate.initialize();
    }

    function onTemporalEvent() {
      // After recieving the event register for the next event
      var duration = new Time.Duration(60 * 5);
      var eventTime = Time.now().add(duration);
      Background.registerForTemporalEvent(eventTime);

      System.println("Background Triggered");

      Background.exit(null);
    }
}

}
