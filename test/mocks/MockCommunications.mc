//! MockCommunications.mc
//!
//! Copyright Greg Caufield 2020

using MonkeyTest.Mocks;

class MockCommunications extends Mocks.Mock {
  private const functions = {
    :makeWebRequest => "makeWebRequest"
  };

  function initialize(type) {
    Mock.initialize(type);
  }

  protected function getFunctionName(key) {
    var name = functions[key];

    if(name != null) {
      return name;
    }

    return Mock.getFunctionName();
  }

  function makeWebRequest(url, parameters, options, responseCallback) {
    // Forward the request to the system communications module
    execute(:makeWebRequest, [url, parameters, options, responseCallback]);
  }
}
