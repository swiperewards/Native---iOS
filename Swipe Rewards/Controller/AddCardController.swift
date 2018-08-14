//
//  AddCardController.swift
//  Swipe Rewards
//
//  Created by Bharathan on 26/07/18.
//  Copyright © 2018 SwipeRewards. All rights reserved.
//

import UIKit

class AddCardController: UIViewController,UITextFieldDelegate {
 var creditCardValidator: CreditCardValidator!
    
    @IBOutlet weak var CardImagevw: UIImageView!
    @IBOutlet weak var NameonCardICON: UILabel!
    @IBOutlet weak var CvvICON: UILabel!
    @IBOutlet weak var ExpiryICON: UILabel!
    @IBOutlet weak var CardnumberICON: UILabel!
    @IBOutlet weak var NameonCard: FloatLabelTextField!
    @IBOutlet weak var Cvv: FloatLabelTextField!
    @IBOutlet weak var ExpiryOn: FloatLabelTextField!
    @IBOutlet weak var CardNumber: FloatLabelTextField!
    @IBOutlet weak var AddButton: UIButton!
    var Input = [String: AnyObject]()
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = MonthYearPickerView()
        ExpiryOn.delegate = self
        ExpiryOn.inputView = pickerView
        pickerView.onDateSelected = { (month: Int, year: Int) in
            let expirymonthandyear = String(format: "%02d/%d", month, year)
            self.ExpiryOn.text = expirymonthandyear
        }
        
