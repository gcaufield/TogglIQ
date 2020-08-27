// BackgroundScheduler.mc
//
// Handles Scheduling the next background event
// Copyright Greg Caufield 2020

using Toybox.Background;

module Toggl {
module Services {

(:background)
class BackgroundScheduler {
  const THIRTY_SECONDS = new Time.Duration(30);
  const FIVE_MINUTES = new Time.Duration(300);

  function initialize() {
    // When initializing the scheduler delete any current registrations... We
    // are not super interested in having background events trigger while we
    // are running.
    Background.deleteTemporalEvent();
  }

  function schedule() {
    try {
      // Try to schedule for 30 seconds from now first, and if that fails fall
      // back to five minutes
      Background.registerForTemporalEvent(Time.now().add(THIRTY_SECONDS));
    } catch( e instanceof Background.InvalidBackgroundTimeException) {
      Background.registerForTemporalEvent(Time.now().add(FIVE_MINUTES));
    }
  }
}

} // Services
} // Toggl