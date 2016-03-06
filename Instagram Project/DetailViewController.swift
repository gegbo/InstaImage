//
//  DetailViewController.swift
//  Instagram Project
//
//  Created by Grace Egbo on 3/1/16.
//  Copyright © 2016 Grace Egbo. All rights reserved.
//

import UIKit
import Parse

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
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                // do something with the data fetched
                self.photos = posts
                self.tableView.reloadData()
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
                let newImage = photo.valueForKey("media")! as? PFFile
                newImage?.getDataInBackgroundWithBlock({ (image: NSData?, error: NSError?) -> Void in
                    
                    if error == nil
                    {
                        cell.photoImageView.image = UIImage(data: image!)
                    }
                })
            }
            else
            {
                print(error)
            }
        }
        cell.captionLabel?.text = photo.valueForKey("caption") as? String
        return cell
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
