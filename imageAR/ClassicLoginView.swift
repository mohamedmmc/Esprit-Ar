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
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
            self.alert.dismiss(animated: true)
            let string = String(describing: message.body)
            let data = string.data(using: .utf8)!
            
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
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name("MyStuffAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(loadArticle), name: name, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @IBAction func Login(_ sender: Any) {
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            self.alert.dismiss(animated: true, completion: nil)
        }))
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
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
         document.getElementById('ContentPlaceHolder1_TextBox3').value = '\(identifiant.text!)';\
         document.getElementById('ContentPlaceHolder1_Button3').click();}\
         else if(document.getElementById('ContentPlaceHolder1_TextBox7')){\
         document.getElementById('ContentPlaceHolder1_TextBox7').value = '\(pass.text!)';\
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
    @IBOutlet weak var rememberMe: UISwitch!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var identifiant: UITextField!
    var matieres = [Matiere]()
}



