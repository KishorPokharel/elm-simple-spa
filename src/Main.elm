module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Page.Login as Login
import Page.Register as Register
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string)


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url
    | GotLoginMsg Login.Msg
    | GotRegisterMsg Register.Msg


type Page
    = HomePage
    | LoginPage Login.Model
    | RegisterPage Register.Model
    | NotFound


type Route
    = Home
    | Login
    | Register


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

        LoginPage loginPageModel ->
            Login.view loginPageModel
                |> Html.map GotLoginMsg

        RegisterPage registerPageModel ->
            Register.view registerPageModel
                |> Html.map GotRegisterMsg

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
                , a [ href "/login", class "nav-link" ] [ text "Login" ]
                , a [ href "/register", class "nav-link" ] [ text "Register" ]
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

        GotLoginMsg loginPageMsg ->
            case model.page of
                LoginPage loginPageModel ->
                    toLogin model (Login.update loginPageMsg loginPageModel)

                _ ->
                    ( model, Cmd.none )

        GotRegisterMsg registerPageMsg ->
            case model.page of
                RegisterPage registerPageModel ->
                    toRegister model (Register.update registerPageMsg registerPageModel)

                _ ->
                    ( model, Cmd.none )


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
        , Parser.map Login (Parser.s "login")
        , Parser.map Register (Parser.s "register")
        ]


toLogin : Model -> ( Login.Model, Cmd Login.Msg ) -> ( Model, Cmd Msg )
toLogin model ( loginPageModel, cmd ) =
    ( { model | page = LoginPage loginPageModel }, Cmd.map GotLoginMsg cmd )


toRegister : Model -> ( Register.Model, Cmd Register.Msg ) -> ( Model, Cmd Msg )
toRegister model ( registerPageModel, cmd ) =
    ( { model | page = RegisterPage registerPageModel }, Cmd.map GotRegisterMsg cmd )


updateUrl url model =
    case Parser.parse parser url of
        Just Home ->
            ( { model | page = HomePage }, Cmd.none )

        Just Login ->
            Login.init ()
                |> toLogin model

        Just Register ->
            Register.init ()
                |> toRegister model

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )
