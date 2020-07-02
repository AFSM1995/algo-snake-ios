//
//  Algorithm Helper Functions.swift
//  Algo Snake
//
//  Created by Álvaro Santillan on 7/1/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

class AlgorithmHelper {
    var scene: GameScene!
    var movePath = [Int]()
    var squareAndParentSquareTuplePath = [Tuple : Tuple]()
    var squareAndNoParentArrayPath = [(Tuple)]()
    
    init(scene: GameScene) {
        self.scene = scene
    }

    // Takes a two dimentional matrix, determins the legal squares.
    // The results are converted into a nested dictionary.
    func gameBoardMatrixToDictionary(gameBoardMatrix: Array<Array<Int>>) -> Dictionary<Tuple, Dictionary<Tuple, Float>> {
        // Initialize the two required dictionaries.
        var mazeDictionary = [Tuple : [Tuple : Float]]()
        var vaildMoves = [Tuple : Float]()
        
        var isYNegIndex = Bool()
        var isYIndex = Bool()
        var isXIndex = Bool()
        var isXNefIndex = Bool()
        let xMax = scene.columnCount
        let yMax = scene.rowCount

        // Loop through every cell in the maze.
        for(y, matrixRow) in gameBoardMatrix.enumerated() {
            for(x, _) in matrixRow.enumerated() {
                // If in a square that is leagal, append valid moves to a dictionary.
                if (gameBoardMatrix[y][x] == 0 || gameBoardMatrix[y][x] == 3 || gameBoardMatrix[y][x] == 1) {
                    if (y+1 >= yMax) {
                        isYIndex = false
                    } else {
                        isYIndex = true
                    }
                    
                    if (x+1 >= xMax) {
                        isXIndex = false
                    } else {
                        isXIndex = true
                    }
                    
                    if (y-1 < 0) {
                        isYNegIndex = false
                    } else {
                        isYNegIndex = true
                    }
                    
                    if (x-1 < 0) {
                        isXNefIndex = false
                    } else {
                        isXNefIndex = true
                    }
                    // Up
                    if isYNegIndex {
                        if (gameBoardMatrix[y-1][x] == 0 || gameBoardMatrix[y-1][x] == 3 || gameBoardMatrix[y-1][x] == 1) {
                            vaildMoves[Tuple(x: x, y: y-1)] = 1
                        }
                    }
                    // Right
                    if isXIndex {
                        if (gameBoardMatrix[y][x+1] == 0 || gameBoardMatrix[y][x+1] == 3 || gameBoardMatrix[y][x+1] == 1) {
                            // Floats so that we can have duplicates keys in dictinaries (Swift dictionary workaround).
                            vaildMoves[Tuple(x: x+1, y: y)] = 1.000001
                        }
                    }
                    // Left
                    if isXNefIndex {
                        if (gameBoardMatrix[y][x-1] == 0 || gameBoardMatrix[y][x-1] == 3 || gameBoardMatrix[y][x-1] == 1) {
                            vaildMoves[Tuple(x: x-1, y: y)] = 1.000002
                        }
                    }
                    // Down
                    if isYIndex {
                        if (gameBoardMatrix[y+1][x] == 0 || gameBoardMatrix[y+1][x] == 3 || gameBoardMatrix[y+1][x] == 1) {
                            vaildMoves[Tuple(x: x, y: y+1)] = 1.000003
                            }
                        }
                    // Append the valid move dictionary to a master dictionary to create a dictionary of dictionaries.
                    mazeDictionary[Tuple(x: x, y: y)] = vaildMoves
                    // Reset the inner dictionary templet.
                    vaildMoves = [Tuple : Float]()
                }
            }
        }
        return mazeDictionary
    }
    
    // Genarate a path and optional statistics from the results of BFS.
    func formatSearchResults(squareAndParentSquare: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Float>], currentSquare: Tuple, visitedSquareCount: Int, returnPathCost: Bool, returnSquaresVisited: Bool) -> ([Int], [(Tuple)], Int, Int) {
        
        // 1 == left, 2 == up, 3 == right, 4 == down

        let (solutionPathMoves, solutionPathArray, solutionPathDuple) = findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: currentSquare)
        
        // Prepare and present the result returns.
        if (returnPathCost == true) {
            // Use the "path" method result to calculate a pathcost using the "pathcost" method.
            let solutionPathCost = findPathCost(solutionPathDuple: solutionPathDuple, gameBoard: gameBoard)
            
            if (returnSquaresVisited == true) {
                return (solutionPathMoves, squareAndNoParentArrayPath, solutionPathCost, visitedSquareCount)
            } else {
                return (solutionPathMoves, squareAndNoParentArrayPath, solutionPathCost, 0)
            }
        }
        else if (returnPathCost == false) && (returnSquaresVisited == true) {
            return (solutionPathMoves, squareAndNoParentArrayPath, 0, visitedSquareCount)
        }
        else {
            return (solutionPathMoves, squareAndNoParentArrayPath, 0, 0)
        }
    }
    
    // Calculate the path cost of the path returned by the "findPath" function.
    func findPathCost(solutionPathDuple: [Tuple : Tuple], gameBoard: [Tuple : Dictionary<Tuple, Float>]) -> Int {
        var cost = 0
        
        for square in solutionPathDuple.keys {
            cost += Int(gameBoard[square]![solutionPathDuple[square]!] ?? 0)
        }
        return(cost)
    }
    
    // Find a path using the results of the search algorthim.
    func findPath(squareAndParentSquare: [Tuple : Tuple], currentSquare: Tuple) -> ([Int],[(Tuple)],[Tuple : Tuple]) {
        if (currentSquare == Tuple(x:-1, y:-1)) {
            return (movePath, squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
        } else {
            squareAndParentSquareTuplePath[currentSquare] = squareAndParentSquare[currentSquare]
            squareAndNoParentArrayPath.append(Tuple(x: currentSquare.x, y: currentSquare.y))
//                squareAndNoParentArrayPath.append((currentSquare.x,currentSquare.y))
            let xValue = currentSquare.x - squareAndParentSquare[currentSquare]!.x
            let yValue = currentSquare.y - squareAndParentSquare[currentSquare]!.y
            // 1 == left, 2 == up, 3 == right, 4 == down
            if (xValue == 0 && yValue == 1) {
                movePath.append(4)
            // 1 == left, 2 == up, 3 == right, 4 == down
            } else if (xValue == 0 && yValue == -1) {
                movePath.append(2)
            // 1 == left, 2 == up, 3 == right, 4 == down
            } else if (xValue == 1 && yValue == 0) {
                movePath.append(3)
            // 1 == left, 2 == up, 3 == right, 4 == down
            } else if (xValue == -1 && yValue == 0) {
                movePath.append(1)
            }
            
            findPath(squareAndParentSquare: squareAndParentSquare, currentSquare: squareAndParentSquare[currentSquare]!)
        }
        return (movePath, squareAndNoParentArrayPath, squareAndParentSquareTuplePath)
    }
}
