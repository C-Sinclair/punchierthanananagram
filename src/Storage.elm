port module Storage exposing (storage, onStorageChange)

import Json.Decode exposing (Value)

port storage : Maybe Value -> Cmd msg

port onStorageChange : (Value -> msg) -> Sub msg
