//
//  Requests.swift
//  Walking
//
//  Created by Pavel Manulik on 20.05.21.
//

import Foundation

request("127.0.0.1").responseJSON { responseJSON in

    switch responseJSON.result {
    case .success(let value):
         guard let users = User.getArray(from: value) else { return }
         print(users)

    case .failure(let error):
        print(error)
    }
}

struct User {

    var id: Int
    var title: String
    var body: String
    var userId: String

    init?(json: [String: Any]) {

        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let body = json["body"] as? String,
            let userId = json["userId"] as? String
        else {
            return nil
        }

        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }

    static func getArray(from jsonArray: Any) -> [User]? {

        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        var users: [User] = []

        for jsonObject in jsonArray {
            if let user = User(json: jsonObject) {
                users.append(user)
            }
        }
        return users
    }
}

struct Points {

    var id: Int
    var title: String
    var body: String
    var latitude: String
    var longtitude: String

    init?(json: [String: Any]) {

        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let body = json["body"] as? String,
            let latitude = json["latitude"] as? String
            let longtitude = json["longtitude"] as? String
        else {
            return nil
        }

        self.id = id
        self.title = title
        self.body = body
        self.latitude = latitude
        self.longtitude = longtitude
    }

    static func getArray(from jsonArray: Any) -> [Points]? {

        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        var points: [Points] = []

        for jsonObject in jsonArray {
            if let point = Points(json: jsonObject) {
                points.append(point)
            }
        }
        return points
    }
}

