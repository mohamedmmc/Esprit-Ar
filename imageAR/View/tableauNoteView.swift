//
//  tableauNoteView.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 5/7/2022.
//

import Foundation
import UIKit

class tableauNoteView: UIViewController,UITableViewDelegate,UITableViewDataSource {
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
    
    @IBOutlet weak var classe: UILabel!
    @IBOutlet weak var fullName: UILabel!
    var tableauNote : [Matiere]?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableauNote!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let cv = cell?.contentView
        let matiere = cv?.viewWithTag(2) as! UILabel
        let exam = cv?.viewWithTag(3) as! UILabel
        let moyenneMatiere = String(calculMoyMatiere(matiere: tableauNote![indexPath.row]).rounded(toPlaces: 2))
        matiere.text = tableauNote![indexPath.row].designation
        exam.text = moyenneMatiere
        if(Float(moyenneMatiere)! < 10 && Float(moyenneMatiere)! >= 8){
            exam.textColor = .orange
        }else if (Float(moyenneMatiere)! < 8){
            exam.textColor = .red
        }else{
            exam.textColor = .green
        }
        //print(tableauNote![indexPath.row].designation + " " + String(calculMoyMatiere(matiere: tableauNote![indexPath.row])))

       return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailMatiere", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailMatiere" {
            let index = sender as! IndexPath
            let destination = segue.destination as! detailMatiere
            destination.matiere = tableauNote![index.row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "identifiant")
        UserDefaults.standard.removeObject(forKey: "rememberClassic")
        UserDefaults.standard.removeObject(forKey: "pass")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "resetClassic", sender: nil)
        }
    }
}
