//
//  CityNameTableViewController.swift
//  Exercise6_Mandapati_Likhitha
//
//  Created by student on 10/13/22.
//

import UIKit

struct City : Codable {
    init() {
        country = ""
        capital = ""
        temp_f = 45
        cap_lat =  0.00
        cap_long = 0.00
    }
    
    var country : String
    var capital : String
    var temp_f : Int
    var cap_lat : Double
    var cap_long : Double
}

class CityNameTableViewController: UITableViewController {
    
    var selectedCity = City()
    var actualCities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        downloadData( url : URL(string: "https://cpl.uh.edu/courses/ubicomp/fall2022/webservice/cities.json")!)
        
        func downloadData(url : URL) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let downloadedData = data{
                    do {
                        self.actualCities = try
                        JSONDecoder().decode(Array<City>.self, from: downloadedData)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("error in JSON encoding")
                    }
                }
                
            }.resume()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actualCities.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cityLabel = cell.viewWithTag(1) as! UILabel
        cityLabel.text = actualCities[indexPath.row].capital
        let temp = actualCities[indexPath.row].temp_f
        let red = getRedFromTemperature(temp: temp)
        let green = getGreenFromTemperature(temp: temp)
        let blue = getBlueFromTemperature(temp: temp)
        //cell.backgroundColor = UIColor.red
       // cell.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(69), blue: CGFloat(69), alpha: CGFloat(1.0))
        //cell.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        //cell.backgroundColor = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: CGFloat(1.0))
        cell.contentView.backgroundColor = UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)
        return cell
    }
    //warm (rgb: 255/69/58), cold (rgb: 143/188/218)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seg_map" {
            let mapViewPage = segue.destination as! ViewController
            mapViewPage.selectedCity = selectedCity
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCity = actualCities[indexPath.row]
        performSegue(withIdentifier: "seg_map", sender: self)
    }
    
    func getRedFromTemperature(temp : Int) -> Float {
        let red = (((temp - 45) * (255 - 143)) / (100 - 45)) + 143
        return Float(red)
    }
    
    func getGreenFromTemperature(temp : Int) -> Float {
        let green = 188 - (((temp - 45) * (188 - 69)) / (100 - 45))
        return Float(green)
    }
    
    func getBlueFromTemperature(temp : Int) -> Float {
        let blue = 218 - (((temp - 45) * (218 - 58)) / (100 - 45))
        return Float(blue)
    }
}
