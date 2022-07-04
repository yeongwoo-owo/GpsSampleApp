//
//  MapModel.swift
//  MySampleApp
//
//  Created by Yeongwoo Kim on 2022/07/04.
//

import Foundation
import OSLog

struct MapModel {
    private enum DataFetchingError: Error {
        case invalidURL
        case urlUnableToConvertToData
        case unDecodable
    }
    
    var shops: [Shop] = []
    
    init() {
        shops = getShopData()
    }
    
    private func getShopData() -> [Shop] {
        let fileName = "GoodPriceShop"
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            os_log(.error, log: .default, "INVALID URL: \(DataFetchingError.invalidURL.localizedDescription)")
            return []
        }
        
        guard let data = try? Data(contentsOf: fileLocation) else {
            os_log(.error, log: .default, "URL UNABLE TO CONVERT TO DATA: \(DataFetchingError.urlUnableToConvertToData.localizedDescription)")
            return []
        }
        
        guard let shops = try? JSONDecoder().decode([Shop].self, from: data) else {
            os_log(.error, log: .default, "UNDECODABLE: \(DataFetchingError.unDecodable.localizedDescription)")
            return []
        }
        
        os_log(.debug, log: .default, "Successfully Get Json Data")
        return shops
    }
    
    func getCategorizedShop(category: ShopCategory) -> [Shop] {
        return shops.filter{ category.isShopIncludedCategory(subCategory: $0.category) }
    }
}

