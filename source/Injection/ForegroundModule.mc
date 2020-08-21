

module Toggl {
module Injection {

  class ForegroundModule extends Module {
    function intialize() {
      Module.intialize();

      bind(:TogglRoundView, [:TogglTimer, :TickManager], method(:buildTogglRoundView));
    }

    function buildTogglRoundView(deps) {
      return new TogglRoundView(deps[:TogglTimer], deps[:TickManager]);
    }
  }
}
}
