module Fosp.Connection exposing (..)

import Debug exposing (log)

import Fosp.Request exposing (..)
import Fosp.Response exposing (..)

import Regex exposing (contains, regex)
import String
import WebSocket

type State = Unauthenticated | Authenticating | Authenticated

type alias Model = { host: String
                   , username: String
                   , password: String
                   , state: State
                   , currentRequestId: Int
                   }

model : Model
model = { host = ""
        , username = ""
        , password = ""
        , state = Unauthenticated
        , currentRequestId = 1
        }

type Msg = UpdateUsername String
         | UpdatePassword String
         | SignIn
         | SendRequest Request
         | ReceiveMessage String
         | ProcessResponse (Response, Int)

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
            in
                update (SendRequest request) model
        SendRequest request ->
            let
                payload = serialize request model.currentRequestId
                cmd = WebSocket.send model.host payload
            in
                ({ model | currentRequestId = model.currentRequestId + 1 }, cmd)
        ReceiveMessage message ->
            case (parse message) of
                Ok (response, sequence) ->
                    update (ProcessResponse (response, sequence)) model
                Err err ->
                    let
                        _ = log "Could not parse response " err
                    in
                        (model, Cmd.none)
        ProcessResponse (response, sequence) ->
            let
                _ = log "Received response " response
            in
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
