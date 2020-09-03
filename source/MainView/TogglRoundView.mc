class TogglRoundView extends TogglView {
  function getDependencies() {
    return TogglView.getDependencies();
  }

  function initialize(deps) {
    TogglView.initialize(deps);
  }

  //! Finds the offset from the bottom of the screen required to display the timer string
  //!
  //! @param dc - Dc object for the current update
  //! @param string - String to display
  hidden function getTimerOffset(dc, string) {
    // Get the radius of the display
    var r = dc.getWidth() / 2;

    // Get the height and width of the string
    var dimensions = dc.getTextDimensions(string, TIMER_FONT);

    // Use the chord that is made by the timer string
    var x = dimensions[0] / 2;

    // Find the distance from the chord to the center of the circle using Pathgoreans
    // (and they said we wouldn't need it after high school)
    var y = Math.pow(r, 2) - Math.pow(x, 2);
    y = Math.sqrt(y);

    // Calculate the required Y offset by finding the distance from the bottom of the
    // display to the chord and add the height of the string because we want the bottom
    // of the string to sit on the chord
    return dc.getHeight() - ( ( r - y ) + dimensions[1] );
  }
}
