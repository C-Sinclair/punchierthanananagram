module Page.Login exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (Html, text, div, h1, label, input)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (optional)
import Json.Encode as Encode
import Route exposing (Route(..))
import Session exposing (Session(..))
import User exposing (User(..))
import Endpoints
import Generic exposing (..)

type alias Model =
    { session : Session 
    , problems : List String
    , form : Form
    }

type alias Form =
    { username : String
    , password : String
    }


type Problem 
    = InvalidEntry ValidatedField String
    | ServerError String

init : Session -> ( Model, Cmd msg )
init session =
    ( { session = session 
      , problems = []
      , form = 
        { username = ""
        , password = ""
        }
      }
    , Cmd.none
    )

view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Login" 
    , content =
        div []
            [ h1 [] [ text "Sign In"]
            , Html.form [ onSubmit SubmittedForm ] 
                [ label [] [ text "Username" ]
                , input 
                    [ onInput EnteredUsername 
                    , value model.form.username
                    ] 
                    []
                , label [] [ text "Password" ]
                , input 
                    [ onInput EnteredPassword 
                    , value model.form.password
                    , type_ "password"
                    ] 
                    []
                ]
            ]
    }

type Msg 
    = SubmittedForm
    | EnteredUsername String
    | EnteredPassword String
    | CompletedLogin (Result Http.Error User)
    | GotSession Session

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of
        SubmittedForm ->
            case validate model.form of 
                Ok validForm ->
                    ( { model | problems = [] }
                    , login validForm
                    )
                Err _ ->
                    ( { model | problems = [ "Error " ] }
                    , Cmd.none 
                    )
        EnteredUsername username ->
            updateForm (\form -> { form | username = username }) model
        EnteredPassword password ->
            updateForm (\form -> { form | password = password }) model
        CompletedLogin (Err _) ->
            ( { model | problems = [] } -- add a random problem here
            , Cmd.none
            )
        CompletedLogin (Ok user) -> 
            ( model, User.store user )
        GotSession session ->
            ( { model | session = session }
            , Route.replaceUrl (Session.navKey session) Route.Home
            )
    
updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)

type ValidatedField
    = Username
    | Password


fieldsToValidate : List ValidatedField
fieldsToValidate =
    [ Username
    , Password
    ]

type TrimmedForm
    = Trimmed Form
    
validate : Form -> Result (List Problem) TrimmedForm
validate form =
    let
        trimmedForm =
            trimFields form
    in
    case List.concatMap (validateField trimmedForm) fieldsToValidate of
        [] ->
            Ok trimmedForm
        problems ->
            Err problems

validateField : TrimmedForm -> ValidatedField -> List Problem
validateField (Trimmed form) field =
    List.map (InvalidEntry field) <|
        case field of 
            Username ->
                if String.isEmpty form.username then
                    [ "username can't be blank" ]
                else 
                    []
            Password ->
                if String.isEmpty form.password then
                    [ "password can't be blank" ]
                else 
                    []

trimFields : Form -> TrimmedForm
trimFields form =
    Trimmed
        { username = String.trim form.username 
        , password = String.trim form.password
        }

encoder : TrimmedForm -> Encode.Value
encoder (Trimmed form) = 
    Encode.object
        [ ( "username", Encode.string form.username )
        , ( "password", Encode.string form.password )
        ]
    
-- decoder : Decoder User
-- decoder =
--     Json.Decode.succeed User
--         |> custom (Json.Decode.field "image" Avatar.decoder)

login : TrimmedForm -> Cmd Msg
login form =
    Http.post 
        { url = Endpoints.login
        , expect = Http.expectJson CompletedLogin User.decoder
        , body = Http.jsonBody (encoder form) 
        }               

toSession : Model -> Session
toSession model =
    model.session
