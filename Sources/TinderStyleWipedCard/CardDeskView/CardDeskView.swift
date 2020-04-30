//
//  CardDeskView.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/4/29.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit

protocol CardDeskViewDataSource: AnyObject {
  func cardDeskViewAllCardViewModels(_ cardDeskView: CardDeskView) -> [CardViewModel]
}

public class CardDeskView: UIView {
  weak var dataSource: CardDeskViewDataSource?
  
  override public init(frame: CGRect) {
    super.init(frame: .zero)
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CardDeskView {
  
  public func putIntoCards() {
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set CardDeskView's dataSource")
    }
    
    dataSource.cardDeskViewAllCardViewModels(self).forEach {
      let cardView = CardView(cardViewModel: $0)
      addSubview(cardView)
      cardView.fillSuperView()
    }
  }
}
