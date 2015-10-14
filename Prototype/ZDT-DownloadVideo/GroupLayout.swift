//
//  GroupLayout.swift
//  Prototype
//
//  Created by Brunno Attorre on 10/14/15.
//  Copyright © 2015 Sztanyi Szabolcs. All rights reserved.
//
import UIKit

let reuseIdentifier = "collCell"

class GroupLayout: UICollectionViewDataSource {
    
    
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    let titles = ["Sand Harbor, Lake Tahoe - California","Beautiful View of Manhattan skyline.","Watcher in the Fog","Great Smoky Mountains National Park, Tennessee","Most beautiful place"]
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    @objc func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.title.text = self.titles[indexPath.row % 5]
        let imgName = "securitymonkeyHead.jpg"
        cell.pinImage.image = UIImage(named: imgName)
        return cell
    }
    
    
   
}