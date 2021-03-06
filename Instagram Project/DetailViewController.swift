//
//  DetailViewController.swift
//  Instagram Project
//
//  Created by Grace Egbo on 3/1/16.
//  Copyright © 2016 Grace Egbo. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class DetailViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photos: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // construct PFQuery
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.whereKey("caption", notEqualTo: "")
        query.limit = 20
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                // do something with the data fetched
                
                self.photos = posts
                
                self.tableView.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            } else {
                // handle error
                print("Unable to attain photos from Parse")
            }
        }
        self.tableView.reloadData()
        
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if photos != nil {
            return photos!.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("photoCell", forIndexPath: indexPath) as! PhotoViewCell
        
        let photo = photos![indexPath.row]
        
        let query = PFQuery(className: "UserMedia")
        query.getObjectInBackgroundWithId(photo.objectId!) {
            (post: PFObject?, error: NSError?) -> Void in
            if error == nil
            {
                if let newImage = photo.valueForKey("media")! as? PFFile
                {
                    newImage.getDataInBackgroundWithBlock({ (image: NSData?, error: NSError?) -> Void in
                        
                        if error == nil
                        {
                            cell.photoImageView.image = UIImage(data: image!)
                        }
                    })
                }

            }
            else
            {
                print("I got here!")
                print(error)
            }
        }
        
        if let newImage = PFUser.currentUser()!["profileMedia"] as? PFFile
        {
            newImage.getDataInBackgroundWithBlock({ (image: NSData?, error: NSError?) -> Void in
                
                if error == nil
                {
                    cell.profileImageView.image = UIImage(data: image!)
                }
            })
        }
        else
        {
            print("error")
        }

        cell.captionLabel?.text = photo.valueForKey("caption") as? String
        cell.username.text = PFUser.currentUser()!.username! as String
        
        let timestampString = photo.valueForKey("createdAt") as? NSDate
        
        if let timestampString = timestampString
        {
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "y M d HH:mm:ss Z"
            
            cell.timestamp.text = calculateTimeStamp((timestampString.timeIntervalSinceNow))
        }
        
        return cell
        
    }
    
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        // Turn timeTweetPostedAgo into seconds, minutes, hours, days, or years
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        // Figure out time ago
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(3153600) <= 1) { // YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        /*if (segue.identifier == "toProfileView")
        {
            print("Going to profile page")
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! PhotoViewCell
            
            let indexPath = tableView.indexPathForCell(cell)
            
            let object = photos![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! ProfileViewController
        
        }
        */
    }
    

}
