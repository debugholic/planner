//
//  ViewController.swift
//  planner
//
//  Created by 김영훈 on 2024/04/04.
//

import UIKit

class PlannerCell: SwipableTableViewCell {
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        tintColor = .purple

        let button1 = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        button1.backgroundColor = .red
        button1.setImage(UIImage(systemName: "trash"), for: .normal)
        button1.tintColor = .white
        add(button: button1, to: .trailing)
        
        let button2 = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        button2.backgroundColor = .yellow
        button2.setImage(UIImage(systemName: "star"), for: .normal)
        button2.tintColor = .black
        add(button: button2, to: .leading)        
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: SwipableTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlannerCell
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
