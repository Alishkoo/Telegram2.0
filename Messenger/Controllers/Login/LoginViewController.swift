//
//  LoginViewController.swift
//  Messenger
//
//  Created by Alibek Baisholanov on 19.01.2025.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    
    //MARK: UIViews
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo3")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue // Sets the return key to say “Continue” instead of “Return.”
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1 // Adds a 1-point border around the text field.
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done // sets the return to say "Return"
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1 // Adds a 1-point border around the text field.
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.isSecureTextEntry = true
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let googleLogInButton = GIDSignInButton()
    
    //MARK: ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log in"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        //MARK: target login, delegates
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        googleLogInButton.addTarget(self,
                                    action: #selector(googleSignInButtonTapped),
                                    for: .touchUpInside)
        emailField.delegate = self
        passwordField.delegate = self
        
        //MARK: Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(googleLogInButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: Set frames to scrollViews
        scrollView.frame = view.bounds
        
        let size = view.width / 3
        imageView.frame = CGRect(x: (view.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom + 10,
                                   width: scrollView.width - 60,
                                   height: 52)
        googleLogInButton.frame = CGRect(x: 30,
                                         y: loginButton.bottom + 10,
                                         width: scrollView.width - 60,
                                         height: 52)
    }
    
    //MARK: objc functions
    
    @objc private func loginButtonTapped(){
        
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty else {
            alertUserLoginError()
            return
        }
        
        //загрузочный экранчик
//        LoadingManager.shared.showLoading(on: self)
        spinner.show(in: view)
        
        //MARK: Firebase Log in
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] AuthResult, error in
            
            guard let strongSelf = self else {
                return
            }
            
            guard let result = AuthResult, error == nil else {
                print("Errod with logging email: \(email)")
                return
            }
            
            let user = result.user
            print("Logged user: \(user)")
            
            //all view processes must be in main thread
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            strongSelf.navigationController?.dismiss(animated: false, completion: nil)
        })
    }
    
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil
                                     ))
        present(alert, animated: true)
    }
    
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: objc google sign in
    @objc private func googleSignInButtonTapped(){
        
        //загрузочный экранчик
        LoadingManager.shared.showLoading(on: self)
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {[weak self] userAuthentication, error in
            
            if let error = error {
                print("Error signing in with Google: \(error.localizedDescription)")
                return
            }
            
            guard let user = userAuthentication?.user else {
                print("Failed to sign in with Google.")
                return
            }
            
            guard let email = user.profile?.email,
                  let firstName = user.profile?.givenName,
                  let lastName = user.profile?.familyName else {
                print("Error: with taking email, firstname, secondName")
                return
            }
            
            DatabaseManager.shared.userExists(with: email, completion: {exists in
                if !exists {
                    //insert to database
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                        lastName: lastName,
                                                                        emailAddress: email))
                }
            })
            
            guard let idToken = user.idToken else {
                print("error idtoken")
                return
            }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
                guard authResult != nil, error == nil else{
                    print("failed to log with google credential: ")
                    return
                }
                
                print("Successfully signed in with Google cred.")
                
                //Dissmiss
                guard let strongSelf = self else {
                    return
                }
                
                LoadingManager.shared.hideLoading()
                
                strongSelf.navigationController?.dismiss(animated: false, completion: nil)
                
            })
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
    
}
