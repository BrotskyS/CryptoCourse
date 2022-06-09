//
//  HomeViewModel.swift
//  CryptoCourse
//
//  Created by Sergiy Brotsky on 08.06.2022.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject{
    
    @Published var  statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let markedDataService = MarketDataService()
    private var cancellable = Set<AnyCancellable>()
    
    
    init(){
        addSubscibers()
    }
    
    private func addSubscibers(){
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellable)
        
        markedDataService.$markerData
            .map(mapGlobalMarkedData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellable)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else {return coins}
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { coin in
            return
                coin.name.lowercased().contains(lowercasedText) ||
                coin.symbol.lowercased().contains(lowercasedText) ||
                coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarkedData(markedDataModel: MarketDataModel?) -> [StatisticModel]{
        var stats: [StatisticModel] = []
        
        guard let data = markedDataModel else {return stats}
        
        let markedCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.000", percentageChange: 0)
        
        stats.append(contentsOf: [
            markedCap,
            volume,
            btcDominance,
            portfolio
        ])
         
        return stats
    }
}
