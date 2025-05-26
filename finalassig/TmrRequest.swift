//
//  TmrRequest.swift
//  finalassig
//
//  Created by Jerry Chu on 12/8/24.
//

import Foundation
import Alamofire

class TmrRequest
{
    func getWeather(location:String, completion: @escaping (Result<[String: Any], Error>) -> Void)
    {
        let URL1 = "\(URL)/\(location)"
        
        AF.request(URL1).responseJSON
        {
            response in switch response.result
            {
            case .success(let value):
                if let json = value as? [String: Any]
                {
                    completion(.success(json))
                }
            case .failure(let error):
                print("Fail Request")
            }
            
        }
    }
}

