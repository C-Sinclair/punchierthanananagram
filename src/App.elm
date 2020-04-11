module App exposing (..)

import Browser exposing (Document)
import Endpoint
import Html exposing (Html, text, h3)
import Http
import Json.Decode exposing (Value, list)
import RemoteData exposing (WebData, RemoteData)
import Url exposing (Url)
import User exposing (User(..))
import Video exposing (Video(..))

type alias Model =
    { videos : WebData (List Video) 
    , user : Maybe User
    }

emptyModel : Model
emptyModel = 
    { videos = RemoteData.NotAsked
    , user = Nothing
    }

type Msg 
    = FetchVideos
    | VideosReceived (WebData (List Video))
    | ClickedVideo Video

init : () -> ( Model, Cmd Msg )
init _ =
    -- check if url contains specific video here
    ( emptyModel, fetchVideos )

fetchVideos : Cmd Msg
fetchVideos =
    Http.get 
        { url = Endpoint.videos
        , expect = 
            list Video.decoder
                |> Http.expectJson (RemoteData.fromResult >> VideosReceived)
        }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        FetchVideos ->
            ( model, fetchVideos )
        VideosReceived response ->
            ( { model | videos = response }, Cmd.none )
        ClickedVideo target ->
            ( model, Cmd.none )

view : Model -> Html Msg 
view model =
    case model.videos of 
        RemoteData.NotAsked ->
            text ""
        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]
        RemoteData.Success videos ->
            text ("Videos received = " ++ String.fromInt (List.length videos))
        RemoteData.Failure httpError ->
            text (buildErrorMessage httpError)

buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message
        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."
        Http.NetworkError ->
            "Unable to reach server."
        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode
        Http.BadBody message ->
            message

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }