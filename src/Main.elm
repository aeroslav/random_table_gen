module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Canopy as T exposing (Node)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Html.Events exposing (onClick)
import Url



---- MODEL ----


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd msg )
init flags url key =
    ( Model key url, Cmd.none )



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
            [ asideMenu model
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


type Role
    = Visitor
    | User
    | Admin


type alias MenuItem =
    { label : String
    , link : Maybe String
    , classes : Maybe (List String)
    , action : Maybe Msg
    , permission : Role
    }


mainMenuItems : Node (Maybe MenuItem)
mainMenuItems =
    T.node Nothing
        [ T.node (Just (MenuItem "Explore" Nothing Nothing Nothing Visitor))
            [ T.leaf (Just (MenuItem "Tables" (Just "/tables") Nothing Nothing Visitor))
            , T.leaf (Just (MenuItem "Tags" (Just "/tags") Nothing Nothing Visitor))
            , T.leaf (Just (MenuItem "Authors" (Just "/authors") Nothing Nothing Visitor))
            ]
        , T.node (Just (MenuItem "Create" (Just "/create") (Just [ "create-link" ]) Nothing Visitor)) []
        ]


asideMenu : Model -> Html Msg
asideMenu model =
    aside [ class "column col-2" ]
        [ div [ class "logo" ] [ img [ src "/logo.svg" ] [] ]
        , renderMenu mainMenuItems
            |> ul [ class "nav" ]
        ]


renderMenu : Node (Maybe MenuItem) -> List (Html Msg)
renderMenu menuNode =
    let
        children =
            T.children menuNode
                |> List.map renderMenu
                |> List.concat

        value =
            T.value menuNode

        subMenu =
            if List.length children > 0 then
                ul [ class "nav" ] children

            else
                text ""
    in
    case value of
        Nothing ->
            [ subMenu ]

        Just val ->
            [ renderMenuItem val
            , subMenu
            ]


renderMenuItem : MenuItem -> Html Msg
renderMenuItem item =
    let
        itemClass =
            String.join " " ("nav-item" :: Maybe.withDefault [] item.classes)

        itemAction =
            Maybe.withDefault NoOp item.action

        itemLink =
            Maybe.withDefault "" item.link
    in
    li
        [ class itemClass
        , onClick itemAction
        ]
        [ a [ href itemLink ] [ text item.label ] ]



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
