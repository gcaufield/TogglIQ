//! SemiRoundLayoutProvider.mc
//!
//! Copyright Greg Caufield 2017

module Toggl {
  class SemiRoundLayoutProvider {
    function initialize() {
    }

    //! Finds the offset from the bottom of the screen required to display the timer string
    //!
    //! @param dc - Dc object for the current update
    //! @param string - String to display
    public function getTimerOffset(dc, font, string) {
      var dimensions = dc.getTextDimensions(string, font);

      // Return the offeset of the label so that the timer will be displayed at
      // the bottom of the screen
      return dc.getHeight() - dimensions[1];
    }

    public function getTimerArc(dc, font) {
      return [230.0d, 310.0d];
    }
  }
}
