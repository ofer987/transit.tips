module Utility.List exposing (distinct)

import List


distinct : List a -> List a
distinct original =
    distinctInternal [] original


distinctInternal : List a -> List a -> List a
distinctInternal result remaining =
    case remaining of
        head :: tail ->
            case List.any (\item -> item == head) tail of
                True ->
                    distinctInternal result tail

                False ->
                    distinctInternal (head :: result) tail

        [] ->
            result
