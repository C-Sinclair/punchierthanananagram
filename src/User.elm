module User exposing (..)

import Asset
import Http
import Html exposing (Attribute)
import Html.Attributes
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline exposing (custom)
import Json.Encode as Encode
import Storage exposing (onStorageChange, storage)
import Types exposing (..)

id : User -> ID
id (User internals) =
    internals.id

username : User -> String
username (User internals) =
    internals.username

token : User -> String
token (User internals) =
    internals.token

image : User -> Maybe String
image (User internals) =
    internals.image

imageSrc : User -> Attribute msg
imageSrc (User internals) =
    case internals.image of
        Just img ->
            Html.Attributes.src img
        Nothing ->
            Asset.src Asset.defaultAvatar

header : User -> Http.Header
header user =
    Http.header "authorization" ("Token" ++ token user)

decoder : Decoder User
decoder =
    Decode.succeed User
        |> custom internalsDecoder

internalsDecoder : Decoder UserInternals
internalsDecoder =
    Decode.map4 UserInternals
        (Decode.field  "id" Decode.string)
        (Decode.field "username" Decode.string)
        (Decode.field "token" Decode.string)
        (Decode.maybe (Decode.field "image"  Decode.string))

changes : (Maybe User -> msg) -> Sub msg
changes toMsg =
    onStorageChange (\value -> toMsg (decodeFromChange value))

decodeFromChange : Value -> Maybe User
decodeFromChange val =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    Decode.decodeValue (Decode.field "user" decoder) val
        |> Result.toMaybe


store : User -> Cmd msg
store user =
    let
        json =
            Encode.object
                [ ( "user"
                  , Encode.object
                        [ ( "id", Encode.string (id user) )
                        , ( "username", Encode.string (username user) )
                        , ( "token", Encode.string (token user) )
                        , ( "image", Encode.string (Maybe.withDefault "" (image user)) )
                        ]
                  )
                ]
    in
    storage (Just json)
