//
//  FavRequest.swift
//  finalassig
//
//  Created by Jerry Chu on 12/10/24.
//

import Foundation
import Alamofire

class FavRequest
{
    func saveCity(city:String, completion: @escaping (Result<Bool, Error>) -> Void)
    {
        let url = "https://assig3chu.wl.r.appspot.com/api/map/cool"
        
        let data: [String: String] =
        [
            "address": "N/A",
            "city": city,
            "state": "N/A",
        ]
        
        AF.request(url, method: .post, parameters:data, encoding: JSONEncoding.default).response
        {
            response in if let error = response.error
                {
                    print("Request failed \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let statusCode = response.response?.statusCode, statusCode == 201
                {
                    completion(.success(true))
                }
        }
    }
    func getCity(completion: @escaping (Result<[MapData], Error>) -> Void)
    {
        let url = "https://assig3chu.wl.r.appspot.com/api/nice/mapAll"
        
        AF.request(url, method: .get)
            .responseDecodable(of: [MapData].self)
            {
                response in switch response.result{
                case .success(let maps):
                    print("Fected maps: \(maps)")
                    completion(.success(maps))
                case .failure(let error):
                    print("Error Fetch Map")
                    completion(.failure(error))
                }
            }
    }
    func delCity(ID:String) -> Void
    {
        let url = "https://assig3chu.wl.r.appspot.com/api/map/del/\(ID)"
        
        AF.request(url, method:.delete).response
        {
            response in switch response.result
            {
                case .success:
                print("Record deleted \(ID)")
                case .failure:
                print("Record deleted fail")
            }
        }
        
    }
}
struct MapData: Decodable
{
    let _id: String
    let address: String
    let city: String
    let state: String
}
