module Utility.Task exposing (flow)

import List
import Task exposing (Task)

{-| Start with a list of tasks, and turn them into a single task that returns a
list. The tasks will be run in order one-by-one but ignore the tasks that fail.
sequence [ succeed 1, succeed 2 ] -- succeed [ 1, 2 ]
This can be useful if you need to make a bunch of HTTP requests one-by-one, and ignore the ones that fail.
-}
flow : List (Task x a) -> Task x (List a)
flow tasks =
    tasks
        |> List.map (Task.map Just)
        |> List.map (Task.onError (\_ -> Task.succeed Nothing))
        |> Task.sequence
        |> Task.map (List.filterMap identity)
