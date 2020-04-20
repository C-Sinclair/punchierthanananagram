module Page.Login exposing (init, subscriptions, update, view)

import Html exposing (Html, text, div, h1, label, input)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Api
import RemoteData
import Json.Encode as Encode
import Session
import User
import Types exposing (..)

init : Session -> ( Model, Cmd Msg )
init session =
    ( Login ( LoginModel [] { username = "", password = "" } session )
    , Cmd.none
    )

view : LoginModel -> { title : String, content : Html LoginMsg }
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

update : LoginMsg -> LoginModel -> ( LoginModel, Cmd LoginMsg )
update msg model = 
    case msg of
        SubmittedForm ->
            case validate model.form of 
                Ok validForm ->
                    ( { model | problems = [] }
                    , Api.login (encoder validForm)
                    )
                Err _ ->
                    ( { model | problems = [ ServerError "Error " ] }
                    , Cmd.none 
                    )
        EnteredUsername username ->
            updateForm (\form -> { form | username = username }) model
        EnteredPassword password ->
            updateForm (\form -> { form | password = password }) model
        CompletedLogin response -> 
            case response of
                RemoteData.Success user ->
                    ( model, User.store user )
                _ ->
                    ( model, Cmd.none )     
    
updateForm : (Form -> Form) -> LoginModel -> ( LoginModel, Cmd LoginMsg )
updateForm transform model =
    ( { model | form = transform model.form }, Cmd.none )

subscriptions : HomeModel -> Sub Msg
subscriptions model =
    Session.changes GotSession (Session.navKey model.session)


fieldsToValidate : List ValidatedField
fieldsToValidate =
    [ Username
    , Password
    ]
    
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
