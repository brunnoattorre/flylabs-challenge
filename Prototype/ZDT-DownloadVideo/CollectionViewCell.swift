//
//  CollectionViewCell.swift
//  Prototype
//
//  Created by Brunno Attorre on 10/14/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//

//
//  CollectionViewCell.swift
//  PinterestLayout
//
//  Created by Shrikar Archak on 12/21/14.
//  Copyright (c) 2014 Shrikar Archak. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    var groupId: Int!
    @IBOutlet weak var personImage2: UIImageView!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personImage3: UIImageView!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var notification_image: UIImageView!
}