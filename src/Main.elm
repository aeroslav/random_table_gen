module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Canopy as T exposing (Node)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Html.Events exposing (onClick)
import Role exposing (Role(..))
import SideMenu as Aside exposing (MenuItem, MenuTree)
import Url



---- MODEL ----


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , menuItems : MenuTree Msg
    }


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd msg )
init flags url key =
    ( getModel key url, Cmd.none )


getModel : Nav.Key -> Url.Url -> Model
getModel key url =
    Model key url mainMenuItems


mainMenuItems : MenuTree msg
mainMenuItems =
    T.node Nothing
        [ T.node (Just (MenuItem "Explore" Nothing Nothing Nothing Visitor))
            [ T.leaf (Just (MenuItem "Tables" (Just "/tables") Nothing Nothing Visitor))
            , T.leaf (Just (MenuItem "Tags" (Just "/tags") Nothing Nothing Visitor))
            , T.leaf (Just (MenuItem "Authors" (Just "/authors") Nothing Nothing Visitor))
            ]
        , T.node (Just (MenuItem "Create" (Just "/create") (Just [ "create-link" ]) Nothing Visitor)) []
        ]



---- UPDATE ----


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External str ->
                    ( model, Nav.load str )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- SUBS ----


subscription : Model -> Sub msg
subscription _ =
    Sub.none



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "RanGen"
    , body =
        [ div [ class "wrapper columns" ]
            [ Aside.asideMenu model
            , main_ [ class "column col-10" ]
                [ div []
                    [ a
                        [ href "/link"
                        , class "link"
                        ]
                        [ text "click me" ]
                    ]
                ]
            ]
        ]
    }



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscription
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
