//
//  CoinImageViewModel.swift
//  CryptoCourse
//
//  Created by Sergiy Brotsky on 08.06.2022.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let imageServise: CoinImageServise
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageServise = CoinImageServise(coin: coin)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        imageServise.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellable)

    }
}
