//
//  GameGridView.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 24/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Result

class GameGridView: UIView {
		
	@IBOutlet fileprivate weak var gridCollectionView: UICollectionView!
	let (selectedRowSignal, selectedRowObserver) = Signal<Int, NoError>.pipe()
	
	fileprivate var grid: Grid = Grid(rowCount: 1, columnCount: 1)
	private var animationCounter: ReactiveCounter?

	var gameGrid: MutableProperty<Randomised2DArray<UIColor>> = MutableProperty(Randomised2DArray(gridRow: []))
	
	class func gameGridView() -> GameGridView {
		return Bundle.main.loadNibNamed("GameGridView", owner: nil, options: nil)?.first! as! GameGridView
	}
	
	fileprivate var colors: [UIColor] = []
	var turnScheduler: TurnScheduler!

	func configure(colors: [UIColor]) {
		self.colors = colors
		let randomizedArray: Randomised2DArray<UIColor> = Randomised2DArray(gridRow: colors)
		gameGrid = MutableProperty(randomizedArray)
		
		grid = Grid(rowCount: colors.count, columnCount: colors.count)
		configureCollectionView()
		(0..<grid.rowCount).forEach { _ in
			gameGrid.value.addNewRow()
		}
		gridCollectionView.reloadData()
	}
	
	func configureCollectionView() {
		let nib = UINib(nibName: "GridCollectionViewCell", bundle: Bundle.main)
		gridCollectionView.register(nib, forCellWithReuseIdentifier: "GridCollectionViewCell")
		gridCollectionView.dataSource = self
		gridCollectionView.delegate = self
	}
	
	var offsetPoint: MutableProperty<CGPoint> = MutableProperty<CGPoint>(CGPoint.zero)
	
	func start() {
		animationCounter = ReactiveCounter(timeInterval: 0.05)
		offsetPoint <~ animationCounter!.counterSignal.map({count in
			let originY = CGFloat(count) * 5.0
			return CGPoint(x: 0, y: originY)
		})		
		offsetPoint.signal.observeValues { [weak self] point in
			self?.gridCollectionView.contentOffset = point
		}
	}
	
	func stop() {
		if let animationCounter = animationCounter {
			animationCounter.stopTimer()
			self.selectedRowObserver.sendCompleted()
		}
	}
}

extension GameGridView: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return gameGrid.value.totalCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as! GridCollectionViewCell
		cell.label.text = "\(indexPath.row)"
		let itemAtIndex = gameGrid.value.itemAtIndexPath(indexPath: indexPath)
		cell.backgroundColor = itemAtIndex
		return cell
	}
}

extension GameGridView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return grid.cellSize(for: collectionView.frame, interCellSpacing: 10.0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10.0
	}
}

extension GameGridView: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		if let color = cell?.backgroundColor, let colorIndex = self.colors.index(of: color) {
			self.selectedRowObserver.send(value: colorIndex + 1)
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let gridHeight = self.gridCollectionView.frame.height
		let contentSizeHeight = self.gridCollectionView.contentSize.height
		if contentSizeHeight < gridHeight + scrollView.contentOffset.y {
			gameGrid.value.addNewRow()
			self.gridCollectionView.reloadData()
		}
	}
}
