module User exposing (..)

import Http
import Html exposing (Attribute)
import Html.Attributes
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline exposing (custom)
import Json.Encode as Encode
import Generic exposing (..)
-- import Storage exposing (storage, onStorageChange)
import Asset

type User
    = User Internals

type alias Internals =
    { id: ID 
    , username: String
    , token: String
    , image: Maybe String
    }


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
    Http.header "authorization" ("Token" ++ (token user))

decoder : Decoder User
decoder =
    Decode.succeed User
        |> custom internalsDecoder

internalsDecoder : Decoder Internals
internalsDecoder =
    Decode.map4 Internals
        (Decode.field  "id" Decode.string)
        (Decode.field "username" Decode.string)
        (Decode.field "token" Decode.string)
        (Decode.maybe (Decode.field "image"  Decode.string))
