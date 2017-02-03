//
//  PostCell.swift
//  SocialDev
//
//  Created by Clyfford Millet on 1/29/17.
//  Copyright © 2017 Clyff Millet. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(post: Post) {
        caption.text = post.caption
        likesLbl.text = String(post.likes)
        //let imageData = try Data(contentsOf: URL(string: post.imageURL)!)
        
        //postImg.image = UIImage(data: imageData)
    }

    
}
