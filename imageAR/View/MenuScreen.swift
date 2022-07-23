//
//  MenuSreen.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 17/7/2022.
//

import Foundation
import UIKit
import WebKit

class MenuScreen: UIViewController,WKScriptMessageHandler {
    var webView : WKWebView?

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let string = String(describing: message.body)
        if (string.contains("note_tp")) {
            print("on va voir les notes principales")
        let data = string.data(using: .utf8)!
        if let matiere = try? JSONDecoder().decode([Matiere].self, from: data){
            matieres = matiere
            self.alertHelper.dismissDialog(alertWait: self.alert!)
            let name = Notification.Name("MyStuffAdded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            }
        }
        
        else if (string.contains("nommodules")) {
            self.alertHelper.dismissDialog(alertWait: self.alert!)
        let data = string.data(using: .utf8)!
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if let matiere = try? JSONDecoder().decode([MatiereRat].self, from: data){
            self.matieresRat = matiere
            let name = Notification.Name("MyStuffAdded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }}
        }
        else if (string.contains("conseil")) {
            DispatchQueue.main.async { [self] in
                alertHelper.dismissDialog(alertWait: self.alert!)
                userContentController.removeAllUserScripts()
            }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.alertHelper.showAlert(title: "Error connecting", message: "Access is temporarily suspended following the progress of class councils", action: "OK")
                }
            }
        else if (string.contains("demandeStage")){
            let config = WKPDFConfiguration()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.webView!.createPDF(configuration: config) { result in
                switch result {
                case .success(let data):
                    self.alertHelper.dismissDialog(alertWait: self.alert!)
                    print("pdf cree : \(data)")
                    let activityViewController = UIActivityViewController(activityItems: ["Save document PDF", data], applicationActivities: nil)
                    self.present(activityViewController, animated: true, completion: nil)
                case .failure(let error):
                    print ("error \(error)")
                }
            }
            
        }
        } else if (string.contains("noTab")) {
            alertHelper.dismissDialog(alertWait: alert!)
            userContentController.removeAllUserScripts()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.alertHelper.showAlert(title: "Empty", message: "You didn't pass the second session", action: "OK")
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "identifiant")
        UserDefaults.standard.removeObject(forKey: "rememberClassic")
        UserDefaults.standard.removeObject(forKey: "pass")
        UserDefaults.standard.removeObject(forKey: "fullName")
        UserDefaults.standard.removeObject(forKey: "classe")
        UserDefaults.standard.removeObject(forKey: "pass")
        UserDefaults.standard.removeObject(forKey: "identifiant")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
    
    var matieres = [Matiere]()
    var matieresRat = [MatiereRat]()
    let alertHelper = AlertHelper()
    let JS = JavaScript()
    var alert : UIAlertController?
    @IBOutlet weak var nomPrenom: UILabel!
    
    @IBAction func demandeStage(_ sender: Any) {
        alert = alertHelper.waitDialog()
        webView = JS.demandeStage(identifiant: UserDefaults.standard.string(forKey: "identifiant")!, pass: UserDefaults.standard.string(forKey: "pass")!, controller: self, view: view)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nomPrenom.text = "Welcome "+UserDefaults.standard.string(forKey: "fullName")!
        let name = Notification.Name("MyStuffAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(loadArticle), name: name, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func CheckGrade(_ sender: Any) {
        alert = alertHelper.waitDialog()
        JS.extractMatiereJs(identifiant: UserDefaults.standard.string(forKey: "identifiant")!, pass: UserDefaults.standard.string(forKey: "pass")!, controller: self, view: view)
    }
    
    @objc func loadArticle(){
        performSegue(withIdentifier: "tableau", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableau" {
            let destination = segue.destination as! tableauNoteView
            destination.matieresPrincipale = matieres
            destination.matieresRat = matieresRat
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
