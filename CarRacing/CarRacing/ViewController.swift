//
//  ViewController.swift
//  CarRacing
//
//  Created by nagasashidhar kummara on 1/16/19.
//  Copyright © 2019 nagasashidhar kummara. All rights reserved.
//

import UIKit

typealias JSON = [String: Any]
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var raceArray = [String] ()
    var raceDict = [String:Any]()
   
    @IBOutlet weak var racingListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        
        let carRacingURL: String = "http://ergast.com/api/f1/current.json"
        guard let url = URL(string: carRacingURL) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        print("\(urlRequest)")
        
        // set up the session
        let session = URLSession.shared
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /api/f1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? JSON

                self.raceDict = ((json?["MRData"] as? JSON)?["RaceTable"] as? JSON)  as! JSON
         
                let raceList = self.raceDict["Races"]
              
 
            
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return raceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "raceCar")
        cell?.textLabel?.text = raceArray[indexPath.row]
        return cell!
        
        
    }
}

//Pragma mark :: Data Models

struct RaceJsonData {
    let mrData: MRData
}

struct MRData {
    let xmlns: String
    let series: String
    let url: String
    let limit, offset, total: String
    let raceTable: RaceTable
}

struct RaceTable {
    let season: String
    let races: [Race]
}

struct Race {
    let season, round: String
    let url: String
    let raceName: String
    let circuit: Circuit
    let date, time: String
}

struct Circuit {
    let circuitID: String
    let url: String
    let circuitName: String
    let location: Location
}

struct Location {
    let lat, long, locality, country: String
}
