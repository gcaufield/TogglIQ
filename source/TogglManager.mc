using Toybox.Communications as Comms;
using Toybox.StringUtil;
using Toybox.System as Sys;

module Toggl {
	class TogglManager {
		hidden enum {
			MANAGER_STATE_INIT,
			MANAGER_STATE_ERROR,
			MANAGER_STATE_DATA
		}

		hidden var _apiKey;
		hidden var _state;
		
		hidden var _togglTimer;
		
		function initialize(togglTimer) {
			_togglTimer = togglTimer;
			_apiKey = StringUtil.encodeBase64(
				"466c32773ae7d027574fb1282428baf8:api_token");
			_state = MANAGER_STATE_INIT;
			
			update();
		}
		
		function onCurrentComplete(responseCode, data) {
			Sys.println(responseCode);
			if( responseCode == 200 ) {
				_togglTimer.setTimer(data["data"]);
				_state = MANAGER_STATE_DATA;
			}
			else {
				_state = MANAGER_STATE_ERROR;
			}
			
			update();
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
	}
}