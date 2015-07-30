//
//  DetailMediaViewController.swift
//  
//
//  Created by Remi Robert on 12/07/15.
//
//

import UIKit
import FLAnimatedImage
import Parse

class DetailMediaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var currentEvent: PFObject!
    var currentMedia: PFObject!
    var currentIndex: Int!
    var dataMedia: NSData!
    var medias: [PFObject]!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleEvent: UILabel!
    @IBOutlet var currentMediaLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var collectionViewLayout: UICollectionViewFlowLayout!
    
    @IBAction func closeController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func upToDetailMoment(sender: AnyObject) {
        self.collectionView.setContentOffset(CGPointZero, animated: true)
    }
    
    @IBAction func displayOptions(sender: AnyObject) {
        let alertController = UIAlertController(title: "Options media", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let removeAction = UIAlertAction(title: "Supprimer", style: UIAlertActionStyle.Destructive) { (_) -> Void in
            let param = NSMutableDictionary()
            param.setValue(self.currentMedia.objectId!, forKey: "mediaId")
            
            PFCloud.callFunctionInBackground("MediaRemove", withParameters: param as [NSObject : AnyObject], block: { (_, err: NSError?) -> Void in
                if err == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    Alert.error("Impossible de supprimer votre Wizz.")
                }
            })
        }
        
        let shareAction = UIAlertAction(title: "Partager", style: UIAlertActionStyle.Default) { (_) -> Void in
            let activityController = UIActivityViewController(activityItems: [self.dataMedia], applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
        }
        
        alertController.addAction(shareAction)
        alertController.addAction(removeAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        
        if indexPath.row > 0 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellPreview", forIndexPath: indexPath) as! PreviewDetailWizzCollectionViewCell
            (cell as! PreviewDetailWizzCollectionViewCell).loadData(medias[indexPath.row - 1])
        }
        else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("detailMomentCell", forIndexPath: indexPath) as! DetailMomentCollectionViewCell
            (cell as! DetailMomentCollectionViewCell).loadDetailMoment(self.currentEvent)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            if (indexPath.row == 0) {
                self.currentMediaLabel.frame.origin.y = -40
            }
            else {
                self.currentMediaLabel.frame.origin.y = 15
            }
        })
        
        if (indexPath.row >= 1) {
            self.currentMediaLabel.text = "(\(indexPath.row) / \(self.medias.count)))"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController
        self.collectionViewLayout.itemSize = CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds))
        self.collectionViewLayout.minimumInteritemSpacing = 0
        self.collectionViewLayout.minimumLineSpacing = 0

        self.collectionView.registerNib(UINib(nibName: "DetailMomentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "detailMomentCell")
        self.collectionView.registerNib(UINib(nibName: "PreviewDetailWizzCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellPreview")
        
        self.collectionView.pagingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectMediaSegue" {
            (segue.destinationViewController as! SelectionMediaViewController).currentEvent = self.currentEvent
            (segue.destinationViewController as! SelectionMediaViewController).blockSelectionCell = {(index: Int) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let indexPos = CGRectGetHeight(UIScreen.mainScreen().bounds) * CGFloat((index + 1))
                    
                    self.collectionView.setContentOffset(CGPointMake(0, CGFloat(indexPos)), animated: true)
                })
            }
            
        }
    }
    
}
