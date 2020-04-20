module App exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Json.Decode exposing (Value)
import Url exposing (Url)
import Session
import Route
import Page.Home as Home
import Page.Login as Login
import Page.Videos as Videos
-- import Page.NotFound as NotFound
import Types exposing (..)

init : Maybe User -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeUser url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.fromUser navKey maybeUser))

view : Model -> Document Msg
view model =
    let
        { title, body } =
            case model of
                Home _ ->
                    Home.view model
                Login _ ->
                    Login.view model
                Videos _ ->
                    Videos.view model
    in
    { title = title
    , body = body
    }

toSession : Model -> Session
toSession model =
    case model of
        Home home ->
            home.session 
        Login login ->
            login.session
        Videos videos ->
            videos.session


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Just HomeRoute ->
            Home.init session
        Just LoginRoute ->
            Login.init session
        Just VideosRoute ->
            Videos.init session
        _ ->
            ( model, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                    )
                Browser.External href ->
                    ( model
                    , Nav.load href
                    )
        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model
        ( GotLoginMsg subMsg, Login login ) ->
            Login.update subMsg login
        ( GotHomeMsg subMsg, Home home ) ->
            Home.update subMsg home
        ( GotVideosMsg subMsg, Videos videos ) ->
            Videos.update subMsg videos
        ( GotSession session, Redirect _ ) ->
            ( Redirect session
            , Route.replaceUrl (Session.navKey session) HomeRoute
            )
        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Home home ->
            Sub.map GotHomeMsg (HomeMsg (Home.subscriptions home))
        Login login ->
            Sub.map GotLoginMsg (Login.subscriptions login)
        Videos videos ->
            Sub.map GotVideosMsg (Videos.subscriptions videos)

main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , view = view
        , update = update
        , subscriptions = subscriptions
        }