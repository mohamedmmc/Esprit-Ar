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
    
    @IBOutlet weak var rememberMe: UISwitch!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var identifiant: UITextField!
    var matieres = [Matiere]()
    let alertHelper = AlertHelper()
    @IBAction func loginUsingAR(_ sender: Any) {
        self.performSegue(withIdentifier: "continueAR", sender: nil)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            
            let string = String(describing: message.body)
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
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func executeScript(identifiant:String,pass:String){
        
        let secondScript = """
         function tableToJson (table) {\
         var data = [];\
         var headers = [];\
         for (var i=0; i<table.rows[0].cells.length; i++) {\
         headers[i] = table.rows[0].cells[i].innerHTML.toLowerCase().replace(/ /gi,'');\
         }\
         for (var i=1; i<table.rows.length; i++) {\
         var tableRow = table.rows[i];\
         var rowData = {};\
         for (var j=0; j<tableRow.cells.length; j++) {\
         rowData[ headers[j] ] = tableRow.cells[j].innerHTML;\
         }\
         data.push(rowData);\
         }\
         return data;\
         }\
         function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;\
         if (document.getElementById('ContentPlaceHolder1_TextBox3')) {\
         document.getElementById('ContentPlaceHolder1_TextBox3').value = '\(identifiant)';\
         document.getElementById('ContentPlaceHolder1_Button3').click();}\
         else if(document.getElementById('ContentPlaceHolder1_TextBox7')){\
         document.getElementById('ContentPlaceHolder1_TextBox7').value = '\(pass)';\
         document.getElementById('ContentPlaceHolder1_ButtonEtudiant').click();}\
         else if (document.getElementById("ContentPlaceHolder1_GridView1")){\
         console.log("qqqqqq");\
         var myjson = JSON.stringify(tableToJson (document.getElementById("ContentPlaceHolder1_GridView1")));\
         console.log(myjson);}\
         else if(document.getElementsByClassName("jumbotron")){\
         window.location.href = 'https://esprit-tn.com/ESPOnline/Etudiants/Resultat2021.aspx';}
         """
         let contentController = WKUserContentController()
         let config = WKWebViewConfiguration()
         config.userContentController = contentController
         let webView = WKWebView(frame: .zero, configuration: config)
         let script = WKUserScript(source: secondScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
         contentController.addUserScript(script)
         webView.configuration.userContentController.add(self, name: "logHandler")
         self.view.addSubview(webView)
                if let url = URL(string: "https://esprit-tn.com/esponline/online/default.aspx") {
                    webView.load(URLRequest(url: url))
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.bool(forKey: "rememberClassic")){
            DispatchQueue.main.async { [self] in
                alertHelper.waitDialog()
            }
            
            executeScript(identifiant: UserDefaults.standard.string(forKey: "identifiant")!, pass: UserDefaults.standard.string(forKey: "pass")!)
        }
        let name = Notification.Name("MyStuffAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(loadArticle), name: name, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @IBAction func Login(_ sender: Any) {
 
        if (rememberMe.isOn) {
            UserDefaults.standard.set(rememberMe.isOn, forKey: "rememberClassic")
            UserDefaults.standard.set(identifiant.text!, forKey: "identifiant")
            UserDefaults.standard.set(pass.text!, forKey: "pass")
        }
        alertHelper.waitDialog()
        executeScript(identifiant: identifiant.text!, pass: pass.text!)
    }
   
}



