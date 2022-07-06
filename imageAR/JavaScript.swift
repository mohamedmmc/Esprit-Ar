//
//  JavaScript.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 6/7/2022.
//

import Foundation
import WebKit
class JavaScript{
   /* func executeScript(identifiant:String,pass:String,controller:UIViewController){
        
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
    }*/
}
