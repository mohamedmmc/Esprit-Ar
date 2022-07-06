//
//  AlertHelper.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 6/7/2022.
//

import Foundation
import UIKit
class AlertHelper : UIViewController{
    let alertWait = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

    func currentTopViewController() -> UIViewController {
        var topVC: UIViewController? = UIApplication.shared.delegate?.window?!.rootViewController
        while (topVC!.presentedViewController != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
    func showAlert(title:String,message:String,action:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .destructive , handler: nil)
        alert.addAction(action)
        let currentTopVC: UIViewController? = self.currentTopViewController()
        currentTopVC!.present(alert, animated: true, completion: nil)
        return alert
    }
    
    
    func waitDialog() -> UIAlertController{
        alertWait.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            self.alertWait.dismiss(animated: true, completion: nil)
        }))
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alertWait.view.addSubview(loadingIndicator)
        let currentTopVC: UIViewController? = self.currentTopViewController()
        currentTopVC!.present(alertWait, animated: true, completion: nil)
        return alertWait
    }
    
    func dismissDialog(){
        alertWait.dismiss(animated: true)
    }
}
