//! Communications.mc
//!
//! Copyright Greg Caufield 2020

using Toybox.Communications as Comms;

module Toggl {
  //! Wraps the Toybox Communications API in an interface
  (:background)
  class Communications {
    function initialize() {
    }

    function makeWebRequest(url, parameters, options, responseCallback) {
      // Forward the request to the system communications module
      Comms.makeWebRequest(url, parameters, options, responseCallback);
    }
  }
}
