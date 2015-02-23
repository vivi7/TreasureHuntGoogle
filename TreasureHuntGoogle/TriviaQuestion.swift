//
//  TriviaQuestion.swift
//  TresureHuntGoogle
//
//  Created by Vincenzo Favara on 15/02/15.
//  Copyright (c) 2015 Vincenzo Favara (VinSoft). All rights reserved.
//

import Foundation

class TriviaQuestion {
    
    var question: String
    var bitmapID: String?
    var answers: Array<String> = Array<String>()
    var correctAnswer: Int = -1
    var rightMessage: String?
    var wrongMessage: String?
    
    init(triviaQuestionsDictonary: NSDictionary) {
        question = triviaQuestionsDictonary["question"] as String
        bitmapID = triviaQuestionsDictonary["bitmap"] as? String
        
        var answersDictonary: NSDictionary = triviaQuestionsDictonary["answers"] as NSDictionary
        for(key, answer) in answersDictonary{
            answers.append(answer as String)
        }
        correctAnswer = triviaQuestionsDictonary["correctAnswer"] as Int
        rightMessage = triviaQuestionsDictonary["rightMessage"] as? String
        wrongMessage = triviaQuestionsDictonary["wrongMessage"] as? String
    }
}