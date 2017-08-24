// ============================
import UIKit
// ============================
class InfoView: UIViewController{
    // ============================
    @IBOutlet weak var infoDateLabel: UILabel!
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var reorderButton: UIButton!
    var theDatabase: [String : [[String : String]]]!
    var theWorkout: [String]!
    //-------------
    override func viewDidLoad(){
        super.viewDidLoad()
        self.theDatabase = Shared.sharedInstance.getDatabase("db")
        self.infoDateLabel.text = self.getDates()[Shared.sharedInstance.theRow]
        self.theWorkout = self.fillUpWorkoutArray(self.infoDateLabel.text!)
    }
    //---------------Methode predefinies du UIViewController-----------------
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    //------------- Methode que active et desactive l'edition et change l'ecriture du bouton
    @IBAction func reorder(_ sender: UIButton){
        if !self.theTableView.isEditing{
            self.theTableView.isEditing = true
            self.reorderButton.setTitle("DONE", for: UIControlState())
        }
        else{
            self.theTableView.isEditing = false
            self.reorderButton.setTitle("EDIT", for: UIControlState())
        }
    }
    //----------Methode pour batir l'array avec les elements du dictionnaire en fonction de la cle envoye par parametre-------------//
    func fillUpWorkoutArray(_ theDate: String) -> [String]{
        var arrToReturn: [String] = []
        
        for (a, b) in self.theDatabase{
            if a == theDate{
                for c in b{
                    for (d, e) in c{
                        arrToReturn.append("[\(e)] : \(d)")
                    }
                }
            }
        }
        return arrToReturn
    }
    //----------Methode pour recuperer les dates de le dictionnaire-------------//
    func getDates() -> [String]{
        var tempArray = [""]
        
        for (a, _) in  self.theDatabase{
            tempArray.append(a)
        }
        tempArray.remove(at: 0)
        
        return tempArray
    }
    //----------Methode pour effacer une date dans la database et les itens associe-------------//
    func deleteFromDatabase(_ theDate: String, indexToDelete: Int){
        for (a, b) in self.theDatabase{
            if a == theDate{
                for _ in b{
                    self.theDatabase[theDate]?.remove(at: indexToDelete)
                    Shared.sharedInstance.saveDatabase(self.theDatabase)
                    return
                }
            }
        }
    }
    //----------Methode pour determiner la quantite de lignes dans la tableView-------------//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        self.theTableView.backgroundColor = UIColor.clear
        return self.theWorkout.count
    }
    //----------Methode pour ajouter les informations de chaque ligne dans la tableView-----//
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.textLabel!.font = UIFont(name: "Caviar Dreams", size: 14.0)
        cell.textLabel!.text = self.theWorkout[indexPath.row]
        tableView.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    //------------- Methode que permet d'editer une rangee d'une table (dans ce cas la effacer la ligne)
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath){
        if editingStyle == UITableViewCellEditingStyle.delete{
            self.theWorkout.remove(at: indexPath.row)
            self.deleteFromDatabase(self.infoDateLabel.text!, indexToDelete: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    //------------- Methode que permet de reordoner les rangees
    func tableView(_ tableView: UITableView, canMoveRowAtIndexPath indexPath: IndexPath) -> Bool{
        return true // Return false if you do not want the item to be re-orderable.
    }
    //------------- Methode que reordoner les rangees
    func tableView(_ tableView: UITableView, moveRowAtIndexPath fromIndexPath: IndexPath, toIndexPath: IndexPath){
        let itemToMove = self.theDatabase[self.infoDateLabel.text!]?[fromIndexPath.row]
        self.theDatabase[self.infoDateLabel.text!]?.remove(at: fromIndexPath.row)
        self.theDatabase[self.infoDateLabel.text!]?.insert(itemToMove!, at: toIndexPath.row)
        Shared.sharedInstance.saveDatabase(self.theDatabase)
    }
    // ============================    
}
// ============================
