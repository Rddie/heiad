//
//  AdDataRequest.swift
//  HeiAd
//
//  Created by Reinhard D on 20.10.21.
//

import Foundation

class AdDataRequest: HeiAdApi {
    
    func getAdData(completion: @escaping (_ list: [AdDTO]?, _ error: String?) -> Void) {
        
        var info: String?
        var dto: [AdDTO]?
        
        let urlRequest = createUrlRequest(urlString: SERVICE_BALSER_MORK)
        
        sendRequest(request: urlRequest, completion: { data, error in
            
            if let data = data, let adsDto = try? JSONDecoder().decode(AdDataDTO.self, from: data) {
                dto = adsDto.items
                info = error ?? "SUCCESS"
            } else {
                info = error ?? "Parsing error"
            }
            completion(dto, info)
            
        })
        
    }
    
    
    internal func execute ( completion: @escaping (_ message: String?) -> Void) {
        
        getAdData { adlist, error in
            if let adlist = adlist {
                
                CoreDataManager.shared.saveAds(data: adlist)
                
            }
            
            completion (error)
        }
    }
    
}

struct AdDataDTO : Codable {
    var items: [AdDTO]
    var size: Int?
    var version: String?
}

struct AdDTO : Codable {
    var id: String
    var description: String?
    var location: String?
    // var ad-type: String?
    var image: ImageDTO?
    var price: PriceDTO?
}

struct ImageDTO : Codable {
    var url: String?
}

struct PriceDTO: Codable {
    var value: Int?
    var total: Int?
}