        setUpNavBar()
        // Initialise Credit Card Validator
        creditCardValidator = CreditCardValidator()
        let fontswipe = FontSwipe()
        CardnumberICON.font = fontswipe.fontOfSize(20)
        CardnumberICON.text = fontswipe.stringWithName(.Wallet)
        CardnumberICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        ExpiryICON.font = fontswipe.fontOfSize(20)
        ExpiryICON.text = fontswipe.stringWithName(.Password)
        ExpiryICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        CvvICON.font = fontswipe.fontOfSize(20)
        CvvICON.text = fontswipe.stringWithName(.Password)
        CvvICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        NameonCardICON.font = fontswipe.fontOfSize(20)
        NameonCardICON.text = fontswipe.stringWithName(.Username)
        NameonCardICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "ADD CARD"
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func AddTap(_ sender: Any) {
        //Check Internet Connectivity
        if !NetworkConnectivity.isConnectedToNetwork() {
            let alert = UIAlertController(title: Constants.NetworkerrorTitle , message: Constants.Networkerror, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //Check All Input Fields are empty ot not
        if !isAllFieldSet() {
            return
        }
        
        AddCardAPIInputBody() //Calling Input API Body for SignUp
        AddButton.isUserInteractionEnabled = false
        AddButton.backgroundColor = UIColor.lightGray
        AddButton.setTitle("", for: .normal)
        showSpinning()
        let DealsAPI = SwipeRewardsAPI.serverURL + SwipeRewardsAPI.AddCardURL
        RequestManager.PostPathwithAUTH(urlString: DealsAPI, params: Input, successBlock:{
            (response) -> () in self.AddCardResponse(response: response as! [String : AnyObject])})
        { (error: NSError) ->() in }
        
    }
    
    
    //MARK: -  SignUp API Input Body
    func AddCardAPIInputBody(){
    
        CardNumber.text = CardNumber.text?.replacingOccurrences(of: "-", with: "")
        ExpiryOn.text = ExpiryOn.text?.replacingOccurrences(of: "-", with: "")
        let expiryMonth = ExpiryOn.text?.prefix(2)
        let expiryYear = ExpiryOn.text?.prefix(24)
        
        let deviceid = UIDevice.current.identifierForVendor?.uuidString
        Input =  [
            "deviceId": deviceid as AnyObject,
            "lat": "" as AnyObject,
            "long": "" as AnyObject,
            "platform": "IOS" as AnyObject,
            "requestData": [
                "cardNumber": CardNumber.text as AnyObject,
                "expiryMonthMM": expiryMonth as AnyObject,
                "expiryYearYYYY": expiryYear as AnyObject,
                "cvv": Cvv.text as AnyObject,
                "nameOnCard": NameonCard.text as AnyObject
            ]] as [String : AnyObject]
    }
    //MARK: -  Fetching Signup data from server
    func AddCardResponse(response: [String : AnyObject]){
        print("AddCardResponse :", response)
        let success:String = String(format: "%@", response["status"] as! NSNumber) //Status checking
        if success == "200" {
            AddButton.isUserInteractionEnabled = true
            hideLoading()
            let alert = UIAlertController(title: "Add Card", message: "Successfully added to your wallet", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: dosomething)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "Add Card", message: "Card already exists in your wallet", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            CardNumber.text = ""
            ExpiryOn.text = ""
            Cvv.text = ""
            NameonCard.text = ""
            
            AddButton.isUserInteractionEnabled = true
            hideLoading()
        }
        
    }
    func dosomething(action: UIAlertAction)   {
        self.navigationController?.popViewController(animated: true)
    }
    func isAllFieldSet() -> Bool {
        let fontswipe = FontSwipe()
        CardnumberICON.font = fontswipe.fontOfSize(20)
        CardnumberICON.text = fontswipe.stringWithName(.Wallet)
        ExpiryICON.font = fontswipe.fontOfSize(20)
        ExpiryICON.text = fontswipe.stringWithName(.Password)
        CvvICON.font = fontswipe.fontOfSize(20)
        CvvICON.text = fontswipe.stringWithName(.Password)
        NameonCardICON.font = fontswipe.fontOfSize(20)
        NameonCardICON.text = fontswipe.stringWithName(.Username)
        
        if (CardNumber.text?.isEmpty)! {
            CardNumber.attributedPlaceholder = NSAttributedString(string: Constants.emptyCardNumber, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            CardNumber.titleTextColour = UIColor.red
            CardnumberICON.textColor = UIColor.red
            
            ExpiryICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ExpiryOn.attributedPlaceholder = NSAttributedString(string: Constants.Expiry)
            ExpiryOn.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            CvvICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Cvv.attributedPlaceholder = NSAttributedString(string: Constants.Cvv)
            Cvv.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            NameonCardICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            NameonCard.attributedPlaceholder = NSAttributedString(string: Constants.NameonCard)
            NameonCard.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            
            return false
        }else if (ExpiryOn.text?.isEmpty)! {
            ExpiryOn.attributedPlaceholder = NSAttributedString(string: Constants.emptyExpiry, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            ExpiryOn.titleTextColour = UIColor.red
            ExpiryICON.textColor = UIColor.red
            
            CardnumberICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            CardNumber.attributedPlaceholder = NSAttributedString(string: Constants.CardNumber)
            CardNumber.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            CvvICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Cvv.attributedPlaceholder = NSAttributedString(string: Constants.Cvv)
            Cvv.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            NameonCardICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            NameonCard.attributedPlaceholder = NSAttributedString(string: Constants.NameonCard)
            NameonCard.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
        }else if (Cvv.text?.isEmpty)! {
            Cvv.attributedPlaceholder = NSAttributedString(string: Constants.emptyCvv, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            Cvv.titleTextColour = UIColor.red
            CvvICON.textColor = UIColor.red
            
            CardnumberICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            CardNumber.attributedPlaceholder = NSAttributedString(string: Constants.CardNumber)
            CardNumber.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ExpiryICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ExpiryOn.attributedPlaceholder = NSAttributedString(string: Constants.Expiry)
            ExpiryOn.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            NameonCardICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            NameonCard.attributedPlaceholder = NSAttributedString(string: Constants.NameonCard)
            NameonCard.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
        }else if (NameonCard.text?.isEmpty)! {
            NameonCard.attributedPlaceholder = NSAttributedString(string: Constants.emptyNameonCard, attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            NameonCard.titleTextColour = UIColor.red
            NameonCardICON.textColor = UIColor.red
            
            CardnumberICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            CardNumber.attributedPlaceholder = NSAttributedString(string: Constants.CardNumber)
            CardNumber.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ExpiryICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ExpiryOn.attributedPlaceholder = NSAttributedString(string: Constants.Expiry)
            ExpiryOn.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            CvvICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Cvv.attributedPlaceholder = NSAttributedString(string: Constants.Cvv)
            Cvv.titleTextColour = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            
            return false
        }else if !creditCardValidator.validate(string: CardNumber.text!) {
            
            let alert = UIAlertController(title: "Card Number", message: "Invalid Card Number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }else if  CardNumber.text!.characters.count != 19{
            let alert = UIAlertController(title: "Card Number", message: "Enter 16 digit Card Number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return false
        }else {
            CardnumberICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            ExpiryICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            CardNumber.attributedPlaceholder = NSAttributedString(string: Constants.CardNumber, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            CardNumber.titleTextColour = UIColor.darkGray
            ExpiryOn.attributedPlaceholder = NSAttributedString(string: Constants.Expiry, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            ExpiryOn.titleTextColour = UIColor.darkGray
            CvvICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            Cvv.attributedPlaceholder = NSAttributedString(string: Constants.Cvv, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            Cvv.titleTextColour = UIColor.darkGray
            NameonCardICON.textColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
            NameonCard.attributedPlaceholder = NSAttributedString(string: Constants.NameonCard, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            NameonCard.titleTextColour = UIColor.darkGray
            return true
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
         //MARK: -  Expiry On
        if textField == ExpiryOn{
            
            if CardNumber.text!.characters.count != 19{
                CardNumber.attributedPlaceholder = NSAttributedString(string: "Enter 16 digit Card Number", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
                CardNumber.titleTextColour = UIColor.red
                CardnumberICON.textColor = UIColor.red
            }
            else{
                if range.location == 7 {
                    return false}
                // Auto-add hyphen before appending 4rd or 7th digit
                if range.length == 0 && (range.location == 2 || range.location == 3) {
                    ExpiryOn.text = "\(textField.text!)-\(string)"
                    return false
                }
            }
            
       
        }//MARK: -  Card Number
        else if textField == CardNumber{
            
            
            if range.location == 19 {
                return false}
            // Auto-add hyphen before appending 4rd or 7th digit
            if range.length == 0 && (range.location == 4 || range.location == 9 || range.location == 14) {
                CardNumber.text = "\(textField.text!)-\(string)"
                return false
            }
            validateCardNumber(number: CardNumber.text!)
            detectCardNumberType(number: CardNumber.text!)
        }else if textField == Cvv {
            if range.location == 3 {
                return false}
        }
        else{
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 28

        }
        
        
        
        return true
    }
        
    
        
    
    
//        let numberOnly = NSCharacterSet.init(charactersIn: "0123456789")
//        let stringFromTextField = NSCharacterSet.init(charactersIn: string)
//        let strValid = numberOnly.isSuperset(of: stringFromTextField as CharacterSet)
//        return strValid
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }/**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        validateCardNumber(number: CardNumber.text!)
        validateCardNumberdigit(number: CardNumber.text!)
        self.view.endEditing(true)
    }
    
    //MARK: -  Activity Indicator
    func hideLoading(){
        AddButton.setTitle("ADD", for: .normal)
        AddButton.backgroundColor = UIColor(red: 80/255, green: 198/255, blue: 254/255, alpha: 1)
        indicator.stopAnimating()
    }
    private func createActivityIndicator() -> UIActivityIndicatorView {
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.white
        return indicator
    }
    private func showSpinning() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        AddButton.addSubview(indicator)
        centerActivityIndicatorInButton()
        indicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: AddButton, attribute: .centerX, relatedBy: .equal, toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0)
        AddButton.addConstraint(xCenterConstraint)
        let yCenterConstraint = NSLayoutConstraint(item: AddButton, attribute: .centerY, relatedBy: .equal, toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0)
        AddButton.addConstraint(yCenterConstraint)
    }
    /**
     Credit card validation
     
     - parameter number: credit card number
     */
    func validateCardNumber(number: String) {
        if creditCardValidator.validate(string: number) {
            
            CardNumber.attributedPlaceholder = NSAttributedString(string: "Card Number", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
            CardNumber.titleTextColour = UIColor.gray
            CardnumberICON.textColor = UIColor.gray
            
       
        } else {
            CardNumber.attributedPlaceholder = NSAttributedString(string: "Card Number is Invalid", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            CardNumber.titleTextColour = UIColor.red
            CardnumberICON.textColor = UIColor.red
        }
    }
    func validateCardNumberdigit(number: String) {
    }
    
    /**
     Credit card type detection
     
     - parameter number: credit card number
     */
    func detectCardNumberType(number: String) {
        if let type = creditCardValidator.type(from: number) {
            
            print(type.name)
            CardImagevw.isHidden = false
            CardnumberICON.isHidden = true
            
            if type.name == "Visa"{
                let image: UIImage = UIImage(named: "Visa")!
                CardImagevw.image = image
            }else if type.name == "Amex"{
                let image: UIImage = UIImage(named: "Amex")!
                CardImagevw.image = image
            }else if type.name == "MasterCard"{
                let image: UIImage = UIImage(named: "MasterCard")!
                CardImagevw.image = image
            }else if type.name == "Maestro"{
                let image: UIImage = UIImage(named: "Maestro")!
                CardImagevw.image = image
            }else if type.name == "Diners Club"{
                let image: UIImage = UIImage(named: "DinersClub")!
                CardImagevw.image = image
            }else if type.name == "JCB"{
                let image: UIImage = UIImage(named: "JCB")!
                CardImagevw.image = image
            }else if type.name == "Discover"{
                let image: UIImage = UIImage(named: "Discover")!
                CardImagevw.image = image
            }else if type.name == "UnionPay"{
                let image: UIImage = UIImage(named: "UnionPay")!
                CardImagevw.image = image
            }else if type.name == "RuPay"{
                let image: UIImage = UIImage(named: "RuPay")!
                CardImagevw.image = image
            }else{
                CardnumberICON.isHidden = false
                CardImagevw.isHidden = true
            }
            
            
            
        } else {
            CardnumberICON.isHidden = false
            CardImagevw.isHidden = true
            
//            self.cardTypeLabel.text = "Undefined"
//            self.cardTypeLabel.textColor = UIColor.red
        }
    }
    
    @IBAction func CardNumberValidation(sender: UITextField) {
        if let number = sender.text {
            if number.isEmpty {
               
            } else {
                validateCardNumber(number: number)
                detectCardNumberType(number: number)
            }
        }
    }
}