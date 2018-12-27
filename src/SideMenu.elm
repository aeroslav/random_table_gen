module SideMenu exposing (MenuItem, MenuTree, asideMenu, mainMenuItems, renderMenu, renderMenuItem)

import Canopy as T exposing (Node)
import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Html.Events exposing (onClick)
import Types exposing (..)



---- MODEL ----


type alias MenuTree msg =
    Node (Maybe (MenuItem msg))


type alias MenuItem msg =
    { label : String
    , link : Maybe String
    , classes : Maybe (List String)
    , action : Maybe msg
    , permission : Role
    }


mainMenuItems : MenuTree msg
mainMenuItems =
    T.node Nothing
        [ T.node (Just (MenuItem "Explore" Nothing Nothing Nothing Visitor))
            [ T.leaf (Just (MenuItem "Tables" (Just "/tables") Nothing Nothing Visitor))
            , T.leaf (Just (MenuItem "Tags" (Just "/tags") Nothing Nothing Visitor))
            , T.leaf (Just (MenuItem "Authors" (Just "/authors") Nothing Nothing Visitor))
            ]
        , T.node (Just (MenuItem "Create" (Just "/create") (Just [ "create-link" ]) Nothing Visitor)) []
        , T.node (Just (MenuItem "Profile" (Just "/profile") Nothing Nothing Visitor)) []
        ]


asideMenu : { model | menuItems : MenuTree msg } -> Html msg
asideMenu model =
    aside [ class "column col-2 bg-secondary" ]
        [ div [ class "logo" ] [ img [ src "/logo.svg" ] [] ]
        , renderMenu model.menuItems
            |> ul [ class "nav" ]
        ]


renderMenu : MenuTree msg -> List (Html msg)
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


renderMenuItem : MenuItem msg -> Html msg
renderMenuItem item =
    let
        itemClass =
            [ class <| String.join " " ("nav-item" :: Maybe.withDefault [] item.classes) ]

        linkAction =
            case item.action of
                Just action ->
                    [ onClick action ]

                Nothing ->
                    []

        linkHref =
            [ href (Maybe.withDefault "" item.link) ]

        linkAttrs =
            List.concat [ linkHref, linkAction ]
    in
    li
        itemClass
        [ a
            linkAttrs
            [ text item.label ]
        ]
