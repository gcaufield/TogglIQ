using Toybox.Communications as Comms;
using Toybox.StringUtil;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

module Toggl {
    class TogglManager {
        hidden enum {
            MANAGER_STATE_INIT,
            MANAGER_STATE_ERROR,
            MANAGER_STATE_DATA
        }

        hidden var _apiKey;
        hidden var _state;
        hidden var _updateTimer;

        hidden var _togglTimer;

        function initialize(togglTimer) {
            _togglTimer = togglTimer;
            _apiKey = StringUtil.encodeBase64(
                "466c32773ae7d027574fb1282428baf8:api_token");
            _state = MANAGER_STATE_INIT;
            _updateTimer = new Timer.Timer();
        }

        hidden function onCurrentComplete(responseCode, data) {
            Sys.println(responseCode);
            if( responseCode == 200 ) {
                _togglTimer.setTimer(data["data"]);
                _state = MANAGER_STATE_DATA;
            }
            else {
                _state = MANAGER_STATE_ERROR;
            }

            _updateTimer.start(method(:update), 5000, false);
        }

        hidden function update() {
            var headers = {
                "Authorization" => "Basic " + _apiKey
            };

            var options = {
                :method=> Comms.HTTP_REQUEST_METHOD_GET,
                :headers=> headers,
                :responseType=> Comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
            };

            Comms.makeWebRequest(
                "https://www.toggl.com/api/v8/time_entries/current",
                null,
                options,
                method(:onCurrentComplete));
        }

        //! Begins Updating the timer
        //! Adds a slight delay before updating, to allow for app to scroll
        function startUpdate() {
            // Request an update in 750 ms, to allow for quick scrolling without wasting data
            _updateTimer.start(method(:update), 750, false);
        }

        //! Stops the update timer
        function stopUpdate() {
            _updateTimer.stop();
        }
    }
}