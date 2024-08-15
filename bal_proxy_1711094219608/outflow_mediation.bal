import ballerina/http;
import choreo/mediation;
import choreo/mediation.add_header;

function handleResponseFlowPolicyResult(http:Response|false|() result, http:Response backendResponse, http:Caller caller, mediation:Context mediationCtx) returns boolean {
    if result is false {
        http:ListenerError? response = replyCaller(caller, new, mediationCtx);
        return true;
    } else if result is http:Response {
        http:ListenerError? response = replyCaller(caller, result, mediationCtx);
        return true;
    }
    return false;
}

function 'get__foo_ResponseFlow(http:Caller caller, mediation:Context mediationCtx, http:Request request, http:Response backendResponse) returns boolean|error {
    LogRecord logRecord = <LogRecord>mediationCtx.get("logRecord");
    {
        logRecord.lastAppliedState = "add_header:addHeader_Out";
        var result = check add_header:addHeader_Out(mediationCtx, request, backendResponse, "Foo", "Baz");

        if handleResponseFlowPolicyResult(result, backendResponse, caller, mediationCtx) {
            return true;
        }
    }

    return false;
}
function 'get__capital_\{Path\-Variable\}_ResponseFlow(http:Caller caller, mediation:Context mediationCtx, http:Request request, http:Response backendResponse) returns boolean|error {
    LogRecord logRecord = <LogRecord>mediationCtx.get("logRecord");
    {
        logRecord.lastAppliedState = "add_header:addHeader_Out";
        var result = check add_header:addHeader_Out(mediationCtx, request, backendResponse, "Foo", "Baz");

        if handleResponseFlowPolicyResult(result, backendResponse, caller, mediationCtx) {
            return true;
        }
    }

    return false;
}
