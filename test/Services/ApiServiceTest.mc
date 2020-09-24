//! ApiServiceTest.mc
//!
//! Copyright Greg Caufield 2020

using Toybox.Lang;

class ApiServiceTest extends Test {
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

(:test)
function run_ApiServiceTests(logger) {
  return new TestRunner().runTestSuite(logger, ApiServiceTest);
}

