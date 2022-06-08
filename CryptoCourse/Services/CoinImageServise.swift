//
//  CoinImageServise.swift
//  CryptoCourse
//
//  Created by Sergiy Brotsky on 08.06.2022.
//

import SwiftUI
import Combine

class CoinImageServise {
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private var coin: CoinModel
    
    
    init(coin: CoinModel){
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage(){
        guard let url = URL(string: coin.image)
        else {return}
        
        imageSubscription =
        NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink { (comlition) in
                NetworkingManager.handleComlition(comlition: comlition)
            } receiveValue: { [weak self](returnedImage) in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            }
    }
}
