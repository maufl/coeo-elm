module Fosp.Connection exposing (..)

import Debug exposing (log)

import Fosp.Request exposing (..)
import Fosp.Response exposing (..)
import Fosp.Object exposing (Object, decoder)

import Regex exposing (contains, regex)
import Json.Decode exposing (decodeString)
import Dict
import String
import WebSocket

type State = Unauthenticated | Authenticating | Authenticated

type alias Model = { host: String
                   , username: String
                   , password: String
                   , state: State
                   , currentRequestId: Int
                   , pendingRequests: Dict.Dict Int Request
                   , objects: Dict.Dict String Object
                   }

model : Model
model = { host = ""
        , username = ""
        , password = ""
        , state = Unauthenticated
        , currentRequestId = 1
        , pendingRequests = Dict.empty
        , objects = Dict.empty
        }

type Msg = UpdateUsername String
         | UpdatePassword String
         | SignIn
         | SendRequest Request
         | ReceiveMessage String

update: Msg -> Model -> ( Model, Cmd a)
update msg model =
    case msg of
        UpdateUsername username ->
            case (getHost username) of
                Just host ->
                    ({ model | username = username, host = host}, Cmd.none)
                Nothing ->
                    ({ model | username = username }, Cmd.none)
        UpdatePassword password ->
            ({ model | password = password }, Cmd.none)
        SignIn ->
            let
                request = Authenticate model.username model.password
                model = { model | state = Authenticating }
            in
                update (SendRequest request) model
        SendRequest request ->
            let
                payload = serialize request model.currentRequestId
                cmd = WebSocket.send model.host payload
                pendingRequests = Dict.insert model.currentRequestId request model.pendingRequests
            in
                ({ model | currentRequestId = model.currentRequestId + 1, pendingRequests = pendingRequests }, cmd)
        ReceiveMessage message ->
            case (parse message) of
                Ok (response, sequence) ->
                    case (Dict.get sequence model.pendingRequests) of
                        Just request ->
                            let
                                pendingRequests = Dict.remove sequence model.pendingRequests
                                model = { model | pendingRequests = pendingRequests }
                            in
                                updateWithResponse request response model
                        Nothing ->
                            let
                                _ = log "Receiced response for which no request was pending"
                            in
                                (model, Cmd.none)
                Err err ->
                    let
                        _ = log "Could not parse response " err
                    in
                        (model, Cmd.none)

updateWithResponse : Request -> Response -> Model -> (Model, Cmd a)
updateWithResponse request response model =
    case request of
        Authenticate _ _ ->
            case response of
                Succeeded _ _ ->
                    let
                        request = Get model.username
                        model = { model | state = Authenticated }
                    in
                        update (SendRequest request) model
                Failed _ _ ->
                    ({ model | state = Unauthenticated }, Cmd.none)
        Get url ->
            case response of
                Succeeded _ body ->
                    case (decodeString decoder body) of
                        Ok object ->
                            let
                                objects = Dict.insert url object model.objects
                            in
                                ({ model | objects = objects }, Cmd.none)
                        Err err ->
                            let
                                _ = log "Error while decoding object" err
                            in
                            (model, Cmd.none)
                Failed _ _ ->
                    (model, Cmd.none)

getHost : String -> Maybe String
getHost username =
    case (String.split "@" username) of
        [name, host] ->
            if (contains (regex "^[^.]+\\.[^.]+$") host) then
                Just ("ws://" ++ host ++ ":1337")
            else
                Nothing
        _ -> Nothing
