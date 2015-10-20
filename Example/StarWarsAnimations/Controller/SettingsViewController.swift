//
//  SettingsViewController.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 9/11/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

private let tableViewOffset: CGFloat = UIScreen.mainScreen().bounds.height < 600 ? 215 : 225
private let beforeAppearOffset: CGFloat = 400

class SettingsViewController: UITableViewController {
    
    var themeChanged: ((darkside: Bool, center: CGPoint) -> Void)?

    @IBOutlet
    private var backgroundHolder: UIView!
    
    @IBOutlet
    private weak var backgroundImageView: UIImageView!

    @IBOutlet
    private weak var backgroundHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet
    private weak var backgroundWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet
    private weak var darkSideSwitch: UISwitch!
    
    @IBOutlet
    private weak var radioInactiveImageView: UIImageView!
    @IBOutlet
    private weak var radioActiveImageView: UIImageView!
    
    @IBOutlet
    private var cellTitleLabels: [UILabel]!
    @IBOutlet
    private var cellSubtitleLabels: [UILabel]!
    
    @IBOutlet
    private weak var usernameLabel: UILabel!
    
    @IBAction
    private func darkSideChanged(sender: AnyObject) {
        let center = self.tableView.convertPoint(darkSideSwitch.center, fromView: darkSideSwitch.superview)
        self.themeChanged?(darkside: darkSideSwitch.on, center: center)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsets(top: tableViewOffset, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -beforeAppearOffset)

        UIView.animateWithDuration(0.5, animations: {
            self.tableView.contentOffset = CGPoint(x: 0, y: -tableViewOffset)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theme = .light
        tableView.backgroundView = backgroundHolder
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = theme.backgroundColor
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        backgroundHeightConstraint.constant = max(navigationController!.navigationBar.bounds.height + scrollView.contentInset.top - scrollView.contentOffset.y, 0)
        backgroundWidthConstraint.constant = navigationController!.navigationBar.bounds.height - scrollView.contentInset.top - scrollView.contentOffset.y * 0.8
    }
}
