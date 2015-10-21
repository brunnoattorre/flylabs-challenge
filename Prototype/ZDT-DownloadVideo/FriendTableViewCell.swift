//
//  FriendTableViewCell.swift
//  Prototype
//
//  Created by Ben Lieblich on 10/20/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
