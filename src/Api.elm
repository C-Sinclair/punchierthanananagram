module Api exposing (..)

import Http
import Json.Decode exposing (list)
import Json.Encode exposing (Value)
import RemoteData
import Endpoint
import User
import Video
import Types exposing (..)

fetchVideos : Cmd VideosMsg
fetchVideos =
    Http.get 
        { url = Endpoint.videos
        , expect = 
            list Video.decoder
                |> Http.expectJson (RemoteData.fromResult >> VideosReceived)
        }
        
login : Value -> Cmd LoginMsg
login form =
    Http.post 
        { url = Endpoint.login
        , expect = User.decoder
            |> Http.expectJson (RemoteData.fromResult >> CompletedLogin) 
        , body = Http.jsonBody form 
        }       
    
buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message
        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."
        Http.NetworkError ->
            "Unable to reach server."
        Http.BadStatus statusCode ->
            "Request failed with status code: " ++ String.fromInt statusCode
        Http.BadBody message ->
            message