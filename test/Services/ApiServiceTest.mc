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
      :canSetApiKey => "canSetApiKey",
      :canGetCurrentTimer => "canGetCurrentTimer",
      :getCurrentTimerMakesWebRequest => "getCurrentTimerMakesWebRequest"
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

  function callback(response, data) {
  }

  function canGetCurrentTimer() {
    var mockComms = new MockCommunications(Mocks.MOCK_TYPE_NICE);
    var deps = {
      :Communications => mockComms
    };

    var apiService = new Toggl.ApiService(deps);

    apiService.getCurrent(method(:callback));
  }

  function getCurrentTimerMakesWebRequest() {
    var mockComms = new MockCommunications(Mocks.MOCK_TYPE_NICE);
      var deps = {
        :Communications => mockComms
      };

    var apiService = new Toggl.ApiService(deps);

    mockComms.expect(:makeWebRequest);

    apiService.getCurrent(method(:callback));

    // Assert the expectations were met.
    mockComms.verifyAndClear();
  }
}

