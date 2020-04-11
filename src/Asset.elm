module Asset exposing (..)

import Html exposing (Attribute)
import Html.Attributes as Attr

type Image 
    = Image String

error : Image
error =
    image "error.jpg"

loading : Image
loading =
    image "loading.svg"

defaultAvatar : Image
defaultAvatar = 
    image "smiley-cyrus.jpg"

image : String -> Image 
image filename =
    Image ("/assets/images/" ++ filename)

src : Image -> Attribute msg
src (Image url) =
    Attr.src url