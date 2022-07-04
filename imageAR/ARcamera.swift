//
//  ViewController.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 8/6/2022.
//

import UIKit
import RealityKit
import ARKit
import JavaScriptCore
import WebKit
class ARcamera: UIViewController{
    var jsContext: JSContext!
    var matieres = [Matiere]()
    @IBAction func backButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "idEsprit")
        UserDefaults.standard.removeObject(forKey: "nom")
        UserDefaults.standard.removeObject(forKey: "prenom")
        UserDefaults.standard.removeObject(forKey: "classe")
        UserDefaults.standard.removeObject(forKey: "mdpEsprit")
        self.performSegue(withIdentifier: "back", sender: nil)
    }
    @IBOutlet var arView: ARView!

    //@IBOutlet weak var documentCamera: VNDocumentCameraViewController!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        print("id esprit est :"+UserDefaults.standard.string(forKey: "idEsprit")!)
        
        //setupARView()
        let boxAnchor = try! EspritAR.loadScene()
        
        let nomText: Entity = boxAnchor.nom!.children[0].children[0]/* Text Object */
        var nomtextModelComp: ModelComponent = (nomText.components[ModelComponent])!
       
        nomtextModelComp.mesh = .generateText("Hey "+UserDefaults.standard.string(forKey: "nom")!,
                                    extrusionDepth: 0.01,
                                              font: .systemFont(ofSize: 0.15),
                                    containerFrame: CGRect(),
                                         alignment: .left,
                                     lineBreakMode: .byCharWrapping)
        boxAnchor.nom!.children[0].children[0].components.set(nomtextModelComp)
        
        if (UserDefaults.standard.string(forKey: "mdpEsprit") != nil) {
            boxAnchor.login?.isEnabled = false
        }
        
        boxAnchor.actions.linkEsprit.onAction = self.remodelling

     
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        let name = Notification.Name("MyStuffAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(loadArticle), name: name, object: nil)
        
    }
    
    
    
    @objc func loadArticle(){
        var i :Float = 1
        matieres.forEach { matiere in
            
            let boxAnchor = try! TextAR.loadScene()
            let nomText: Entity = boxAnchor.text!.children[0].children[0]/* Text Object */
            var nomtextModelComp: ModelComponent = (nomText.components[ModelComponent])!
           
            nomtextModelComp.mesh = .generateText(matiere.designation+", Exam :"+matiere.note_exam,
                                        extrusionDepth: 0.005,
                                                  font: .systemFont(ofSize: 0.02),
                                        containerFrame: CGRect(),
                                             alignment: .left,
                                         lineBreakMode: .byCharWrapping)
            boxAnchor.text!.children[0].children[0].components.set(nomtextModelComp)
            boxAnchor.text!.position = SIMD3(x: 0, y: i, z: 0.05)
            
            let mesh: MeshResource = .generateBox(width: 1,height: 0.2,depth: 0)
            var pbr = PhysicallyBasedMaterial()
            pbr.baseColor = .init(tint: .red, texture: nil)
            let boxComponent = ModelComponent(mesh: mesh, materials: [pbr])
            boxAnchor.board!.children[0].components.set(boxComponent)
            boxAnchor.board!.position = SIMD3(x: 0, y: i - 0.1, z: 0)
            i -= 0.05
            arView.scene.anchors.append(boxAnchor)
            
        }
        
        }
    

    
    fileprivate func remodelling(_ entity: Entity?) {
        let alertController = UIAlertController(title: "Login", message: "To login, please enter your password below", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Esprit Password"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Ok", style: .default) { _ in
            UserDefaults.standard.setValue(alertController.textFields![0].text, forKey: "mdpEsprit")
            let pass = UserDefaults.standard.string(forKey: "mdpEsprit")!
            let identifi = UserDefaults.standard.string(forKey: "idEsprit")!
            //self.performSegue(withIdentifier: "web", sender: nil)
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
            document.getElementById('ContentPlaceHolder1_TextBox3').value = '\(identifi)';\
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
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
 
    /*func setupARView() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        if #available(iOS 13.0, *) {
            configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        }
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }*/
    
   /* func setupARView() {
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal,.vertical]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
    }*/
    
    func createJsonForJavaScript(for data: [String : Any]) -> String {
    var jsonString : String?
    do {
       let jsonData = try JSONSerialization.data(withJSONObject: data,       options: .prettyPrinted)
      // here "jsonData" is the dictionary encoded in JSON data .
      jsonString = String(data: jsonData, encoding: .utf8)!
       
       jsonString = jsonString?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "")
     }  catch {
            print(error.localizedDescription)
       }
    print(jsonString!)
    return jsonString!
    }
    
    

}

extension ARcamera: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      if message.name == "logHandler" {
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
}

