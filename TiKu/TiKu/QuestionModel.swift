//
//  QuestionModel.swift
//  TiKu
//
//  Created by tiny on 2018/1/19.
//  Copyright © 2018年 tiny. All rights reserved.
//

import UIKit

class QuestionModel: NSObject {
    var No:String!
    var Question:String!
    var RightAnswer:String!
    var AnswerA:String!
    var AnswerB:String!
    var AnswerC:String!
    var AnswerD:String!
    var AnswerDetail:String!
    
 init(No:String,Question:String,RightAnswer:String,AnswerA:String,AnswerB:String,AnswerC:String,AnswerD:String,AnswerDetail:String) {
        self.No = No
        self.Question = Question
        self.RightAnswer = RightAnswer
        self.AnswerA = AnswerA
        self.AnswerB = AnswerB
        self.AnswerC = AnswerC
        self.AnswerD = AnswerD
        self.AnswerDetail = AnswerDetail
    }
    
    init(dict : [String : AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    class func queryDataFromDB() -> [QuestionModel]? {
        let sql = "select * from 'DicContent'"
        let allData = SQLiteManager.shareInstance().queryDBData(querySQL: sql)

        if let tempDicM = allData {
            var model = [QuestionModel]()
            for dict in tempDicM {
                model.append(QuestionModel(dict: dict))
            }
            return model
        }
        return nil
    }
    
    class func toDictionory(model:QuestionModel) -> NSDictionary {
        let mdicProperties = NSMutableDictionary()
        
        mdicProperties.setObject(model.Question, forKey: "Question" as NSCopying)
        
        if("NOE" != model.AnswerA) {
            mdicProperties.setObject(model.AnswerA, forKey: "AnswerA" as NSCopying)
        }else if("NOE" != model.AnswerB) {
            mdicProperties.setObject(model.AnswerB, forKey: "AnswerA" as NSCopying)
        }else if("NOE" != model.AnswerC){
            mdicProperties.setObject(model.AnswerC, forKey: "AnswerA" as NSCopying)
        }else if("NOE" != model.AnswerD){
            mdicProperties.setObject(model.AnswerD, forKey: "AnswerA" as NSCopying)
        }
        
        return mdicProperties
    }
    
    class func toAskArray(model:QuestionModel) -> NSArray {
        let marray = NSMutableArray()
        
//        marray.add("题目: " + model.Question)
        
        if("NOE" != model.AnswerA) {
            marray.add("A: " + model.AnswerA)
        }
        if("NOE" != model.AnswerB) {
            marray.add("B: " + model.AnswerB)
        }
        if("NOE" != model.AnswerC){
            marray.add("C: " + model.AnswerC)
        }
        if("NOE" != model.AnswerD){
            marray.add("D: " + model.AnswerD)
        }
        
        return marray
    }
    
    class func toAnswerArray(model:QuestionModel) -> NSArray {
        let marray = NSMutableArray()
        
        var RightAnswer = ""
        switch model.RightAnswer {
        case "1":
            RightAnswer = "A"
            break
        case "2":
            RightAnswer = "B"
            break
        case "3":
            RightAnswer = "C"
            break
        case "4":
            RightAnswer = "D"
            break
        default:
            RightAnswer = ""
        }
        marray.add("正确答案: "+RightAnswer)
        
        marray.add("解析: " + model.AnswerDetail)
        
        return marray
    }
}
