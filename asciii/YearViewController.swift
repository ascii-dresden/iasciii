//
//  YearViewController.swift
//  asciii
//
//  Created by Hendrik Sollich on 30.03.18.
//  Copyright © 2018 Hendrik Sollich. All rights reserved.
//

import UIKit

class YearViewController: UITableViewController {

    var years: [Int] = []

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows")

        return years.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for row")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!// ?? UITableViewCell()
        //        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = String(self.years[indexPath.row])
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.tableView.dataSource = self
        self.tableView.delegate = self

        let fetcher = ApiClient(url: URL(string: "http://localhost:8000/api/")!);
        fetcher.getListOfYears(){ (s) in
            print("I just fetched and parsed \(s)")
            self.years = s
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "OpenProjectsList", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedRow = self.tableView.indexPathForSelectedRow!.row
        let selectedYear = self.years[selectedRow]
        if let ptvc = segue.destination as? ProjectListTableViewController {
            ptvc.year = selectedYear
            print("segue into \(selectedYear)")
        } else {
            print("can't find segue destination")
        }
    }


}

