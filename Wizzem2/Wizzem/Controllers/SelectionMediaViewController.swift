//
//  SelectionMediaViewController.swift
//  
//
//  Created by Remi Robert on 30/07/15.
//
//

import UIKit
import Parse

class SelectionMediaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var currentEvent: PFObject!
    var medias = Array<PFObject>()
    var blockSelectionCell: ((index: Int) -> Void)!
    @IBOutlet var collectionViewLayout: UICollectionViewFlowLayout!

    @IBOutlet var collectionView: UICollectionView!
    
    func fetchMedia() {
        let params = NSMutableDictionary()
        params.setValue(currentEvent.objectId, forKey: "eventId")
        
        PFCloud.callFunctionInBackground("MediaAll", withParameters: params as [NSObject : AnyObject]) { (results: AnyObject?, _) -> Void in
            
            if let results = results as? [PFObject] {
                self.medias = results
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewLayout.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) / 3, CGRectGetWidth(UIScreen.mainScreen().bounds) / 3)
        self.collectionViewLayout.minimumInteritemSpacing = 0
        self.collectionViewLayout.minimumLineSpacing = 0
        
        fetchMedia()
        
        self.collectionView.registerNib(UINib(nibName: "SelectMediaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectionMediaCell")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension SelectionMediaViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.blockSelectionCell(index: indexPath.row)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("selectionMediaCell", forIndexPath: indexPath) as! SelectMediaCollectionViewCell
        
        cell.mediaPreview.image = nil
        
        let currentMedia = medias[indexPath.row]
        if let filePreview = currentMedia["min"] as? PFFile {
            filePreview.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                if let data = data {
                    
                    let image = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.mediaPreview.image = image
                    })
                }
            })
        }
        return cell
    }
}
