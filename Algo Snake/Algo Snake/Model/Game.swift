//
//  Game.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameManager {
    var audioPlayer: AVAudioPlayer?
    var viewController: GameScreenViewController!
    var play = true
    var gameStarted = false
    var matrix = [[Int]]()
    var moveInstructions = [Int]()
    var pathBlockCordinates = [Tuple]()
    var pathBlockCordinatesNotReversed = [Tuple]()
    var onPathMode = false
    var scene: GameScene!
    var nextTime: Double?
    var gameSpeed: Float = 1
    var paused = false
    var playerDirection: Int = 3 // 1 == left, 2 == up, 3 == right, 4 == down
    var currentScore: Int = 0
    var barrierNodesWaitingToBeDisplayed: [SkNodeAndLocation] = []
    var barrierNodesWaitingToBeRemoved: [SkNodeAndLocation] = []
    var snakeBodyPos: [SkNodeAndLocation] = []
    var godModeWasTurnedOn = false
    var verticalMaxBoundry = Int()
    var verticalMinBoundry = Int()
    var horizontalMaxBoundry = Int()
    var horizontalMinBoundry = Int()
    var foodPosition: [SkNodeAndLocation] = []
    
    init(scene: GameScene) {
        self.scene = scene
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let vc = appDelegate.window?.rootViewController {
            self.viewController = (vc.presentedViewController as? GameScreenViewController)
        }
    }
    
    func initiateSnakeStartingPosition() {
        // Must be run at the very begining.
        verticalMaxBoundry = (scene.rowCount - 2)
        verticalMinBoundry = 1
        horizontalMaxBoundry = (scene.columnCount - 2)
        horizontalMinBoundry = 1
        
        var node = scene.gameBoard.first(where: {$0.location == Tuple(x: 2, y: 7)})!.square
        snakeBodyPos.append(SkNodeAndLocation(square: node, location: Tuple(x: 2, y: 7)))
        matrix[2][7] = 1

        node = scene.gameBoard.first(where: {$0.location == Tuple(x: 2, y: 6)})!.square
        snakeBodyPos.append(SkNodeAndLocation(square: node, location: Tuple(x: 2, y: 6)))
        matrix[2][6] = 2

        node = scene.gameBoard.first(where: {$0.location == Tuple(x: 2, y: 5)})!.square
        snakeBodyPos.append(SkNodeAndLocation(square: node, location: Tuple(x: 2, y: 5)))
        matrix[2][5] = 2

        node = scene.gameBoard.first(where: {$0.location == Tuple(x: 2, y: 4)})!.square
        snakeBodyPos.append(SkNodeAndLocation(square: node, location: Tuple(x: 2, y: 4)))
        matrix[2][4] = 2

        node = scene.gameBoard.first(where: {$0.location == Tuple(x: 2, y: 3)})!.square
        snakeBodyPos.append(SkNodeAndLocation(square: node, location: Tuple(x: 2, y: 3)))
        matrix[2][3] = 2

        node = scene.gameBoard.first(where: {$0.location == Tuple(x: 2, y: 2)})!.square
        snakeBodyPos.append(SkNodeAndLocation(square: node, location: Tuple(x: 2, y: 2)))
        matrix[2][2] = 2
        
        gameStarted = true
        // Look into moving
        spawnFoodBlock()
    }
    
    var foodBlocksHaveAnimated = Bool()
    func spawnFoodBlock() {
        let foodPalletsNeeded = (UserDefaults.standard.integer(forKey: "Food Count Setting") - foodPosition.count)
        
        if foodPalletsNeeded > 0 {
            for _ in 1...foodPalletsNeeded {
                foodBlocksHaveAnimated = false
                var randomX = Int.random(in: 1...verticalMaxBoundry)
                var randomY = Int.random(in: 1...horizontalMaxBoundry)
                
                var validFoodLocationConfirmed = false
                var foodLocationChnaged = false
                
                while validFoodLocationConfirmed == false {
                    validFoodLocationConfirmed = true
                    for i in (barrierNodesWaitingToBeDisplayed) {
                        if i.location.y == randomY && i.location.x == randomX {
                            randomX = Int.random(in: 1...verticalMaxBoundry)
                            randomY = Int.random(in: 1...horizontalMaxBoundry)
                            validFoodLocationConfirmed = false
                            foodLocationChnaged = true
                        }
                    }

                    for i in (snakeBodyPos) {
                        if i.location.y == randomY && i.location.x == randomX {
                            randomX = Int.random(in: 1...verticalMaxBoundry)
                            randomY = Int.random(in: 1...horizontalMaxBoundry)
                            validFoodLocationConfirmed = false
                            foodLocationChnaged = true
                        }
                    }
                    
                    foodPosition = Array(Set(foodPosition))
                    if foodLocationChnaged == false {
                        validFoodLocationConfirmed = true
                    }
                }
                matrix[randomX][randomY] = 3
                // potential reverseal
                let node = scene.gameBoard.first(where: {$0.location == Tuple(x: randomX, y: randomY)})?.square
                foodPosition.append(SkNodeAndLocation(square: node!, location: Tuple(x: randomY, y: randomX)))
            }
        }
        pathSelector()
    }
        
    var nnnpath: (([Int], [(Tuple)], Int, Int), [SkNodeAndLocation], [[SkNodeAndLocation]], [SkNodeAndLocation], [Bool])?
    var conditionGreen = Bool()
    var conditionYellow = Bool()
    var conditionRed = Bool()
    
    var fronteerSquareArray = [[SkNodeAndLocation]]()
    var visitedNodeArray = [SkNodeAndLocation]()
    var pathSquareArray = [SkNodeAndLocation]()
    var displayFronteerSquareArray = [[SkNodeAndLocation]]()
    var displayVisitedSquareArray = [SkNodeAndLocation]()
    var displayPathSquareArray = [SkNodeAndLocation]()
    
    let mainScreenAlgoChoice = UserDefaults.standard.integer(forKey: "Selected Path Finding Algorithim")
    func pathSelector() {
        let sceleton = AlgorithmHelper(scene: scene)
        let dfs = DepthFirstSearch(scene: scene)
        let bfs = BreadthFirstSearch(scene: scene)
        
        let snakeHead = Tuple(x: snakeBodyPos[0].location.y, y: snakeBodyPos[0].location.x)
        let gameBoardDictionary = sceleton.gameBoardMatrixToDictionary(gameBoardMatrix: matrix)
        if mainScreenAlgoChoice == 2 {
            nnnpath = bfs.breathFirstSearch(startSquare: snakeHead, foodLocations: foodPosition, gameBoard: gameBoardDictionary, returnPathCost: false, returnSquaresVisited: false)
            pathManager()
        } else if mainScreenAlgoChoice == 3 {
            nnnpath = dfs.depthFirstSearch(startSquare: snakeHead, foodLocations: foodPosition, gameBoard: gameBoardDictionary, returnPathCost: false, returnSquaresVisited: false)
            pathManager()
        } else {
            moveInstructions = []
        }
        
        for i in pathBlockCordinatesNotReversed {
            let node = scene.gameBoard.first(where: {$0.location == Tuple(x: i.y, y: i.x)})?.square
            pathSquareArray.append(SkNodeAndLocation(square: node!, location: Tuple(x: i.x, y: i.y)))
            displayPathSquareArray.append(SkNodeAndLocation(square: node!, location: Tuple(x: i.x, y: i.y)))
        }
        displayPathSquareArray.removeFirst()
        displayPathSquareArray.removeLast()

        if UserDefaults.standard.bool(forKey: "Step Mode On Setting") {
                // problem may not be needed
            if scene.firstAnimationSequanceHasCompleted == true {
                scene.buttonManager(playButtonIsEnabled: true)
            }
            
            UserDefaults.standard.set(true, forKey: "Game Is Paused Setting")
            paused = true
            checkIfPaused()
        }
        scene.updateScoreButtonHalo()
    }
    
    func pathManager() {
        moveInstructions = nnnpath!.0.0
        moveInstructions = moveInstructions.reversed()
        pathBlockCordinatesNotReversed = nnnpath!.0.1
        pathBlockCordinates = pathBlockCordinatesNotReversed.reversed()
        visitedNodeArray = nnnpath!.1
        displayVisitedSquareArray = visitedNodeArray
        fronteerSquareArray = nnnpath!.2
        displayFronteerSquareArray = fronteerSquareArray
        pathSquareArray = nnnpath!.3
        conditionGreen = nnnpath!.4[0]
        conditionYellow = nnnpath!.4[1]
        conditionRed = nnnpath!.4[2]
//        print("Snake head", snakeBodyPos[0].location)
//        print("food", foodPosition)
//        print("move instructions", moveInstructions)
    }
    
    func bringOvermatrix(tempMatrix: [[Int]]) {
        matrix = tempMatrix
    }
    
    func runPredeterminedPath() {
        if gameStarted == true {
            if (moveInstructions.count != 0) {
                swipe(ID: moveInstructions[0])
                moveInstructions.remove(at: 0)
                if displayPathSquareArray.count != 0 {
                    displayPathSquareArray.removeLast()
                }
                pathBlockCordinates.remove(at: 0)
                playSound(selectedSoundFileName: "sfx_coin_single3")
                onPathMode = true
            } else {
                onPathMode = false
                pathSelector()
                onPathMode = true
            }
        }
    }
    
    func update(time: Double) {
            
        if nextTime == nil {
            nextTime = time + Double(gameSpeed)
        } else if (paused == true) {
            if gameIsOver != true {
                checkIfPaused()
            }
        }
        else {
            if time >= nextTime! {
//                if gameIsOver != true {
//                    checkForDeath()
//                    updateSnakePosition()
                    if gameIsOver != true {
                        nextTime = time + Double(gameSpeed)
                        barrierSquareManager()
                        scene.updateScoreButtonHalo()
                        scene.updateScoreButtonText()
                        
                        // these two must be together
                        runPredeterminedPath()
                        updateSnakePosition()
                        
                        checkIfPaused()
                        checkForFoodCollision()
                        
//                        checkForDeath()
//                        updateSnakePosition()
                    }
//                }
            }
        }
    }
    
    func barrierSquareManager() {
        barrierNodesWaitingToBeDisplayed = Array(Set(barrierNodesWaitingToBeDisplayed).subtracting(barrierNodesWaitingToBeRemoved))
        barrierNodesWaitingToBeRemoved.removeAll()
    }
    
    func checkIfPaused() {
        if UserDefaults.standard.bool(forKey: "Game Is Paused Setting") {
            tempColor()
            paused = true
        } else {
            scene.animatedVisitedSquareCount = 0
            scene.animatedQueuedSquareCount = 0
            gameSpeed = UserDefaults.standard.float(forKey: "Snake Move Speed")
            paused = false
        }
    }
    
    func tempColor() {
        if scene.pathFindingAnimationsHaveEnded == true && paused == false {
            func colorTheGameboard() {
                for i in scene.gameBoard {
                    i.square.fillColor = scene.gameboardSquareColor
                }
            }

            func colorTheSnake() {
                for (index, squareAndLocation) in snakeBodyPos.enumerated() {
                    if index == 0 {
                        squareAndLocation.square.fillColor = scene.snakeHeadSquareColor
                    } else {
                        squareAndLocation.square.fillColor = scene.snakeBodySquareColor
                    }
                }
            }
            func colorTheFood() {
                for i in (foodPosition) {
                    i.square.fillColor = scene.foodSquareColor

                    if foodBlocksHaveAnimated == false {
                        i.square.run(scene.animationSequanceManager(animation: 3))
                        foodBlocksHaveAnimated = true
                    }
                }
            }
            
            func colorThePath() {
                for i in (displayPathSquareArray) {
                    i.square.fillColor = scene.pathSquareColor
                }
            }
            
            func colorTheBarriers() {
                for i in (barrierNodesWaitingToBeDisplayed) {
                    i.square.fillColor = scene.barrierSquareColor
                }
            }
            
            colorTheGameboard()
            colorTheSnake()
            colorTheFood()
            colorThePath()
            colorTheBarriers()
        }
    }
    
    var gameIsOver = Bool()
    func endTheGame() {
        scene.algorithimChoiceName.text = "Game Over"
        self.viewController?.scoreButton.layer.borderColor = UIColor.red.cgColor
        updateScore()
        gameIsOver = true
        scene.buttonManager(playButtonIsEnabled: true)
    }
    
    // this is run when game hasent started. fix for optimization.
        func checkForDeath() {
        if snakeBodyPos.count > 0 {
            // Create temp variable of snake without the head.
            var snakeBody = snakeBodyPos
            snakeBody.remove(at: 0)
            // Implement wraping snake in god mode.
            // If head is in same position as the body the snake is dead.
            // The snake dies in corners becouse blocks are stacked.
            

            if snakeBody.contains(snakeBodyPos[0]) {
//            if contains(a: snakeBody, v: snakeBodyPos[0]) {
                if UserDefaults.standard.bool(forKey: "God Button On Setting") {
                    godModeWasTurnedOn = true
                } else {
                    endTheGame()
                }
            }
            
            let snakeHead = snakeBodyPos[0]
            if barrierNodesWaitingToBeDisplayed.contains(snakeHead) {
                endTheGame()
            }
        }
    }
    
    var foodCollisionPoint = Int()
    func checkForFoodCollision() {
        if foodPosition != nil {
            let x = snakeBodyPos[0].location.x
            let y = snakeBodyPos[0].location.y
            var counter = 0
            
            for i in (foodPosition) {
                // potential redudndent casting
                if Int((i.location.x)) == y && Int((i.location.y)) == x {
                    
                    matrix[Int(i.location.y)][Int(i.location.x)] = 0
                    foodCollisionPoint = counter
                    foodPosition.remove(at: foodCollisionPoint)
                    
                    
                    spawnFoodBlock()
                    playSound(selectedSoundFileName: "sfx_coin_double3")
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    
                    // Update the score
                    if !(UserDefaults.standard.bool(forKey: "God Button On Setting")) {
                         currentScore += 1
                     }
                    
                    // Grow snake by 3 blocks.
                    let max = UserDefaults.standard.integer(forKey: "Food Weight Setting")
                    for _ in 1...max {
                        snakeBodyPos.append(snakeBodyPos.last!)
                    }
                }
                counter += 1
            }
         }
    }
    
    func playSound(selectedSoundFileName: String) {
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)
        let musicPath = Bundle.main.path(forResource: selectedSoundFileName, ofType:"wav")!
        let url = URL(fileURLWithPath: musicPath)
        
        if UserDefaults.standard.bool(forKey: "Volume On Setting") {
            do {
                let sound = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer = sound
                sound.play()
            } catch {
                print("Error playing file")
            }
        }
    }
    
    func swipe(ID: Int) {
//        if onPathMode == false {
//            if !(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2) {
//                if !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1) {
//                print(ID)
                playerDirection = ID
//                }
//            }
//        }
    }
    
    private func updateSnakePosition() {
        var xChange = -1
        var yChange = 0

//        print(playerDirection)
        switch playerDirection {
            case 1:
                //left
                xChange = -1
                yChange = 0
                break
            case 2:
                //up
                xChange = 0
                yChange = -1
                break
            case 3:
                //right
                xChange = 1
                yChange = 0
                break
            case 4:
                //down
                xChange = 0
                yChange = 1
                break
            default:
                break
        }

        if snakeBodyPos.count > 0 {
            var start = snakeBodyPos.count - 1
            matrix[snakeBodyPos[start].location.x][snakeBodyPos[start].location.y] = 0
            while start > 0 {
                snakeBodyPos[start] = snakeBodyPos[start - 1]
                start -= 1
            }
            // Can be reduced only 3 blocks need to be updated.
            let xx = (snakeBodyPos[0].location.x + yChange)
            let yy = (snakeBodyPos[0].location.y + xChange)
            let newSnakeHead = scene.gameBoard.first(where: {$0.location == Tuple(x: xx, y: yy)})
            snakeBodyPos[0] = newSnakeHead!
//            snakeBodyPos[0].location.x = (snakeBodyPos[0].location.x + yChange)
//            snakeBodyPos[0].location.y = (snakeBodyPos[0].location.y + xChange)
            if snakeBodyPos[0].location.x < 0 || snakeBodyPos[0].location.y < 0 {
                endTheGame()
            }
//            print("location update", snakeBodyPos[0])
            if gameIsOver != true {
                matrix[snakeBodyPos[0].location.x][snakeBodyPos[0].location.y] = 1
                matrix[snakeBodyPos[1].location.x][snakeBodyPos[1].location.y] = 2
            }
            matrix[snakeBodyPos[2].location.x][snakeBodyPos[2].location.y] = 2
            matrix[snakeBodyPos[3].location.x][snakeBodyPos[3].location.y] = 2
            matrix[snakeBodyPos[4].location.x][snakeBodyPos[4].location.y] = 2
            matrix[snakeBodyPos[5].location.x][snakeBodyPos[5].location.y] = 2
//            for i in 0...(scene.rowCount-1) {
//                print(matrix[i])
//            }
//            print("----")
        }
    
        if gameIsOver != true {
            if snakeBodyPos.count > 0 {
                let x = snakeBodyPos[0].location.y
                let y = snakeBodyPos[0].location.x
                if UserDefaults.standard.bool(forKey: "God Button On Setting") {
                    // modified to debug
    //                if y > verticalMaxBoundry { // Moving To Bottom
    //                    snakeBodyPos[0].0 = verticalMinBoundry // Spawning At Top
    //                } else if y < verticalMinBoundry { // Moving to top
    //                    snakeBodyPos[0].0 = verticalMaxBoundry // Spawning at bottom
    //                } else if x > horizontalMaxBoundry { // Moving to right
    //                    snakeBodyPos[0].1 = horizontalMinBoundry // Spawning on left
    //                } else if x < horizontalMinBoundry { // Moving to left
    //                    snakeBodyPos[0].1 = horizontalMaxBoundry // Spawning on right
    //                }
                } else {
                    if y > verticalMaxBoundry { // Moving To Bottom
                        endTheGame()
                    } else if y < verticalMinBoundry { // Moving to top
                        endTheGame()
                    } else if x > horizontalMaxBoundry { // Moving to right
                        endTheGame()
                    } else if x < horizontalMinBoundry { // Moving to left
                        endTheGame()
                    }
                }
            }
            tempColor()
        }
    }

    func updateScore() {
        // Update the high score if need be.
         if currentScore > UserDefaults.standard.integer(forKey: "highScore") {
              UserDefaults.standard.set(currentScore, forKey: "highScore")
         }
        
        // Reset and present score variables on game menu.
        UserDefaults.standard.set(currentScore, forKey: "lastScore")
         currentScore = 0
    }
}

