//! ExpectationException.mc
//!
//! Copyright Greg Caufield 2020

using MonkeyTest.Tests;

module MonkeyTest {
(:Mocks)
module Mocks{
  class ExpectationException extends Tests.TestException {
    function initialize() {
      TestException.initialize("Expectation not met");
    }
  }
}
}

