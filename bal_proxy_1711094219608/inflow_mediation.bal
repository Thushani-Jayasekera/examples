import ballerina/http;
import choreo/mediation;
import choreo/mediation.add_header;

function handleRequestFlowPolicyResult(http:Response|false|() result, http:Caller caller, mediation:Context mediationCtx) returns boolean {
    if result is false {
        http:ListenerError? response = replyCaller(caller, new, mediationCtx);
        return true;
    } else if result is http:Response {
        http:ListenerError? response = replyCaller(caller, result, mediationCtx);
        return true;
    }
    return false;
}

function 'get__foo_RequestFlow(http:Caller caller, mediation:Context mediationCtx, http:Request request) returns boolean|error {
    LogRecord logRecord = <LogRecord>mediationCtx.get("logRecord");
    {
        logRecord.lastAppliedState = "add_header:addHeader_In";
        var result = check add_header:addHeader_In(mediationCtx, request, "Foo", "Bar");

        if handleRequestFlowPolicyResult(result, caller, mediationCtx) {
            return true;
        }
    }

    return false;
}
function 'get__capital_\{Path\-Variable\}_RequestFlow(http:Caller caller, mediation:Context mediationCtx, http:Request request) returns boolean|error {
    LogRecord logRecord = <LogRecord>mediationCtx.get("logRecord");
    {
        logRecord.lastAppliedState = "add_header:addHeader_In";
        var result = check add_header:addHeader_In(mediationCtx, request, "Foo", "Bar");

        if handleRequestFlowPolicyResult(result, caller, mediationCtx) {
            return true;
        }
    }

    return false;
}
