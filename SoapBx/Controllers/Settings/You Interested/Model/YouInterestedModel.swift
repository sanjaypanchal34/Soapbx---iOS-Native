//
//  YouInterestedModel.swift
//  Operators Techno Lab, Ahmedabad
//
//  Developed by Harsh Kadiya
//  Created by OTL-HK on 28/07/2019.
//  Copyright © 2023 OTL-HK. All rights reserved.
//

import Foundation

struct TrendsModel: Codable {
    let active: Int?
    let sub_category_id: Int?
    let updated_at: String?
    let category_id: Int?
    let created_at: String?
    let id: Int?
    let image: String?
    let image_url: String?
    let name: String?
    let sub_category: TrendsCategoryModel?
    let category: TrendsCategoryModel?
    var isSelected: Bool = false
    
    init(name: String) {
        active = 0
        sub_category_id = 0
        updated_at = ""
        category_id = 0
        created_at = ""
        id = 0
        image = ""
        image_url = ""
        self.name = name
        sub_category = nil
        category = nil
    }
    
    
    enum CodingKeys: String, CodingKey {
        case active, sub_category_id, updated_at, category_id, created_at, id, image, image_url, name, sub_category, category
    }
    
}

struct TrendsCategoryModel: Codable {
    let active: Int?
    let category_id: Int?
    let created_at: String?
    let id: Int?
    let image: String?
    let image_url: String?
    let name: String?
    let updated_at: String?
    
    enum CodingKeys: String, CodingKey {
        case active, category_id, created_at, id, image, image_url, name, updated_at
    }
    
}

//{
//    active = 1;
//    sub_category_id" = 1;
//    updated_at" = "2023-07-25T06:47:29.000000Z";
//    category_id" = 1;
//    created_at" = "2023-07-25T06:47:29.000000Z";
//    id = 1;
//    image = "";
//    image_url" = "http://164.90.178.223:9179/assets/img/user-icon.png";
//    name = t1;
//    sub_category" =     {
//        active = 1;
//        category_id" = 1;
//        created_at" = "2023-07-25T06:47:29.000000Z";
//        id = 1;
//        image = "<null>";
//        image_url" = "http://164.90.178.223:9179/assets/img/user-icon.png";
//        name = "sub-cat1";
//        updated_at" = "2023-07-25T06:47:29.000000Z";
//    };
//    category =     {
//        active = 1;
//        "created_at" = "2023-07-25T06:47:28.000000Z";
//        id = 1;
//        image = "<null>";
//        "image_url" = "http://164.90.178.223:9179/assets/img/user-icon.png";
//        name = cat1;
//        "updated_at" = "2023-07-25T06:47:28.000000Z";
//    };
//}
