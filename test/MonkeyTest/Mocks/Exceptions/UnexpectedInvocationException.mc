//! UnexpectedInvocationException.mc
//!
//! Copyright Greg Caufield 2020

using MonkeyTest.Tests;

module MonkeyTest {
(:Mocks)
module Mocks {
//! Exception for a function invocation that was not declared
class UnexpectedInvocationException extends Tests.TestException {
  function initialize(functionName) {
    TestException.initialize("");
    self.mMessage = "Unexpected Invocation of function " + functionName;
  }
}
}
}
