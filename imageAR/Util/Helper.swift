//
//  Extentions.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 8/7/2022.
//

import Foundation
import JavaScriptCore
import WebKit
import ARKit
class Helper {
    func convertStringToFloat(string:String) -> Float {
        let float = string.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
        return Float(float)!
    }
}

extension Float {
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
extension ARcamera: WKScriptMessageHandler {
    
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      if message.name == "logHandler" {
          
          let string = String(describing: message.body)
          let data = string.data(using: .utf8)!
          
          if let matiere = try? JSONDecoder().decode([Matiere].self, from: data){
              print("je deserialise matiere principale")
              matieres = matiere
              let name = Notification.Name("MyStuffAdded")
              let notification = Notification(name: name)
              NotificationCenter.default.post(notification)
          }else{
              if let matiere = try? JSONDecoder().decode([MatiereRat].self, from: data){
                  print("je deserialise matiere rattrapage")
                  matieresRat = matiere
                  let name = Notification.Name("MyStuffAdded")
                  let notification = Notification(name: name)
                  NotificationCenter.default.post(notification)
              }
          }
         }
  }
}

extension ARcamera:ARSessionDelegate{
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == "Experience"{
                placeObject(named: anchorName, for:anchor)
            }
        }
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
}

extension UIView {
    public var viewWidth: CGFloat {
        return self.frame.size.width
    }

    public var viewHeight: CGFloat {
        return self.frame.size.height
    }
}


