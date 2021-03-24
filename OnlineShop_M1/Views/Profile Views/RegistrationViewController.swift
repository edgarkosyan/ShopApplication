//
//  RegistrationViewController.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 13.03.21.
//

import UIKit
import JGProgressHUD

class RegistrationViewController: UIViewController {
    
    var hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var repeatPasswordTextViewd: UITextField!
    @IBOutlet weak var backToLogInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    @IBOutlet weak var emailAdressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setBackButton()
    }
    
    
    
    @IBAction func backViewTapped(_ sender: Any) {
        self.view.endEditing(false)
    }
    func setBackButton(){
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonAction))]
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpView(){
        
        emailAdressTextField.borderStyle = .none
        passwordTextField.borderStyle = .none
        repeatPasswordTextViewd.borderStyle = .none
        backToLogInButton.layer.cornerRadius = 4
        backToLogInButton.layer.borderWidth = 2
        backToLogInButton.layer.borderColor = UIColor.gray.cgColor
        backToLogInButton.tintColor = UIColor.darkGray
        registerButton.layer.cornerRadius = 4
        registerButton.backgroundColor = UIColor.init(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        if  emailAdressTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextViewd.text != "" {
            
            if passwordTextField.text == repeatPasswordTextViewd.text {
                User.registerUser(email: emailAdressTextField.text!, password: passwordTextField.text!) { (error) in
                    
                    if error == nil {
                        self.hud.textLabel.text = "Registration Completed"
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.show(in: self.view)
                        self.hud.dismiss(afterDelay: 2.0)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    } else {
                        self.hud.textLabel.text = error!.localizedDescription
                        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        self.hud.show(in: self.view)
                        self.hud.dismiss(afterDelay: 2.0)
                    }
                }
            }else{
                self.hud.textLabel.text = "Password mismatch"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }else {
            self.hud.textLabel.text = "All Fields Are Required"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func backToLoginClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
