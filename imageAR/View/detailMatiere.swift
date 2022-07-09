//
//  detailMatiere.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 9/7/2022.
//

import Foundation
import UIKit

class detailMatiere: UIViewController {
    
    @IBOutlet weak var noteExam: UILabel!
    @IBOutlet weak var noteCC: UILabel!
    @IBOutlet weak var noteTP: UILabel!
    @IBOutlet weak var coef: UILabel!
    @IBOutlet weak var enseignant: UILabel!
    @IBOutlet weak var designation: UILabel!
    var matiere : Matiere?
    override func viewDidLoad() {
        noteTP.text = matiere?.note_tp
        noteCC.text = matiere?.note_cc
        noteExam.text = matiere?.note_exam
        coef.text = matiere?.coef
        enseignant.text = matiere?.nom_ens
        designation.text = matiere?.designation
        super.viewDidLoad()
    }
}
