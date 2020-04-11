module Video exposing (..)

import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, required)
import User exposing (User(..))
import Generic exposing (..)

type Video
    = Video Internals

type alias Internals = 
    { id : ID 
    , title : String
    }

title : Video -> String
title (Video internals) =
    internals.title

id : Video -> ID
id (Video internals) =
    internals.id

decoder : Decoder Video
decoder =
    Decode.succeed Video
        |> custom internalsDecoder

internalsDecoder : Decoder Internals
internalsDecoder =
    Decode.succeed Internals
        |> required "id" Decode.string
        |> required "title" Decode.string

toHtml : Video -> Html msg
toHtml video =
    Html.video [] [] 
