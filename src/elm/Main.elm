module App exposing (..)

import Html exposing (Html, main_)
import Html.Attributes exposing (id)
import Json.Decode exposing (Value)
import Browser exposing (Document)
import Browser.Navigation as Nav
import Url exposing (Url)
import User exposing (User(..))
import Session as Session exposing (Session(..))
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Login as Login
import Page.Video as Video
import Generic exposing (..)
import Route exposing (Route(..))

type Model
    = Home Home.Model
    | Login Login.Model
    | Video Video.Model 

type Msg 
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | HomeMsg Home.Msg
    | LoginMsg Login.Msg
    | VideoMsg Video.Msg

init : Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( { route = Route.fromUrl url 
      , session = Session.init Nothing navKey
      }
    , Cmd.none
    )

view : Model -> Document Msg 
view model =
    let
        { title, content } =
            page model
    in
    { title = title 
    , body =
        [ main_ [ id "root" ] 
            [ content ]
        ]
    }

page : Model -> { title : String, content : Html Msg }
page model =
    case model of
        Home _ ->
            Home.view model
        Login _ ->
            Login.view model
        Video _ -> 
            Video.view model
    
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        ClickedLink urlRequest ->
            case urlRequest of 
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl (Session.navKey model.session) (Url.toString url) 
                    )
                Browser.External href ->
                    ( model
                    , Nav.load href 
                    )

        ChangedUrl url ->
            change (Route.fromUrl url) model

        HomeMsg subMsg ->
            Home.update subMsg model

        LoginMsg subMsg ->
            Login.update subMsg model

        VideoMsg subMsg ->
            Video.update subMsg model

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

toSession : Model -> Session
toSession model =
    model.session
   
change : Maybe Route -> Model -> ( Model, Cmd Msg )
change maybeRoute model = 
     let 
        session = 
            toSession model
    in
    case maybeRoute of 
        Nothing -> 
            ( model, Cmd.none )
        Just Route.Home -> 
            Home.init session
        Just Route.Login ->
            Login.init session
        Just (Route.Video id) -> 
            Video.init session id

main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , view = view 
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }