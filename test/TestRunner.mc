class TestRunner {
  function runTestSuite(logger, suiteDef) {
    var testList = suiteDef.testList();

    logger.debug("=======================");
    logger.debug("Running test suite " + suiteDef.name());


    var keys = testList.keys();
    var success = true;
    for(var i = 0; i < testList.size(); i++) {
      logger.debug(" " + testList[keys[i]] + ".........");
      var test = new suiteDef();

      test.setUp();

      try {
        var testMethod = new Lang.Method(test, keys[i]);
        testMethod.invoke();
        logger.debug("  PASS");
      }
      catch (ex instanceof TestException) {
        success = false;
        logger.error("  FAIL");
        //logger.error(ex.getMessage());
      }
      finally {
        test.tearDown();
      }
    }

    return success;
  }
}
