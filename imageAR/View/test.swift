//
//  test.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 14/7/2022.
//

import Foundation
import UIKit
import WebKit
import PDFKit
class test: UIViewController,WKScriptMessageHandler {
    var webView : WKWebView?
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
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
            } else {
                print("Some other message sent from web page...")
            }
    }
    @IBAction func nextpage(_ sender: Any) {
        performSegue(withIdentifier: "first", sender: nil)
    }
    
    let JS = JavaScript()
    override func viewDidLoad() {
        super.viewDidLoad()
        //JS.demandeStage(identifiant: "181JMT3039", pass:"Mohamedmalek93",controller: self,view: view)
        /*let secondScript = """
         function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;\
         if (document.getElementById('ContentPlaceHolder1_TextBox3')) {\
         document.getElementById('ContentPlaceHolder1_TextBox3').value = '181JMT3039';\
         document.getElementById('ContentPlaceHolder1_Button3').click();}\
         else if(document.getElementById('ContentPlaceHolder1_TextBox7')){\
         document.getElementById('ContentPlaceHolder1_TextBox7').value = 'Mohamedmalek93';\
         document.getElementById('ContentPlaceHolder1_ButtonEtudiant').click();\
         window.location.href = 'https://esprit-tn.com/ESPOnline/Etudiants/demande_de_stage.aspx';console.log('go vers demande');}\
         else if (document.getElementById('ContentPlaceHolder1_Button2')){\
         document.getElementById('ContentPlaceHolder1_Button2').click();
         console.log('ok');window.print();}\
         if(window.location.href.includes('aspxerrorpath')){\
         console.log('timeout');}
         """
         let contentController = WKUserContentController()
         let config = WKWebViewConfiguration()
         config.userContentController = contentController
        print("Height",view.viewHeight)
        print("Width",view.viewWidth)
         webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 1920, height: 1080), configuration: config)
        
         let script = WKUserScript(source: secondScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
         contentController.addUserScript(script)
        webView!.configuration.userContentController.add(self, name: "logHandler")
        view.addSubview(webView!)
                if let url = URL(string: "https://esprit-tn.com/esponline/online/default.aspx") {
                    webView!.load(URLRequest(url: url))
                }*/
        }
    }

