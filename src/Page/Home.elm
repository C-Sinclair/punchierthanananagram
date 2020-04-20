module Page.Home exposing (init, update, view, subscriptions)

import Html exposing (Html, h1, div, text, p, a)
import Route exposing (href)
import Session
import Types exposing (..)

init : Session -> ( Model, Cmd Msg )
init session =
    ( Home (HomeModel session)
    , Cmd.none 
    )    

view : Model -> { title : String, content : Html Msg }
view _ =
    { title = "Home" 
    , content = 
        div [] 
            [ h1 [] [ text "Punchier Than An Anagram" ]
            , p [] [ text "Hi Joe" ] 
            , a [ href LoginRoute ] [ text "Login" ]
            , a [ href VideosRoute ] [ text "Videos" ]
            ]
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )

subscriptions : HomeModel -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)