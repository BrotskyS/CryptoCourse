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
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
        
    }
    
    private func getCoinImage(){
        if let savedImage =  fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        }else{
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage(){
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
                guard let self = self, let downloadedImage = returnedImage else {return}
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            }
    }
}
