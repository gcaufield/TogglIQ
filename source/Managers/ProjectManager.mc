//! RecentTimerManager.mc
//!
//! Copyright Greg Caufield 2022
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Communications;

module Toggl {
module Managers {
  (:background)
  class ProjectManager {

    private var _apiService;
    private var _projects;

    private var _requests;

    public function getDependencies() {
      return [:TogglApiService];
    }

    public function initialize(deps) {
      _apiService = deps[:TogglApiService];
      _projects = {};

      _requests = {};
    }

    public function getProjectName(id, onNameRetrieved) {
      if(_projects.hasKey(id)) {
        return _projects[id]["name"];
      }

      _requests.put(id, onNameRetrieved);

      _apiService.getProject(id, method(:onProjectData));
      return null;
    }

    function onProjectData(responseCode, data) {
      switch(responseCode) {
        case 200:
          var project = data["data"];
          var pid = project["id"];
          _projects.put(pid, project);

          if(_requests.hasKey(pid)) {
            _requests[pid].invoke(project["id"], project["name"]);
            _requests.remove(pid);
          }

          break;
      }
    }
  }
}
}
