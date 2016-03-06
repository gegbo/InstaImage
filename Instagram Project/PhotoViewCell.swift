//
//  PhotoViewCell.swift
//  Instagram Project
//
//  Created by Grace Egbo on 3/5/16.
//  Copyright © 2016 Grace Egbo. All rights reserved.
//

import UIKit

class PhotoViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var createdAt: NSDate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
