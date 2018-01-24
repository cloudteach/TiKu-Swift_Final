//
//  MainViewController.swift
//  TiKu
//
//  Created by tiny on 2018/1/18.
//  Copyright © 2018年 tiny. All rights reserved.
//

import UIKit

protocol MainViewDelegate {
    func didSelectedAnswer(row:NSInteger)
}

class MainViewController: SuperViewController,MainViewDelegate {
    
    var questionModel : QuestionModel!
    var arrayData : NSArray!
    var viewBottom : UIView!
    var questionView : QuestionView!
    var buttonGoal : UIButton!
    var rightAnswerCount : Int = 0
    var totalAnswerCount : Int = 0
    var currentQuestionIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBottom = UIView.init(frame: CGRect.init(x: 0, y: sh-49-44, width: sw, height: 44))
        viewBottom.backgroundColor = UIColor.lightGray
        
        let length = (sw-44-2)/2
        for i in 0...2 {
            let button = UIButton.init(type: .system)
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.lightGray, for: .normal)
            if(0 == i) {
                button.frame = CGRect.init(x: 0, y: 1, width: length, height: viewBottom.frame.size.height-1)
                button.setTitle("上一题", for: .normal)
            }else if(1 == i){
                button.frame = CGRect.init(x: length+1, y: 1, width: viewBottom.frame.size.height, height: viewBottom.frame.size.height-1)
                button.setTitle("0/0", for: .normal)
                button.isUserInteractionEnabled = false
                buttonGoal = button
            }else if(2 == i) {
                button.frame = CGRect.init(x: sw-length, y: 1, width: length, height: viewBottom.frame.size.height-1)
                button.setTitle("下一题", for: .normal)
            }
            button.tag = i
            button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
            viewBottom.addSubview(button)
        }
        
        self.view.addSubview(viewBottom)
        
        if(SQLiteManager.shareInstance().openDB()) {
            arrayData = QuestionModel.queryDataFromDB()! as NSArray
        }
        
        self.reloadQuestion(index: currentQuestionIndex)
        
        questionView = QuestionView(frame: CGRect(x: 12, y: 0, width: sw-24, height: sh-64-44))
        questionView.delegate = self
        questionView.initModel(model: questionModel)
        questionView.tableview.reloadData()
        self.view.addSubview(questionView)
        
        // Do any additional setup after loading the view.
    }
    
    func reloadQuestion(index:Int) {
        questionModel = arrayData.object(at: currentQuestionIndex) as! QuestionModel
    }
    
    func refreshData() {
        questionView.initModel(model: questionModel)
        questionView.tableview.reloadData()
    }
    
    func buttonClick(button:UIButton) {
        if(0==button.tag) {
            if(0 < currentQuestionIndex) {
                currentQuestionIndex -= 1
                self.reloadQuestion(index: currentQuestionIndex)
                self.refreshData()
            }
        }else if(2==button.tag) {
            if(arrayData.count > currentQuestionIndex+1) {
                currentQuestionIndex += 1
                self.reloadQuestion(index: currentQuestionIndex)
                self.refreshData()
            }
        }
    }
    
    func didSelectedAnswer(row: NSInteger) {
        totalAnswerCount += 1
        if(row+1 == NSInteger(questionModel.RightAnswer)) {
            rightAnswerCount += 1
        }
        buttonGoal.setTitle(String(rightAnswerCount)+"/"+String(totalAnswerCount), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class MainCell: UITableViewCell {
    
    var labelTitle : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func data(model:QuestionModel,askArray:NSArray,answerArray:NSArray,indexPath:NSIndexPath) {
        labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: sw, height: 60))
        self.contentView.addSubview(labelTitle)
        if(askArray.count == indexPath.row) {
            labelTitle.text = answerArray.object(at: 0) as? String
        }else {
            labelTitle.text = askArray.object(at: indexPath.row) as? String
        }
    }
}

class QuestionView : UIView,UITableViewDelegate,UITableViewDataSource {
    var questionModel : QuestionModel!
    var tableview : UITableView!
    var askArray : NSArray!
    var answerArray : NSArray!
    var delegate : MainViewDelegate!

    var isSelected : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        tableview = UITableView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), style:.grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = UIColor.white
        tableview.showsVerticalScrollIndicator = false
        
        self.addSubview(tableview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func initModel(model:QuestionModel) {
        questionModel = model
        self.initArray()
        self.resetMark()
    }
    
    func initArray() {
        askArray = QuestionModel.toAskArray(model: questionModel)
        answerArray = QuestionModel.toAnswerArray(model: questionModel)
    }
    
    func resetMark() {
        isSelected = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!isSelected) {
            return askArray.count
        }
        return askArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MainCell.init(style: .default, reuseIdentifier: "cell")
        
        cell.data(model: questionModel, askArray: askArray, answerArray: answerArray, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(!isSelected) {
            return 0.1
        }
        
        return self.frame.size.height-60*CGFloat(askArray.count+1)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: sw-24, height: 60))
        view.backgroundColor = UIColor.white
        
        let labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: sw-24, height: view.frame.size.height))
        labelTitle.text = "题目: " + questionModel.Question
        view.addSubview(labelTitle)
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let textview = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: sw-24, height: self.frame.size.height-60*CGFloat(askArray.count+1)))
        textview.text = questionModel.AnswerDetail
        textview.font = UIFont.systemFont(ofSize: 16)
        textview.isUserInteractionEnabled = false
        textview.showsVerticalScrollIndicator = false
        return textview
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        if(!isSelected) {
            isSelected = true
            delegate.didSelectedAnswer(row: indexPath.row)
            tableView.reloadData()
        }
    }
}

