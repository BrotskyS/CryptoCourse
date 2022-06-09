//
//  MarketDataService.swift
//  CryptoCourse
//
//  Created by Sergiy Brotsky on 09.06.2022.
//

import Foundation
import Combine

class MarketDataService {
    @Published var markerData:  MarketDataModel? = nil

    var markedDataSubscription: AnyCancellable?
    
    init(){
        getData()
    }
    
    private func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else {return}
        
        markedDataSubscription =
        NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink { (comlition) in
                NetworkingManager.handleComlition(comlition: comlition)
            } receiveValue: { [weak self](returnedGloabData) in
                self?.markerData = returnedGloabData.data
                self?.markedDataSubscription?.cancel()
            }
    }
}
