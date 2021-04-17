//
//  Constants.swift
//  Veerender_weather
//
//  Created by apple on 16/04/21.
//

import Foundation
import UIKit


enum Constants{
    
    static let ApiKey = "fae7190d7e6433ec3a45285ffcf55c86"
    static let ApiHost = "http://api.openweathermap.org/data/2.5"
    
    static let appBlueColor = UIColor(red: 54/255.0, green: 84/255.0, blue: 201/255.0, alpha: 1.0).cgColor
    static let appBlue2Color = UIColor(red: 54/255.0, green: 84/255.0, blue: 201/255.0, alpha: 1.0)
    static let lightBlue = UIColor(red: 197/255.0, green: 213/255.0, blue: 251/255.0, alpha: 1.0)
    
   static func NavigateToSegue(vc: Any, storyBoard : String, xib : String, pvc : Any, anim : Bool) {
         
         let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
         let segue = storyboard.instantiateViewController(withIdentifier: xib)
         segue.modalPresentationStyle = .fullScreen
         (pvc as AnyObject).navigationController??.pushViewController(segue, animated: anim)
         
     }
     
  static func popToSegue(vc: Any, storyBoard : String, xib : String, pvc : Any, anim : Bool) {
            
            let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
            let segue = storyboard.instantiateViewController(withIdentifier: xib)
            segue.modalPresentationStyle = .fullScreen
            (pvc as AnyObject).navigationController??.popToViewController(segue, animated: anim)
            
        }
    
    static func PopToMainSegue( pvc : Any, anim : Bool ){
        
        (pvc as AnyObject).navigationController??.popViewController(animated: anim)
        
    }
    
    static func dateStyleChance(_ str : String) -> String{
        
        let dateString = str
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          // dateFormatter.locale = Locale.init(identifier: "en_GB")
          
        let dateObj = dateFormatter.date(from: dateString)
          
          dateFormatter.dateFormat = "HH:mm a"
          //print("Dateobj: \(dateFormatter.string(from: dateObj!))")

        let dateStr = dateFormatter.string(from: dateObj!) as NSString
        
        return dateStr as String
        
    }
 
}

class genaralProperties {
    
   
}



struct Response: Codable { // or Decodable
    let objectData: String
}
