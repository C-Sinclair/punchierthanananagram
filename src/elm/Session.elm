module Session exposing (Session(..), init, user, token, navKey, changes, fromUser)

import User exposing (User(..))
import Browser.Navigation as Nav

type Session
    = LoggedIn Nav.Key User
    | Guest Nav.Key

init : Maybe User -> Nav.Key -> Session
init maybeUser key =
    case maybeUser of
        Just u ->
            LoggedIn key u
        Nothing ->            
            Guest key

user : Session -> Maybe User
user session =
    case session of
        LoggedIn _ val ->
            Just val
        Guest _ -> 
            Nothing

token : Session -> Maybe String
token session =
    case session of
        LoggedIn _ val ->
            Just (User.token val)
        Guest _ -> 
            Nothing

navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key

changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    User.changes (\maybeViewer -> toMsg (fromUser key maybeViewer))

fromUser : Nav.Key -> Maybe User -> Session
fromUser key maybeViewer =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    case maybeViewer of
        Just viewerVal ->
            LoggedIn key viewerVal

        Nothing ->
            Guest key
