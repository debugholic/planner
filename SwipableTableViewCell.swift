//
//  SwipableTableViewCell.swift
//  planner
//
//  Created by debugHolic on 7/5/24.
//

import UIKit

public enum ButtonPosition {
    case leading
    case trailing
}

protocol SwipableTableViewCellScrollDelegate {
    func swipableTableViewCellScrollViewDidScroll(_ cell: SwipableTableViewCell, scrollView: UIScrollView)
}


protocol SwipableTableViewCellDelegate {
    func swipableTableViewCellDidSelectButton(_ cell: SwipableTableViewCell, sender: Any)
}

class ScrollView: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragging {
            self.superview?.touchesBegan(touches, with: event)
        } else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragging {
            self.superview?.touchesCancelled(touches, with: event)
        } else {
            super.touchesCancelled(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragging {
            self.superview?.touchesEnded(touches, with: event)
        } else {
            super.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDragging {
            self.superview?.touchesMoved(touches, with: event)
        } else {
            super.touchesMoved(touches, with: event)
        }
    }
}

open class SwipableTableViewCell: UITableViewCell {
    var scrollContentViewTrailing: NSLayoutConstraint!
    var scrollContentViewLeading: NSLayoutConstraint!

    var delegate: SwipableTableViewCellDelegate?
    var scrollDelegate: SwipableTableViewCellScrollDelegate?

    var scrollView: ScrollView!
    
    private var trailingButtons = [UIButton]()
    private var leadingButtons = [UIButton]()
    
    var buttonTrailing: NSLayoutConstraint?
    var buttonLeading: NSLayoutConstraint?

    var buttonWidth: CGFloat = 48
    var openSide: OpenSide?
    
    enum OpenSide {
        case leading
        case trailing
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        scrollView = ScrollView()
        addSubview(scrollView)
        contentView.removeFromSuperview()
        
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollContentViewLeading = contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        scrollContentViewTrailing = scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentViewLeading, scrollContentViewTrailing
        ])
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        DispatchQueue.main.async {
            self.scrollView.contentOffset.x = self.scrollContentViewLeading.constant
            self.openSide = nil
        }
    }
   
    open func add(button: UIButton, to: ButtonPosition) {
        scrollView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        switch to {
        case .leading:
            if let first = leadingButtons.first {
                first.leadingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
                button.widthAnchor.constraint(equalTo: first.widthAnchor).isActive = true

            } else {
                let constraint = button.trailingAnchor.constraint(equalTo: contentView.leadingAnchor)
                constraint.priority = UILayoutPriority(rawValue: 751)
                constraint.isActive = true
            }
            
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: buttonWidth).isActive = true
            button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            
            buttonLeading?.isActive = false
            buttonLeading = scrollView.superview?.leadingAnchor.constraint(equalTo: button.leadingAnchor)
            buttonLeading?.priority = UILayoutPriority(rawValue: 500)
            buttonLeading?.isActive = true
            
            leadingButtons.append(button)
            scrollContentViewLeading.constant = CGFloat(leadingButtons.count) * buttonWidth
            break

        case .trailing:
            if let last = trailingButtons.last {
                last.trailingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
                button.widthAnchor.constraint(equalTo: last.widthAnchor).isActive = true

            } else {
                let constraint = button.leadingAnchor.constraint(equalTo: contentView.trailingAnchor)
                constraint.priority = UILayoutPriority(rawValue: 751)
                constraint.isActive = true
            }
            
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: buttonWidth).isActive = true
            button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            
            buttonTrailing?.isActive = false
            buttonTrailing = scrollView.superview?.trailingAnchor.constraint(equalTo: button.trailingAnchor)
            buttonTrailing?.priority = UILayoutPriority(rawValue: 500)
            buttonTrailing?.isActive = true
                                    
            trailingButtons.append(button)
            scrollContentViewTrailing.constant = CGFloat(trailingButtons.count) * buttonWidth
            break
        }
    }
    
    func reset(animated: Bool = false) {
        scrollContentViewTrailing?.constant = CGFloat(trailingButtons.count) * buttonWidth
        scrollContentViewLeading?.constant = CGFloat(leadingButtons.count) * buttonWidth
        
        scrollView.isScrollEnabled = false
        scrollView.layoutIfNeeded()
        scrollView.setContentOffset(CGPoint(x: scrollContentViewLeading?.constant ?? 0, y: 0), animated: animated)
        scrollView.isScrollEnabled = true
    }
}

