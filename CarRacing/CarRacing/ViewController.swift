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
        
        self.racingListTableView.delegate  = self
        self.racingListTableView.dataSource = self
        
        let carRacingURL: String = "http://ergast.com/api/f1/current.json"
        guard let url = URL(string: carRacingURL) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
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
            
                let jsondata = try! JSONDecoder().decode(CarRacing.self, from: responseData)
                let abc = jsondata.mrData.raceTable.races
                self.raceArray = abc.map{$0.circuit.location.locality}
                self.racingListTableView.reloadData()
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


struct CarRacing: Codable {
    let mrData: MRData
    
    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
    
    struct MRData: Codable {
        let xmlns: String
        let series: String
        let url: String
        let limit, offset, total: String
        let raceTable: RaceTable
        
        enum CodingKeys: String, CodingKey {
            case xmlns, series, url, limit, offset, total
            case raceTable = "RaceTable"
        }
    }
    
    struct RaceTable: Codable {
        let season: String
        let races: [Race]
        
        enum CodingKeys: String, CodingKey {
            case season
            case races = "Races"
        }
    }
    
    struct Race: Codable {
        let season, round: String
        let url: String
        let raceName: String
        let circuit: Circuit
        let date, time: String
        
        enum CodingKeys: String, CodingKey {
            case season, round, url, raceName
            case circuit = "Circuit"
            case date, time
        }
    }
    
    struct Circuit: Codable {
        let circuitID: String
        let url: String
        let circuitName: String
        let location: Location
        
        enum CodingKeys: String, CodingKey {
            case circuitID = "circuitId"
            case url, circuitName
            case location = "Location"
        }
    }
    
    struct Location: Codable {
        let lat, long, locality, country: String
    }
}
