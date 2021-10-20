//
//  HeiAdApi.swift
//  HeiAd
//
//  Created by Reinhard D on 20.10.21.
//


import Foundation

class HeiAdApi {
    
    func sendRequest(request: URLRequest, completion: @escaping (_ data: Data?, _ error: String?) -> Void) {
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            
            
            guard error == nil, let response = response as? HTTPURLResponse, (200 ... 299).contains(response.statusCode), data != nil else {
                
                var errorInfo: String?
                if let data = data, let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                    errorInfo = apiError.title
                } else {
                    errorInfo = error?.localizedDescription
                }
                
                completion(nil, errorInfo)
                return
                
            }
        
            print ("API RESONSE: \(String(data: data!, encoding: .utf8) ?? "empty")")
            
            completion(data, nil)
            
        }).resume()
        
    }
    
    func createUrlRequest(urlString: String, method: String = "GET", params: [String:String]? = nil) -> URLRequest {
        
        var url = URLComponents(string: urlString)!
        
        if let params = params {
            
            var queryItems: [URLQueryItem] = []
            params.forEach( { key, value in
                queryItems.append(URLQueryItem(name: key, value: value))
            })
            url.queryItems = queryItems
        }
        
        var urlRequest = URLRequest(url: url.url!)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
        
    }
}

struct ApiError : Codable {
    var type: String
    var title: String
    var status: Int
}
