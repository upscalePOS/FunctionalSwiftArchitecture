//
//  MasterViewController.swift
//  FunctionalSwiftArchitecture
//
//  Created by Pallas, Ricardo on 12/4/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import UIKit

class CategoryListVC: UITableViewController, JokeCategoriesListView{
    
    var detailViewController: JokeDetailVC? = nil
    var categories = [CategoryViewModel]()
    var context:GetCategoriesContext?


    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? JokeDetailVC
        }
        self.setUpDependencyGraph()
        
        //Execute presentation logic - run side effects
        onCategoriesViewLoaded(context: context!)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    func setUpDependencyGraph() {
        self.context = GetCategoriesContext(view: self)
    }
    
    func drawCategories(categories: [CategoryViewModel]) {
        self.categories = categories
        self.tableView.reloadData()
    }
    
    func showGenericError() {
        let alert = UIAlertController(title: "Error", message: "Error, please try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let category = categories[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! JokeDetailVC
                controller.categoryName = category.name
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel!.text = category.name
        return cell
    }
}

