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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.bool(forKey: "rememberClassic")){
            DispatchQueue.main.async { [self] in
                alertHelper.waitDialog()
            }
            JS.executeScript(identifiant: UserDefaults.standard.string(forKey: "identifiant")!, pass: UserDefaults.standard.string(forKey: "pass")!,controller: self,view: view)
        }
        let name = Notification.Name("MyStuffAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(loadArticle), name: name, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //OUTLETS
    @IBOutlet weak var rememberMe: UISwitch!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var identifiant: UITextField!
    
    //VAR
    var matieres = [Matiere]()
    let alertHelper = AlertHelper()
    let JS = JavaScript()
    var student = Student(fullName: "", classeEsprit: "")
    
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
            }
            alertHelper.waitDialog()
            JS.executeScript(identifiant: identifiant.text!, pass: pass.text!,controller: self,view: view)
        }else{
            alertHelper.showAlert(title: "Empty", message: "Required data", action: "OK")
        }
    }
    
    //FUNCTIONS
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            let string = String(describing: message.body)
            //print(string)
            if let range = string.range(of: "FullName") {
                let name = string[range.upperBound...].replacingOccurrences(of: "  ", with: "", options: .literal, range: nil)
                student.fullName = String(name)
            }
            if let range = string.range(of: "ClasseEsprit") {
                let classe = string[range.upperBound...]
                student.classeEsprit = String(classe)
            }
            let data = string.data(using: .utf8)!
            alertHelper.dismissDialog()
            if let matiere = try? JSONDecoder().decode([Matiere].self, from: data){
                matieres = matiere
                let name = Notification.Name("MyStuffAdded")
                let notification = Notification(name: name)
                NotificationCenter.default.post(notification)
            }
        }
    }
    
    @objc func loadArticle(){
        self.performSegue(withIdentifier: "tableau", sender: matieres)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableau" {
            let destination = segue.destination as! tableauNoteView
            destination.tableauNote = matieres
            destination.student = student
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



