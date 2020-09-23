using Toybox.System as Sys;
using Toybox.Time as Time;

module Toggl {
  enum {
    TIMER_STATE_RUNNING,
    TIMER_STATE_STOPPED
  }

  enum {
    TIMER_WARNING_NONE,
    TIMER_WARNING_NO_API_KEY,
    TIMER_WARNING_INVALID_API_KEY,
    TIMER_WARNING_NO_NETWORK
  }

  (:glance)
  class TogglTimer {
    function getDependencies() {
      return [:StorageService];
    }

    private var _togglTimer;
    private var _project;
    private var _onPropertyChanged;
    private var _startMoment;
    private var _warnings;
    private var _storageService;

    function initialize(deps) {
      _togglTimer = null;
      _warnings = {};

      _storageService = deps[:StorageService];
      updateTimer(_storageService.getTimer(), false);
      setProject(_storageService.getProject());
    }

    function setTimer( togglTimer ) {
      updateTimer(togglTimer, true);
    }

    function setProject( project ) {
      _project = project;
    }

    function setWarning( warning ) {
      if(!_warnings.hasKey(warning)) {
        _warnings.put(warning, true);
      }
    }

    function clearWarning( warning ) {
      if(_warnings.hasKey(warning)) {
        _warnings.remove(warning);
      }
    }

    //! Retrieves the state of the Timer
    function getTimerState() {
      if( _togglTimer != null  && ( _togglTimer["duration"] < 0 ) ) {
        // Timer is not null and the duration is negative. Timer is running.
        return Toggl.TIMER_STATE_RUNNING;
      }

      return Toggl.TIMER_STATE_STOPPED;
    }

    //! Retrives the Duration of the Active Timer
    //! @returns [Time.Duration] The duration of the active timer,
    //!     null if there is no active task
    function getTimerDuration() {
      if( _togglTimer != null ) {
        return Time.now().subtract(_startMoment);
      }

      return null;
    }

    //! Retrieves a string representing the active task
    //! @returns [String] Representing the active task, null
    //!     if there is no active task
    function getActiveTaskString() {
      if( _togglTimer != null ) {
        return _togglTimer["description"];
      }
      return null;
    }

    //! Retrieves a string representing the project for the active task
    //! @returns [String] Representing the project, null
    //!   if there is no project
    function getProjectName() {
      if( _project != null ) {
        return _project["name"];
      }

      return null;
    }

    //! Retrieves the color ID of the active project
    //! @returns [Integer] Representing the project color or null if there is no
    //!  project
    function getProjectColor() {
      if( _project != null ) {
        return _project["color"].toNumber();
      }

      return null;
    }

    function getTimer() {
      return _togglTimer;
    }

    function getWarnings() {
      return _warnings;
    }

    private function updateTimer(timer, persist) {
      _togglTimer = timer;

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

        if(_project != null && _togglTimer["pid"] != _project["id"]) {
          _project = null;
        }
      }
      else {
        _project = null;
      }

      if(persist) {
        _storageService.setTimer(_togglTimer);
        _storageService.setProject(_project);
      }
    }
  }
}
