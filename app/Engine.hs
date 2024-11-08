module Engine where 

import Chess as C  
import Data.Array as D
import Data.Maybe

--Evaluator works the following way: lookup table for the value of a piece on a certain square. 
--Sum these for all pieces on the board, + for engines, - for opponent.
pawnValues :: Array (Int, Int) Float
knightValues :: Array (Int, Int) Float 
bishopValues :: Array (Int, Int) Float
rookValues :: Array (Int, Int) Float
queenValues :: Array (Int, Int) Float
kingValues :: Array (Int, Int) Float

pawnValues = D.listArray ((0,0), (7,7)) [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
  5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0, 5.0,
  1.0, 1.0, 2.0, 3.0, 3.0, 2.0, 1.0, 1.0, 
  0.5, 0.5, 1.0, 2.5, 2.5, 1.0, 0.5, 0.5,
  0.0, 0.0, 0.0, 2.0, 2.0, 0.0, 0.0, 0.0, 
  0.5, -0.5, -1.0, 0.0, 0.0, -1.0, -0.5, 0.5, 
  0.5, 1.0, 1.0, -2.0, -2.0, 1.0, 1.0, 0.5, 
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]

knightValues = D.listArray ((0,0), (7,7)) [ -5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0,
  -4.0, -2.0, 0.0, 0.0, 0.0, 0.0, -2.0, -4.0, 
  -3.0, 0.0, 1.0, 1.5, 1.5, 1.0, 0.0, -3.0,
  -3.0, 0.5, 1.5, 2.0, 2.0, 1.5, 0.5, -3.0, 
  -3.0, 0.0, 1.5, 2.0, 2.0, 1.5, 0.0, -3.0,
  -3.0, 0.5, 1.0, 1.5, 1.5, 1.5, 1.0, 0.5, -3.0,
  -4.0, -2.0, 0.0, 0.5, 0.5, 0.0, -2.0, -4.0,
  -5.0, -4.0, -3.0, -3.0, -3.0, -4.0, -5.0]

bishopValues = D.listArray ((0,0), (7,7)) [ -2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0,
  -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0,
  -1.0, 0.0, 0.5, 1.0, 1.0, 0.5, 0.0, -1.0, 
  -1.0, 0.5, 0.5, 1.0, 1.0, 0.5, 0.5, -1.0, 
  -1.0, 0.0, 1, 1, 1, 1, 0.0, -1.0,
  -1.0, 1, 1, 1, 1, 1, 1, -1.0,
  -1.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.5, -1.0, 
  -2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0]

rookValues = D.listArray ((0,0), (7,7)) [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
  0.5, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.5,
  -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5,
  -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5, 
  -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5,
  -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5,
  -0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.5, 
  0.0, 0.0, 0.0, 0.5, 0.5, 0.0, 0.0, 0.0]

queenValues = D.listArray ((0,0), (7,7)) [-2.0, -1.0, -1, -0.5, -0.5, -1, -1, -2.0
  -1, 0, 0, 0, 0, 0, 0, -1,
  -1, 0, 0.5, 0.5, 0.5, 0.5, 0, -1,
  -0.5, 0, 0.5, 0.5, 0.5, 0.5, 0, -0.5, 
  0, 0, 0.5, 0.5, 0.5, 0.5, 0, -0.5, 
  -1, 0.5, 0.5, 0.5, 0.5, 0.5, 0, -1 
  -1, 0, 0.5, 0, 0, 0, 0, -1 
  -2, -1, -1, -0.5, -0.5, -1, -1, -2]

kingValues = D.listArray ((0,0), (7,7)) [-3, -4, -4, -5, -5, -4, -4, -3, 
  -3, -4, -4, -5, -5, -4, -4, -3, 
  -3, -4, -4, -5, -5, -4, -4, -3, 
  -3, -4, -4, -5, -5, -4, -4, -3, 
  -2, -3, -3, -4, -4, -3, -3, -2, 
  -1, -2, -2, -2, -2, -2, -2, -1,
  2, 2, 0, 0, 0, 0, 2, 2, 
  2, 3, 1, 0, 0, 1, 3, 2]

--Rose tree to represent the possible board states of the game.
data Rose a = MkRose a [Rose a] | Leaf a 

--Proof of Concept in easiest way: assign a piece a value for being on a square.
--Nog toe te voegen: Evaluator for het einde van de game.
evaluateBoard :: C.GameState -> C.Color -> Float 
evaluateBoard state engineColor 
  | isDraw state || isStalemate state = 0.0
  | isCheckmate state                 = 
    let winColor = (fromJust . winner) state 
    in 
      if winColor == engineColor 
        then 1000000 
        else -1000000 
  | otherwise                         = 
      let pieces = zip createCoordinateList $ (D.elems . board) state 
      in foldr (+) 0 $ map ((flip evaluateSquare) engineColor) pieces 

evaluateSquare :: ((Int, Int), Square) -> C.Color -> Float 
evaluateSquare (_, Empty) _ = 0
evaluateSquare (ix, Square (Piece color piece)) engineColor = 
  let val = case piece of 
              Pawn   -> pawnValues   ! ix
              Knight -> knightValues ! ix
              Bishop -> bishopValues ! ix
              Rook   -> rookValues   ! ix
              Queen  -> queenValues  ! ix
              King   -> kingValues   ! ix
  in 
    if color == engineColor
      then val
      else -val

createCoordinateList :: [(Int, Int)]
createCoordinateList = countUp 0 0  
  where 
    countUp :: Int -> Int -> [(Int, Int)]
    countUp 7 7 = []
    countUp x 7 = (x, 7) : (countUp (x+1) 0)
    countUp x y = (x, y) : (countUp (x) (y+1))

--Invariant: depth > 0 
createGameTree :: C.GameState -> Int -> Rose C.GameState
createGameTree state 1     = Leaf state 
createGameTree state depth = 
  let moves = legalMoves state
      newStates = map (fromJust . (applyMove state)) moves
  in MkRose state (map ((flip createGameTree) (depth -1)) newStates)

minimax :: C.GameState -> C.Color -> Rose Float 
minimax state engineColor = 
  undefined
