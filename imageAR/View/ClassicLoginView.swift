//
//  ClassicLoginView.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 5/7/2022.
//

import Foundation
import UIKit
import JavaScriptCore
import WebKit
import RealityKit
import ARKit
class ClassicLoginView: UIViewController, WKScriptMessageHandler {
    //VAR
    let alertHelper = AlertHelper()
    let JS = JavaScript()
    var student = Student(fullName: "", classeEsprit: "")
    var alert : UIAlertController?
    
    //OUTLETS
    @IBOutlet weak var rememberMe: UISwitch!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var identifiant: UITextField!
    
    override func viewDidLoad() {
        //UserDefaults.standard.removeObject(forKey: "rememberClassic")
        super.viewDidLoad()
        if(UserDefaults.standard.bool(forKey: "rememberClassic")){
            pass.text = UserDefaults.standard.string(forKey: "pass")!
            identifiant.text = UserDefaults.standard.string(forKey: "identifiant")!
            rememberMe.isOn = true
            DispatchQueue.main.async { [self] in
                alert = alertHelper.waitDialog()
            }
            //JS.demandeStage(identifiant: identifiant.text!, pass: pass.text!,controller: self,view: view)
            JS.connect(identifiant: UserDefaults.standard.string(forKey: "identifiant")!, pass: UserDefaults.standard.string(forKey: "pass")!,controller: self,view: view)
        }
        
        let name = Notification.Name("MyStuffAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(loadArticle), name: name, object: nil)
        
        //dismiss keyboard option
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //ACTIONS
    @IBAction func loginUsingAR(_ sender: Any) {
        self.performSegue(withIdentifier: "continueAR", sender: nil)
    }
    
    @IBAction func Login(_ sender: Any) {
        if(!((identifiant.text ?? "").isEmpty) && !((pass.text ?? "").isEmpty)){
            if (rememberMe.isOn) {
                UserDefaults.standard.set(rememberMe.isOn, forKey: "rememberClassic")
                UserDefaults.standard.set(identifiant.text!, forKey: "identifiant")
                UserDefaults.standard.set(pass.text!, forKey: "pass")
            }else{
                UserDefaults.standard.set(identifiant.text!, forKey: "identifiant")
                UserDefaults.standard.set(pass.text!, forKey: "pass")
            }
            alert = alertHelper.waitDialog()
            JS.connect(identifiant: identifiant.text!, pass: pass.text!,controller: self,view: view)
        }else{
             alertHelper.showAlert(title: "Empty", message: "Required data", action: "OK")
        }
    }
    
    //FUNCTIONS
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            let string = String(describing: message.body)
            print(string)
            if (string.contains("paiement")) {
                alertHelper.dismissDialog(alertWait: alert!)
                userContentController.removeAllUserScripts()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.alertHelper.showAlert(title: "Error connecting", message: "Please proceed to the payment of your registration fees", action: "OK")
                }
            }
            if (string.contains("timeout")) {
                alertHelper.dismissDialog(alertWait: alert!)
                userContentController.removeAllUserScripts()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.alertHelper.showAlert(title: "Error connecting", message: "Logs incorrect or service may not working", action: "OK")
                }
            }
            
            if (string.contains("ok")) {
                alertHelper.dismissDialog(alertWait: alert!)
                userContentController.removeAllUserScripts()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let name = Notification.Name("MyStuffAdded")
                    let notification = Notification(name: name)
                    NotificationCenter.default.post(notification)                }
            }
            if let range = string.range(of: "FullName") {
                let name = string[range.upperBound...].replacingOccurrences(of: "  ", with: "", options: .literal, range: nil)
                UserDefaults.standard.set(String(name), forKey: "fullName")
                student.fullName = String(name)
            }
            if let range = string.range(of: "ClasseEsprit") {
                let classe = string[range.upperBound...]
                UserDefaults.standard.set(String(classe), forKey: "classe")
                student.classeEsprit = String(classe)
            }
            
            alertHelper.dismissDialog(alertWait: alert!)

 
        }
    }
    
    @objc func loadArticle(){
        self.performSegue(withIdentifier: "connect", sender: nil)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



