//
//  SettingsViewController.swift
//  Snake
//
//  Created by Álvaro Santillan on 3/21/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    // Views
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    // Text Buttons
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var clearBarrierButton: UIButton!
    @IBOutlet weak var clearPathButton: UIButton!
    @IBOutlet weak var godModeButton: UIButton!
    @IBOutlet weak var snakeSpeedButton: UIButton!
    @IBOutlet weak var foodWeightButton: UIButton!
    @IBOutlet weak var foodCountButton: UIButton!
    // Icon Buttons
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet weak var returnToLastScreenButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var stepOrPlayPauseButton: UIButton!
    @IBOutlet weak var darkOrLightModeButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Views
        leftView.layer.shadowColor = UIColor.darkGray.cgColor
        leftView.layer.shadowRadius = 10
        leftView.layer.shadowOpacity = 0.5
        leftView.layer.shadowOffset = .zero
        
        // Text Buttons
        clearAllButton.layer.cornerRadius = 6
        clearAllButton.layer.shadowColor = UIColor.darkGray.cgColor
        clearAllButton.layer.shadowRadius = 5
        clearAllButton.layer.shadowOpacity = 0.2
        clearAllButton.layer.shadowOffset = .zero
        clearBarrierButton.layer.cornerRadius = 6
        clearBarrierButton.layer.shadowColor = UIColor.darkGray.cgColor
        clearBarrierButton.layer.shadowRadius = 5
        clearBarrierButton.layer.shadowOpacity = 0.2
        clearBarrierButton.layer.shadowOffset = .zero
        clearPathButton.layer.cornerRadius = 6
        clearPathButton.layer.shadowColor = UIColor.darkGray.cgColor
        clearPathButton.layer.shadowRadius = 5
        clearPathButton.layer.shadowOpacity = 0.2
        clearPathButton.layer.shadowOffset = .zero
        godModeButton.layer.cornerRadius = 6
        godModeButton.layer.shadowColor = UIColor.darkGray.cgColor
        godModeButton.layer.shadowRadius = 5
        godModeButton.layer.shadowOpacity = 0.2
        godModeButton.layer.shadowOffset = .zero
        snakeSpeedButton.layer.cornerRadius = 6
        snakeSpeedButton.layer.shadowColor = UIColor.darkGray.cgColor
        snakeSpeedButton.layer.shadowRadius = 5
        snakeSpeedButton.layer.shadowOpacity = 0.2
        snakeSpeedButton.layer.shadowOffset = .zero
        foodWeightButton.layer.cornerRadius = 6
        foodWeightButton.layer.shadowColor = UIColor.darkGray.cgColor
        foodWeightButton.layer.shadowRadius = 5
        foodWeightButton.layer.shadowOpacity = 0.2
        foodWeightButton.layer.shadowOffset = .zero
        foodCountButton.layer.cornerRadius = 6
        foodCountButton.layer.shadowColor = UIColor.darkGray.cgColor
        foodCountButton.layer.shadowRadius = 5
        foodCountButton.layer.shadowOpacity = 0.2
        foodCountButton.layer.shadowOffset = .zero
        
        // Icon Buttons
        returnToLastScreenButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        returnToLastScreenButton.layer.cornerRadius = 6
        returnToLastScreenButton.layer.shadowColor = UIColor.darkGray.cgColor
        returnToLastScreenButton.layer.shadowRadius = 5
        returnToLastScreenButton.layer.shadowOpacity = 0.5
        returnToLastScreenButton.layer.shadowOffset = .zero
        helpButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        helpButton.layer.cornerRadius = 6
        helpButton.layer.shadowColor = UIColor.darkGray.cgColor
        helpButton.layer.shadowRadius = 5
        helpButton.layer.shadowOpacity = 0.5
        helpButton.layer.shadowOffset = .zero
        soundButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        soundButton.layer.cornerRadius = 6
        soundButton.layer.shadowColor = UIColor.darkGray.cgColor
        soundButton.layer.shadowRadius = 5
        soundButton.layer.shadowOpacity = 0.5
        soundButton.layer.shadowOffset = .zero
        stepOrPlayPauseButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        stepOrPlayPauseButton.layer.cornerRadius = 6
        stepOrPlayPauseButton.layer.shadowColor = UIColor.darkGray.cgColor
        stepOrPlayPauseButton.layer.shadowRadius = 5
        stepOrPlayPauseButton.layer.shadowOpacity = 0.5
        stepOrPlayPauseButton.layer.shadowOffset = .zero
        darkOrLightModeButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        darkOrLightModeButton.layer.cornerRadius = 6
        darkOrLightModeButton.layer.shadowColor = UIColor.darkGray.cgColor
        darkOrLightModeButton.layer.shadowRadius = 5
        darkOrLightModeButton.layer.shadowOpacity = 0.5
        darkOrLightModeButton.layer.shadowOffset = .zero
        homeButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        homeButton.layer.cornerRadius = 6
        homeButton.layer.shadowColor = UIColor.darkGray.cgColor
        homeButton.layer.shadowRadius = 5
        homeButton.layer.shadowOpacity = 0.5
        homeButton.layer.shadowOffset = .zero
    }
    
    var legendData = [["Snake", 0], ["Food", 3], ["Path", 17], ["Visited Square", 5], ["Queued Square", 15], ["Unvisited Square", 13], ["Barrier", 7], ["Weight", 19]]
    
    let colors = [ // Range 0 to 19
        UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00), // White Clouds
        UIColor(red:0.74, green:0.76, blue:0.78, alpha:1.00), // White Silver
        UIColor(red:0.58, green:0.65, blue:0.65, alpha:1.00), // Light Gray Concrete
        UIColor(red:0.50, green:0.55, blue:0.55, alpha:1.00), // Light Gray Asbestos
        UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.00), // Dark Gray Wet Asphalt
        UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.00), // Dark Gray Green Sea
        UIColor(red:0.61, green:0.35, blue:0.71, alpha:1.00), // Purple Amethyst
        UIColor(red:0.56, green:0.27, blue:0.68, alpha:1.00), // Purple Wisteria
        UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.00), // Blue Peter River
        UIColor(red:0.16, green:0.50, blue:0.73, alpha:1.00), // Blue Belize Hole
        UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.00), // Green Emerald
        UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.00), // Green Nephritis
        UIColor(red:0.10, green:0.74, blue:0.61, alpha:1.00), // Teal Turquoise
        UIColor(red:0.09, green:0.63, blue:0.52, alpha:1.00), // Teal GreenSea
        UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.00), // Red Alizarin
        UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.00), // Red Pomegranate
        UIColor(red:0.90, green:0.49, blue:0.13, alpha:1.00), // Orange Carrot
        UIColor(red:0.83, green:0.33, blue:0.00, alpha:1.00), // Orange Pumpkin
        UIColor(red:0.95, green:0.77, blue:0.06, alpha:1.00), // Yellow Sun Flower
        UIColor(red:0.95, green:0.61, blue:0.07, alpha:1.00) // Yellow Orange
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legendData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! SettingsScreenTableViewCell
        cell2.myLabell.text = legendData[indexPath.row][0] as? String
        cell2.myImagee.backgroundColor = colors[(legendData[indexPath.row][1] as? Int)!]
        cell2.myImagee.layer.borderWidth = 1
        cell2.myImagee.layer.cornerRadius = cell2.myImagee.frame.size.width/4
        cell2.myImagee.clipsToBounds = true
        cell2.selectionStyle = UITableViewCell.SelectionStyle.none
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cell2.myImagee.tag = indexPath.row
        cell2.myImagee.isUserInteractionEnabled = true
        cell2.myImagee.addGestureRecognizer(tapGestureRecognizer)
        return cell2
    }
    
    // method to run when imageview is tapped
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imgView = tapGestureRecognizer.view as! UIImageView
        var colorID = (legendData[imgView.tag][1] as! Int) + 1
        if colorID == colors.count {colorID = 0}
        legendData[imgView.tag][1] = colorID
        tableVIew.reloadData()
    }
    
    @IBAction func clearAllButton(_ sender: UIButton) {
        sender.setTitle("Gameboard Cleared",for: .normal)
        clearBarrierButton.setTitle("Barriers Cleared",for: .normal)
        clearPathButton.setTitle("Path Cleared",for: .normal)
    }
    
    @IBAction func clearBarrierButtonPressed(_ sender: UIButton) {
        sender.setTitle("Barriers Cleared",for: .normal)
    }
    
    @IBAction func clearPathButtonPressed(_ sender: UIButton) {
        sender.setTitle("Path Cleared",for: .normal)
    }
    
    @IBAction func snakeSpeedButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setTitle("Speed: Fast", for: .normal)
            sender.tag = 1
        } else if sender.tag == 1 {
            sender.setTitle("Speed: Extreme", for: .normal)
            sender.tag = 2
        } else if sender.tag == 2 {
            sender.setTitle("Speed: Slow", for: .normal)
            sender.tag = 3
        } else {
            sender.setTitle("Speed: Normal", for: .normal)
            sender.tag = 0
        }
    }
    
    @IBAction func foodWeightButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setTitle("Food Weight: 2", for: .normal)
            sender.tag = 1
        } else if sender.tag == 1 {
            sender.setTitle("Food Weight: 3", for: .normal)
            sender.tag = 2
        } else if sender.tag == 2 {
            sender.setTitle("Food Weight: 5", for: .normal)
            sender.tag = 3
        } else {
            sender.setTitle("Food Weight: 1", for: .normal)
            sender.tag = 0
        }
    }
    
    @IBAction func foodCountButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setTitle("Food Count: 2", for: .normal)
            sender.tag = 1
        } else if sender.tag == 1 {
            sender.setTitle("Food Count: 3", for: .normal)
            sender.tag = 2
        } else if sender.tag == 2 {
            sender.setTitle("Food Count: 5", for: .normal)
            sender.tag = 3
        } else {
            sender.setTitle("Food Count: 1", for: .normal)
            sender.tag = 0
        }
    }
    
    @IBAction func godButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setTitle("God Mode: On",for: .normal)
            sender.tag = 1
        } else {
            sender.setTitle("God Mode: Off",for: .normal)
            sender.tag = 0
        }
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "volume-mute-solid.pdf"), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "volume-down-solid.pdf"), for: .normal)
            sender.tag = 0
        }
    }
    
    @IBAction func stepOrPlayPauseButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "step-forward-solid.pdf"), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "shoe-prints-solid.pdf"), for: .normal)
            sender.tag = 0
        }
    }
    
    @IBAction func darkOrLightModeButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(named: "adjust-flipped-solid.pdf"), for: .normal)
            sender.tag = 1
        } else {
            sender.setImage(UIImage(named: "adjust-solid.pdf"), for: .normal)
            sender.tag = 0
        }
    }
}
