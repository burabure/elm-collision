module Circles exposing (..)

{-| Demo for `circleToCircle` function.
-}

import Playground exposing (..)
import Collision2D 


type alias Memory = 
  ()


initialModel: Memory
initialModel =
  ()


view : Computer -> Memory -> List Shape
view computer memory =
  let
    (x, y) =
      (computer.mouse.x, computer.mouse.y)

    hitbox1 =  
      Collision2D.circle x y 30

    hitbox2 = 
      Collision2D.circle 100 100 40

    colliding =  
      Collision2D.circleToCircle hitbox1 hitbox2

    circleColor =
      if colliding then red else blue

  in
    [ circle circleColor 40 
        |> move 100 100
    -- Follow mouse 
    , circle orange 30 
        |> move x y
    -- X axis 
    , rectangle darkGray computer.screen.width 1
    -- Y axis
    , rectangle darkGray 1 computer.screen.height
    , message <| "Mouse position " ++ (String.fromFloat x) ++ ";" ++ (String.fromFloat y)
    ]


message text = 
  words black text
    |> move 0 -150


update : Computer -> Memory -> Memory
update computer memory =
    memory


main =
    Playground.game view update initialModel


