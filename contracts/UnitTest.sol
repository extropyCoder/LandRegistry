contract UnitTest{
    enum TestResult {NONE,FAIL,PASS}
    event TestFinished(TestResult);

    struct TestResults{
        bytes32 testName;
        TestResult result;
    }

    TestResults[] public testResults;

    function setUp() external;

    function runTestSuite() external ;

    function setResult  (bytes32 _name,TestResult _result) internal{
        TestResults memory thisResult;
        thisResult.testName = _name;
        thisResult.result = _result;
        testResults.push(thisResult);
    }

    function clearResults() internal{
        delete testResults;
    }

}

contract ExampleContract {

}
