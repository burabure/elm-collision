module Rectangles exposing (..)

{-| Demo for `axisAlignedBoundingBox` function.
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
      Collision2D.rectangle x y 80 60

    hitbox2 = 
      Collision2D.rectangle 100 100 90 110

    colliding =  
      Collision2D.axisAlignedBoundingBox hitbox1 hitbox2

    rectangleColor =
      if colliding then red else blue

  in
    [ rectangle rectangleColor 90 110
        |> move 100 100
    -- Follow mouse 
    , rectangle orange 80 60
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


