module View.Loading exposing (view)

import Html.Styled exposing (Html, styled, div)
import Html.Styled.Attributes exposing (id, class)
import Model exposing (Msg)


view : Html Msg
view =
    div
        [ id "fountainG" ]
        [ div [ id "fountainG_1", class "fountainG" ] []
        , div [ id "fountainG_2", class "fountainG" ] []
        , div [ id "fountainG_3", class "fountainG" ] []
        , div [ id "fountainG_4", class "fountainG" ] []
        , div [ id "fountainG_5", class "fountainG" ] []
        , div [ id "fountainG_6", class "fountainG" ] []
        , div [ id "fountainG_7", class "fountainG" ] []
        , div [ id "fountainG_8", class "fountainG" ] []
        ]
