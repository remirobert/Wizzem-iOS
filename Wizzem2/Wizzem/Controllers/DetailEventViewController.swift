//
//  DetailEventViewController.swift
//  
//
//  Created by Remi Robert on 12/07/15.
//
//

import UIKit
import Parse

class DetailEventViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var currentEvent: PFObject!
    var medias = Array<PFObject>()
    var currentSelectedMedia: Int!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewLayout: UICollectionViewFlowLayout!
    
    lazy var headerView: HeaderCollectionReusableView! = {
        let headerView = NSBundle.mainBundle().loadNibNamed("HeaderCollectionReusableView", owner: self, options: nil).first as! HeaderCollectionReusableView
        headerView.frame.size.width = CGRectGetWidth(UIScreen.mainScreen().bounds)
//        if let author = self.currentEvent["creator"] as? PFUser {
//            headerView.authorLabel.text = author["true_username"] as? String
//        }
        headerView.addMediaButton.addTarget(self, action: "addMedia", forControlEvents: UIControlEvents.TouchUpInside)
        return headerView
    }()
    
    func addMedia() {
        performSegueWithIdentifier("addMediaSegue", sender: nil)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath) as! HeaderCollectionReusableView
        header.addSubview(headerView)
        return header
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentSelectedMedia = indexPath.row
        performSegueWithIdentifier("detailMediaSegue", sender: medias[indexPath.row])
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("mediaCell", forIndexPath: indexPath) as! MediaCollectionViewCell
        
        cell.previewMedia.image = nil
        
        let currentMedia = medias[indexPath.row]
        if let filePreview = currentMedia["min"] as? PFFile {
            filePreview.getDataInBackgroundWithBlock({ (data: NSData?, _) -> Void in
                if let data = data {
                    
                    let image = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.previewMedia.image = image
                    })
                }
            })
        }
        return cell
    }
    
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
    
    override func viewDidAppear(animated: Bool) {
        fetchMedia()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLayout.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) / 3 - 3, CGRectGetWidth(UIScreen.mainScreen().bounds) / 3 - 3)
        collectionViewLayout.minimumInteritemSpacing = 1
        collectionViewLayout.minimumLineSpacing = 1
        collectionViewLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), 249)
        
        title = currentEvent["title"] as? String
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerClass(HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailMediaSegue" {
            (segue.destinationViewController as! DetailMediaViewController).currentMedia = sender as! PFObject
            (segue.destinationViewController as! DetailMediaViewController).currentEvent = currentEvent
            (segue.destinationViewController as! DetailMediaViewController).currentIndex = currentSelectedMedia
        }
        else if (segue.identifier == "addMediaSegue") {
            (segue.destinationViewController as! CameraViewController).event = currentEvent
        }
    }
    
}
