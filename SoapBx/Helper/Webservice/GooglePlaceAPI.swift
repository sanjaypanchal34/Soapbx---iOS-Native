//
//  GooglePlaceAPI.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 26/02/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

typealias JSON = [String:Any]
typealias JSONArray = [[String:Any]]

func googleMapSearch(_ search: String, complition: @escaping ((GMapSearchResult)->Void)) {
    
    let apiKey = "AIzaSyAHAlST6bNP2AiqirvrrOnB1si9Y-LQSRI"
    let semaphore = DispatchSemaphore (value: 0)
    
        var urlComponents = URLComponents(url: URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json")!, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "query", value: search),
            URLQueryItem(name: "key", value: apiKey)]

    var request = URLRequest(url: urlComponents!.url!)
    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
          DispatchQueue.main.async {
              complition(GMapSearchResult([:]))
          }
        semaphore.signal()
        return
      }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? JSON
            
            DispatchQueue.main.async {
                complition(GMapSearchResult(json ?? [:]))
            }
            semaphore.signal()
        }catch {
            
            semaphore.signal()
        }
      
    }

    task.resume()
    semaphore.wait()
    
}


struct GMapSearchResult {
    var results: [GMapResult] = []
    
    init(_ json: JSON) {
        results = []
        for obj in (json["results"] as? JSONArray ?? []) {
            results.append(GMapResult(obj))
        }
    }
}

struct GMapResult {
    var formattedAddress: String = ""
    var placeId: String = ""
    var geometry: GMapGeometry?
    
    init(_ json: JSON) {
        formattedAddress = json["formatted_address"] as? String ?? ""
        placeId = json["place_id"] as? String ?? ""
        geometry = GMapGeometry(json["geometry"] as? JSON ?? [:])
    }
}
struct GMapGeometry {
    var location:GMapLocation?
    
    init(_ json: JSON) {
        location = GMapLocation(json["location"] as? JSON ?? [:])
    }
}
struct GMapLocation {
    var lat: Double = 0
    var lng: Double = 0
    
    init(_ json: JSON) {
        lat = json["lat"] as? Double ?? 0
        lng = json["lng"] as? Double ?? 0
    }
}
