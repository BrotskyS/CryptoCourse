//
//  HomeViewModel.swift
//  CryptoCourse
//
//  Created by Sergiy Brotsky on 08.06.2022.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject{
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    private var dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    
    init(){
        addSubscibers()
    }
    
    private func addSubscibers(){
        dataService.$allCoins
            .sink{ [weak  self](returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
    }
}
