module Types exposing (..)

import Browser.Navigation as Nav
import Url exposing (Url)
import RemoteData exposing (WebData)
import Browser

type Msg 
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMsg HomeMsg
    | GotLoginMsg LoginMsg
    | GotVideosMsg VideosMsg
    | GotSession Session

type HomeMsg
    = HomeMsg Msg

type LoginMsg
    = SubmittedForm
    | EnteredUsername String
    | EnteredPassword String
    | CompletedLogin (WebData User)

type VideosMsg
    = FetchVideos
    | VideosReceived (WebData (List Video))
    | ClickedVideo Video

type alias ID
    = String

type Status a
    = Loading
    | Loaded a
    | Failed

type Video
    = Video VideoInternals

type alias VideoInternals = 
    { id : ID 
    , title : String
    }

type User
    = User UserInternals

type alias UserInternals =
    { id: ID 
    , username: String
    , token: String
    , image: Maybe String
    }

type Session
    = LoggedIn Nav.Key User
    | Guest Nav.Key
    
type Model 
    = Home HomeModel
    | Login LoginModel
    | Videos VideosModel

type alias HomeModel =
    { session : Session
    }

type alias VideosModel =
    { videos : WebData (List Video) 
    , session : Session
    }

type alias LoginModel =
    { problems : List Problem
    , form : Form
    , session : Session
    }

type alias Form =
    { username : String
    , password : String
    }

type TrimmedForm
    = Trimmed Form

type ValidatedField
    = Username
    | Password

type Problem 
    = InvalidEntry ValidatedField String
    | ServerError String

type Image 
    = Image String

type Route 
    = Redirect Session
    | HomeRoute
    | LoginRoute
    | VideosRoute
    -- | Video String