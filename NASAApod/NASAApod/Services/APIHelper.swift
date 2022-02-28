//
//  APIHelper.swift
//  NASAApod
//
//  Created by Prasad More on 28/02/22.
//

import Foundation

class APIHelper {
    var urlSession: URLSession?
    static let shared = APIHelper()
    
    ///Get APOD data for perticualar Date
    func getData(dateStr: String, completionHandler: @escaping (NASAResponse?, Error?) -> Void) {
        let selectedDateStr = "&date=" + dateStr
        let finalURLStr = Constants.baseURL + Constants.kAPIKey + selectedDateStr
        guard let nasaURL = URL(string: finalURLStr) else { return }
        var urlRequest = URLRequest(url: nasaURL)
        urlRequest.httpMethod = "GET"
        let urlSession = URLSession(configuration: .default)
        let getDataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
            if response != nil {
                do {
                    let decoder = JSONDecoder.init()
                    let jsonObject = try decoder.decode(NASAResponse.self, from: data ?? Data())
                    print("SUCCESS = ", jsonObject)
                    completionHandler(jsonObject, nil)
                } catch {
                    
                    print("EROR =" , error.localizedDescription)
                    completionHandler(nil, error)
                }
            }
        }
        getDataTask.resume()
    }
    
    
}
