import ballerina/http;
import ballerina/log;
import choreo/mediation;

type Album readonly & record {|
    string title;
    string artist;
|};

table<Album> key(title) albums = table [
    {title: "Blue Train", artist: "John Coltrane"},
    {title: "Jeru", artist: "Gerry Mulligan"}
];

listener http:Listener ep0 = new (9090, timeout = 0);
service / on ep0 {

    resource function get albums/'\*(http:Caller caller, http:Request request) returns error? {
        map<mediation:PathParamValue> pathParams = {};
        log:printInfo("GET /albums" + albums.toArray().toString());
        return caller->respond(200);
    }

    resource function post albums(Album album) returns Album {
        albums.add(album);
        return album;
    }
}
