module Video exposing (..)

import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, required)
import Types exposing (..)

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

internalsDecoder : Decoder VideoInternals
internalsDecoder =
    Decode.succeed VideoInternals
        |> required "id" Decode.string
        |> required "title" Decode.string

toHtml : Video -> Html msg
toHtml video =
    Html.video [] [] 
