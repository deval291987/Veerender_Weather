//
//  mapViewController.swift
//  Veerender_weather
//
//  Created by apple on 16/04/21.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController {
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        Constants.PopToMainSegue(pvc: self, anim: false)
        
    }
    
    @IBOutlet weak var getbtn: UIButton!
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var rainLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func addWeatherBtnAction(_ sender: Any) {
        
        appDelegate.persistentContainer.performBackgroundTask{ (BackgroundContext) in

             let weatherEntity = Weather(context: BackgroundContext)
            
            DispatchQueue.main.async {
    
            weatherEntity.city = self.cityLbl.text!
            weatherEntity.humidity = self.humidityLbl.text!
            weatherEntity.temp = self.tempLbl.text!
            weatherEntity.wind = self.windLbl.text!
            weatherEntity.rain = self.rainLbl.text!
            weatherEntity.desc = self.descLbl.text!
            weatherEntity.degree = ""
            weatherEntity.time = ""
            weatherEntity.id = 0
                self.loadData()
            }
    
             do{
                 try BackgroundContext.save()
                 
                 
                 
             }catch{
                 print(error.localizedDescription)
             }

          

         }
        
    }
    
    func loadData(){
        
        gradientView.isHidden = true
        addView.isHidden = true
        Constants.PopToMainSegue(pvc: self, anim: false)
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        
        loadData()
        
    }
    
    
    @IBAction func getWeatherBtnAction(_ sender: Any) {
        
        getWeather(city: addressLabel.text!)
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var previousLocation: CLLocation?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        loadUI()
    }
    
    func loadUI(){
        
        gradientView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(gradientView)
        gradientView.isHidden = true
        
        addView.frame = CGRect(x:25, y:(self.view.frame.size.height - 500)/2, width:self.view.frame.size.width - 50, height: 500 )
        self.view.addSubview(addView)
        addView.isHidden = true
        addView.layer.cornerRadius = 10.0
        
        
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


extension mapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension mapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let city = placemark.locality ?? ""
          //  let local = placemark.subLocality ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(city)"
                print(self.addressLabel.text!)
                self.getbtn.isHidden = false
            }
        }
    }
}

extension mapViewController{
    
    func getWeather(city: String){

        let location = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        if let url = URL(string: "\(Constants.ApiHost)/weather?q=\(location)&appid=\(Constants.ApiKey)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                   // if let jsonString = String(data: data, encoding: .utf8) {
                     //   print(jsonString)
                      //  let dict = convertToDictionary(stringDict: jsonString)
                        
                      //  let responseData = request.responseData()
                    if let responseDict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [AnyHashable: Any]{
                        
                        print("responseDict is \(String(describing: responseDict))")
                        DispatchQueue.main.async {
                        self.cityLbl.text = (responseDict["name"] as! String)
                        
                        let weather = (responseDict["weather"] as! Array<Any>)
                        
                        self.descLbl.text = ((weather[0] as AnyObject).value(forKey: "description") as! String)
                        self.tempLbl.text = "\((responseDict["main"]  as AnyObject).value(forKey: "temp")!)"
                        self.humidityLbl.text = "\((responseDict["main"]  as AnyObject).value(forKey: "humidity")!)°"
                        self.rainLbl.text = "\((responseDict["clouds"]  as AnyObject).value(forKey: "all")!)%"
                        self.windLbl.text = "\((responseDict["wind"]  as AnyObject).value(forKey: "speed")!)"
                        
                        self.gradientView.isHidden = false
                        self.addView.isHidden = false
                            
                        }
                    }else{
                        print(error ?? "Somthing went wrong")
                    }
                }
            }.resume()
        }
        
        

        
     /*   print("\(Constants.ApiHost)/weather?q=\(location)&appid=\(Constants.ApiKey)")
        if let url = URL(string: "\(Constants.ApiHost)/weather?q=\(city)&appid=\(Constants.ApiKey)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: data)
                        print(res.objectData)
                    } catch let error {
                        print(error)
                    }
                }
            }.resume()
        } */
        
        
    }
    
    
}


