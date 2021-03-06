//
//  LoginViewController.swift
//  FinalChallenge
//
//  Created by Andre Machado Parente on 29/08/17.
//  Copyright :copyright: 2017 Andre Machado Parente. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FBSDKLoginKit


class LoginViewController: UIViewController {
    var modelAccess : ModelAccessFacade!
    
    var nameTxtField: KaedeTextField!
    var emailTxtField: KaedeTextField!
    var passwordTxtField: KaedeTextField!
    var fbLoginButton: FBSDKLoginButton!
    var loginButton: UIButton!
    
    var nameRegisterTxtField: KaedeTextField!
    var emailRegisterTxtField: KaedeTextField!
    var passwordRegisterTxtField: KaedeTextField!
    var fbRegisterButton: FBSDKLoginButton!
    var registerButton: UIButton!
    
    var loginView: UIView!
    var registerView: UIView!
    
    var entrarLbl: UILabel!
    var registrarLbl: UILabel!
    var registrarlateralLbl: UILabel!
    
    var loginRecognizer: UITapGestureRecognizer!
    var registerRecognizer: UITapGestureRecognizer!
    
    var logoImage: UIImageView!
    var setViewMovedUp: Bool = false
    var loginViewSelected: Bool = false
    var registerViewSelected: Bool = false
    var anyTxtFieldIsActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        modelAccess = ModelAccessFacade.init()
        