extension SwipableTableViewCell: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let trailing: CGFloat = scrollContentViewTrailing.constant
        let leading: CGFloat = scrollContentViewLeading.constant
                        
        if targetContentOffset.pointee.x > leading {
            if velocity.x > 0 {
                targetContentOffset.pointee = CGPoint(x: trailing + leading, y: 0)

            } else if velocity.x < 0 {
                targetContentOffset.pointee = CGPoint(x: leading, y: 0)
                
            } else if targetContentOffset.pointee.x > ((trailing + leading) / 2) {
                if scrollView.contentOffset.x > targetContentOffset.pointee.x {
                    targetContentOffset.pointee = CGPoint(x: leading, y: 0)

                } else {
                    targetContentOffset.pointee = CGPoint(x: trailing + leading, y: 0)
                }
                
            } else {
                targetContentOffset.pointee = CGPoint(x: leading, y: 0)
            }
            
        } else {
            if velocity.x > 0 {
                targetContentOffset.pointee = CGPoint(x: leading, y: 0)

            } else if velocity.x < 0 {
                targetContentOffset.pointee = CGPoint(x: 0, y: 0)

            } else if targetContentOffset.pointee.x > (leading / 2) {
                if scrollView.contentOffset.x > targetContentOffset.pointee.x {
                    targetContentOffset.pointee = CGPoint(x: 0, y: 0)

                } else {
                    targetContentOffset.pointee = CGPoint(x: leading, y: 0)
                }
                
            } else {
                targetContentOffset.pointee = CGPoint(x: 0, y: 0)
            }
        }
        
        if targetContentOffset.pointee.x == leading {
            openSide = nil
        }
        
        if openSide == .leading && targetContentOffset.pointee.x > leading {
            targetContentOffset.pointee = CGPoint(x: leading, y: 0)
            openSide = nil
            
        } else if openSide == .trailing && targetContentOffset.pointee.x < leading {
            targetContentOffset.pointee = CGPoint(x: leading, y: 0)
            openSide = nil
        }
        scrollDelegate?.swipableTableViewCellScrollViewDidScroll(self, scrollView: scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= CGFloat(leadingButtons.count) * buttonWidth {
            if scrollContentViewLeading.constant == 0 {
                DispatchQueue.main.async {
                    self.scrollContentViewLeading.constant = CGFloat(self.leadingButtons.count) * self.buttonWidth
                    self.scrollView.contentOffset.x = CGFloat(self.leadingButtons.count) * self.buttonWidth
                    self.leadingButtons.forEach({ $0.isHidden = false })
                    self.scrollView.layoutIfNeeded()
                }
            }
        }
        
        if scrollView.contentOffset.x > 0 {
            DispatchQueue.main.async {
                self.scrollContentViewTrailing.constant = CGFloat(self.trailingButtons.count) * self.buttonWidth
                self.trailingButtons.forEach({ $0.isHidden = false })
                self.scrollView.layoutIfNeeded()
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollContentViewLeading.constant {
            openSide = nil
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollContentViewLeading.constant {
            openSide = nil
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let leading = scrollContentViewLeading.constant

        if openSide == .trailing && scrollView.contentOffset.x < leading {
            scrollView.contentOffset.x = leading
            
        } else if openSide == .leading && scrollView.contentOffset.x > leading {
            scrollView.contentOffset.x = leading
        }
                
        if openSide == nil && scrollView.contentOffset.x < leading {
            openSide = .leading
            
        } else if openSide == nil && scrollView.contentOffset.x > leading {
            openSide = .trailing
        }
        
        var r: CGFloat
        if leading > 0 && scrollView.contentOffset.x < leading {
            r = 1 - (scrollView.contentOffset.x / leading)
            
        } else if scrollView.contentOffset.x > leading {
            r = (scrollView.contentOffset.x / leading) - 1
            
        } else {
            r = 0
        }
        
        if r > 1 {
            r = 1
            
        } else if r < 0 {
            r = 0
        }
        
        backgroundColor = tintColor.withAlphaComponent(r * 0.12)
    }
}
