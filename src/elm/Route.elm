module Route exposing (Route(..), href, fromUrl, replaceUrl)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)

type Route 
    = Home
    | Login
    | Video String

parser : Parser (Route -> a) a
parser =
    oneOf 
        [ Parser.map Home Parser.top 
        , Parser.map Login (s "login")
        , Parser.map Video (s "video" </> string)
        ]

href : Route -> Attribute msg 
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser

-- internal 

routeToString : Route -> String
routeToString page =
    String.join "/" (routeToPieces page)

routeToPieces : Route -> List String
routeToPieces page =
    case page of 
        Home -> 
            []
        Login -> 
            ["login"]
        Video id ->
            ["videos", id]
