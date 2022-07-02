//
//  ViewController.swift
//  testAR
//
//  Created by Mohamed Melek Chtourou on 4/6/2022.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    var isActionPlaying: Bool = false
    @IBOutlet var arView: ARView!
    var tankAnchor : TinyToyTank._TinyToyTank?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load the tank
        tankAnchor = try! TinyToyTank.load_TinyToyTank()
        
        tankAnchor!.cannon?.setParent(tankAnchor!.tank, preservingWorldTransform: true)
        tankAnchor?.actions.actionComplete.onAction = { _ in
          self.isActionPlaying = false
        }

        // Add the box anchor to the scene
        arView.scene.anchors.append(tankAnchor!)
        
    }
    
    @IBAction func aimLeft(_ sender: Any) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }

        tankAnchor!.notifications.turretLeft.post()

    }
    @IBAction func tankFire(_ sender: Any) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }

        tankAnchor!.notifications.cannonFire.post()

    }
    
    @IBAction func aimRight(_ sender: Any) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }

        tankAnchor!.notifications.turretRight.post()
    }
    
    @IBAction func tankLeft(_ sender: Any) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }

        tankAnchor!.notifications.tankLeft.post()

    }
    @IBAction func tankForward(_ sender: Any) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }

        tankAnchor!.notifications.tankForward.post()

    }
    @IBAction func tankRight(_ sender: Any) {
        if self.isActionPlaying { return }
        else { self.isActionPlaying = true }

        tankAnchor!.notifications.tankRight.post()

    }
}
