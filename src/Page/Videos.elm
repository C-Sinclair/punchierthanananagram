module Page.Videos exposing (init, subscriptions, toSession, update, view)

import Api
import Html exposing (Html, text, h3)
import Session
import RemoteData
import Types exposing (..)

init : Session -> ( VideosModel, Cmd VideosMsg )
init session =
    ( VideosModel RemoteData.NotAsked session
    , Api.fetchVideos
    )

view : VideosModel -> { title : String, content : Html VideosMsg }
view model =
    let 
        content =
            case model.videos of 
                RemoteData.NotAsked ->
                    text ""
                RemoteData.Loading ->
                    h3 [] [ text "Loading..." ]
                RemoteData.Success videos ->
                    text ("Videos received = " ++ String.fromInt (List.length videos))
                RemoteData.Failure httpError ->
                    text (Api.buildErrorMessage httpError)
    in
    { title = "Video Gallery"
    , content = content
    }

update : VideosMsg -> VideosModel -> ( VideosModel, Cmd VideosMsg )
update msg model =
    case msg of 
        FetchVideos ->
            ( model, Api.fetchVideos )
        VideosReceived response ->
            ( { model | videos = response }, Cmd.none )
        ClickedVideo _ ->
            ( model, Cmd.none )

subscriptions : VideosModel -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)

toSession : VideosModel -> Session
toSession model =
    model.session
