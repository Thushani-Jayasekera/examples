import choreo/mediation;
import ballerina/log;
import ballerina/url;
import ballerina/time;
import ballerina/http;

// listener http:Listener ep0 = new (9090, timeout = 0);

service / on new http:Listener(9090) {
    resource function get foo/'\*(http:Caller caller, http:Request request) returns error? {
map<mediation:PathParamValue> pathParams = {};
log:printInfo("Request received for foo 1");
mediation:Context originalCtx = mediation:createImmutableMediationContext("get", ["foo", "*"], pathParams, request.getQueryParams());
log:printInfo("Request received for foo 2");
mediation:Context mediationCtx = mediation:createMutableMediationContext(originalCtx, ["foo", "*"], pathParams, request.getQueryParams());
log:printInfo("Request received for foo 3");
http:Response? backendResponse = ();
LogRecord logRecord = initLogRecord(request, mediationCtx);
		do {
			backendResponse = check forwardRequestToBackend(request, mediationCtx, pathParams);
            log:printInfo("Request received for foo 4");
			check replyCaller(caller, <http:Response>backendResponse, mediationCtx, updateState = true);
		} on fail var e {
			http:Response errFlowResponse = createDefaultErrorResponse(e);
			error err = e;
			check replyCaller(caller, errFlowResponse, mediationCtx);
		}
    }
    resource function post foo/'\*(http:Caller caller, http:Request request) returns error? {
map<mediation:PathParamValue> pathParams = {};
mediation:Context originalCtx = mediation:createImmutableMediationContext("post", ["foo", "*"], pathParams, request.getQueryParams());
mediation:Context mediationCtx = mediation:createMutableMediationContext(originalCtx, ["foo", "*"], pathParams, request.getQueryParams());
http:Response? backendResponse = ();
LogRecord logRecord = initLogRecord(request, mediationCtx);
		do {
			backendResponse = check forwardRequestToBackend(request, mediationCtx, pathParams);

			check replyCaller(caller, <http:Response>backendResponse, mediationCtx, updateState = true);
		} on fail var e {
			http:Response errFlowResponse = createDefaultErrorResponse(e);
			error err = e;
			check replyCaller(caller, errFlowResponse, mediationCtx);
		}
    }
    resource function get number/[int pathVariable]/'\*(http:Caller caller, http:Request request) returns error? {
