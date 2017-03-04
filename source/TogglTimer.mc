using Toybox.System as Sys;
using Toybox.Time as Time;

module Toggl {
    enum {
        TIMER_REFRESH,
        TIMER_RUNNING,
        TIMER_STOPPED
    }

    class TogglTimer {
        hidden var _togglTimer;
        hidden var _onPropertyChanged;
        hidden var _startMoment;
    
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
            
            if(_togglTimer != null) {
                // Time string is in ISO8601 format:
                // YYYY-MM-DDTHH:MM:SS
                var timeStr = _togglTimer["start"];
                _startMoment = Time.Gregorian.moment({
                    :year => timeStr.substring(0, 4).toNumber(),
                    :month => timeStr.substring(5, 7).toNumber(),
                    :day => timeStr.substring(8, 10).toNumber(),
                    :hour => timeStr.substring(11, 13).toNumber(),
                    :minute => timeStr.substring(14, 16).toNumber(),
                    :second => timeStr.substring(17, 19).toNumber()
                });
            }

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

        function getTimerDuration() {
            if( _togglTimer != null ) {
                return Time.now().subtract(_startMoment);
            }

            return null;
        }
    }
}