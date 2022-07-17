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
        if (string.contains("ok")) {

        let data = string.data(using: .utf8)!
        if let matiere = try? JSONDecoder().decode([Matiere].self, from: data){
            matieres = matiere
            let name = Notification.Name("MyStuffAdded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
            }
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
            alertHelper.dismissDialog(alertWait: self.alert!)
            userContentController.removeAllUserScripts()
            let config = WKPDFConfiguration()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                self.webView!.createPDF(configuration: config) { result in
                switch result {
                case .success(let data):
                    print("pdf cree : \(data)")
                    let activityViewController = UIActivityViewController(activityItems: ["Save document PDF", data], applicationActivities: nil)
                    self.present(activityViewController, animated: true, completion: nil)
                case .failure(let error):
                    print ("error \(error)")
                }
            }
            
           // var  test = webView!.exportAsPdfFromWebView()
            }
        }
    }
    
    
    var matieres = [Matiere]()
    let alertHelper = AlertHelper()
    let JS = JavaScript()
    var student = Student(fullName: "", classeEsprit: "")
    var alert : UIAlertController?

    @IBAction func demandeStage(_ sender: Any) {
        alert = alertHelper.waitDialog()
        webView = JS.demandeStage(identifiant: UserDefaults.standard.string(forKey: "identifiant")!, pass: UserDefaults.standard.string(forKey: "pass")!, controller: self, view: view)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func CheckGrade(_ sender: Any) {
        alert = alertHelper.waitDialog()
        JS.extractMatiereJs(identifiant: UserDefaults.standard.string(forKey: "identifiant")!, pass: UserDefaults.standard.string(forKey: "pass")!, controller: self, view: view)
    }
    
    @objc func loadArticle(){
        self.performSegue(withIdentifier: "tableau", sender: nil)
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
