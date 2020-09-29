//! TestMain.mc
//!
//! Copyright Greg Caufield 2020

using MonkeyTest.Tests;

var testSuites = [
  ApiServiceTest
];

(:test)
function runAllTests(logger) {
  return new Tests.TestRunner().runAllTestSuites(logger, testSuites);
}
