//
//  ProfilViewController.swift
//  OnlineShop_M1
//
//  Created by edgar kosyan on 16.03.21.
//

import UIKit

class ProfilViewController: UIViewController {
    
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpView()
        signOutButton.isHidden = true
        addItemButton.isHidden = true
        self.view.reloadInputViews()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkOnboardingStatus()
        
        
    }
    
    
    
    
    func checkOnboardingStatus(){
        if User.currentUser() != nil{
            // if User.currentUser()!.isLoggedIn == true  {
            checkForModerator()
            self.signOutButton.isHidden = false
            self.stackView.isHidden = true
            self.currentUserNameLabel.text = "\(User.currentUser()!.email)"
            print("enter in profile View")
            //            }else{
            //
            //            }
        }else{
            
            print("User == nil")
            
        }
    }
    
    func checkForModerator(){
        if User.currentUser() != nil && User.currentUser()?.email == "e.kosyan0073@gmail.com"{
            addItemButton.isHidden = false
        }else{
            addItemButton.isHidden = true
        }
        
    }
    
    @IBAction func addItemButtonClicked(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "addproduct")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func signOutButtonClicked(_ sender: Any) {
        logOut()
        signOutButton.isHidden = true
        stackView.isHidden = false
        currentUserNameLabel.text = "Profile"
        addItemButton.isHidden = true
        
    }
    
    func loggedOutStatus(){
        let value = ["isLoggedIn": false]
        
        updateUserStatusInFirestore(value: value) { (error) in
            
            if error == nil {
                print("status was changed")
                
            }else{
                print("error updating status")
            }
        }
    }
    
    func logOut(){
        User.loggOutCurrentUser { (error) in
            if error == nil {
                print("Logged Out")
            }
        }
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "signIn")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createAccountClicked(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "createaccount")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!
        ]
        // chevron.backward
        navigationItem.title = "Midiart"
        navigationController?.navigationBar.titleTextAttributes = attrs
        //navigationItem.backButtonTitle = "Back"
    }
    func setUpView(){
        signInButton.layer.cornerRadius = 4
        createAccountButton.layer.cornerRadius = 4
    }
}
