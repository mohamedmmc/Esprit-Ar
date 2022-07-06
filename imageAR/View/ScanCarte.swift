//
//  ScanCarte.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 9/6/2022.
//

//
//  ViewController.swift
//  j
//
//  Created by Mohamed Melek Chtourou on 9/6/2022.
//

import UIKit
import VisionKit
import Vision

class ScanCarte: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    var documentCamera: VNDocumentCameraViewController?
    var idEsprit : String?
    var nom : String?
    var prenom : String?
    var classe : String?
    var firstTime = true
    

    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if (self.firstTime) {
            self.showDocumentScanner()
            self.firstTime = false
        }else if ((UserDefaults.standard.string(forKey: "idEsprit") ?? "").isEmpty){
            self.showDocumentScanner()
            //self.firstTime = true
            DispatchQueue.main.async {
                _ = AlertHelper().showAlert(title: "Invalid Card", message: "Couldn't extract Identifier from Card",action: "Try again")
            }
        }else{
            //self.dismiss(animated: true)
            //self.firstTime = true
            print(UserDefaults.standard.string(forKey: "idEsprit")!)
            self.performSegue(withIdentifier: "showAR", sender: nil)
            }
    }
    
   
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
      documentCamera?.dismiss(animated: true, completion: nil)
    }
      
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
      
      print("Document Scanner did fail with Error")
    }
      
    func propmt(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
  
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
      documentCamera?.dismiss(animated: true, completion: nil)
      documentCamera = nil
      let firstImage = scan.imageOfPage(at: 0)
        detectText(in: firstImage)
    }
    
    func showDocumentScanner() {
      guard VNDocumentCameraViewController.isSupported else{
          print("Document scanning not supported")
          return }
      documentCamera = VNDocumentCameraViewController()
      documentCamera?.delegate = self
      present(documentCamera!, animated: true, completion: nil)
    }
    
    func detectText(in image: UIImage) {
      guard let image = image.cgImage else {
        print("Invalid image")
        return
      }
      let request = VNRecognizeTextRequest { (request, error) in
        if let error = error {
          print("Error detecting text: \(error)")
        } else {
          self.handleDetectionResults(results: request.results)
        }
      }
      
      request.recognitionLanguages = ["en_US"]
      request.recognitionLevel = .accurate
      performDetection(request: request, image: image)
    }
    
    func performDetection(request: VNRecognizeTextRequest, image: CGImage) {
      let requests = [request]
      let handler = VNImageRequestHandler(cgImage: image, orientation: .up, options: [:])
      DispatchQueue.global(qos: .userInitiated).async {
          do {
              try handler.perform(requests)
          } catch let error {
              print("Error: \(error)")
          }
      }
    }
    
    func handleDetectionResults(results: [Any]?) {
      guard let results = results, results.count > 0 else {
          print("No text found")
          return
      }
        
      for result in results {
          if let observation = result as? VNRecognizedTextObservation {
              for text in observation.topCandidates(1) {
                  //print(text.string)
                  if let range = text.string.range(of: "NOM :") {
                      let id = text.string[range.upperBound...]
                      let trimmedString = id.trimmingCharacters(in: .whitespaces)
                      print(trimmedString)
                      UserDefaults.standard.set(String(trimmedString), forKey: "nom")
                  }
                  if let range = text.string.range(of: "PRÉNOM :") {
                      let id = text.string[range.upperBound...]
                      let trimmedString = id.trimmingCharacters(in: .whitespaces)
                      UserDefaults.standard.set(String(trimmedString), forKey: "prenom")

                  }
                  if let range = text.string.range(of: "CLASSE :") {
                      let id = text.string[range.upperBound...]
                      let str2 = id.replacingOccurrences(of: ":", with: "", options: NSString.CompareOptions.literal, range: nil)
                      let str3 = str2.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                      UserDefaults.standard.set(String(str3), forKey: "classe")

                  }
                  if let range = text.string.range(of: "IDENTIFIANT") {
                      let id = text.string[range.upperBound...]
                      let str2 = id.replacingOccurrences(of: ":", with: "", options: NSString.CompareOptions.literal, range: nil)
                      let str3 = str2.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                      UserDefaults.standard.set(String(str3), forKey: "idEsprit")
                  }
              }
          }
      }
       
        
    }

  
}



