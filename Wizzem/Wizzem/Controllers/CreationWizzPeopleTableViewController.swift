//
//  CreationWizzPeopleTableViewController.swift
//  Wizzem
//
//  Created by Remi Robert on 14/06/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class CreationWizzPeopleTableViewController: UITableViewController {

    var wizz: PFObject!
    var numberPeople: UILabel!
    var inviteOption1: Bool = false
    var inviteOption2: Bool = false
    @IBOutlet var sliderNumberParticipant: UISlider!
    @IBOutlet var numberTextFlied: UILabel!
    @IBOutlet var switchOption2: UISwitch!
    @IBOutlet var indicatorLabelOption: UILabel!
    
    @IBAction func changeValue(sender: AnyObject) {
        let slider = sender as! UISlider
        if slider.value == 31 {
            numberTextFlied.text = "Illimité"
        }
        else {
            numberTextFlied.text = "\(Int(slider.value))"
        }
    }
    
    @IBAction func changeOption1(sender: AnyObject) {
        inviteOption1 = (sender as! UISwitch).on
        if (sender as! UISwitch).on {
            switchOption2.alpha = 1
            indicatorLabelOption.alpha = 1
        }
        else {
            switchOption2.alpha = 0.4
            indicatorLabelOption.alpha = 0.4
            switchOption2.on = false
            inviteOption2 = false
        }
    }
    
    @IBAction func changeOption2(sender: AnyObject) {
        inviteOption2 = (sender as! UISwitch).on
    }
    
    @IBAction func createWizz(sender: AnyObject) {
        if sliderNumberParticipant == 31 {
            wizz.setValue(0, forKey: "nbMaxParticipant")
        }
        else {
            wizz.setValue(Int(sliderNumberParticipant.value), forKey: "nbMaxParticipant")
        }
        wizz.setValue(inviteOption1, forKey: "sharing")
        wizz.setValue(inviteOption2, forKey: "author_approval")
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Creation de votre Wizz"
        
        wizz.saveInBackgroundWithBlock { (success: Bool, err: NSError?) -> Void in
            hud.hide(true)
            println("\(err)")
            if success {
                
            }
            else {
                Alert.error("Création du Wizz impossible")
            }
        }
    }
}
