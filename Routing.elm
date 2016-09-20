module Routing exposing (..)

import UrlParser exposing (Parser, oneOf, format, s, string, (</>))
import Navigation

type Route = Root
    | Login
    | Signup
    | Profile String

routeParser: UrlParser.Parser (Route -> a) a
routeParser =
    oneOf
        [format Root (s "")
        ,format Login (s "login")
        ,format Signup (s "signup")
        ,format Profile (s "u" </> string)
        ]
