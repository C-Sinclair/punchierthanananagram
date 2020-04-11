module Generic exposing (..)

type alias ID
    = String

type Status a
    = Loading
    | Loaded a
    | Failed
