//! ApiServiceTest.mc
//!
//! Copyright Greg Caufield 2020

using MonkeyTest.Tests;

class ApiServiceTest extends Tests.Test {
  function name() {
    return "ApiServiceTest";
  }

  function testList() {
    return {
      :canSetApiKey => "canSetApiKey"
    };
  }

  function initialize() {
    Test.initialize();
  }

  function canSetApiKey() {
    var deps = {
      :Communications => new Toggl.Communications()
    };

    var apiService = new Toggl.ApiService(deps);
    apiService.setApiKey("1234");
  }
}

