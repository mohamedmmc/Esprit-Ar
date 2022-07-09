//
//  detailMatiere.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 9/7/2022.
//

import Foundation
import UIKit
import Lottie
class detailMatiere: UIViewController {

    @IBOutlet weak var moyenneMatiere: UILabel!
    @IBOutlet weak var noteExam: UILabel!
    @IBOutlet weak var noteCC: UILabel!
    @IBOutlet weak var noteTP: UILabel!
    @IBOutlet weak var coef: UILabel!
    @IBOutlet weak var enseignant: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    var matiere : Matiere?
    var calcul = Calcul()
    
    override func viewDidLoad() {
        if (matiere!.note_cc.elementsEqual("&nbsp;")) {
            noteCC.text = "NC"
        } else {
            noteCC.text = matiere?.note_cc
        }
        if (matiere!.note_tp.elementsEqual("&nbsp;")) {
            noteTP.text = "NC"
        } else {
            noteTP.text = matiere?.note_cc
        }
        noteExam.text = matiere?.note_exam
        coef.text = matiere?.coef
        enseignant.text = matiere?.nom_ens
        designation.text = matiere?.designation
        moyenneMatiere.text =  String(calcul.calculMoyMatiere(matiere: matiere!).rounded(toPlaces: 2))
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
        super.viewDidLoad()
    }
}
