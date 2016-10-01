module Fosp.Request exposing (Request (Authenticate, Get), serialize)

import Json.Encode exposing (encode, object, string)

type Request = Authenticate String String
    | Get String

serialize : Request -> Int -> String
serialize request id =
    case request of
        Authenticate username password -> serializeAuthenticate username password id
        Get url -> serializeGet url id

serializeAuthenticate : String -> String -> Int -> String
serializeAuthenticate username password id =
    let
        head = "AUTH * " ++ toString id ++ "\r\n\r\n"
        initialResponse = "\0" ++ username ++ "\0" ++ password
        value = object
                [ ("sasl", object
                       [ ("mechanism", string "PLAIN")
                       , ("authorization-identity", string username)
                       , ("initial-response", string initialResponse)
                       ]
                  )
                ]
        body = encode 0 value
    in
        head ++ body

serializeGet : String -> Int -> String
serializeGet url id =
    "GET " ++ url ++ " " ++ toString id ++ "\r\n\r\n"
