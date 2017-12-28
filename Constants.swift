//
//  Constants.swift
//  Enova
//
//  Created by APPLE MAC MINI on 21/12/17.
//  Copyright © 2017 APPLE MAC MINI. All rights reserved.
//

import Foundation
import UIKit

var MenuClicked:Bool = false
var MealClicked:Bool = false
var DiabetesClicked:Bool = false
var isLogin:Bool = false

var User

//API

var baseURL = "https://enovawellness.com/api"
var userImgPath = "https://enovawellness.com/upload/user/"
var foodImgPath = "https://enovawellness.com/upload/food/"

var LoginAPI = "\(baseURL)/login"
var UpdateProfileAPI = "\(baseURL)/update-profile"
var ForgetPasswordAPI = "\(baseURL)/forgot-password"
var AddWeightAPI = "\(baseURL)/add-weight"
var GetWeightAPI = "\(baseURL)/get-weight"
var AddGlucoseAPI = "\(baseURL)/add-glucose"
var GetGlucoseAPI = "\(baseURL)/get-glucose"
var AddKetonesAPI = "\(baseURL)/add-ketones"
var GetKetonesAPI = "\(baseURL)/get-ketones"
var AddFoodLogAPI = "\(baseURL)/add-food-log"
var RemoveFoodLogAPI = "\(baseURL)/remove-food-log"
var GetFoodLogAPI = "\(baseURL)/get-food-log"
var GetMeasurementsAPI = "\(baseURL)/get-measurement"
var AddWaistAPI = "\(baseURL)/add/waist"
var AddHipsAPI = "\(baseURL)/add/hips"
var AddWristAPI = "\(baseURL)/add/wrist"
var AddForearmAPI = "\(baseURL)/add/forearm"




