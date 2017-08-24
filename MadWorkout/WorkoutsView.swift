// ============================
import UIKit
// ============================
class WorkoutsView: UIViewController{
    // ============================
    var theDatabase: [String : [[String : String]]]!
    //---------------Methode predefinies du UIViewController---------------------------------------------------//
    override func viewDidLoad(){
        super.viewDidLoad()
        self.theDatabase = Shared.sharedInstance.getDatabase("db")
    }
    //---------------Methode predefinies du UIViewController---------------------------------------------------//
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    //----------Methode pour recuperer les dates de le dictionnaire-------------------------------------------//
    func getDates() -> [String]{
        var tempArray = [""]
        
        for (a, _) in  self.theDatabase{
            tempArray.append(a)
        }
        tempArray.remove(at: 0)
        
        return tempArray
    }
    //----------Methode pour determiner la quantite de lignes dans la tableView------------------------------//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.theDatabase.count
    }
    //----------Methode pour ajouter les informations de chaque ligne dans la tableView----------------------//
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        cell.textLabel!.font = UIFont(name: "Caviar Dreams", size: 18.0)
        cell.textLabel!.text = self.getDates()[indexPath.row]
        tableView.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    //----------Methode qui selectionne une rangee (et dans ce cas la, pour aller a une nouvelle page)------//
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.darkGray
        Shared.sharedInstance.theRow = indexPath.row
        performSegue(withIdentifier: "theSegway", sender: nil)
    }
    //----------Methode pour effacer une rangee------------------------------------------------------------//
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath){
        if editingStyle == UITableViewCellEditingStyle.delete{
            self.theDatabase[self.getDates()[indexPath.row]] = nil
            Shared.sharedInstance.saveDatabase(self.theDatabase)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    // ============================
}
// ============================
