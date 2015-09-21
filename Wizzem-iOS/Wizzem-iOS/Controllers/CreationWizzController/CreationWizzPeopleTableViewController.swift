//
//  CreationWizzPeopleTableViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 14/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

class CreationWizzPeopleTableViewController: UITableViewController {

    var titleWizz: String!
    var descriptionWizz: String!
    
    @IBOutlet var switchVisibility: UISwitch!
    @IBOutlet var switchOpen: UISwitch!
   
    @IBOutlet var labelVisibility: UILabel!
    @IBOutlet var labelOpenWizz: UILabel!
    @IBOutlet var detailLabelOpenWizz: UILabel!
    
    @IBAction func changeVisibility(sender: AnyObject) {
        if switchVisibility.on {
            labelVisibility.text = "Accés exclusif"
        }
        else {
            labelVisibility.text = "Visible par tous"
        }
    }
    
    @IBAction func changeOpenWizz(sender: AnyObject) {
        if switchOpen.on {
            labelOpenWizz.text = "Fermé"
            detailLabelOpenWizz.text = "Vous seul pourrez publier des wizz dans votre moment."
        }
        else {
            labelOpenWizz.text = "Ouvert"
            detailLabelOpenWizz.text = "Tous les participants peuvent publier des wizz. Vous en gardez cepandant le contrôle."
        }
    }
    
    @IBAction func createWizz(sender: AnyObject) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.color = UIColor(red:0.23, green:0.33, blue:0.33, alpha:1)
        hud.labelText = "Creation de votre moment ..."
        
        let wizz = PFObject(className: "Event")
        wizz["title"] = titleWizz!
        if let description = descriptionWizz {
            wizz["description"] = description
        }
        wizz["creator"] = PFUser.currentUser()
        wizz["public"] = switchVisibility.on
        wizz["author_approval"] = switchOpen.on
        wizz["nbMedia"] = 0
        wizz["nbMaxParticipant"] = 0
        wizz["closed"] = false
        wizz["nbParticipant"] = 0
        
        wizz.saveInBackgroundWithBlock { (_, error: NSError?) -> Void in
            if let _ = error {
                hud.hide(true)
                Alert.error("Erreur survenie lors de la création de votre moment. Veuillez vérifier les champs rentrés, et recommencer.")
                return
            }
            
            let params = NSMutableDictionary()
            params.setValue(wizz.objectId!, forKey: "eventId")
            params.setValue(PFUser.currentUser()?.objectId, forKey: "userId")
            params.setValue("accepted", forKey: "status")
            params.setValue(true, forKey: "approval")
            params.setValue(false, forKey: "invited")
            
            print("params  :\(params)")
            
            PFCloud.callFunctionInBackground("ParticipantAdd", withParameters: params as [NSObject : AnyObject], block: { (result: AnyObject?, error: NSError?) -> Void in

                hud.hide(true)

                if let error = error {
                    print("error : \(error)")
                    Alert.error("Erreur survenie lors de la création de votre moment. Veuillez vérifier les champs rentrés, et recommencer.")
                    return
                }
                if self.switchOpen.on {
                    self.performSegueWithIdentifier("privacySegue", sender: nil)
                }
                else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
}
