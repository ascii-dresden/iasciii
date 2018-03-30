//
//  ApiClient.swift
//  asciii
//
//  Created by Hendrik Sollich on 30.03.18.
//  Copyright © 2018 Hendrik Sollich. All rights reserved.
//

import Foundation

class ApiClient {

    let baseUrl: URL


    init(url: URL) {
        self.baseUrl = url
    }

    func fetch(fromUrl url: URL, and cb: @escaping (String) -> Void) { // TODO: loopup @escaping closures
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let data = data {
                cb(String(data: data, encoding: String.Encoding.utf8) ?? "bad data") // shorthandable .utf8
            } else {
                if let error = err {
                    print("error during fetch", error)
                }
            }
            }.resume()
    }

    func fetch(and cb: @escaping (String)->Void) {
        self.fetch(fromUrl: self.baseUrl, and: cb)
    }

    func fetchEndPoint(query: String, and cb: @escaping (String) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.fetch(fromUrl: URL.init(string: encodedQuery, relativeTo: self.baseUrl)!, and: cb)
    }

    func getListOfYears(and cb: @escaping ([Int])-> Void) {
        self.fetchEndPoint(query: "projects/year") { body in

            let years = try? JSONDecoder().decode([Int].self, from: body.data(using: .utf8)!)
            cb(years ?? [])

        }
    }


    func getListOfProjects(from year: Int, and cb: @escaping ([String])-> Void) {
        self.fetchEndPoint(query: "projects/year/\(year)") { body in

            let years = try? JSONDecoder().decode([String].self, from: body.data(using: .utf8)!)
            cb(years ?? [])

        }
    }

    func getProject(name: String, and cb: @escaping (AsciiiProject) -> Void) {
        self.fetchEndPoint(query: "projects/\(name)") { body in
            let project = try? JSONDecoder().decode(AsciiiProject.self, from: body.data(using: .utf8)!)
            print(project)
            cb(project!)
        }
    }

}

struct AsciiiProject: Codable {

    struct Client: Codable {
        let title: String?
        let first_name: String?
        let last_name: String?
    }

    let client: Client

    struct Event: Codable {
        let name: String?
        let date: String?
        let manager: String?
    }

    let event: Event

    subscript(indexPath: IndexPath) -> (String, String) {
        switch (indexPath.section, indexPath.row ) {
            case (0, 0): return ("Event", self.event.name ?? "?")
            case (0, 1): return ("Date", self.event.date ?? "?")
            case (0, 2): return ("Manager", self.event.manager ?? "?")
            case (1, 0): return ("Client", "\(self.client.first_name ?? "") \(self.client.last_name ?? "")")

            case _ : return ("", "")
        }
    }

    func sectionTitle(index: Int) -> String {
        switch index {
            case 0: return "Event"
            case 1: return "Client"
            case _: return ""
        }
    }

    var count: Int {
        return 4
    }
}



















