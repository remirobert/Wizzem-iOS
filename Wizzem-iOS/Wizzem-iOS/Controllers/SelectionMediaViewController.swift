//
//  SelectionMediaViewController.swift
//  
//
//  Created by Remi Robert on 30/07/15.
//
//

import UIKit

class SelectionMediaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var numberWizzLabel: UILabel!
    var currentEvent: PFObject!
    var currentIndex: Int!
    var medias = Array<PFObject>()
    var blockSelectionCell: ((index: Int) -> Void)!
    @IBOutlet var collectionViewLayout: UICollectionViewFlowLayout!

    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchMedia() {
        let params = NSMutableDictionary()
        params.setValue(currentEvent.objectId, forKey: "eventId")
        
        PFCloud.callFunctionInBackground("MediaAll", withParameters: params as [NSObject : AnyObject]) { (results: AnyObject?, _) -> Void in
            
            if let results = results as? [PFObject] {
                self.medias = results
                self.numberWizzLabel.text = "\(self.medias.count) wizz"
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.collectionViewLayout.itemSize = CGSizeMake((CGRectGetWidth(self.collectionView.frame) - 6) / 3, (CGRectGetWidth(self.collectionView.frame) - 6) / 3)
        self.collectionViewLayout.minimumInteritemSpacing = 2
        self.collectionViewLayout.minimumLineSpacing = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numberWizzLabel.text = nil
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
        
        cell.contentView.layer.borderWidth = 0
        
        if self.currentIndex == indexPath.row {
            cell.contentView.layer.borderWidth = 3
            cell.contentView.layer.borderColor = UIColor(red:0.3, green:0.85, blue:0.39, alpha:1).CGColor
        }
        
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
