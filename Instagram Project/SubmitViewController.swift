//
//  SubmitViewController.swift
//  Instagram Project
//
//  Created by Grace Egbo on 3/1/16.
//  Copyright © 2016 Grace Egbo. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var instructionLabel: UILabel!
    
    let vc = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectPicture(sender: AnyObject) {
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
            photoImageView.image = editedImage
            
            // Do something with the images (based on your use case)
            instructionLabel.hidden = true
            
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        
        if (photoImageView.image != nil)
        {
            UserMedia.postUserImage(photoImageView.image, withCaption: captionField.text) { (boolean: Bool, error: NSError?) -> Void in
                self.performSegueWithIdentifier("detailView", sender: nil)
                print("Successfully uploaded image!")
            }
        }
        
        
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
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
