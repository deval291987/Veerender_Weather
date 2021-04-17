//
//  ViewController.swift
//  Veerender_weather
//
//  Created by apple on 16/04/21.
//

import UIKit

class ViewController: UIViewController {
    
    var weathers : [Weather] = []
    @IBOutlet weak var weatherTable : UITableView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBAction func addRecordBtnAction(_ sender: Any) {
       
        Constants.NavigateToSegue(vc: mapViewController.self, storyBoard: "Main", xib: "mapViewController", pvc: self, anim: false)
       
   }

    override func viewWillAppear(_ animated: Bool) {
        
        loadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTable.delegate = self
        weatherTable.dataSource = self
       
        // Do any additional setup after loading the view.
    }
    
    
    func loadData(){
        
      weathers.removeAll()
        
        do{
            weathers = try appDelegate.persistentContainer.viewContext.fetch(Weather.fetchRequest()) as [Weather]
            
            DispatchQueue.main.async {
                self.weatherTable.reloadData()
            }

            
        }catch{
            
            print(error.localizedDescription)
        }
                
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: cityCell = self.weatherTable.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! cityCell
        
        cell.cityLbl.text = weathers[indexPath.row].city
        cell.timeLbl.text = weathers[indexPath.row].desc
        cell.degreeLbl.text = weathers[indexPath.row].humidity
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        appDelegate.navId = indexPath.row
        Constants.NavigateToSegue(vc: cityViewController.self, storyBoard: "Main", xib: "cityViewController", pvc: self, anim: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            let context = appDelegate.persistentContainer.viewContext

            context.delete(weathers[indexPath.row])
            weathers.remove(at: indexPath.row)
            
            
            do{
                
                try context.save()
                
            }catch{
                
                print(error.localizedDescription)
            }
            
        
            self.weatherTable.deleteRows(at: [(indexPath as IndexPath)], with: .fade)
        default:
            return

        }
    }

}


