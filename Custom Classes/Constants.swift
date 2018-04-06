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


var udefault = UserDefaults.standard




//API

var baseURL = "https://enovawellness.com/api/api/"
var userImgPath = "https://enovawellness.com/api/upload/user/"
var foodImgPath = "https://enovawellness.com/api/upload/food/"
var chatImgPath = "http://enovawellness.com/api/upload/message/"
var notificationImgPath = "http://enovawellness.com/api/upload/notification/"

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
var GetMealTypeAPI = "\(baseURL)/get-food-category"
var GetDiabetesTypeAPI = "\(baseURL)/get-diabetes-type"
var GetMessagesAPI = "\(baseURL)/message/get"
var SendMessagesAPI = "\(baseURL)/message/add"
var GetNotificationAPI = "\(baseURL)/notification/get"
var AddFastAPI = "\(baseURL)/fasting/add"
var GetFastAPI = "\(baseURL)/fasting/get"
var CancelFastAPI = "\(baseURL)/fasting/cancel"
var UpdateFastAPI = "\(baseURL)/fasting/update"


// values for userdefaults...

var UserId = "user_id"
var isLogin = "isLogin"
var EmailAddress = "email"
var Password = "password"
var UserData = "userdata"
var FoodLogSelectedId = "foodlogselectedid"
var FoodLogSelectedNote = "foodlogselectednote"
var FoodLogSelectedImage = "foodlogselectedimage"
var FoodLogSelectedCategory = "foodlogselectedcategory"
var FoodLogSelectedTime = "foodlogselectedtime"
var FoodLogSelectedTimeStamp = "foodlogselectedtimestamp"
var FoodLogSelectedDeletedAt = "foodlogselecteddeletedat"
var GlucoseConditionValue = "glucoseConditionValue"
var KetonesConditionValue = "ketonesConditionValue"
var WeightConditionValue = "weightConditionValue"
var FoodImageDefault = "foodimage"
var DeviceToken = "devicetoken"

