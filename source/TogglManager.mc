using Toybox.Communications as Comms;
using Toybox.StringUtil;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

module Toggl {
    class TogglManager {
        hidden var _apiKey;
        hidden var _state;
        hidden var _updateTimer;

        hidden var _togglTimer;

        function initialize(togglTimer, apiKey) {
            _togglTimer = togglTimer;
            setApiKey(apiKey);
            _updateTimer = new Timer.Timer();
        }

        function onStopComplete(responseCode, data) {
            if( responseCode == 200 ) {
                _togglTimer.setTimer( null );
            }

            update();
        }

        function onCurrentComplete(responseCode, data) {
            if( responseCode == 200 ) {
                _togglTimer.clearWarning(Toggl.TIMER_WARNING_INVALID_API_KEY);
                _togglTimer.setTimer(data["data"]);
            }
            else {
                _togglTimer.setWarning(Toggl.TIMER_WARNING_INVALID_API_KEY);
            }

            _updateTimer.start(method(:update), 5000, false);
        }

        function update() {
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

        function stopTimer() {
            if( _togglTimer.getTimerState() != Toggl.TIMER_STATE_RUNNING ) {
                return;
            }

            _updateTimer.stop();

            var headers = {
                "Authorization" => "Basic " + _apiKey
            };

            var options = {
                :method=> Comms.HTTP_REQUEST_METHOD_PUT,
                :headers=> headers,
                :responseType=> Comms.HTTP_RESPONSE_CONTENT_TYPE_JSON
            };

            Comms.makeWebRequest(
                "https://www.toggl.com/api/v8/time_entries/" + _togglTimer.getTimer()["id"] + "/stop",
                null,
                options,
                method(:onStopComplete));
        }

        function setApiKey(apiKey) {
            if(apiKey == "" || apiKey == null) {
                _togglTimer.setWarning(Toggl.TIMER_WARNING_NO_API_KEY);
            } else {
                _togglTimer.clearWarning(Toggl.TIMER_WARNING_NO_API_KEY);
                _apiKey = StringUtil.encodeBase64(apiKey + ":api_token");
            }
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