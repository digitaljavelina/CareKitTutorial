//
//  CarePlanData.swift
//  ZombieKit
//
//  Created by Michael Henry on 10/4/16.
//  Copyright © 2016 Razeware. All rights reserved.
//

import CareKit

enum ActivityIdentifer: String {
    case cardio
    case limberUp = "Limber Up"
    case targetPractice = "Target Practice"
    case pulse
    case temperature
}

class CarePlanData: NSObject {
    
    let carePlanStore: OCKCarePlanStore
    
    let contacts =
        [OCKContact(contactType: .personal,
                    name: "Shaun Riley",
                    relation: "Friend",
                    tintColor: nil,
                    phoneNumber: CNPhoneNumber(stringValue: "888-555-5512"),
                    messageNumber: CNPhoneNumber(stringValue: "888-555-5512"),
                    emailAddress: "shaunofthedead@example.com",
                    monogram: "SR",
                    image: UIImage(named: "shaun-avatar")),
         OCKContact(contactType: .careTeam,
                    name: "Columbus Ohio",
                    relation: "Therapist",
                    tintColor: nil,
                    phoneNumber: CNPhoneNumber(stringValue: "888-555-5235"),
                    messageNumber: CNPhoneNumber(stringValue: "888-555-5235"),
                    emailAddress: "columbus@example.com",
                    monogram: "CO",
                    image: UIImage(named: "columbus-avatar")),
         OCKContact(contactType: .careTeam,
                    name: "Dr Hershel Greene",
                    relation: "Veterinarian",
                    tintColor: nil,
                    phoneNumber: CNPhoneNumber(stringValue: "888-555-2351"),
                    messageNumber: CNPhoneNumber(stringValue: "888-555-2351"),
                    emailAddress: "dr.hershel@example.com",
                    monogram: "HG",
                    image: UIImage(named: "hershel-avatar"))]
    
    init(carePlanStore: OCKCarePlanStore) {
        self.carePlanStore = carePlanStore
        
        let cardioActivity = OCKCarePlanActivity(identifier: ActivityIdentifer.cardio.rawValue, groupIdentifier: nil, type: .intervention, title: "Cardio", text: "60 Minutes", tintColor: UIColor.darkOrange(), instructions: "Jog at a moderate pace for an hour. If there isn't an actual one, imagine a horde of zombies behind you.", imageURL: nil, schedule: CarePlanData.dailyScheduleRepeating(occurrencesPerDay: 2), resultResettable: true, userInfo: nil)
        
        let limberUpActivity = OCKCarePlanActivity(identifier: ActivityIdentifer.limberUp.rawValue, groupIdentifier: nil, type: .intervention, title: "Limber Up", text: "Stretch Regularly", tintColor: UIColor.darkOrange(), instructions: "Stretch and warm up muscles in your arms, legs and back before any expected burst of activity. This is especially important if, for example, you're heading down a hill to inspect a Hostess truck.", imageURL: nil, schedule: CarePlanData.dailyScheduleRepeating(occurrencesPerDay: 6), resultResettable: true, userInfo: nil)
        
        let targetPracticeActivity = OCKCarePlanActivity(identifier: ActivityIdentifer.targetPractice.rawValue, groupIdentifier: nil, type: .intervention, title: "Target Practice", text: nil, tintColor: UIColor.darkOrange(), instructions: "Gather some objects that frustrated you before the apocalypse, like printers and construction barriers. Keep your eyes sharp and your arm steady, and blow as many holes as you can in them for at least five minutes.", imageURL: nil, schedule: CarePlanData.dailyScheduleRepeating(occurrencesPerDay: 2), resultResettable: true, userInfo: nil)
        
        let pulseActivity = OCKCarePlanActivity.assessment(withIdentifier: ActivityIdentifer.pulse.rawValue, groupIdentifier: nil, title: "Pulse", text: "Do you have one?", tintColor: UIColor.darkGreen(), resultResettable: true, schedule: CarePlanData.dailyScheduleRepeating(occurrencesPerDay: 1), userInfo: ["ORKTask": AssessmentTaskFactory.makePulseAssessmentTask()])
        
        let temperatureActivity = OCKCarePlanActivity.assessment(withIdentifier: ActivityIdentifer.temperature.rawValue, groupIdentifier: nil, title: "Temperature", text: "Oral", tintColor: UIColor.darkYellow(), resultResettable: true, schedule: CarePlanData.dailyScheduleRepeating(occurrencesPerDay: 1), userInfo: ["ORKTask" :AssessmentTaskFactory.makeTemperatureAssessmentTask()])
        
        super.init()
        
        for activity in [cardioActivity, limberUpActivity, targetPracticeActivity, pulseActivity, temperatureActivity] {
            add(activity: activity)
        }
    }
    
    class func dailyScheduleRepeating(occurrencesPerDay: UInt) -> OCKCareSchedule {
        return OCKCareSchedule.dailySchedule(withStartDate: DateComponents.firstDateOfCurrentWeek, occurrencesPerDay: occurrencesPerDay)
    }
    
    func add(activity: OCKCarePlanActivity) {
        carePlanStore.activity(forIdentifier: activity.identifier) {
            [weak self] (success, fetchedActivity, error) in
            guard success else { return }
            guard let strongSelf = self else { return }
            
            if let _ = fetchedActivity { return }
            
            strongSelf.carePlanStore.add(activity, completion: { _ in })
        }
    }
    
}

extension CarePlanData {
    
    func generateDocumentWith(chart: OCKChart?) -> OCKDocument {
        let intro = OCKDocumentElementParagraph(content: "I've been tracking my efforts to avoid becoming a Zombie with ZombieKit. Please check the attached report to see if you're safe around me.")
        
        var documentElements: [OCKDocumentElement] = [intro]
        if let chart = chart {
            documentElements.append(OCKDocumentElementChart(chart: chart))
        }
        
        let document = OCKDocument(title: "Re: Your Brains", elements: documentElements)
        document.pageHeader = "ZombieKit: Weekly Report"
        
        return document
    }
    
}
