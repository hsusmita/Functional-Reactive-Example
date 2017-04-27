//
//  GameGrid.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 24/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Result

struct Grid {
	var row: Int
	var column: Int
	var cellCount: Int {
		return row * column
	}
	func cellSize(for frame: CGRect, interCellSpacing: CGFloat) -> CGSize {
		let width = (frame.width - interCellSpacing * CGFloat(column - 1)) / CGFloat(column)
		return CGSize(width: width, height: width)
	}
	
//	func totalSize(for frame: CGRect) -> CGSize {
//		return CGSize
//	}
}

class GameGrid: UIView {

	@IBOutlet fileprivate weak var gridCollectionView: UICollectionView!
	let (selectedRowSignal, selectedRowObserver) = Signal<Int, NoError>.pipe()
	
	fileprivate var grid: Grid = Grid(row: 1, column: 1)
	
	class func gameGridView() -> GameGrid {
		return Bundle.main.loadNibNamed("GameGrid", owner: nil, options: nil)?.first! as! GameGrid
	}
	var colors: [UIColor] = [.red, .blue, .green, .yellow, .gray]
	var colorsName = ["Red", "Blue", "Green", "Yellow", "Gray"]
	
	private var counter: ReactiveCounter!
	private var animationCounter: ReactiveCounter!
	var currentRowCount = 0
	
	func configure(with grid: Grid) {
		self.grid = grid
		let nib = UINib(nibName: "GridCollectionViewCell", bundle: Bundle.main)
		gridCollectionView.register(nib, forCellWithReuseIdentifier: "GridCollectionViewCell")
		gridCollectionView.dataSource = self
		gridCollectionView.delegate = self
		gridCollectionView.reloadData()
		currentRowCount = grid.row
	}
	
	var offsetPoint: MutableProperty<CGPoint> = MutableProperty<CGPoint>(CGPoint.zero)
	
	func start() {
		counter = ReactiveCounter(timeInterval: 2.0)
		animationCounter = ReactiveCounter(timeInterval: 0.05)
		
		let observer: Observer<Int, NoError> = Observer(value: { value in
			
		})
		
 		counter.counterSignal.observe(observer)
		offsetPoint <~ animationCounter.counterSignal.map({ [unowned self] count in
			let totalIteration = Int(self.gridCollectionView.contentSize.height / 5.0)
			let originY = CGFloat(count) * 5.0
			return CGPoint(x: 0, y: originY)
		})
		
		offsetPoint.signal.observeValues() { [weak self] point in
			self?.gridCollectionView.contentOffset = point
		}
		
		/*animationCounter.counterSignal.observeValues { value in
			let offsetPoint = CGPoint(x: 0, y : self.getNextYPosition(currentYPosition: 0.0))
			if offsetPoint.equalTo(self.gridCollectionView.contentOffset) {
				let offsetPoint = CGPoint(x: 0,y : self.originY)
				self.gridCollectionView.contentOffset = offsetPoint
			}
		}*/
	}
	
	func stop() {
		animationCounter.stopTimer()
		counter.stopTimer()
	}
	
/*	func configAutoscrollTimer() {
		timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(autoScrollView), userInfo: nil, repeats: true)
	}
	
	func deconfigAutoscrollTimer() {
		timer?.invalidate()
	}
	
	func onTimer() {
		autoScrollView()
	}
	
	func autoScrollView() {
		let initailPoint = CGPoint(x: 0.0, y: self.originY)
		
		if initailPoint.equalTo(self.gridCollectionView.contentOffset) {
			if self.originY < self.gridCollectionView.contentSize.height {
				self.originY += 3.0
			}
			else {
				self.originY = -self.frame.size.height
			}
			
			let offsetPoint = CGPoint(x: 0,y : self.originY)
			self.gridCollectionView.contentOffset = offsetPoint
		}
		else {
			self.originY = self.gridCollectionView.contentOffset.y
		}
	}
	
	func getNextYPosition(currentYPosition: CGFloat) -> CGFloat {
		var nextYPosition = currentYPosition
		if currentYPosition < self.gridCollectionView.contentSize.height {
			nextYPosition += 3.0
		}
		else {
			nextYPosition = -self.frame.size.height
		}

	}
	func scrollView(to point: CGPoint) {
		if point.equalTo(self.gridCollectionView.contentOffset) {
			let offsetPoint = CGPoint(x: 0,y : self.originY)
			self.gridCollectionView.contentOffset = offsetPoint
		}
		else {
			self.originY = self.gridCollectionView.contentOffset.y
		}

	}*/
}

extension GameGrid: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return grid.column * currentRowCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as! GridCollectionViewCell
		cell.label.text = "\(indexPath.row)"
		cell.backgroundColor = colors[indexPath.item % grid.row]
		return cell
	}
}

extension GameGrid: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return grid.cellSize(for: collectionView.frame, interCellSpacing: 10.0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 10.0
	}
}

extension GameGrid: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		if let color = cell?.backgroundColor, let colorIndex = self.colors.index(of: color) {
			self.selectedRowObserver.send(value: colorIndex + 1)
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let gridHeight = self.gridCollectionView.frame.height
		let contentSizeHeight = self.gridCollectionView.contentSize.height
		
		//add rows when collectionviews reaches to end
		if contentSizeHeight == gridHeight + scrollView.contentOffset.y {
			self.currentRowCount += 5
			self.gridCollectionView.reloadData()
		}
	}
}
