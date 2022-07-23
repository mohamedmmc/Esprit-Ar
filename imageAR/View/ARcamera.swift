//
//  ViewController.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 8/6/2022.
//

import UIKit
import RealityKit
import ARKit
class ARcamera: UIViewController{
    
    //VAR
    var matieres = [Matiere]()
    var matieresRat = [MatiereRat]()
    let boxAnchor = try! EspritAR.loadScene()
    let alertHelper = AlertHelper()
    let JS = JavaScript()
    var alert : UIAlertController?
    //OUTLETS
    @IBOutlet var arView: ARView!
    
    //ACTIONS
    @IBAction func backButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "idEsprit")
        self.arView.session.pause()
        self.arView.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "back", sender: nil)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "idEsprit")
            self.arView.session.pause()
            self.arView.removeFromSuperview()
            //self.arView = nil
            //self.dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.performSegue(withIdentifier: "reset", sender: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        arView.session.delegate = self
        super.viewDidLoad()
        let nomText: Entity = boxAnchor.nom!.children[0].children[0]/* Text Object */
        var nomtextModelComp: ModelComponent = (nomText.components[ModelComponent.self])!
        nomtextModelComp.mesh = .generateText("Hey "+UserDefaults.standard.string(forKey: "nom")!,
                                    extrusionDepth: 0.01,
                                              font: .systemFont(ofSize: 0.15),
                                    containerFrame: CGRect(),
                                         alignment: .left,
                                     lineBreakMode: .byCharWrapping)
        boxAnchor.nom!.children[0].children[0].components.set(nomtextModelComp)
        
        if (UserDefaults.standard.string(forKey: "mdpEsprit") != nil){
            boxAnchor.login?.isEnabled = false
        }
        boxAnchor.actions.linkEsprit.onAction = self.remodelling
        arView.scene.anchors.append(boxAnchor)
        let name = Notification.Name("MyStuffAdded")
        NotificationCenter.default.addObserver(self, selector: #selector(loadMatiere), name: name, object: nil)
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    @objc func handleTap(recognizer:UITapGestureRecognizer){
        let location = recognizer.location(in: arView)
        print(location)
        let results = arView.raycast(from: location, allowing: .existingPlaneInfinite, alignment: .any)
        print(results)
        if let firstResult = results.first{
            let anchor = ARAnchor(name: "Experience", transform: firstResult.worldTransform)
            arView.session.add(anchor: anchor)
        }else{
            print("erreur, pas de surface plate")
        }
    }
    
    @objc func loadMatiere(){
        var i :Float = 1
        if !(matieres.isEmpty){
            matieres.forEach { matiere in
                
                let boxAnchor = try! TextAR.loadScene()
                let nomText: Entity = boxAnchor.text!.children[0].children[0]/* Text Object */
                var nomtextModelComp: ModelComponent = (nomText.components[ModelComponent.self])!
               
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
        }else{
            matieresRat.forEach { matiere in
                
                let boxAnchor = try! TextAR.loadScene()
                let nomText: Entity = boxAnchor.text!.children[0].children[0]/* Text Object */
                var nomtextModelComp: ModelComponent = (nomText.components[ModelComponent.self])!
               
                nomtextModelComp.mesh = .generateText(matiere.nommodules+", Exam :"+matiere.note_exam_rat,
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
        
        alertHelper.dismissDialog(alertWait: alert!)
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
            //self.alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            //self.performSegue(withIdentifier: "web", sender: nil)
            self.alert = self.alertHelper.waitDialog()
            self.JS.extractMatiereJs(identifiant: identifi, pass: pass,controller: self,view: self.view)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func placeObject(named entityName:String, for anchor : ARAnchor){
        if !(matieres.isEmpty) {
            var i = matieres.count
            for matiere in matieres {
                self.arView.scene.anchors.remove(at: i)
                i -= 1
            }
        }else{
            var i = matieresRat.count
            for matiere in matieresRat {
                self.arView.scene.anchors.remove(at: i)
                i -= 1
            }
        }
       
        loadMatiere()
    }
}
