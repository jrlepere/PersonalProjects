//
//  FirstViewController.swift
//  Can't Decide
//
//  Created by Jake Lepere on 12/4/15.
//  Copyright © 2015 Jake Lepere. All rights reserved.
//

import UIKit
import Foundation

class FirstViewController_Choices: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet var tableChoices: UITableView!
    @IBOutlet var resultText: UITextField!
    @IBOutlet var generateButton: UIButton!
    @IBOutlet var reGenerateButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        resultText.hidden = true
        reGenerateButton.hidden = true
        backButton.hidden = true
        tableChoices.hidden = false
        generateButton.hidden = false
        clearButton.hidden = false
        tableChoices.reloadData()
    }

    //Sets the number of rows in the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choiceMgr.choices.count
    }
    
    //Sets the text of the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")
        cell.textLabel?.text = choiceMgr.choices[indexPath.row].description
        
        return cell
    }
    
    //Executes when the delete icon appears and is pressed
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            choiceMgr.choices.removeAtIndex(indexPath.row)
            tableChoices.reloadData()
        }
    }
    
    //Executes when the resolve button is pressed
    @IBAction func resolveChoices(sender: UIButton) {
        if choiceMgr.choices.count != 0 {
            tableChoices.hidden = true;
            let result = arc4random_uniform(UInt32 (choiceMgr.choices.count))
            resultText.text = choiceMgr.choices[Int (result)].description
            resultText.hidden = false
            reGenerateButton.hidden = false
            backButton.hidden = false
            generateButton.hidden = true
            clearButton.hidden = true
        }
    }
    
    //ReGenerate
    @IBAction func reGenerateButton(sender: UIButton) {
        let result = arc4random_uniform(UInt32 (choiceMgr.choices.count))
        resultText.text = choiceMgr.choices[Int (result)].description
        resultText.reloadInputViews()
    }
    
    //Back button
    @IBAction func backButton(sender:UIButton) {
        resultText.text = ""
        resultText.hidden = true
        reGenerateButton.hidden = true
        generateButton.hidden = false
        tableChoices.hidden = false
        backButton.hidden = true
        clearButton.hidden = false
    }
    
    //Clear button
    @IBAction func clearButton(sender: UIButton) {
        choiceMgr.choices.removeAll()
        tableChoices.reloadData()
    }
}

