module RectangleSide exposing (..)

{-| Demo for `axisAlignedBoundingBox` function.
-}

import Playground exposing (..)
import Collision2D exposing (Side(..))


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

    collisionSide =  
      Collision2D.rectangleSide hitbox1 hitbox2

    rectangleColor =
      if collisionSide /= Nothing then red else blue      

  in
    [ rectangle orange 90 110
        |> move 100 100
    -- Follow mouse 
    , rectangle rectangleColor 80 60
        |> move x y
    -- X axis 
    , rectangle darkGray computer.screen.width 1
    -- Y axis
    , rectangle darkGray 1 computer.screen.height
    , message ("Side " ++ (sideName collisionSide))
        |> move x (y + 10) 
    ]

sideName: Maybe Side -> String 
sideName maybeSide =
  case maybeSide of
    Just Top ->
      "top"

    Just Right ->
      "right"

    Just Bottom ->
      "bottom"

    Just Left ->
      "left"
    
    Nothing ->
      "none"


message text = 
  words black text
    |> move 0 -70


update : Computer -> Memory -> Memory
update computer memory =
    memory


main =
    Playground.game view update initialModel


