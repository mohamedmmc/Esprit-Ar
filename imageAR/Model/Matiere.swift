//
//  matiere.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 2/7/2022.
//

import Foundation
struct Matieres: Decodable{
    var matieres: [Matiere]?
}

struct Matiere : Decodable{
    let designation : String
    let coef : String
    let nom_ens : String
    let note_cc : String
    let note_tp : String
    let note_exam : String
}
