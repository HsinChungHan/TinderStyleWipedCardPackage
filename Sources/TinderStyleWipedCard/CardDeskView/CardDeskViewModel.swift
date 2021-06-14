//
//  CardDeskViewModel.swift
//  
//
//  Created by ChungHan Hsin on 2021/6/14.
//

import Foundation

class CardDeskViewModel {
    let isEmpty = Bindable<Bool>.init(value: nil)
    
    func getCardViewIndex(cardView: CardView, cardViews:[CardView]) -> Int {
        return cardViews.firstIndex(of: cardView) ?? -1
    }
}
