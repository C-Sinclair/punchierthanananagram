module Endpoint exposing (Endpoint(..), login, video, videos)

import Url.Builder exposing (QueryParameter)
import Generic exposing (..)

type Endpoint
    = Endpoint String

toString : Endpoint -> String
toString (Endpoint str) = 
    str

url : List String -> List QueryParameter -> Endpoint
url paths params =
    Url.Builder.crossOrigin "https://_____" -- this should be a functions endpoint
        ("api" :: paths)
        params
        |> Endpoint


-- ENDPOINTS


login : String
login =
    toString ( url [ "login" ] [] )

video : ID -> String
video id =
    toString ( url [ "video" ] [ Url.Builder.string "id" id ] )

videos : String
videos =
    toString ( url [ "video" ] [] )
