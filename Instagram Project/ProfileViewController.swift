//
//  ProfileViewController.swift
//  Instagram Project
//
//  Created by Grace Egbo on 3/5/16.
//  Copyright © 2016 Grace Egbo. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var numPosts: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    

    var user: PFUser!
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        user = PFUser.currentUser()
        
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        username.text = user.username

        if let newImage = self.user["profileMedia"] as? PFFile
        {
            newImage.getDataInBackgroundWithBlock({ (image: NSData?, error: NSError?) -> Void in
                
                if error == nil
                {
                    self.profileImageView.image = UIImage(data: image!)
                    self.instructionLabel.hidden = false
                }
            })
        }
        else
        {
            print("error")
        }
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        
        if let newImage = self.user["profileMedia"] as? PFFile
        {
            newImage.getDataInBackgroundWithBlock({ (image: NSData?, error: NSError?) -> Void in
                
                if error == nil
                {
                    self.profileImageView.image = UIImage(data: image!)
                    self.instructionLabel.hidden = false

                }
            })
        }
        else
        {
            print("error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPress(sender: AnyObject) {
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImageView.image = originalImage
        
        // Do something with the images (based on your use case)
        instructionLabel.hidden = true
        
        UserMedia.postUserProfileImage(profileImageView.image) { (boolean: Bool, error: NSError?) -> Void in
            print("Successfully updated profile picture")
            self.user["profileMedia"] = UserMedia.getPFFileFromImage(originalImage)
            print(self.user)
        }
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        //self.present
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
