module Page.Home exposing (Model, Msg, init, toSession, update, view)

import Html exposing (Html, h1, div, text, p, a)
import Route exposing (href, Route(..))
import Session exposing (Session(..))
import Generic exposing (..)

type alias Model = 
    { session : Session
    , loading : Bool 
    }

type Msg 
    = GotSession Session
    
init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , loading = False
      }
    , Cmd.none 
    )    

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home" 
    , content = 
        div [] 
            [ h1 [] [ text "Punchier Than An Anagram" ]
            , p [] [ text "Hi Joe" ] 
            , a [ href Login ] [ text "Login" ]
            ]
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

toSession : Model -> Session
toSession model =
    model.session 