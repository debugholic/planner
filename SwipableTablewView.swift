//
//  SwipableTablewView.swift
//  planner
//
//  Created by debugholic on 7/5/24.
//

import Foundation

import UIKit


open class SwipableTableView: UITableView {
    private var scrolledCell: SwipableTableViewCell?
    
    open override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        if let cell = super.dequeueReusableCell(withIdentifier: identifier) as? SwipableTableViewCell {
            cell.reset()
            cell.scrollView.delegate = cell
            cell.scrollDelegate = self
            cell.scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.1)
            return cell
            
        } else {
            return super.dequeueReusableCell(withIdentifier: identifier)
        }
    }
}

extension SwipableTableView: SwipableTableViewCellScrollDelegate {
    func swipableTableViewCellScrollViewDidScroll(_ cell: SwipableTableViewCell, scrollView: UIScrollView) {
        if scrolledCell !== cell {
            if scrolledCell != nil {
                scrolledCell?.reset(animated: true)
            }
            scrolledCell = cell
        }
    }
}
