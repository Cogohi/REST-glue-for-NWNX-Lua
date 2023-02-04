#include "nwnx_lua"

// @member int code - response code
// @member string error - error message
// @member json response - response body
struct JsonResponse
{
    int code;
    string error;
    json response;
};

// Make a REST call to endpoints that support JSON bodies and responses.
// This is a very thin implementation.  No request or response chunking
// nor header support.
//
// @param string sMethod - Http Method: GET, POST, DELETE, PATCH, etc.
// @param string sUrl - The full url to the REST API including path and request params.
//              eg. https://example.com:3333/v1/wacky/8675309?askingFor=Jenny
// @param json jRequestBody - optional request body
// @returns struct JsonResponse - the results
struct JsonResponse RestCall(string sMethod, string sUrl, json jRequestBody);

// Make a REST call to endpoints that support JSON responses.
// This is a very thin implementation.  No response chunking
// nor header support.
//
// @param string sMethod - Http Method: GET, POST, DELETE, PATCH, etc.
// @param string sUrl - The full url to the REST API including path and request params.
//              eg. https://example.com:3333/v1/wacky/8675309?askingFor=Jenny
// @returns struct JsonResponse - the results
struct JsonResponse RestCallNoRequestBody(string sMethod, string sUrl);

// INTERNAL USE ONLY
// - json datatype has no useful constant to use as a default.  Please use the above interfaces
struct JsonResponse RestCallImpl(string sMethod, string sUrl, string sRequestBody = "") {

    // This is internal

    // NWNX_Lua_Eval() does NOT return the string value or the way to do it is non-obvious
    //  returned by the code.
    // All of the availble calls to Lua only support ONE argument
    //
    // To get around the response problem we generate a UUID and use module localvars
    //  which allows us to pass back multiple values
    // The body is passed as a var due to straying into quoting hell when embedded
    //  in the argument.
    //
    // luasockets' http.request does support headers and has a chunking interace
    // for both request and response bodies so this can be expanded

    object oModule = GetModule();
    string uuid = GetRandomUUID();

    SetLocalString(oModule,uuid+":body",sRequestBody);

    NWNX_Lua_EvalVoid("doREST('"+uuid+"|"+sMethod+"|"+sUrl+"')");

    int code = GetLocalInt(oModule,uuid+":code");
    string response = GetLocalString(oModule,uuid+":response");

    DeleteLocalInt(oModule,uuid+":code");
    DeleteLocalString(oModule,uuid+":response");
    DeleteLocalString(oModule,uuid+":body");

    struct JsonResponse jsonResponse;

    jsonResponse.code = code;

    if(code == -1) {
        // response will be a string with an error message
        // that indicates an issue connecting to the REST
        // service
        jsonResponse.error = response;
        jsonResponse.response = JsonNull();
    } else {
        jsonResponse.response = JsonParse(response);
    }

    return jsonResponse;
}

struct JsonResponse RestCall(string sMethod, string sUrl, json jRequestBody) {
    return RestCallImpl(sMethod, sUrl, JsonDump(jRequestBody));
}

struct JsonResponse RestCallNoRequestBody(string sMethod, string sUrl) {
    return RestCallImpl(sMethod, sUrl);
}

