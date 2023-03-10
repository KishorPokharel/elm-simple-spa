module Page.Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, type_, value)


type alias Model =
    {}


type Msg
    = NoOp


view : Model -> Html Msg
view model =
    div [ class "login-form" ]
        [ h2 [] [ text "Login" ]
        , form []
            [ div []
                [ label [] [ text "Email" ]
                , input [ type_ "email" ] []
                ]
            , div []
                [ label [] [ text "Password" ]
                , input [ type_ "password" ] []
                ]
            , div []
                [ input [ type_ "submit", value "Login" ] []
                ]
            ]
        ]


init : () -> ( Model, Cmd Msg )
init flags =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- main : Program () Model Msg
-- main =
--     Browser.element
--         { init = init
--         , view = view
--         , update = update
--         , subscriptions = subscriptions
--         }
