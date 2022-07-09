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
    @IBOutlet weak var classe: UILabel!
    @IBOutlet weak var fullName: UILabel!
    var tableauNote : [Matiere]?
    @IBOutlet weak var moyenneGeneral: UILabel!
    var student : Student?
    let calcul = Calcul()
    override func viewDidLoad() {
        classe.text = student?.classeEsprit
        fullName.text = student?.fullName
        moyenneGeneral.text = String(calcul.calculMoyGeneral(matieres: tableauNote!))
        if(calcul.calculMoyGeneral(matieres: tableauNote!) < 10 && calcul.calculMoyGeneral(matieres: tableauNote!) >= 8){
            moyenneGeneral.textColor = .orange
        }else if (calcul.calculMoyGeneral(matieres: tableauNote!) < 8){
            moyenneGeneral.textColor = .red
        }else{
            moyenneGeneral.textColor = .green
        }
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableauNote!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let cv = cell?.contentView
        let matiere = cv?.viewWithTag(2) as! UILabel
        let exam = cv?.viewWithTag(3) as! UILabel
        let moyenneMatiere = String(calcul.calculMoyMatiere(matiere: tableauNote![indexPath.row]).rounded(toPlaces: 2))
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

    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "identifiant")
        UserDefaults.standard.removeObject(forKey: "rememberClassic")
        UserDefaults.standard.removeObject(forKey: "pass")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "resetClassic", sender: nil)
        }
    }
}
