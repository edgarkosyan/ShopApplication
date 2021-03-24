//
//  ProfileViewController.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 07.03.21.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class LogInViewController: UIViewController {

    var hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: .gray, padding: nil)
    }
    
    func setBackButton(){
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonAction))]
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
   
    //MARK: ACTIONS
    
    @IBAction func backgroundTapGesture(_ sender: Any) {
        self.view.endEditing(false)
    }
    
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
            
            User.logInUser(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                if error == nil {
                        print("User was Logged")
                        self.navigationController?.popViewController(animated: true)
                }else{
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
                self.activityIndicator!.removeFromSuperview()
                self.activityIndicator!.stopAnimating()
            }
        }else {
            self.hud.textLabel.text = "All Fields Are Required"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
//    func loggedInStatus(){
//        let value = ["isLoggedIn": true]
//
//        updateUserStatusInFirestore(value: value) { (error) in
//            if error == nil {
//                print("done")
//
//            }else{
//                print("error")
//            }
//        }
            
        
   // }
    
    @IBAction func forgorPasswordClicked(_ sender: Any) {
    }
    
    
    
    @IBAction func addItem(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addproduct")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Setups
    func setUpView(){
        signInButton.backgroundColor = UIColor.init(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.6)
        signInButton.layer.cornerRadius = 4
        
    }

    
    
    
}
