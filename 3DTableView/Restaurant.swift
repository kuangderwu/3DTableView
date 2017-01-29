//
//  Restaurant.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/23.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import Foundation

enum StoreType {
    case brunch, coffee, desert, others
}

class Restaurant {
    
    var name = ""
    var location = ""
    var type = StoreType.others
    var phone = ""
    var image = ""
    var isVisited = false
    var rating = ""
    var website = ""

    init(name: String,type: StoreType, location: String, phone: String, image: String, isVisited: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.image = image
        self.isVisited = isVisited
    }
    
}



 var restaurants:[Restaurant] = [
 Restaurant(name: "Cafe Deadend", type: .coffee, location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", image: "Cafe Deadend.jpg", isVisited: false),
 Restaurant(name:"Homei", type: .coffee, location: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong", phone: "348-233423", image: "Homei.jpg", isVisited: false),
 Restaurant(name:"Teakha", type: .coffee, location: "Shop B, 18 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "354-243523", image: "Teakha.jpg", isVisited: false),
 Restaurant(name: "Cafe Loisl", type: .coffee, location: "Shop B, 20 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "453-333423", image: "Cafe Loisl.jpg", isVisited: false),
 Restaurant(name: "Petite Oyster", type: .others, location: "24 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "983-284334", image: "Petite Oyster.jpg", isVisited: false),
 Restaurant(name: "For Kee Restaurant", type: .brunch, location: "Shop J-K., 200 Hollywood Road, SOHO, Sheung Wan, Hong Kong", phone: "232-434222", image: "For Kee Restaurant.jpg", isVisited: false),
 Restaurant(name: "Po's Atelier", type: .desert, location: "G/F, 62 Po Hing Fong, Sheung Wan, Hong Kong", phone: "234-834322", image: "Po's Atelier.jpg", isVisited: false),
 Restaurant(name: "Bourke Street Backery", type: .brunch, location: "633 Bourke St Sydney New South Wales 2010 Surry Hills", phone: "982-434343", image: "Bourke Street Bakery.jpg", isVisited: false),
 Restaurant(name: "Haigh's Chocolate", type: .desert, location: "412-414 George St Sydney New South Wales", phone: "734-232323", image: "Haigh's Chocolate.jpg", isVisited: false),
 Restaurant(name: "Palomino Espresso", type: .coffee, location: "Shop 1 61 York St Sydney New South Wales", phone: "872-734343", image: "Palomino Espresso.jpg", isVisited: false),
 Restaurant(name: "Upstate", type: .others, location: "95 1st Ave New York, NY 10003", phone: "343-233221", image: "Upstate.jpg", isVisited: false),
 Restaurant(name: "Traif", type: .others, location: "229 S 4th St Brooklyn, NY 11211", phone: "985-723623", image: "Traif.jpg", isVisited: false),
 Restaurant(name: "Graham Avenue Meats And Deli", type: .brunch, location: "445 Graham Ave Brooklyn, NY 11211", phone: "455-232345", image: "Graham Avenue Meats And Deli.jpg", isVisited: false),
 Restaurant(name: "Waffle & Wolf", type: .brunch, location: "413 Graham Ave Brooklyn, NY 11211", phone: "434-232322", image: "Waffle & Wolf.jpg", isVisited: false),
 Restaurant(name: "Five Leaves", type: .desert, location: "18 Bedford Ave Brooklyn, NY 11222", phone: "343-234553", image: "Five Leaves.jpg", isVisited: false),
 Restaurant(name: "Cafe Lore", type: .coffee, location: "Sunset Park 4601 4th Ave Brooklyn, NY 11220", phone: "342-455433", image: "Cafe Lore.jpg", isVisited: false),
 Restaurant(name: "Confessional", type: .others, location: "308 E 6th St New York, NY 10003", phone: "643-332323", image: "Confessional.jpg", isVisited: false),
 Restaurant(name: "Barrafina", type: .others, location: "54 Frith Street London W1D 4SL United Kingdom", phone: "542-343434", image: "Barrafina.jpg", isVisited: false),
 Restaurant(name: "Donostia", type: .desert, location: "10 Seymour Place London W1H 7ND United Kingdom", phone: "722-232323", image: "Donostia.jpg", isVisited: false),
 Restaurant(name: "Royal Oak", type: .others, location: "2 Regency Street London SW1P 4BZ United Kingdom", phone: "343-988834", image: "Royal Oak.jpg", isVisited: false),
 Restaurant(name: "CASK Pub and Kitchen", type: .others, location: "22 Charlwood Street London SW1V 2DY Pimlico", phone: "432-344050", image: "CASK Pub and Kitchen.jpg", isVisited: false),
 ]

