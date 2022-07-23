//
//  JavaScript.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 6/7/2022.
//

import Foundation
import WebKit
class JavaScript{
    
    func extractMatiereJs(identifiant:String,pass:String,controller:WKScriptMessageHandler,view:UIView){
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
         document.getElementById('ContentPlaceHolder1_Button3').click();\
         } else if (document.getElementById('ContentPlaceHolder1_TextBox7')) {\
         document.getElementById('ContentPlaceHolder1_TextBox7').value = '\(pass)';\
         document.getElementById('ContentPlaceHolder1_ButtonEtudiant').click();\
         } else if (window.location.href.includes('noterat') || window.location.href.includes('Resultat2021')) {\
         if(document.getElementById("ContentPlaceHolder1_GridView1")){\
         if (window.window.location.href.includes('Resultat2021')) {\
         console.log('principale');\
         } else if (window.window.location.href.includes('noterat')) {\
         console.log('rattrapage');}\
         var myjson = JSON.stringify(tableToJson(document.getElementById("ContentPlaceHolder1_GridView1")));\
         console.log(myjson);\
         }else{\
         console.log('noTab');}\
         } else if (document.getElementsByClassName("jumbotron")) {\
         var listes = document.getElementsByClassName("dropdown")[2].getElementsByTagName('li');\
         for (var i = 0; i < listes.length; i++) {\
         if (listes[i].innerHTML.includes('Conseil')) {\
         console.log('conseil');\
         break;\
         } else if (listes[i].innerHTML.includes('noterat')) {\
         window.location.href = 'https://esprit-tn.com/ESPOnline/Etudiants/noterat.aspx';\
         break;\
         } else if (listes[i].innerHTML.includes('Resultat2021')) {\
         window.location.href = 'https://esprit-tn.com/ESPOnline/Etudiants/Resultat2021.aspx';\
         break;}}}\
         if (window.location.href.includes('aspxerrorpath')) {\
         console.log('timeout');}
         """
        //print(secondScript)
         let contentController = WKUserContentController()
         let config = WKWebViewConfiguration()
         config.userContentController = contentController
        let webView = WKWebView(frame: .zero, configuration: config)
         let script = WKUserScript(source: secondScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
         contentController.addUserScript(script)
        view.addSubview(webView)

         webView.configuration.userContentController.add(controller, name: "logHandler")
                if let url = URL(string: "https://esprit-tn.com/esponline/online/default.aspx") {
                    webView.load(URLRequest(url: url))
                }
    }
    
    func demandeStage(identifiant:String,pass:String,controller:WKScriptMessageHandler,view:UIView)->WKWebView?{
        let secondScript = """
         function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;\
         if (document.getElementById('ContentPlaceHolder1_TextBox3')) {\
         document.getElementById('ContentPlaceHolder1_TextBox3').value = '\(identifiant)';\
         document.getElementById('ContentPlaceHolder1_Button3').click();}\
         else if(document.getElementById('ContentPlaceHolder1_TextBox7')){\
         document.getElementById('ContentPlaceHolder1_TextBox7').value = '\(pass)';\
         document.getElementById('ContentPlaceHolder1_ButtonEtudiant').click();\
         window.location.href = 'https://esprit-tn.com/ESPOnline/Etudiants/demande_de_stage.aspx';console.log('go vers demande');}\
         else if (document.getElementById('ContentPlaceHolder1_Button2')){\
         document.getElementById('ContentPlaceHolder1_Button2').click();
         console.log('demandeStage');}\
         if(window.location.href.includes('aspxerrorpath')){\
         console.log('timeout');}
         """
         let contentController = WKUserContentController()
         let config = WKWebViewConfiguration()
         config.userContentController = contentController
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.viewWidth, height: view.viewHeight), configuration: config)
        
         let script = WKUserScript(source: secondScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
         contentController.addUserScript(script)
         webView.configuration.userContentController.add(controller, name: "logHandler")
         //view.addSubview(webView)
                if let url = URL(string: "https://esprit-tn.com/esponline/online/default.aspx") {
                    webView.load(URLRequest(url: url))
                }
        return webView
            }
    
        func connect(identifiant:String,pass:String,controller:WKScriptMessageHandler,view:UIView){
        print(identifiant)
        print(pass)
        let secondScript = """
         function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;\
         if(document.alert){console.log('paiement');}\
         if (document.getElementById('ContentPlaceHolder1_TextBox3')) {\
         document.getElementById('ContentPlaceHolder1_TextBox3').value = '\(identifiant)';\
         document.getElementById('ContentPlaceHolder1_Button3').click();}\
         else if(document.getElementById('ContentPlaceHolder1_TextBox7')){\
         document.getElementById('ContentPlaceHolder1_TextBox7').value = '\(pass)';\
         document.getElementById('ContentPlaceHolder1_ButtonEtudiant').click();}\
         else if(document.getElementsByClassName("jumbotron")){\
         console.log('FullName '+document.getElementById('Label2').textContent);\
         console.log('ClasseEsprit '+document.getElementById('Label3').textContent);\
         console.log('ok');}\
         var elem = document.scripts;\
         for (var i = 0, len = elem.length; i < len; i++) {\
         var txt = elem[i].textContent.match('alert');\
         if (txt) { console.log("paiement",txt.input); }}
         """
            print(secondScript)
         let contentController = WKUserContentController()
         let config = WKWebViewConfiguration()
         config.userContentController = contentController
            let webView = WKWebView(frame:  .zero, configuration: config)
        
         let script = WKUserScript(source: secondScript, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
         contentController.addUserScript(script)
         webView.configuration.userContentController.add(controller, name: "logHandler")
         view.addSubview(webView)
                if let url = URL(string: "https://esprit-tn.com/esponline/online/default.aspx") {
                    webView.load(URLRequest(url: url))
                }
        }
    
}
