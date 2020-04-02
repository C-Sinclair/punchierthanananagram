module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view 
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }

type alias Model =
    { key : Nav.Key 
    , url : Url.Url 
    }

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )

type Msg 
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        LinkClicked urlRequest ->
            case urlRequest of 
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )
                Browser.External href ->
                    ( model, Nav.load href )
        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

view : Model -> Browser.Document Msg 
view model =
    { title = "PunchierThanAnAnagram" 
    , body =
        [ main_ [ id "root" ] 
            [ h1 [] [ text "Punchier Than An Anagram" ]
            , p [] 
                [ text "You've reached the website for the "
                , i [] [ text "amazing" ]
                , text " comedy duo behind such hits as Bibblin' and Public Service Announcement!" 
                ]
                , footer [] [ text "Hi Joe!" ]
            ]
        ]
    }

listLink : String -> Html msg 
listLink path = 
    li [] [ a [ href path ] [ text path ]]