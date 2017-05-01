//
//  Grid.swift
//  Functional-Reactive-Example
//
//  Created by Susmita Horrow on 28/04/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

typealias GridRow = [Int]

struct Grid {
	private(set) var rowCount: Int
	let columnCount: Int
	
	init(rowCount: Int, columnCount: Int) {
		self.rowCount = rowCount
		self.columnCount = columnCount
	}
	
	var cellCount: Int {
		return rowCount * columnCount
	}
	
	func cellSize(for frame: CGRect, interCellSpacing: CGFloat) -> CGSize {
		let width = (frame.width - interCellSpacing * CGFloat(rowCount - 1)) / CGFloat(rowCount)
		return CGSize(width: width, height: width)
	}
}

struct GameGrid {
	private(set) var gridRows: [GridRow] = []
	
	init(gridRow: GridRow) {
		gridRows.append(gridRow)
	}
	
	mutating func addNewRow() {
		if let lastArray = gridRows.last {
			gridRows.append(lastArray.shuffled())
		}
	}
	
	var rowCount: Int {
		return gridRows.count
	}
	
	var columnCount: Int {
		guard let lastRow = gridRows.last else {
			return 0
		}
		return lastRow.count
	}
	
	var totalCount: Int {
		return gridRows.count * columnCount
	}
	
	func itemAtIndexPath(indexPath: IndexPath) -> Int {
		let rowIndex = indexPath.item / columnCount
		let columnIndex = indexPath.item % columnCount
		return gridRows[rowIndex][columnIndex]
	}
}

struct Randomised2DArray<T> {
	private(set) var gridRows: [[T]] = []
	
	init(gridRow: [T]) {
		gridRows.append(gridRow)
	}
	
	mutating func addNewRow() {
		if let lastArray = gridRows.last {
			gridRows.append(lastArray.shuffled())
		}
	}
	
	var rowCount: Int {
		return gridRows.count
	}
	
	var columnCount: Int {
		guard let lastRow = gridRows.last else {
			return 0
		}
		return lastRow.count
	}
	
	var totalCount: Int {
		return gridRows.count * columnCount
	}
	
	func itemAtIndexPath(indexPath: IndexPath) -> T {
		let rowIndex = indexPath.item / columnCount
		let columnIndex = indexPath.item % columnCount
		return gridRows[rowIndex][columnIndex]
	}
}

extension MutableCollection where Index == Int {
	/// Shuffle the elements of `self` in-place.
	mutating func shuffle() {
		// empty and single-element collections don't shuffle
		if count < 2 { return }
		
		for i in startIndex ..< endIndex - 1 {
			let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
			if i != j {
				swap(&self[i], &self[j])
			}
		}
	}
}

extension Sequence {
	/// Returns an array with the contents of this sequence, shuffled.
	func shuffled() -> [Iterator.Element] {
		var result = Array(self)
		result.shuffle()
		return result
	}
}
