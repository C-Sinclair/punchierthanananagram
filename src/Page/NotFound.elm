module Page.NotFound exposing (view)

import Html exposing (Html, h4, text, div, p)

view : { title : String, content : Html msg } 
view =
    { title = "Page No Exist"
    , content = 
        div []
            [ h4 [] [ text "Ooops, no page here!" ]
            , p [] [ text "Probably your fault, try again?" ]
            ]
    }
