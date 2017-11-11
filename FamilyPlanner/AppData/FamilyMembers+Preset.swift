//
//  FamilyMembers+Preset.swift
//  AppData
//
//  Created by Daniel Meachum on 10/23/17.
//  Copyright © 2017 Meachum. All rights reserved.
//

import SwiftDate

extension FamilyMember
{
    public static var dad : FamilyMember {
        
        let birthday = Date.birthdate(day: 30, month: 9, year: 1957)
        
        return FamilyMember(firstName: "David", lastName: "Meachum", nickName : "Dad", group: .immediate, emailAddress: "meachum5@windstream.net", phoneNumber: "704-400-7327", birthday: birthday)
    }
    
    public static var mom : FamilyMember {
        
        let birthday = Date.birthdate(day: 31, month: 1, year: 1960)
        
        return FamilyMember(firstName: "Tanya", lastName: "Meachum", nickName: "Mimi", group: .immediate, emailAddress: "tmeachum@windstream.net", phoneNumber: "704-273-6519", birthday: birthday)
    }
    
    public static var jasmine : FamilyMember {
        
        let birthday = Date.birthdate(day: 3, month: 7, year: 1983)
        
        return FamilyMember(firstName: "David", lastName: "Meachum", nickName: "Jazzy", group: .immediate, emailAddress: "cjasmine@windstream.net", phoneNumber: "704-242-3834", birthday: birthday)
    }
    
    public static var glennsFamily : Family {
        
        let glenn = FamilyMember(firstName: "Glenn", lastName: "Meachum", nickName: "Glenn", group: .immediate, emailAddress: "dgmeachum@gmail.com", phoneNumber: "704-320-3495", birthday: Date.birthdate(day: 17, month: 10, year: 1984))
        
        let michelle = FamilyMember(firstName: "Glenn", lastName: "Meachum", nickName: "Glenn", group: .immediate, emailAddress: "dgmeachum@gmail.com", phoneNumber: "704-320-3495", birthday: Date.birthdate(day: 28, month: 8, year: 1986))
        
        
        let kayleigh = Child(firstName: "Kayleigh", birthday: Date.birthdate(day: 20, month: 4, year: 2009), parent: glenn)
        
        let shannon = Child(firstName: "Shannon", birthday: Date.birthdate(day: 9, month: 2, year: 2011), parent: glenn)
        
        let reagan = Child(firstName: "Reagan", birthday: Date.birthdate(day: 15, month: 9, year: 2017), parent: glenn)
        
        
        let family = Family(husband: glenn, wife: michelle, children: [kayleigh,shannon,reagan])
        
        return family
    }
    
    public static var dansFamily : Family {
        
        let dan = FamilyMember(firstName: "Dan", lastName: "Meachum", nickName: "Danechka", group: .immediate, emailAddress: "danielmeachum@me.com", phoneNumber: "704-604-9255", birthday: Date.birthdate(day: 10, month: 2, year: 1986))
        
        let olya = FamilyMember(firstName: "Olga", lastName: "Meachum", nickName: "Olya", group: .immediate, emailAddress: "meachum.family@gmail.com", phoneNumber: "704-441-3695", birthday: Date.birthdate(day: 27, month: 3, year: 1985))
        
        
        let natalie = Child(firstName: "Natalie", birthday: Date.birthdate(day: 29, month: 8, year: 2008), parent: dan)
        
        let clara = Child(firstName: "Clara", birthday: Date.birthdate(day: 27, month: 8, year: 2013), parent: dan)
        
        let family = Family(husband: dan, wife: olya, children: [natalie, clara])
        
        return family
    }
    
    public static var allFamilyRepresentation : [FamilyRepresentation] {
        
        return [dad,mom,jasmine,glennsFamily,dansFamily]
    }
    
    public static func allFamilyRepresentationOfGroup(group : FamilyMemberGroup) -> [FamilyRepresentation] {
        
        return allFamilyRepresentation.filter({ $0.group == group })
    }
    
    public static var allFamilyMembers : [FamilyMember] {
        
        var members = [FamilyMember]()
        
        for representation in allFamilyRepresentation {
            
            members += representation.familyMembers
        }
        
        return members
    }
    
}

extension Date {
    
    public static func birthdate(day : Int, month : Int, year : Int) -> Date {
        
        return DateInRegion(components: [.day : day, .month : month, .year : year])!.absoluteDate
    }
}
