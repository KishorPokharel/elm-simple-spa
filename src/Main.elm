module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string)


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url


type Page
    = HomePage
    | AboutPage
    | ContactPage
    | NotFound


type Route
    = Home
    | About
    | Contact


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    updateUrl url { key = key, page = HomePage }


view : Model -> Document Msg
view model =
    { title = "My Elm SPA"
    , body =
        [ viewHeader
        , main_ [ class "main-content" ]
            [ loadPage model
            ]
        , viewFooter
        ]
    }


loadPage : Model -> Html Msg
loadPage model =
    case model.page of
        HomePage ->
            viewHomePage

        AboutPage ->
            text "About page"

        ContactPage ->
            text "Contact page"

        NotFound ->
            text "Notfound"


viewHomePage : Html Msg
viewHomePage =
    div []
        [ h1 [] [ text "Home Page" ]
        , p [] [ text "Elit voluptates corrupti itaque accusamus assumenda. Animi quod adipisci ullam possimus nam? Quaerat nihil distinctio alias amet quidem." ]
        , p [] [ text "Distinctio unde nemo facere a dolor, aut consequatur perspiciatis aliquid Quos dicta iure praesentium vel voluptatibus! Ut quibusdam enim velit ea laboriosam?" ]
        , p [] [ text "Amet veniam placeat accusantium quaerat nemo Sunt molestias voluptas sunt qui consequatur Tenetur temporibus praesentium odio quam at Magnam harum aut qui porro molestias Nihil repudiandae quae fuga et repellendus Atque earum ad dolorum aspernatur iusto. Deserunt saepe et perspiciatis." ]
        , p [] [ text "Elit voluptates corrupti itaque accusamus assumenda. Animi quod adipisci ullam possimus nam? Quaerat nihil distinctio alias amet quidem. Distinctio unde nemo facere a dolor, aut consequatur perspiciatis aliquid Quos dicta iure praesentium vel voluptatibus! Ut quibusdam enim velit ea laboriosam?" ]
        , p [] [ text "Distinctio unde nemo facere a dolor, aut consequatur perspiciatis aliquid Quos dicta iure praesentium vel voluptatibus! Ut quibusdam enim velit ea laboriosam?" ]
        , p [] [ text "Amet veniam placeat accusantium quaerat nemo Sunt molestias voluptas sunt qui consequatur Tenetur temporibus praesentium odio quam at Magnam harum aut qui porro molestias Nihil repudiandae quae fuga et repellendus Atque earum ad dolorum aspernatur iusto. Deserunt saepe et perspiciatis." ]
        , p [] [ text "Elit voluptates corrupti itaque accusamus assumenda. Animi quod adipisci ullam possimus nam? Quaerat nihil distinctio alias amet quidem. Distinctio unde nemo facere a dolor, aut consequatur perspiciatis aliquid Quos dicta iure praesentium vel voluptatibus! Ut quibusdam enim velit ea laboriosam?" ]
        ]


viewFooter : Html Msg
viewFooter =
    footer [] [ p [] [ text "One is never alone with a rubber duck. - Doublas Adams" ] ]


viewHeader : Html Msg
viewHeader =
    header []
        [ nav []
            [ h3 [] [ text "Elm SPA" ]
            , div [ class "nav-links" ]
                [ a [ href "/", class "nav-link" ] [ text "Home" ]
                , a [ href "/about", class "nav-link" ] [ text "About" ]
                , a [ href "/contact", class "nav-link" ] [ text "Contact" ]
                ]
            ]
        ]


update msg model =
    case msg of
        ClickedLink urlRequest ->
            case urlRequest of
                Browser.External href ->
                    ( model, Nav.load href )

                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

        ChangedUrl url ->
            updateUrl url model


subscriptions model =
    Sub.none


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map About (Parser.s "about")
        , Parser.map Contact (Parser.s "contact")
        ]


updateUrl url model =
    case Parser.parse parser url of
        Just Home ->
            ( { model | page = HomePage }, Cmd.none )

        Just About ->
            ( { model | page = AboutPage }, Cmd.none )

        Just Contact ->
            ( { model | page = ContactPage }, Cmd.none )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )
