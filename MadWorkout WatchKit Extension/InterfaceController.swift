//  InterfaceController.swift
//  MadWorkout WatchKit Extension
//
//  Created by eleves on 2017-07-17.
//  Copyright © 2017 GrassetSucre. All rights reserved.
//
// ============================
import WatchKit
import Foundation
import WatchConnectivity
// ============================

class InterfaceController: WKInterfaceController, WCSessionDelegate {
 // ============================
    @IBOutlet var table: WKInterfaceTable!
    var data : [String : String] = [:]
    var dates : [String] = []
    var workouts : [String] = []
    var session : WCSession!
    //---------------Methode predefinies-------------------------------------------------------------------//
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    //-----------------Methode pour recupere les informations d'UserDefault--------------------------------//
    func userDefaultManager() {
        if UserDefaults.standard.object(forKey: "data") == nil{
            UserDefaults.standard.set(data, forKey: "data")
        } else {
            data = UserDefaults.standard.object(forKey: "data") as! [String : String]
        }
    }
    //-----------------Methode qui fait la connection-------------------------------------------------------//
    func session (_ session: WCSession, didReceiveMessage message : [String : Any], replyHandler: @escaping([String : Any]) -> Void){
        let value = message["Message"] as? [String : String]
        DispatchQueue.main.async{ () -> Void in
            self.data = value!
            UserDefaults.standard.set(self.data, forKey: "data")
            self.dates = Array(value!.keys)
            self.workouts = Array(value!.values)
            self.tableRefresh()
        }
    }
    //------------------Methode pour faire le refresh de la table-----------------------------------------//
    func tableRefresh(){
        table.setNumberOfRows(data.count, withRowType: "row")
        
        for index in 0..<table.numberOfRows{
            let row = table.rowController(at: index) as! TableRowController
            row.dates.setText(dates[index])
        }
    }
    //--------------Methode obligatoire pour le protocole---------------------------------------------------//
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    //---------------Methode pour verifier si l'interface est active-----------------------------------------//
    override func willActivate() {
        
        super.willActivate()
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            
            userDefaultManager()
            
            self.dates = Array(data.keys)
            self.workouts = Array(data.values)
            tableRefresh()
            
        }
    }
    //--------------Methode obligatoire pour le protocole----------------------------------------------------//
    @available (watchOS 2.2, *)
    public func session (_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //...
    }
    //--------------Methode qui permet la selection d'une rangee pour aller a la deuxieme page---------------//
    override func table (_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int){
        self.pushController(withName: "page2", context: ["workout" : workouts[rowIndex]])
    }
// ============================
}
// ============================

