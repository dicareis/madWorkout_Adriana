// ============================
import UIKit
// ============================
class Shared: UIViewController{
    // ============================
    var theDatabase: [String : [[String : String]]]!
    var savedUserDefault: UserDefaults = UserDefaults.standard
    static let sharedInstance = Shared()
    var theRow: Int!
    //-----------------Methode pour verifier s'il y a un UserDefault avec la cle envoyer par parametre---------------------------------//
    func checkForUserDefaultByName(_ theName: String, andUserDefaultObject: UserDefaults) -> Bool{
        let userDefaultObject = andUserDefaultObject.object(forKey: theName)
        
        if userDefaultObject == nil{
            return false
        }
        return true
    }
    //-----------------Methode qui cree un UserDefaults vide ou recupere les informations d'UserDefault' deja enregistrees-------------//
    func  saveOrLoadUserDefaults(_ name: String){
       //self.savedUserDefault.removeObjectForKey(name)
        
        if !self.checkForUserDefaultByName(name, andUserDefaultObject: self.savedUserDefault){
            var tempArray = ["" : [["" : ""]]]
            tempArray[""] = nil
            
            self.saveUserDefaultByName(name, andUserDefaultObject: self.savedUserDefault, andSomeValue: tempArray)
        }
        else{
           self.theDatabase = self.savedUserDefault.value(forKey: name) as! [String : [[String : String]]]
        }
    }
    //-----------------Methode pour sauvegarder le dictionnaire dans le UserDefault a partir d'une cle envoyée par parametre-----------//
    func saveUserDefaultByName(_ theName: String, andUserDefaultObject: UserDefaults, andSomeValue: [String : [[String : String]]]){
        andUserDefaultObject.setValue(andSomeValue, forKey: theName)
    }
    //-----------------Methode pour recuperer les informations du dictionnaire dans le UserDefault------------------------------------//
    func getDatabase(_ name: String) -> [String : [[String : String]]]{
        return self.savedUserDefault.value(forKey: name) as! [String : [[String : String]]]
    }
    //-----------------Methode pour sauvegarder le dictionnaire dans le UserDefault a partir de la cle 'db'---------------------------//
    func saveDatabase(_ valueToSave: [String : [[String : String]]]){
        self.savedUserDefault.setValue(valueToSave, forKey: "db")
    }
    // ============================
}
// ============================
