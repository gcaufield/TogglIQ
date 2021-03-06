//! TogglApiService.mc
//!
//! Copyright Greg Caufield 2017

using Toybox.Time as Time;
using Toybox.Lang as Lang;
using Toybox.StringUtil as StringUtil;
using Toybox.Communications as Comms;

module Toggl {

  const API_ENDPOINT_START = "time_entries";
  const API_ENDPOINT_CURRENT = "time_entries/current";

  //! Service Class for Interacting with the Toggl API
  (:background)
  class ApiService {

    private var _comms;
    private var _apiKey;

    function getDependencies() {
      return [:Communications];
    }

    function initialize(deps) {
      _comms = deps[:Communications];
    }

    function setApiKey(apiKey) {
      _apiKey = StringUtil.encodeBase64(apiKey + ":api_token");
    }

    //! Requests the current active timer
    //!
    //! @param callback [Method] (required) Callback for the result of the request
    function getCurrent( callback ) {
      sendApiRequest( Toggl.API_ENDPOINT_CURRENT, Comms.HTTP_REQUEST_METHOD_GET, null, callback );
    }

    //! Starts a new timer
    //!
    //! @param startMoment [Moment] (required) The Moment that the timer started
    //! @param data [Dictionary] (optional) Data associated with the new timer
    //! @param callback [Method] (required) Callback for the result of the request
    function startNewTimer( startMoment, data, callback ) {
      var description = "";

      if( data != null ) {
        if( data.hasKey("description") ) {
          description = data["description"];
        }
      }

      var postData = {
        "time_entry" => {
          "created_with" => "TogglIQ",
          "description" => description,
          "duration" => "-" + startMoment.value(),
          "start" => toIso8601( startMoment )
        }
      };

      if(data != null && data.hasKey("pid")) {
        postData["time_entry"]["pid"] = data["pid"];
      }

      sendApiRequest( Toggl.API_ENDPOINT_START, Comms.HTTP_REQUEST_METHOD_POST, postData, callback );
    }

    //! Receive all of the timers that have been started in the last 9 days
    //!
    //! @param startMoment [Moment] (required) the start of the time window to
    //!   retrieve
    //! @param callback [Method] (required) Callback for the response
    function getTimers(startMoment, endMoment, callback) {
      var paramsStr = "start_date=" + Comms.encodeURL(toIso8601(startMoment));
      if(endMoment != null ) {
        paramsStr = paramsStr + "&end_date=" + Comms.encodeURL(toIso8601(endMoment));
      }

      sendApiRequest("time_entries?" + paramsStr, Comms.HTTP_REQUEST_METHOD_GET, null, callback );
    }

    //! Stops an active timer
    //!
    //! @param id [Number] (required) ID of the timer to stop
    //! @param callback [Method] (required) Callback for the response
    function stopTimer( id, callback ) {
      sendApiRequest("time_entries/" + id + "/stop", Comms.HTTP_REQUEST_METHOD_GET, null, callback );
    }

    //! Request project information for a given project id
    //!
    //! @param id [Number] (required) ID of the project to request
    //! @param callback [Method] (required) Callback for the response
    function getProject( id, callback ) {
      sendApiRequest("projects/" + id, Comms.HTTP_REQUEST_METHOD_GET, null, callback );
    }

    //! Converts a Moment to the ISO8601
    //!
    //! Converts a moment to the format expected by Toggl API calls
    hidden function toIso8601( moment ) {
      var info = Time.Gregorian.utcInfo( moment, Time.Gregorian.FORMAT_SHORT );
      var str = Lang.format("$1$-$2$-$3$T$4$:$5$:$6$.000Z", [
          info.year.format("%04d"),
          info.month.format("%02d"),
          info.day.format("%02d"),
          info.hour.format("%02d"),
          info.min.format("%02d"),
          info.sec.format("%02d")]);
      return str;
    }

    private function sendApiRequest(endpoint, method, postData, callback) {
      sendRequest("api/v8/", endpoint, method, postData, callback);
    }

    //! Sends a request to the Toggl API
    //!
    //! @param endpoint [String] (required) API_ENDPOINT_* for the request
    //! @param method [Number] (required) HTTP_REQUEST_METHOD_* type of the request
    //! @param postData [Dictionary] (optional) Data to send with the request
    //! @param callback [Method] (required) Callback for the response
    hidden function sendRequest( api, endpoint, method, postData, callback ){
      var headers = {
        "Authorization" => "Basic " + _apiKey,
        "Content-Type" => Comms.REQUEST_CONTENT_TYPE_JSON
      };

      var options = {
        :method=> method,
        :headers=> headers,
        :responseType=> Comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
      };

      _comms.makeWebRequest(
          "https://api.track.toggl.com/" + api + endpoint,
          postData,
          options,
          callback);
    }
  }
}
