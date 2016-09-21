//
//  SettingsViewController.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

private let TableViewOffset: CGFloat = UIScreen.main.bounds.height < 600 ? 215 : 225
private let BeforeAppearOffset: CGFloat = 400

class SettingsViewController: UITableViewController {
    
    var themeChanged: ((_ darkside: Bool, _ center: CGPoint) -> Void)?

    @IBOutlet fileprivate var backgroundHolder: UIView!
    
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!

    @IBOutlet fileprivate weak var backgroundHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var backgroundWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var darkSideSwitch: UISwitch!
    
    @IBOutlet fileprivate weak var radioInactiveImageView: UIImageView!
    @IBOutlet fileprivate weak var radioActiveImageView: UIImageView!
    
    @IBOutlet fileprivate var cellTitleLabels: [UILabel]!
    @IBOutlet fileprivate var cellSubtitleLabels: [UILabel]!
    
    @IBOutlet fileprivate weak var usernameLabel: UILabel!
    
    @IBAction fileprivate func darkSideChanged(_ sender: AnyObject) {
        let center = self.tableView.convert(darkSideSwitch.center, from: darkSideSwitch.superview)
        self.themeChanged?(darkSideSwitch.isOn, center)
    }
    
    var theme: SettingsTheme! {
        didSet {
            backgroundImageView.image = theme.topImage
            tableView.separatorColor = theme.separatorColor
            backgroundHolder.backgroundColor = theme.backgroundColor
            for label in cellTitleLabels { label.textColor = theme.cellTitleColor }
            for label in cellSubtitleLabels { label.textColor = theme.cellSubtitleColor }
            radioInactiveImageView.image = theme.radioInactiveImage
            radioActiveImageView.image = theme.radioActiveImage
            usernameLabel.text = theme.username
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsets(top: TableViewOffset, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -BeforeAppearOffset)

        UIView.animate(withDuration: 0.5) {
            self.tableView.contentOffset = CGPoint(x: 0, y: -TableViewOffset)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theme = .light
        tableView.backgroundView = backgroundHolder
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = theme.backgroundColor
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        backgroundHeightConstraint.constant = max(navigationController!.navigationBar.bounds.height + scrollView.contentInset.top - scrollView.contentOffset.y, 0)
        backgroundWidthConstraint.constant = navigationController!.navigationBar.bounds.height - scrollView.contentInset.top - scrollView.contentOffset.y * 0.8
    }
}