map<mediation:PathParamValue> pathParams = {"pathVariable": urlEncodeUtf8(pathVariable)};
mediation:Context originalCtx = mediation:createImmutableMediationContext("get", ["number", {name: "pathVariable", kind: mediation:PATH_PARAM, 'type: int}, "*"], pathParams, request.getQueryParams());
mediation:Context mediationCtx = mediation:createMutableMediationContext(originalCtx, ["number", {name: "pathVariable", kind: mediation:PATH_PARAM, 'type: int}, "*"], pathParams, request.getQueryParams());
http:Response? backendResponse = ();
LogRecord logRecord = initLogRecord(request, mediationCtx);
		do {
			backendResponse = check forwardRequestToBackend(request, mediationCtx, pathParams);

			check replyCaller(caller, <http:Response>backendResponse, mediationCtx, updateState = true);
		} on fail var e {
			http:Response errFlowResponse = createDefaultErrorResponse(e);
			error err = e;
			check replyCaller(caller, errFlowResponse, mediationCtx);
		}
    }
    resource function get capital/[string pathVariable](http:Caller caller, http:Request request) returns error? {
map<mediation:PathParamValue> pathParams = {"pathVariable": urlEncodeUtf8(pathVariable)};
mediation:Context originalCtx = mediation:createImmutableMediationContext("get", ["capital", {name: "pathVariable", kind: mediation:PATH_PARAM, 'type: string}], pathParams, request.getQueryParams());
mediation:Context mediationCtx = mediation:createMutableMediationContext(originalCtx, ["capital", {name: "pathVariable", kind: mediation:PATH_PARAM, 'type: string}], pathParams, request.getQueryParams());
http:Response? backendResponse = ();
LogRecord logRecord = initLogRecord(request, mediationCtx);
		do {
			logRecord.lastAppliedState = "get__capital_(Path-Variable)_RequestFlow";
    if check get__capital_\{Path\-Variable\}_RequestFlow(caller, mediationCtx, request) {
    return;
}

			backendResponse = check forwardRequestToBackend(request, mediationCtx, pathParams);

			logRecord.lastAppliedState = "get__capital_(Path-Variable)_ResponseFlow";
if check get__capital_\{Path\-Variable\}_ResponseFlow(caller, mediationCtx, request, <http:Response>backendResponse) {
    return;
}

			check replyCaller(caller, <http:Response>backendResponse, mediationCtx, updateState = true);
		} on fail var e {
			http:Response errFlowResponse = createDefaultErrorResponse(e);
			error err = e;
			check replyCaller(caller, errFlowResponse, mediationCtx);
		}
    }
    resource function post capital/[string pathVariable](http:Caller caller, http:Request request) returns error? {
map<mediation:PathParamValue> pathParams = {"pathVariable": urlEncodeUtf8(pathVariable)};
mediation:Context originalCtx = mediation:createImmutableMediationContext("post", ["capital", {name: "pathVariable", kind: mediation:PATH_PARAM, 'type: string}], pathParams, request.getQueryParams());
mediation:Context mediationCtx = mediation:createMutableMediationContext(originalCtx, ["capital", {name: "pathVariable", kind: mediation:PATH_PARAM, 'type: string}], pathParams, request.getQueryParams());
http:Response? backendResponse = ();
LogRecord logRecord = initLogRecord(request, mediationCtx);
		do {
			backendResponse = check forwardRequestToBackend(request, mediationCtx, pathParams);

			check replyCaller(caller, <http:Response>backendResponse, mediationCtx, updateState = true);
		} on fail var e {
			http:Response errFlowResponse = createDefaultErrorResponse(e);
			error err = e;
			check replyCaller(caller, errFlowResponse, mediationCtx);
		}
    }
}
configurable string Endpoint = "	https://webhook.site/262b50be-1c79-494a-bb7b-0ed906c019eb/local";
configurable string SandboxEndpoint = "	https://webhook.site/262b50be-1c79-494a-bb7b-0ed906c019eb/local";
configurable map<string> AdvancedSettings = {};

final http:Client backendEP = check new(Endpoint, config = {
    secureSocket: {
        enable: check boolean:fromString("false"),
         cert: "/home/ballerina/ca.pem",
        verifyHostName: AdvancedSettings.hasKey("verifyHostname") ? check boolean:fromString(AdvancedSettings.get("verifyHostname")): true
    },
    timeout: 300,
    httpVersion: AdvancedSettings.hasKey("httpVersion") ? <http:HttpVersion>(<anydata>AdvancedSettings.get("httpVersion")) : "1.1"
});
final http:Client sandboxEP = check new(SandboxEndpoint, config = {
    secureSocket: {
        enable: check boolean:fromString("false"),
         cert: "/home/ballerina/sand_ca.pem",
        verifyHostName: AdvancedSettings.hasKey("verifyHostname") ? check boolean:fromString(AdvancedSettings.get("verifyHostname")) : true
    },
    timeout: 300,
    httpVersion: AdvancedSettings.hasKey("httpVersion") ? <http:HttpVersion>(<anydata>AdvancedSettings.get("httpVersion")) : "2.0"
});

function createDefaultErrorResponse(error err) returns http:Response {
    http:Response resp = new;
    log:printError(err.message(), (), err.stackTrace(), details=err.detail().toString());
    resp.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;
    return resp;
}

function buildQuery(map<string[]> params) returns string {
    if (params.length() == 0) {
        return "";
    }

    string qParamStr = "?";

    foreach [string, string[]] [name, val] in params.entries() {
        foreach string item in val {
            string encoded = urlEncodeUtf8(item);
            qParamStr += string `${name}=${encoded}&`;
        }
    }

    return qParamStr.substring(0, qParamStr.length() - 1);
}

function buildRestParamPath(string[] pathSegments) returns string {
    return pathSegments.reduce(
        function (string path, string segment) returns string => string `${path}/${segment}`, "");
}

function urlEncodeUtf8(any value) returns string {
    string strValue = value.toString();
    string|error encoded = url:encode(strValue, "UTF-8");
    if encoded is error {
        log:printError("Unreachable error. Error occurred while URL encoding", 'error = encoded, keyValues = {"value": strValue});
        return strValue;
    }
    return encoded;
}

function initLogRecord(http:Request request, mediation:Context mediationCtx) returns LogRecord {
    string|error req_id_header = request.getHeader("x-request-id");
    string request_id = req_id_header is string ? req_id_header : "-";
    LogRecord logRecord = {
        upstreamSvcTime: 0,
        upstreamHost: "-",
        upstreamPath: "-",
        upstreamMethod: "-",
        requestId: request_id,
        upstreamStatus: "-",
        lastAppliedState: "downstream_inbound_request"
    };
    mediationCtx.put("logRecord", logRecord);
    return logRecord;
}

function forwardRequestToBackend(http:Request request, mediation:Context mediationCtx,  map<mediation:PathParamValue> pathParams) returns http:Response?|error {
    LogRecord logRecord = <LogRecord>mediationCtx.get("logRecord");
    http:Response? backendResponse = ();
    decimal startTime = time:monotonicNow();
    string|error backendPath = mediationCtx.resourcePath().resolve(pathParams);
    string|error incomingEnvHeader = request.getHeader("X-ENV");
    logRecord.lastAppliedState = "upstream_outbound_request";
    log:printInfo("Request received for foo 5");
    if incomingEnvHeader is string && incomingEnvHeader === "sandbox" {
        request.removeHeader("X-ENV");
        logRecord.upstreamHost = SandboxEndpoint;
        log:printInfo("Request received for foo 6");
        backendResponse = check sandboxEP->execute(mediationCtx.httpMethod(), (check backendPath) + buildQuery(mediationCtx.queryParams()), request, targetType = http:Response);
    } else {
        log:printInfo("Request received for foo 6");
        logRecord.upstreamHost = Endpoint;
        backendResponse = check backendEP->execute(mediationCtx.httpMethod(), (check backendPath) + buildQuery(mediationCtx.queryParams()), request, targetType = http:Response);
        log:printInfo("Request received for foo 7");
    }
    logRecord.lastAppliedState = "upstream_inbound_response";
    logRecord.upstreamPath = backendPath is string ? backendPath : "-";
    logRecord.upstreamMethod = mediationCtx.httpMethod();
    logRecord.upstreamSvcTime = time:monotonicNow() - startTime;
    logRecord.upstreamStatus = backendResponse != () ? backendResponse.statusCode.toString() : "-";
    return backendResponse;
}

function replyCaller(http:Caller caller, http:Response response, mediation:Context mediationCtx, boolean updateState = false) returns http:ListenerError? {
    LogRecord logRecord = <LogRecord>mediationCtx.get("logRecord");
    boolean|error enableDetailedAccessLog = AdvancedSettings.hasKey("enableDetailedAccessLog") ? boolean:fromString(AdvancedSettings.get("enableDetailedAccessLog")): true;
    // Update state should be set to true if the backend response is sent to the client successfully. 
    if updateState {
        logRecord.lastAppliedState = "downstream_outbound_response";
    }
    if enableDetailedAccessLog is boolean && enableDetailedAccessLog {
        log:printInfo(logRecord.toString(), id = logRecord.requestId);
    }
    return caller->respond(response);
}

type LogRecord record {
    decimal upstreamSvcTime;
    string upstreamHost;
    string upstreamPath;
    string requestId;
    string upstreamStatus;
    string upstreamMethod;
    string lastAppliedState;
};
