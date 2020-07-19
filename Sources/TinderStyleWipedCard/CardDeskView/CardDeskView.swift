//
//  CardDeskView.swift
//  TinderCard
//
//  Created by Chung Han Hsin on 2020/4/29.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit

public protocol CardDeskViewDataSource: AnyObject {
  func cardDeskViewARoundDuration(_ cardDeskView: CardDeskView) -> TimeInterval
  func cardDeskViewAllCardViewModelTuples(_ cardDeskView: CardDeskView) -> [(title: String, textAlignment: NSTextAlignment, images: [String])]
}

public protocol CardDeskViewDelegate: AnyObject {
  func cardDeskViewDidLikeCard(_ cardDeskView: CardDeskView, cardViewModel: CardViewModel)
  
  func cardDeskViewDidDislikeCard(_ cardDeskView: CardDeskView, cardViewModel: CardViewModel)
}

public class CardDeskView: UIView {
  weak public var dataSource: CardDeskViewDataSource?
  weak public var delegate: CardDeskViewDelegate?
  var cardViews = [CardView]()
  var timer: Timer?
  
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
    
    let cardDeskViewAllCardViewModelTuples = dataSource.cardDeskViewAllCardViewModelTuples(self)
    var cardVMs = [CardViewModel]()
    cardDeskViewAllCardViewModelTuples.forEach {
      var images = [UIImage]()
      for imageName in $0.images {
        let image = UIImage(named: imageName)!
        images.append(image)
      }
      let vm = CardViewModel(name: $0.title, textAlignment: $0.textAlignment, photos: images)
      cardVMs.append(vm)
    }
    cardVMs.forEach {
      let cardView = CardView(cardViewModel: $0)
      addSubview(cardView)
      cardView.fillSuperView()
      cardView.delegate = self
      cardViews.append(cardView)
    }
  }
  
  public func launchTimer() {
    timer = makeTimer()
    RunLoop.current.add(timer!, forMode: .common)
  }
  
  fileprivate func makeTimer() -> Timer {
    guard let dataSource = dataSource else {
      fatalError("🚨 You have to set dataSource for CardDeskView first")
    }
    let duration = dataSource.cardDeskViewARoundDuration(self)
    let timer = Timer.init(timeInterval: duration, target: self, selector: #selector(onTimerFires(sender:)), userInfo: nil, repeats: true)
    return timer
  }
  
  @objc func onTimerFires(sender: Timer) {
    if cardViews[0].moveForwardToNextPhoto() {
      invalidateTimer()
    }
  }
  
  public func invalidateTimer() {
    if let _ = timer {
      timer!.invalidate()
    }
    timer = nil
  }
}

extension CardDeskView: CardViewDelegate {
  func cardViewDidLikeCard(_ cardView: CardView, cardViewModel: CardViewModel) {
    delegate?.cardDeskViewDidLikeCard(self, cardViewModel: cardViewModel)
  }
  
  func cardViewDidDislikeCard(_ cardView: CardView, cardViewModel: CardViewModel) {
    delegate?.cardDeskViewDidDislikeCard(self, cardViewModel: cardViewModel)
  }
}
