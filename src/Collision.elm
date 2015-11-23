module Collision
  ( axisAlignedBoundingBox
  , circleToCircle
  , Side(Top, Right, Bottom, Left)
  , rectangleSide
  ) where

{-| Detect collision/intersection of geometry in a defined coordinate space
AKA tell me when objects are touching or overlapping

# Rectangle to rectangle
@docs axisAlignedBoundingBox, rectangleSide

# Circle to circle
@docs circleToCircle
-}


import Collision.Hitbox as Hitbox


{-| Detect collision between two Rectangles that
are axis aligned — meaning no rotation.

    rect1 = { cx = 5, cy = 5, w = 10, h = 10 }
    rect2 = { cx = 7, cy = 5, w = 10, h = 10 }

    axisAlignedBoundingBox rect1 rect2 -- True
    -- rect1 is coliding with rect2
-}
axisAlignedBoundingBox : Hitbox.Rectangle -> Hitbox.Rectangle -> Bool
axisAlignedBoundingBox rect1 rect2 =
  let
    startingPoint centerPoint length = centerPoint - (length / 2)
    x1 = startingPoint rect1.cx rect1.w
    x2 = startingPoint rect2.cx rect2.w
    y1 = startingPoint rect1.cy rect1.h
    y2 = startingPoint rect2.cy rect2.h
  in
    if x1 < x2 + rect2.w &&
       x1 + rect1.w > x2 &&
       y1 < y2 + rect2.h &&
       rect1.h + y1 > y2 then
      True
    else
      False


{-| Detect collision between two Circles

    circle1 = { cx = 5, cy = 5, radius = 5 }
    circle2 = { cx = 7, cy = 5, radius = 5 }

    circleToCircle circle1 circle2 -- True
    -- circle1 is coliding with circle2
-}
circleToCircle : Hitbox.Circle -> Hitbox.Circle -> Bool
circleToCircle circle1 circle2 =
  let
    dx = circle1.cx - circle2.cx
    dy = circle1.cy - circle2.cy
    distance = sqrt ((dx * dx) + (dy * dy))
  in
    if distance < circle1.radius + circle2.radius then
      True
    else
      False


{-| Represents sides of a Rectangle
-}
type Side
  = Top
  | Right
  | Bottom
  | Left


{-| Detect which side of a Rectangle is colliding with another Rectangle

    rect1 = { cx = 5, cy = 5, w = 10, h = 10 }
    rect2 = { cx = 7, cy = 5, w = 10, h = 10 }

    rectangleSide rect1 rect2 -- Just Right
    -- rect1 is coliding with it's right side onto rect2

Current implementation note: this algorithm is very efficient but
has some issues handling corner to corner collision, I'm planning on a
way to solve this on a next release. Right now just know that
corner to corner collision may not get reported at all
-}
rectangleSide : Hitbox.Rectangle -> Hitbox.Rectangle -> Maybe Side
rectangleSide rect1 rect2 =
  {-
    Calculate which side of a rectangle is colliding w/ another, it works by
    getting the Minkowski sum of rect2 and rect1, then checking where the centre of
    rect1 lies relatively to the new rectangle (from Minkowski) and to its diagonals
    * thanks to sam hocevar @samhocevar for the formula!
  -}
  let
    w = 0.5 * (rect1.w + rect2.w)
    h = 0.5 * (rect1.h + rect2.h)
    dx = rect2.cx - rect1.cx
    dy = rect2.cy - rect1.cy
    wy = w * dy
    hx = h * dx

  in
    if abs dx <= w && abs dy <= h then
      if (wy > hx) then
        if (wy > -hx) then
          Just Top
        else
          Just Left
      else
        if (wy > -hx) then
          Just Right
        else
          Just Bottom
    else
      Nothing
