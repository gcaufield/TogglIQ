//! RoundLayoutProvider.mc
//!
//! Copyright Greg Caufield 2017

using Toybox.System;
using Toybox.Graphics;
using Toybox.Math;

module Toggl {
  class RoundLayoutProvider {
    function initialize() {
    }

    //! Finds the offset from the bottom of the screen required to display the timer string
    //!
    //! @param dc - Dc object for the current update
    //! @param string - String to display
    public function getTimerOffset(dc, font, string) {
      // Get the radius of the display
      var r = dc.getWidth() / 2;

      // Get the height and width of the string
      var dimensions = dc.getTextDimensions(string, font);

      // Use the chord that is made by the timer string
      var x = dimensions[0] / 2;

      // Find the distance from the chord to the center of the circle using Pathgoreans
      // (and they said we wouldn't need it after high school)
      var y = Math.pow(r, 2) - Math.pow(x, 2);
      y = Math.sqrt(y);

      // Calculate the required Y offset by finding the distance from the bottom of the
      // display to the chord and add the height of the string because we want the bottom
      // of the string to sit on the chord
      //return dc.getHeight() - ( ( r - y ) + dimensions[1] );
      return dc.getHeight() - ( ( r - y ) + Graphics.getFontAscent(font) );
    }

    public function getTimerArc(dc, font) {
      // Get the radius of the display
      var r = dc.getWidth() / 2.0d;

      // Get the height and width of the string
      var dimensions = dc.getTextDimensions("00:00:00", font);

      // Use the chord that is made by the timer string
      var x = dimensions[0] / 2.0d;

      // Find the distance from the chord to the center of the circle using Pathgoreans
      // (and they said we wouldn't need it after high school)
      var y = Math.pow(r, 2) - Math.pow(x, 2);
      y = Math.sqrt(y);

      // Shorten y by 1/2 of the font ascent so that we can find the angle to
      // chord that runs through the middle of the timer label.
      y = y - (Graphics.getFontAscent(font) / 2);

      // Find the angle
      var ang = Math.acos(y / r);
      ang = (180.0d / Math.PI) * ang;

      return [270.0d - ang, 270.0d + ang];
    }
  }
}
