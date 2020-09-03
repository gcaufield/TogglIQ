class TogglSemiRoundView extends TogglView {

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
    var dimensions = dc.getTextDimensions(string, TIMER_FONT);

    // Return the offeset of the label so that the timer will be displayed at
    // the bottom of the screen
    return dc.getHeight() - dimensions[1];
  }
}
