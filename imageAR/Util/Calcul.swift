//
//  calcul.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 9/7/2022.
//

import Foundation

class Calcul{
    
    let helper = Helper()
    
    func calculMoyMatiere(matiere :Matiere) -> Float {
        
        var moyenne : Float = 0.0
        if ((matiere.note_cc.elementsEqual("&nbsp;")) && (matiere.note_tp).elementsEqual("&nbsp;")) {
            moyenne = helper.convertStringToFloat(string: matiere.note_exam)
        }else if ((matiere.note_cc != "&nbsp;") && (matiere.note_tp).elementsEqual("&nbsp;")){
            moyenne = (0.6 * helper.convertStringToFloat(string: matiere.note_exam)) + (0.4 * helper.convertStringToFloat(string: matiere.note_cc))
        }else if ((matiere.note_cc.elementsEqual("&nbsp;"))) && (matiere.note_tp != "&nbsp;"){
            moyenne = (0.8 * helper.convertStringToFloat(string: matiere.note_exam)) + (0.2 * helper.convertStringToFloat(string: matiere.note_tp))
        }else{
            moyenne = (0.5 * helper.convertStringToFloat(string: matiere.note_exam)) + (0.3 * helper.convertStringToFloat(string: matiere.note_cc)) + (0.2 * helper.convertStringToFloat(string: matiere.note_tp))
        }
        return moyenne
    }
    
    func calculMoyGeneral(matieres: [Matiere]) -> Float {
        var moyenneGen : Float = 0.0
        var coefTotal : Float = 0.0
        for matiere in matieres {
            moyenneGen += calculMoyMatiere(matiere: matiere) * helper.convertStringToFloat(string: matiere.coef)
            coefTotal += helper.convertStringToFloat(string: matiere.coef)
        }
        
        return (moyenneGen / coefTotal).rounded(toPlaces: 2)
    }
}
