//
//  tableauNoteView.swift
//  imageAR
//
//  Created by Mohamed Melek Chtourou on 5/7/2022.
//

import Foundation
import UIKit

class tableauNoteView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableauNote : [Matiere]?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableauNote!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let cv = cell?.contentView
        let matiere = cv?.viewWithTag(2) as! UILabel
        let exam = cv?.viewWithTag(3) as! UILabel
        matiere.text = tableauNote![indexPath.row].designation
        exam.text = tableauNote![indexPath.row].note_exam

       return cell!
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
