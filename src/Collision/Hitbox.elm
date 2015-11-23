module Collision.Hitbox
  (Rectangle
  , rectangle
  , Circle
  , circle
  ) where

{-| Define and create hitbox geometry to test for collisions.
All objects use the same coordinate system you might see in an algebra or
physics problem, origin (0,0) is at the center of the object,
so they're compatible with the core Graphics.Collage coordinate system.

# Basic geometry
@docs Rectangle, rectangle, Circle, circle
-}


{-| Represents rectangular hitbox geometry.
You should only use this type for type annotations, don't depend on the constructor
instead, use the rectangle function

    -- GOOD
    myRectangle : Hitbox.Rectangle
    myRectangle =
      rectangle 5 5 10 10

    -- BAD
    myRectangle : Hitbox.Rectangle
    myRectangle =
      Rectangle 5 5 10 10

Using the rectangle function will keep your code working if there's an
internal change on the Rectangle type definition
-}
type alias Rectangle = { cx: Float, cy: Float, w : Float, h : Float }


{-| Create a Rectangle hitbox from geometry (width and height) and coordinates (x, y)

    rectangle 5 5 10 10 -- a 10 x 10 rectangle centered on coordinates 5,5
-}
rectangle : Float -> Float -> Float -> Float -> Rectangle
rectangle centerX centerY width height =
  { cx = centerX, cy = centerY, w = width, h = height }


{-| Represents circular geometry.
You should only use this type for type annotations, don't depend on the constructor
instead, use the circle function

    -- GOOD
    myCircle : Hitbox.Circle
    myCircle =
      circle 5 5 10 10

    -- BAD
    myCircle : Hitbox.Circle
    myCircle =
      Hitbox.Circle 5 5 10 10

Using the circle function will keep your code working if there's an
internal change on the Circle type definition
-}
type alias Circle = { cx: Float, cy: Float, radius : Float }


{-| Create a Circle Hitbox from geometry (radius) and coordinates (x, y)

    circle 5 5 10 -- a radius 10 circle centered on coordinates 5,5
-}
circle : Float -> Float -> Float -> Circle
circle centerX centerY radius =
  { cx = centerX, cy = centerY, radius = radius }