        // Do  any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if modelAccess == nil{
            ModelAccessFacade.init()
        }
        
        if let user = Auth.auth().currentUser {
//            DatabaseAccess.sharedInstance.fetchUserInfoBy(id: user.uid, callback: { (success: Bool) in
//                if success {
//                    self.performSegue(withIdentifier: "LoginToMain", sender: self)
//                } else {
//                    self.showAlert(title: "Erro", message: "Não foi possível fazer login, por favor tente novamente mais tarde!")
//                }
//            })
            
        modelAccess.fetchUserInfoBy(id: user.uid, callback: { (success: Bool) in
            if success {
                self.performSegue(withIdentifier: "LoginToMain", sender: self)
            } else {
                self.showAlert(title: "Erro", message: "Não foi possível fazer login, por favor tente novamente mais tarde!")
            }
        })
            
        } else {
            setLoginView()
            setRegisterView()
            
            setLogo()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func setLogo() {
        self.logoImage = UIImageView(frame: CGRect(x: 0, y: 40, width: 300, height: 172))
        self.logoImage.contentMode = .center
        self.logoImage.center.x = self.view.center.x
        self.logoImage.image = UIImage(named: "Logo")
        self.view.addSubview(logoImage)
        
        //Contraints
        logoImage.translatesAutoresizingMaskIntoConstraints = false
    
        //left
        let leftConstraints = NSLayoutConstraint (item: logoImage, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0 )
        //right
        let rightConstraints = NSLayoutConstraint (item: logoImage, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1.0, constant: 0 )
        //top
        let topConstraints = NSLayoutConstraint (item: logoImage, attribute: .topMargin, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1.0, constant: 0 )
        
        //add constraints
        view.addConstraints([leftConstraints, rightConstraints, topConstraints])
    }
    
    func setLoginView() {
        loginView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.height))
        
        self.loginRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.loginSelected))
        self.loginView.addGestureRecognizer(self.loginRecognizer)
        self.loginView.backgroundColor = UIColor.vitrineDarkBlue
        self.view.addSubview(loginView)
        entrarLbl = UILabel(frame: CGRect(x: 20, y: 400, width: 2.5*self.loginView.frame.width/3, height: 50))
        entrarLbl.text = "Entrar"
        entrarLbl.textColor = UIColor.white
        entrarLbl.makeHorizontal()
        //entrarLbl.center.x = loginView.center.x
        self.loginView.addSubview(entrarLbl)
        
        
        
        passwordTxtField = KaedeTextField()
        passwordTxtField.foregroundColor = .white
        passwordTxtField.backgroundColor = .blue
        passwordTxtField.frame.size.width = 250
        passwordTxtField.frame.size.height = 35
        self.passwordTxtField.center = self.view.center
        passwordTxtField.alpha = 0
        passwordTxtField.textColor = .white
        passwordTxtField.placeholder = "senha"
        passwordTxtField.placeholderColor = .blue
        self.view.addSubview(passwordTxtField)
        passwordTxtField.isSecureTextEntry = true
        self.passwordTxtField.delegate = self
        
        
        emailTxtField = KaedeTextField()
        emailTxtField.foregroundColor = .white
        emailTxtField.backgroundColor = .blue
        emailTxtField.frame.size.width = 250
        emailTxtField.frame.size.height = 35
        emailTxtField.center.y = passwordTxtField.center.y - 40
        emailTxtField.center.x = self.view.center.x
        emailTxtField.alpha = 0
        emailTxtField.autocapitalizationType = .none
        emailTxtField.textColor = .white
        emailTxtField.placeholder = "email"
        emailTxtField.placeholderColor = .blue
        self.emailTxtField.delegate = self
        self.view.addSubview(emailTxtField)
        loginButton = UIButton()
        loginButton.frame.size.width = 250
        loginButton.frame.size.height = 30
        loginButton.center.x = passwordTxtField.center.x
        loginButton.center.y = passwordTxtField.center.y + 40
        loginButton.alpha = 0
        loginButton.backgroundColor = .gray
        loginButton.setTitle("entrar", for: .normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.login), for: .touchUpInside)
        self.view.addSubview(loginButton)
    
        
        
        fbLoginButton = FBSDKLoginButton()
        fbLoginButton.readPermissions = ["email","public_profile"]
        fbLoginButton.delegate = self
        fbLoginButton.center.x = loginButton.center.x
        fbLoginButton.center.y = loginButton.center.y + 40
        fbLoginButton.alpha = 0
        self.view.addSubview(fbLoginButton)
        
    }

    func loginSelected(){
        self.view.bringSubview(toFront: registerView)
        UIView.animate(withDuration: 0.5) {
            // self.view.bringSubview(toFront: self.loginView)
            self.registerView.alpha = 1
            self.registerView.frame.size.height = 200
            self.registerView.frame.size.width = 60
            self.registerView.frame.origin.x = self.view.frame.width - self.registerView.frame.width
            self.registerView.frame.origin.y = self.view.frame.height - self.registerView.frame.height
            self.loginView.frame.size.width = self.view.frame.width
            
            //self.entrarLbl.center.x = self.emailTxtField.frame.minX
            // self.entrarLbl.frame.origin.y = self.emailTxtField.frame.minY - self.entrarLbl.frame.height - 15
            self.registrarLbl.alpha = 1
            self.registrarLbl.frame.origin.y = 20
            self.registrarLbl.frame.origin.x = 25
            //            self.registrarLbl.frame.origin.x = UIScreen.main.bounds.width - self.registerView.frame.origin.x
            //            self.registrarLbl.frame.origin.y = self.registerView.frame.origin.y
            //            self.registrarLbl.center = self.registerView.center
            //self.registrarLbl.clipsToBounds = true
            //print(self.registrarLbl.center)
            
            self.fbLoginButton.alpha = 1
            self.emailTxtField.alpha = 1
            self.passwordTxtField.alpha = 1
            self.loginButton.alpha = 1
            
            self.registerRecognizer.addTarget(self, action: #selector(self.loginToRegisterTapped))
            self.view.bringSubview(toFront: self.logoImage)
            self.view.bringSubview(toFront: self.emailTxtField)
            self.view.bringSubview(toFront: self.passwordTxtField)
            self.view.bringSubview(toFront: self.loginButton)
            self.view.bringSubview(toFront: self.fbLoginButton)
            self.loginViewSelected = true
            self.registerViewSelected = false

            
            
        }
    }
    
    func setRegisterView() {
        registerView = UIView(frame: CGRect(x: self.view.frame.width/2, y: 0, width: self.view.frame.width/2, height: self.view.frame.height))
        registerView.backgroundColor = .white
        self.registerRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.registerSelected))
        self.registerView.addGestureRecognizer(self.registerRecognizer)
        self.view.addSubview(registerView)
        registrarLbl = UILabel(frame: CGRect(x: 160, y: 500, width: 2.5*self.registerView.frame.width/3, height: 50))
        //        registrarLbl = UILabel(frame: CGRect(x: 10, y: 10, width: self.registerView.frame.width, height: 50))
        
        registrarLbl.text = "Registrar"
        registrarLbl.textColor = .blue
        registrarLbl.font = UIFont(name: "helvetica", size: 14)
        registrarLbl.makeHorizontal()
        self.registerView.addSubview(registrarLbl)
        // registrarLbl.center.x = registerView.frame.width/2
        registrarlateralLbl = UILabel(frame: CGRect(x: 120, y: 350, width: 2.5*self.registerView.frame.width/3, height: 50))
        registrarlateralLbl.center = registerView.center
        registrarlateralLbl.text = "R E G I S T R A R"
        self.registerView.addSubview(registrarlateralLbl)
        registrarlateralLbl.alpha = 0
        
        
        
        
        
        passwordRegisterTxtField = KaedeTextField()
        passwordRegisterTxtField.foregroundColor = .white
        passwordRegisterTxtField.backgroundColor = .blue
        passwordRegisterTxtField.frame.size.width = 250
        passwordRegisterTxtField.frame.size.height = 35
        passwordRegisterTxtField.textColor = .white
        self.passwordRegisterTxtField.center = self.view.center
        passwordRegisterTxtField.alpha = 0
        passwordRegisterTxtField.placeholder = "crie uma senha"
        passwordRegisterTxtField.placeholderColor = .blue
        self.view.addSubview(passwordRegisterTxtField)
        passwordRegisterTxtField.isSecureTextEntry = true
        self.passwordRegisterTxtField.delegate = self
        
        emailRegisterTxtField = KaedeTextField()
        emailRegisterTxtField.foregroundColor = .white
        emailRegisterTxtField.backgroundColor = .blue
        emailRegisterTxtField.frame.size.width = 250
        emailRegisterTxtField.frame.size.height = 35
        emailRegisterTxtField.textColor = .white
        emailRegisterTxtField.center.y = passwordRegisterTxtField.center.y - 40
        emailRegisterTxtField.center.x = self.view.center.x
        emailRegisterTxtField.alpha = 0
        emailRegisterTxtField.placeholder = "insira seu email"
        emailRegisterTxtField.placeholderColor = .blue
        emailRegisterTxtField.autocorrectionType = .no
        self.emailRegisterTxtField.delegate = self
        self.view.addSubview(emailRegisterTxtField)
        
        nameRegisterTxtField = KaedeTextField()
        nameRegisterTxtField.foregroundColor = .white
        nameRegisterTxtField.backgroundColor = .blue
        nameRegisterTxtField.frame.size.width = 250
        nameRegisterTxtField.frame.size.height = 35
        nameRegisterTxtField.textColor = .white
        nameRegisterTxtField.center.y = emailRegisterTxtField.center.y - 40
        nameRegisterTxtField.center.x = self.view.center.x
        nameRegisterTxtField.alpha = 0
        nameRegisterTxtField.placeholder = "qual o seu nome?"
        nameRegisterTxtField.placeholderColor = .blue
        nameRegisterTxtField.autocorrectionType = .no
        self.nameRegisterTxtField.delegate = self
        self.view.addSubview(nameRegisterTxtField)
        
        registerButton = UIButton()
        registerButton.frame.size.width = 250
        registerButton.frame.size.height = 35
        registerButton.center.x = self.view.center.x
        registerButton.center.y = passwordRegisterTxtField.center.y + 40
        registerButton.alpha = 0
        registerButton.backgroundColor = .gray
        registerButton.setTitle("Registrar", for: .normal)
        registerButton.addTarget(self, action: #selector(LoginViewController.register), for: .touchUpInside)
        self.view.addSubview(registerButton)
        
        
        fbRegisterButton = FBSDKLoginButton()
        fbRegisterButton.readPermissions = ["email","public_profile"]
        fbRegisterButton.delegate = self
        fbRegisterButton.center.x = registerButton.center.x
        fbRegisterButton.center.y = registerButton.center.y + 40
        fbRegisterButton.alpha = 0
        self.view.addSubview(fbRegisterButton)
        
    }

    
    func registerSelected() {
        
        UIView.animate(withDuration: 0.5) {
            self.view.bringSubview(toFront: self.loginView)
            self.registerView.frame.origin.x = 0
            self.registerView.frame.size.width = self.view.frame.width
            //self.registerGradient.frame = self.registerView.frame
            //           self.registrarLbl.center.x = self.nameRegisterTxtField.frame.minX
            
            //           self.registrarLbl.frame.origin.y = self.nameRegisterTxtField.frame.minY - self.registrarLbl.frame.height - 15
            
            self.registrarLbl.center.x = self.registerView.frame.width - 20
            self.registrarLbl.center.y = self.registerView.frame.height - 85
            
            self.passwordRegisterTxtField.alpha = 1
            self.registerView.layoutSubviews()
            self.fbRegisterButton.alpha = 1
            self.registerButton.alpha = 1
            
            self.loginView.alpha = 1
            self.loginView.frame.size.height = 200
            self.loginView.frame.size.width = 60
            self.loginView.frame.origin.x = 0
            self.loginView.frame.origin.y = self.view.frame.height - self.loginView.frame.height //+ self.registerView.frame.size.height
            self.entrarLbl.frame.origin.y = 30
            self.entrarLbl.frame.origin.x = 20
            
            
            self.emailRegisterTxtField.alpha = 1
            self.nameRegisterTxtField.alpha = 1
            self.view.bringSubview(toFront: self.logoImage)
            self.view.bringSubview(toFront: self.nameRegisterTxtField)
            self.view.bringSubview(toFront: self.emailRegisterTxtField)
            self.view.bringSubview(toFront: self.passwordRegisterTxtField)
            self.view.bringSubview(toFront: self.registerButton)
            self.view.bringSubview(toFront: self.fbRegisterButton)
            self.loginRecognizer.addTarget(self, action: #selector(self.registerToLoginTapped))
            self.loginViewSelected = false
            self.registerViewSelected = true

            
            
        }
    }
    
    func loginToRegisterTapped() {
        
        UIView.animate(withDuration: 0.3, animations: {
            //animacoes
            //  self.registerView.frame.origin = CGPoint(x: 0, y: 0)
            self.registerView.frame = self.view.frame
            self.loginView.alpha = 1
            self.loginView.frame.size.height = 200
            self.loginView.frame.size.width = 60
            self.loginView.frame.origin.x = 0
            self.loginView.frame.origin.y = self.view.frame.height - self.loginView.frame.height //+ self.registerView.frame.size.height
            self.entrarLbl.frame.origin.y = 30
            self.entrarLbl.frame.origin.x = 20
            self.registrarLbl.center.x = self.registerView.frame.width - 20
            self.registrarLbl.center.y = self.registerView.frame.height - 85
            
            //esconder os campos do login
            self.emailTxtField.alpha = 0
            self.passwordTxtField.alpha = 0
            self.loginButton.alpha = 0
            self.fbLoginButton.alpha = 0
            
        }) { (success: Bool) in
            if success {
                self.view.bringSubview(toFront: self.loginView)
                self.loginRecognizer.addTarget(self, action: #selector(self.registerToLoginTapped))
                self.view.bringSubview(toFront: self.logoImage)
                self.view.bringSubview(toFront: self.nameRegisterTxtField)
                self.view.bringSubview(toFront: self.emailRegisterTxtField)
                self.view.bringSubview(toFront: self.passwordRegisterTxtField)
                self.view.bringSubview(toFront: self.registerButton)
                self.view.bringSubview(toFront: self.fbRegisterButton)
                self.loginViewSelected = false
                self.registerViewSelected = true
                
                self.loginView.addGestureRecognizer(self.loginRecognizer)

                
            } else {
                
            }
        }
    }

    func registerToLoginTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            //animacoes
            self.registerView.alpha = 1
            self.registerView.frame.size.height = 200
            self.registerView.frame.size.width = 60
            self.registerView.frame.origin.x = self.view.frame.width - self.registerView.frame.width
            self.registerView.frame.origin.y = self.view.frame.height - self.registerView.frame.height
            
            self.loginView.frame = self.view.frame
            self.entrarLbl.frame.origin.x = 20
            self.entrarLbl.frame.origin.y = 580
            
            self.registrarLbl.alpha = 1
            self.registrarLbl.frame.origin.y = 25
            self.registrarLbl.frame.origin.x = 20
            self.registrarLbl.clipsToBounds = true
            print(self.registrarLbl.center)
            
            self.fbLoginButton.alpha = 1
            self.emailTxtField.alpha = 1
            self.passwordTxtField.alpha = 1
            self.loginButton.alpha = 1
            
            self.nameRegisterTxtField.alpha = 0
            self.emailRegisterTxtField.alpha = 0
            self.passwordRegisterTxtField.alpha = 0
            self.fbRegisterButton.alpha = 0
            self.registerButton.alpha = 0
            
            self.registerRecognizer.addTarget(self, action: #selector(self.loginToRegisterTapped))
            
        }) { (success: Bool) in
            if success {
                self.view.bringSubview(toFront: self.registerView)
                self.view.bringSubview(toFront: self.logoImage)
                self.view.bringSubview(toFront: self.emailRegisterTxtField)
                self.view.bringSubview(toFront: self.logoImage)
                self.view.bringSubview(toFront: self.emailTxtField)
                self.view.bringSubview(toFront: self.passwordTxtField)
                self.view.bringSubview(toFront: self.loginButton)
                self.view.bringSubview(toFront: self.fbLoginButton)
                self.loginViewSelected = true
                self.registerViewSelected = false
                
            } else {
                
            }
        }
    }
    
    func dismissKeyboard() {
        print("entrou no dismisskeyboard")

        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                if self.anyTxtFieldIsActive {
                    
                } else {
                    if loginViewSelected {
                        self.emailTxtField.frame.origin.y -= keyboardSize.height/2
                        self.passwordTxtField.frame.origin.y -= keyboardSize.height/2
                        self.loginButton.frame.origin.y -= keyboardSize.height/2
                        self.fbLoginButton.frame.origin.y -= keyboardSize.height/2
                        self.loginRecognizer.addTarget(self, action: #selector(dismissKeyboard))
                    } else {
                        self.nameRegisterTxtField.frame.origin.y -= keyboardSize.height/2
                        self.emailRegisterTxtField.frame.origin.y -= keyboardSize.height/2
                        self.passwordRegisterTxtField.frame.origin.y -= keyboardSize.height/2
                        self.registerButton.frame.origin.y -= keyboardSize.height/2
                        self.fbRegisterButton.frame.origin.y -= keyboardSize.height/2
                        self.registerRecognizer.addTarget(self, action: #selector(dismissKeyboard))
                    }
                    self.anyTxtFieldIsActive = true

                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if loginViewSelected {
                    self.emailTxtField.frame.origin.y += keyboardSize.height/2
                    self.passwordTxtField.frame.origin.y += keyboardSize.height/2
                    self.loginButton.frame.origin.y += keyboardSize.height/2
                    self.fbLoginButton.frame.origin.y += keyboardSize.height/2

                } else {
                    self.nameRegisterTxtField.frame.origin.y += keyboardSize.height/2
                    self.emailRegisterTxtField.frame.origin.y += keyboardSize.height/2
                    self.passwordRegisterTxtField.frame.origin.y += keyboardSize.height/2
                    self.registerButton.frame.origin.y += keyboardSize.height/2
                    self.fbRegisterButton.frame.origin.y += keyboardSize.height/2

                }
            print("passou pelo keyboardWillHide")
            self.registerRecognizer.addTarget(self, action: #selector(loginToRegisterTapped))
            self.loginRecognizer.addTarget(self, action: #selector(registerToLoginTapped))

            self.anyTxtFieldIsActive = false
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            if user != nil {
                //user logado com sucesso
                //puxar infos do database do us
                
//                DatabaseAccess.sharedInstance.fetchUserInfo(email: self.emailTxtField.text!, callback: { (success: Bool) in
//                    if success {
//                        self.performSegue(withIdentifier: "LoginToMain", sender: self)
//                    } else {
//                        self.showAlert(title: "Erro", message: "Não foi possível fazer login, por favor tente novamente mais tarde!")
//
//                    }
//                })
                self.modelAccess.fetchUserInfo(email: self.emailTxtField.text!, callback: { (success: Bool) in
                    if success {
                        self.performSegue(withIdentifier: "LoginToMain", sender: self)
                    } else {
                        self.showAlert(title: "Erro", message: "Não foi possível fazer login, por favor tente novamente mais tarde!")
                    }
                })
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: emailRegisterTxtField.text!, password: passwordRegisterTxtField.text!) { (user, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            if user != nil {
                //adiciona email e nome ao path do Uid (ok)
                
                let user = User(name: self.nameRegisterTxtField.text!, email: Auth.auth().currentUser!.email!)
                user.id = Auth.auth().currentUser?.providerID
                
                
//                DatabaseAccess.sharedInstance.databaseAccessWriteCreateUser(user: user)
                self.modelAccess.databaseAccessWriteCreateUser(user: user)
                
//                DatabaseAccess.sharedInstance.fetchUserInfo(email: Auth.auth().currentUser!.email!, callback: { (success: Bool) in
//                    if success {
//                        self.performSegue(withIdentifier: "LoginToMain", sender: self)
//                    } else {
//                        self.showAlert(title: "Erro", message: "Não foi possível registrar seu usuário, tente novamente mais tarde")
//
//                    }
//                })
                
                self.modelAccess.fetchUserInfo(email: Auth.auth().currentUser!.email!, callback: { (success: Bool) in
                    if success {
                        self.performSegue(withIdentifier: "LoginToMain", sender: self)
                    } else {
                        self.showAlert(title: "Erro", message: "Não foi possível fazer login, por favor tente novamente mais tarde!")
                    }
                })
                
            }
        }
    }
    
}
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            if result != nil {
                
                //transform facebook's credential in  firebase's credential
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "name,picture,email"]).start(completionHandler: { (connection, result, error) in
                    if error != nil {
                        print((error?.localizedDescription)!)
                        return
                    }
                    if result != nil {
                        //Autentica firebase
                        Auth.auth().signIn(with: credential) { (user, error) in
                            if let error = error {
                                print(error)
                                return
                            }
                                //Autenticacao OK
                            else {
                                if let resultado = result as? Dictionary<String,AnyObject> {
                                    print(resultado["name"] as! String)
                                    print(resultado["email"] as! String)
                                    let userDatabase = User(name: resultado["name"] as! String, email: resultado["email"] as! String)
                                    
                                    // ELE JA EXISTE NO FIREBASE?
//                                    DatabaseAccess.sharedInstance.fetchUserInfo(email: userDatabase.email, callback: { (success: Bool) in
//                                        if success {
//                                            self.performSegue(withIdentifier: "LoginToMain", sender: self)
//                                        } else {
//                                            //SE NAO EXISTIR, CRIA NO FIREBASE
//                                            DatabaseAccess.sharedInstance.databaseAccessWriteCreateUser(user: userDatabase)
//                                            self.performSegue(withIdentifier: "LoginToMain", sender: self)
//                                        }
//                                    })
                                    // ELE JA EXISTE NO FIREBASE?
                                    self.modelAccess.fetchUserInfo(email: userDatabase.email, callback: { (success: Bool) in
                                        if success {
                                            self.performSegue(withIdentifier: "LoginToMain", sender: self)
                                        } else {
                                            //SE NAO EXISTIR, CRIA NO FIREBASE
                                            self.modelAccess.databaseAccessWriteCreateUser(user: userDatabase)
                                            self.performSegue(withIdentifier: "LoginToMain", sender: self)
                                        }
                                    })
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        NotificationCenter.default.post(name: .UIKeyboardWillHide, object: nil)
//        
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        NotificationCenter.default.post(name: .UIKeyboardWillShow, object: nil)
//    }
}
