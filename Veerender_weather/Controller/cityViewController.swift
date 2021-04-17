//
//  cityViewController.swift
//  Veerender_weather
//
//  Created by apple on 17/04/21.
//

import UIKit

class cityViewController: UIViewController {
     
    var moreData = NSMutableArray()
    @IBOutlet weak var timeCollection: UICollectionView!
    var selectedIndex : NSInteger = 0
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        Constants.PopToMainSegue(pvc: self, anim: false)
        
    }
    
    var weathers : [Weather] = []
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var rainLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        timeCollection.delegate = self
        timeCollection.dataSource = self
        loadData()
        getWeather(city: self.weathers[self.appDelegate.navId].city ?? "")

        // Do any additional setup after loading the view.
    }
    
   
    
    func loadData(){
        
      weathers.removeAll()
        
        do{
            weathers = try appDelegate.persistentContainer.viewContext.fetch(Weather.fetchRequest()) as [Weather]
            
            DispatchQueue.main.async {
               
                self.cityLbl.text = self.weathers[self.appDelegate.navId].city
                self.descLbl.text = self.weathers[self.appDelegate.navId].desc
                self.humidityLbl.text = self.weathers[self.appDelegate.navId].humidity
                self.tempLbl.text = self.weathers[self.appDelegate.navId].temp
                self.rainLbl.text = self.weathers[self.appDelegate.navId].rain
                self.windLbl.text = self.weathers[self.appDelegate.navId].wind
            }

            
        }catch{
            
            print(error.localizedDescription)
        }
                
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension cityViewController{
    
    func getWeather(city: String){

        let location = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if let url = URL(string: "\(Constants.ApiHost)/forecast?q=\(location)&appid=\(Constants.ApiKey)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                   // if let jsonString = String(data: data, encoding: .utf8) {
                     //   print(jsonString)
                      //  let dict = convertToDictionary(stringDict: jsonString)
                        
                      //  let responseData = request.responseData()
                    if let responseDict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [AnyHashable: Any]{
                        
                      //  print("responseDict is \(String(describing: responseDict))")
                        
                        let arr = NSMutableArray()
                        arr.addObjects(from: (responseDict["list"] as! [Any]))
                        
                        for i in (0..<7){
                            
                            self.moreData.add(arr[i])
                            
                        }
                        
                        
                        print(self.moreData)
                        DispatchQueue.main.async {
                            if self.moreData.count != 0{
                             parseJSONOject()
                            }
                           
                        self.timeCollection.reloadData()
                            
                        }
                        
                     
                        
                    }else{
                        print(error ?? "Somthing went wrong")
                    }
                }
            }.resume()
        }
        
       
        
        
        
        func parseJSONOject(){
            
            let weather = ((moreData[0] as AnyObject).value(forKey:"weather") as! Array<Any>)
            self.descLbl.text = ((weather[0] as AnyObject).value(forKeyPath: "description") as! String)
            self.tempLbl.text = "\(((moreData[0] as AnyObject).value(forKey:"main") as AnyObject).value(forKey: "temp")!)"
            self.humidityLbl.text = "\(((moreData[0] as AnyObject).value(forKey:"main")  as AnyObject).value(forKey: "humidity")!)°"
            self.rainLbl.text = "\(((moreData[0] as AnyObject).value(forKey:"clouds")  as AnyObject).value(forKey: "all")!)%"
            self.windLbl.text = "\(((moreData[0] as AnyObject).value(forKey:"wind") as AnyObject).value(forKey: "speed")!)"
            
           
        }

        
    
        
        
    }
    
    
}


extension cityViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
 
     return moreData.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
     {
      
      return CGSize(width: 100.0, height: 100.0)
         
      
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         
       
             let cell: timeCell = timeCollection.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! timeCell
        
        
        if indexPath.row == selectedIndex{
            
            cell.bgView.backgroundColor = Constants.appBlue2Color
            cell.timeLbl.textColor = .white
          //  cell.timeLbl.text = "Now"
            let time = (moreData[indexPath.row] as AnyObject).value(forKey: "dt_txt") as! String
            cell.timeLbl.text = Constants.dateStyleChance(time)
            
        }else{
            cell.bgView.backgroundColor = .white
            cell.timeLbl.textColor = Constants.appBlue2Color
            
            let time = (moreData[indexPath.row] as AnyObject).value(forKey: "dt_txt") as! String
            cell.timeLbl.text = Constants.dateStyleChance(time)
            
        }
      
            
            
         
         return cell
             
         
     }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let weather = ((moreData[indexPath.row] as AnyObject).value(forKey:"weather") as! Array<Any>)
    self.descLbl.text = ((weather[0] as AnyObject).value(forKeyPath: "description") as! String)
    self.tempLbl.text = "\(((moreData[indexPath.row] as AnyObject).value(forKey:"main") as AnyObject).value(forKey: "temp")!)"
    self.humidityLbl.text = "\(((moreData[indexPath.row] as AnyObject).value(forKey:"main")  as AnyObject).value(forKey: "humidity")!)°"
    self.rainLbl.text = "\(((moreData[indexPath.row] as AnyObject).value(forKey:"clouds")  as AnyObject).value(forKey: "all")!)%"
    self.windLbl.text = "\(((moreData[indexPath.row] as AnyObject).value(forKey:"wind") as AnyObject).value(forKey: "speed")!)"
    selectedIndex = indexPath.row
    self.timeCollection.reloadData()
   
  }
    
    
    
    
}
