//
//  LevelsViewController.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/6/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import UIKit

class LevelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    
    //MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tag the cells of the table view
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //we create our table
        self.tableView = UITableView()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        //requires that our class conforms to UITableViewDataSource
        self.tableView.dataSource = self
        //requires that our class conforms to UITableViewDelegate
        self.tableView.delegate = self
        self.view.addSubview(tableView)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .AlignAllCenterX, metrics: nil, views: ["tableView": self.tableView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[guide][tableView]|", options: .AlignAllCenterX, metrics: nil, views: ["guide": topLayoutGuide, "tableView": self.tableView]))
    }

    
    
    //MARK: UITableViewDelegate and UITableViewDataSource methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.attributedText = self.makeAttributedString(title: "yuhou", subtitle: "")
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let gameViewController = GameViewController()
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    //MARK: Helper methods
    
    /**
    Create attributed strings for our table more easily
     If no subtitle input is epty, does not display a subtitle
    */
    func makeAttributedString(title title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), NSForegroundColorAttributeName: UIColor.purpleColor()]
        let subtitleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        
        if subtitle.characters.count > 0 {
            let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)
            titleString.appendAttributedString(subtitleString)
        }
        
        return titleString
    }
}
