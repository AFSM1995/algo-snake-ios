//
//  GameManager.swift
//  Snake
//
//  Created by Álvaro Santillan on 1/8/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import SpriteKit

class GameManager {
    
    var scene: GameScene!
    var nextTime: Double?
    // Snake speed
    var timeExtension: Double = 0.1
    var playerDirection: Int = 1 // 1 == left, 2 == up, 3 == right, 4 == down
    var currentScore: Int = 0
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func initGame() {
        //starting player position
        scene.snakeBodyPos.append((10, 10))
        scene.snakeBodyPos.append((10, 11))
        scene.snakeBodyPos.append((10, 12))
        scene.snakeBodyPos.append((10, 13))
        scene.snakeBodyPos.append((10, 14))
        scene.snakeBodyPos.append((10, 15))
        scene.snakeBodyPos.append((10, 16))
        scene.snakeBodyPos.append((10, 17))
        scene.snakeBodyPos.append((10, 18))
        renderChange()
        generateNewPoint()
    }
    
    private func generateNewPoint() {
        var randomX = CGFloat(arc4random_uniform(19))
        var randomY = CGFloat(arc4random_uniform(39))

        while contains(a: scene.snakeBodyPos, v: (Int(randomX), Int(randomY))) {
            randomX = CGFloat(arc4random_uniform(19))
            randomY = CGFloat(arc4random_uniform(39))
        }
        scene.scorePos = CGPoint(x: randomX, y: randomY)
    }
    
    func swipe(ID: Int) {
        if !(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2) {
            if !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1) {
                if playerDirection != 0 {
                    playerDirection = ID
                }
            }
        }
    }
    
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtension
        } else {
            if time >= nextTime! {
                nextTime = time + timeExtension
                updatePlayerPosition()
                checkForScore()
                checkForDeath()
                finishAnimation()
            }
        }
    }
    
    private func finishAnimation() {
        if playerDirection == 0 && scene.snakeBodyPos.count > 0 {
            var hasFinished = true
            let headOfSnake = scene.snakeBodyPos[0]
            for position in scene.snakeBodyPos {
                if headOfSnake != position {
                    hasFinished = false
                }
             }
         if hasFinished {
            print("end game")
            updateScore()
            playerDirection = 4
            //animation has completed
            scene.scorePos = nil
            scene.snakeBodyPos.removeAll()
            renderChange()

            scene.gameBackground.run(SKAction.scale(to: 0, duration: 0.4)) {
                self.scene.gameBackground.isHidden = true
                self.scene.gameLogo.isHidden = false
                self.scene.gameLogo.run(SKAction.move(to: CGPoint(x: 0, y: (self.scene.frame.size.height / 2) - 200), duration: 0.5)) {
                     self.scene.playButton.isHidden = false
                     self.scene.playButton.run(SKAction.scale(to: 1, duration: 0.3))
                     self.scene.bestScore.run(SKAction.move(to: CGPoint(x: 0, y: self.scene.gameLogo.position.y - 50), duration: 0.3))
                   }
              }
              }
         }
    }
    
    private func checkForDeath() {
        if scene.snakeBodyPos.count > 0 {
            var arrayOfPositions = scene.snakeBodyPos
            let headOfSnake = arrayOfPositions[0]
            arrayOfPositions.remove(at: 0)
            if contains(a: arrayOfPositions, v: headOfSnake) {
                playerDirection = 0
            }
        }
    }
    
    private func checkForScore() {
        if scene.scorePos != nil {
            let x = scene.snakeBodyPos[0].0
            let y = scene.snakeBodyPos[0].1
            if Int((scene.scorePos?.x)!) == y && Int((scene.scorePos?.y)!) == x {
                currentScore += 1
                scene.gameScore.text = "Score: \(currentScore)"
                generateNewPoint()
                //Grow snake by 3 blocks
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
                scene.snakeBodyPos.append(scene.snakeBodyPos.last!)
             }
         }
    }
    
    private func updatePlayerPosition() {
        var xChange = -1
        var yChange = 0

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
            //4
//            case 0:
//                //dead
//                xChange = 0
//                yChange = 0
//                break
            default:
                break
        }
        if scene.snakeBodyPos.count > 0 {
            var start = scene.snakeBodyPos.count - 1
            while start > 0 {
                scene.snakeBodyPos[start] = scene.snakeBodyPos[start - 1]
                start -= 1
            }
            scene.snakeBodyPos[0] = (scene.snakeBodyPos[0].0 + yChange, scene.snakeBodyPos[0].1 + xChange)
        }
        
        // Wrap snake around screen
        if scene.snakeBodyPos.count > 0 {
            let x = scene.snakeBodyPos[0].1
            let y = scene.snakeBodyPos[0].0
            if y > 73 {
                scene.snakeBodyPos[0].0 = 73
            } else if y < 0 {
                scene.snakeBodyPos[0].0 = 0
            } else if x > 41 {
               scene.snakeBodyPos[0].1 = 41
            } else if x < 0 {
                scene.snakeBodyPos[0].1 = 0
            }
        }
        renderChange()
    }
    
    func renderChange() {
        for (node, x, y) in scene.gameBoard {
            if contains(a: scene.snakeBodyPos, v: (x,y)) {
                node.fillColor = SKColor.cyan
            } else {
                node.fillColor = SKColor.clear
                if scene.scorePos != nil {
                    if Int((scene.scorePos?.x)!) == y && Int((scene.scorePos?.y)!) == x {
                        node.fillColor = SKColor.red
                    }
                }
            }
        }
    }
    
    func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }

    private func updateScore() {
         if currentScore > UserDefaults.standard.integer(forKey: "bestScore") {
              UserDefaults.standard.set(currentScore, forKey: "bestScore")
         }
         currentScore = 0
         scene.gameScore.text = "Score: 0"
         scene.bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
    }
}
