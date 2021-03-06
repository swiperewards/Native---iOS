//
//  ReferandEarnViewController.swift
//  Nouvo
//
//  Created by Bharathan on 24/09/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit
import Fontello_Swift

class ReferandEarnViewController: UIViewController {

    @IBOutlet var Referralcode: UILabel!
    @IBOutlet var Swipelogoicon: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Database.set(Constants.mycode, forKey: Constants.mycodeKey)
        
        let invitecode: String?
        invitecode = Database.value(forKey: Constants.mycodeKey) as? String
        if  invitecode == "" || invitecode == nil{
        }
        else{
            
            Referralcode.text = invitecode
        }
        
        let fontNuovo = FontNuovo()
        Swipelogoicon.font = fontNuovo.fontOfSize(60)
        Swipelogoicon.text = fontNuovo.stringWithName(.Nuovo)
        Swipelogoicon.textColor = UIColor.white
        setUpNavBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "REFER & EARN"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func Invite(_ sender: Any) {
        
                        let text = "Hey, join this Nouvo app to get rewards on card swipe. Enter my code (%s) and we'll each get rewards!"
                        // set up activity view controller
        let textToShare = [ text , Referralcode.text! ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                        // exclude some activity types from the list (optional)
                        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.mail,UIActivityType.message,UIActivityType.postToTwitter ]
                        // present the view controller
                        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
