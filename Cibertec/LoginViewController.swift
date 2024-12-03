//
//  LoginViewController.swift
//  Cibertec
//
//  Created by Wilmer Ocampo on 2/12/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginAction(_ sender: Any) {
        let email = emailTextField.text
        let pass = passTextField.text
        
        goToHome()
        
    }
    
    func goToHome(){
        let stoyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = stoyboard.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true)
    }
    
}
