
module Toggl {
	enum {
		TIMER_REFRESH,
		TIMER_RUNNING,
		TIMER_STOPPED,
	}

	class TogglTimer {
		hidden var _togglTimer;
		hidden var _onPropertyChanged;
	
		function initialize() {
			_togglTimer = null;
		}
		
		hidden function onPropertyChanged(property) {
			if( _onPropertyChanged != null ) {
				_onPropertyChanged.invoke(self, property);
			}
		}
		
		function setTimer( togglTimer ) {
			_togglTimer = togglTimer;
			onPropertyChanged(:timerState);
		}
		
		function setRequestState( requestState ) {
		}
		
		function setOnPropertyChanged( callback ) {
			_onPropertyChanged = callback;
		}
		
		function clearOnPropertyChanged() {
			_onPropertyChanged = null;
		}
		
		function getTimerState() {
			if( _togglTimer != null ) {
				return Toggl.TIMER_RUNNING;
			}
			
			return Toggl.TIMER_STOPPED;
		}
	}
}