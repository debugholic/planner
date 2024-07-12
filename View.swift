//
//  View.swift
//  planner
//
//  Created by 김영훈 on 7/8/24.
//

import UIKit

class View: UIView {
    var scrollContentViewTrailing: NSLayoutConstraint!
    var scrollContentViewLeading: NSLayoutConstraint!

    var delegate: SwipableTableViewCellDelegate?
    var scrollDelegate: SwipableTableViewCellScrollDelegate?

    var scrollView: ScrollView!
    lazy var scrollContentView: UIView = {
        let view = UIView()
        self.scrollView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollContentViewTrailing = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        scrollContentViewLeading = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentViewLeading,
            scrollContentViewTrailing
        ])
        return view
    }()
    
    var contentView: UIView!
    
    private var trailingButtons = [UIButton]()
    private var leadingButtons = [UIButton]()
    
    var buttonTrailing: NSLayoutConstraint?
    var buttonLeading: NSLayoutConstraint?

    var buttonWidth: CGFloat = 48
    var isScrolled: Bool = false
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        scrollView = ScrollView()
        addSubview(scrollView)
        scrollView.delegate = self

        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .green
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .lightGray
        
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

extension View: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let trailing: CGFloat = scrollContentViewTrailing.constant
        let leading: CGFloat = scrollContentViewLeading.constant
                
        if targetContentOffset.pointee.x > leading {
            if velocity.x > 0 {
                targetContentOffset.pointee = CGPoint(x: leading + trailing, y: 0)

            } else if velocity.x < 0 {
                print("2")
                targetContentOffset.pointee = CGPoint(x: leading, y: 0)

            } else if targetContentOffset.pointee.x > (leading + (trailing / 2)) {
                print("3", leading, trailing)
                targetContentOffset.pointee = CGPoint(x: leading + trailing, y: 0)

            } else {
                print("4")
                targetContentOffset.pointee = CGPoint(x: leading, y: 0)
            }

        } else {
            if velocity.x > 0 {
                print("5")
                targetContentOffset.pointee = CGPoint(x: leading, y: 0)

            } else if velocity.x < 0 {
                print("6")
                targetContentOffset.pointee = CGPoint(x: 0, y: 0)

            } else if targetContentOffset.pointee.x > ((leading) / 2) {
                print("7")
                targetContentOffset.pointee = CGPoint(x: leading, y: 0)

            } else {
                print("8")
                targetContentOffset.pointee = CGPoint(x: 0, y: 0)
            }
        }
//        scrollDelegate?.swipableTableViewCellScrollViewDidScroll(self, scrollView: scrollView)
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollContentViewLeading.constant {
            isScrolled = false

        } else if scrollContentViewLeading.constant != 0 && scrollView.contentOffset.x <= scrollContentViewLeading.constant / 2 {
            isScrolled = true

        } else if scrollContentViewTrailing.constant != 0 && scrollView.contentOffset.x >= scrollContentViewTrailing.constant / 2 {
            isScrolled = true
        }
        
        var r: CGFloat
        if scrollContentViewLeading.constant > 0 && scrollView.contentOffset.x < scrollContentViewLeading.constant {
            r = 1 - (scrollView.contentOffset.x / scrollContentViewLeading.constant)
            
        } else if scrollView.contentOffset.x > scrollContentViewLeading.constant {
            r = (scrollView.contentOffset.x - scrollContentViewLeading.constant) / scrollContentViewTrailing.constant

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
