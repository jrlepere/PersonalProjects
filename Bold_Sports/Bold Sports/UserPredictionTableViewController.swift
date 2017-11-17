//
//  UserPredictionTableViewController.swift
//  Bold Sports
//
//  Created by Jake Lepere on 8/6/16.
//  Copyright © 2016 Jake Lepere. All rights reserved.
//

import UIKit

class UserPredictionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, KumulosDelegate, UISearchBarDelegate {
    
    // Outlets
    @IBOutlet var predictionsTableView: UITableView!
    @IBOutlet var userPredictionSearchBar: UISearchBar!
    
    // Kumulos
    let K = Kumulos()
    
    // User Predictions
    var userPredictions: Predictions!
    var predictionsBySearch:[Int]!
    
    /**
     Preforms when the user loads the view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Kumulos
        K.delegate = self
        
        // Outlets : tableView
        self.predictionsTableView.delegate = self
        self.predictionsTableView.dataSource = self
        
        // Outlets: Search Bar
        self.userPredictionSearchBar.delegate = self
        
        // User Predictions
        predictionsBySearch = []
        var count = 0
        
        for _ in userPredictions.predictions {
            
            predictionsBySearch.append(count)
            
            count += 1
            
        }
        
        // Gestures
        let removeKeyBoardTap = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardTap(_:)))
        let removeKeyBoardSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LogInViewController.removeKeyBoardSwipe(_:)))
        removeKeyBoardSwipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(removeKeyBoardTap)
        self.view.addGestureRecognizer(removeKeyBoardSwipe)
        
        // Navigation Bar
        self.navigationItem.title = "My Predictions"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        removeTapGestures()
        
        predictionsTableView.reloadData()
        
    }
    
    /**
     TableView Data Source. Sets the number of rows in the TableView.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return predictionsBySearch.count
        
    }
    
    /**
     TableView Data Source. Sets the cell for each row in the TableView.
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let predictionCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "")
        let predictionData = userPredictions.getPrediction(predictionsBySearch[indexPath.row])
        
        predictionCell.textLabel?.text = predictionData.prediction
        predictionCell.detailTextLabel?.text = "\(predictionData.noWayCount + predictionData.maybeCount + predictionData.obviouslyCount) Votes Recieved"
        
        return predictionCell
        
    }
    
    /**
     TableView Delegate. Preforms when the user presses the delete button after swiping on a cell.
     */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this prediction?", preferredStyle: .Alert)
            deleteAlert.addAction(UIAlertAction(title: "YES", style: .Default, handler: { (action) in
                self.K.removePredictionWithPollID(UInt(self.userPredictions.getPrediction(self.predictionsBySearch[indexPath.row]).pollID))
                self.userPredictions.remove(self.predictionsBySearch[indexPath.row])
                self.predictionsBySearch.removeAll()
                var count = 0
                for _ in self.userPredictions.predictions {
                    
                    self.predictionsBySearch.append(count)
                    count = count + 1
                    
                }
                
                tableView.reloadData()
                
            }))
            deleteAlert.addAction(UIAlertAction(title: "NO", style: .Default, handler: nil))
            
            self.presentViewController(deleteAlert, animated: true, completion: nil)
            
            
        }
        
    }
    
    /**
     TableView Delegate. Preforms when the user selects a row
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        cellTapped(indexPath.row)
        
    }
    
    /**
     Action for when the user taps any cell
     */
    func cellTapped(predictionIndex: Int) {
        
        let predictionData = userPredictions.getPrediction(predictionsBySearch[predictionIndex])
        
        let individualPredictionView = self.storyboard?.instantiateViewControllerWithIdentifier("IndividualUserPredictionView") as! IndividualUserPredictionViewController
        individualPredictionView.predictionData = predictionData
        
        self.navigationController?.showViewController(individualPredictionView, sender: self)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        predictionsBySearch.removeAll()
        
        var count = 0
        
        if searchText == "" {
        
            for _ in userPredictions.predictions {
                
                predictionsBySearch.append(count)
                count = count + 1
                
            }
            
        } else {
        
            for prediction in userPredictions.predictions {
            
                if prediction.prediction.lowercaseString.containsString(searchText.lowercaseString) {
                
                    predictionsBySearch.append(count)
                
                }
            
                count = count + 1
            
            }
        }
        
        predictionsTableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        removeTapGestures()
        self.predictionsTableView.userInteractionEnabled = true
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        addTapGestures()
        self.predictionsTableView.userInteractionEnabled = false
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        removeTapGestures()
        self.predictionsTableView.userInteractionEnabled = true
        
    }
    
    /**
     Remove the keyboard from the screen after a tap
     */
    func removeKeyBoardTap(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }
    
    /**
     Remove the keyboard from the screen after a swipe down
     */
    func removeKeyBoardSwipe(sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        
    }
    
    func addTapGestures() {
        
        for gesture in self.view.gestureRecognizers! {
            
            gesture.enabled = true
            
        }
        
    }
    
    func removeTapGestures() {
        
        for gesture in self.view.gestureRecognizers! {
            
            gesture.enabled = false
            
        }
        
    }
    
}
