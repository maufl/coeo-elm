module Fosp.Response exposing (Response (..), parse)

import Regex exposing (regex, split, HowMany (AtMost, All))
import String exposing (toInt)

type Response = Succeeded Int String
    | Failed Int String

parse : String -> Result String (Response, Int)
parse message =
    case (splitFirstLine message) of
        [statusLine, rest] ->
            case (parseStatusLine statusLine) of
                Ok (status, code, sequence) ->
                    case status of
                        "SUCCEEDED" -> Ok (Succeeded code rest, sequence)
                        "FAILED" -> Ok (Failed code rest, sequence)
                        _ -> Err ("Unknown response status " ++ status)
                Err err -> Err err
        _ ->
            Err "Unable to extract status line"

parseStatusLine : String -> Result String (String, Int, Int)
parseStatusLine statusLine =
    case (splitAtWhitespace statusLine) of
        [status, codeString, sequenceString] ->
            case (toInt codeString, toInt sequenceString) of
                (Ok code, Ok sequence) ->
                    Ok (status, code, sequence)
                (Err _, _) ->
                    Err ("Response code " ++ codeString ++ " is not a number")
                (_, Err _) ->
                    Err ("Sequence number " ++ sequenceString ++ " is not a number")
        _ ->
            Err ("Statusline does not consist of three parts: " ++ statusLine)

splitFirstLine string =
    split (AtMost 1) (regex "\r\n") string

splitAtWhitespace string =
    split All (regex "\\s+") string
