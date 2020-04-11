module Page.Video exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Http
import Html exposing (Html, section, header, footer, text)
import Session exposing (Session(..))
import Video exposing (Video(..))
import Route exposing (Route(..))
import Endpoints as Endpoint
import Generic exposing (..)

type alias Model =
    { session : Session 
    , video : Status Video
    }

type Msg 
    = CompletedLoadVideo (Result Http.Error Video)
    | GotSession Session

init : Session -> ID -> ( Model, Cmd Msg )
init session id =
    ( { session = session
      , video = Loading
      }
    , fetch id
    )

view : Model -> { title : String, content : Html Msg }
view model =
    case model.video of 
        Loaded video ->
            let
                title =
                    Video.title video
            in
            { title = title 
            , content =
                section [] 
                    [ header [] []
                    , Video.toHtml video
                    , footer [] []
                    ]
            }
        Loading ->
            { title = "Video", content = text "Loading..." }
        Failed ->
            { title = "Video", content = text "Error" }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model=
    case msg of
        CompletedLoadVideo (Ok video) ->
            ( { model | video = Loaded video }, Cmd.none )
        CompletedLoadVideo (Err _) ->
            ( { model | video = Failed }, Cmd.none )
        GotSession session ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.Home
            )

subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)

toSession : Model -> Session
toSession model =
    model.session

fetch : ID -> Cmd Msg
fetch id =
    Http.get 
        { url = Endpoint.video id
        , expect = Http.expectJson CompletedLoadVideo Video.decoder
        }