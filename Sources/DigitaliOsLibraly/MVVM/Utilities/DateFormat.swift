//
//  DateFormat.swift
//  DualBiz
//
//  Created by EVGENIY DAN on 11.06.2020.
//  Copyright © 2020 EVGENIY DAN. All rights reserved.
//

import Foundation


class DateFormat {
    
    func getDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateString) // replace Date String
    }
    
    
    
    /// Date Format type
    enum DateFormatType: String {
        /// Time
        case time = "HH:mm:ss"
        
        /// Date with hours
        case dateWithHours = "yyyy-MM-dd HH:mm"
        
        /// Date with hours, minutes
        case dateWithSeconds = "yyyy-MM-dd HH:mm:ss"
        
        /// Date
        case date = "dd-MMM-yyyy"
    }
    
    
    /// Convert String to Date
    func convertToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatType.date.rawValue // Your date format
        let serverDate: Date = dateFormatter.date(from: dateString)! // according to date format your date string
        return serverDate
    }
    
    /// Convert Date to String
    func convertToString(date: Date, dateformat formatType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue // Your New Date format as per requirement change it own
        
        let newDate: String = dateFormatter.string(from: date) // pass Date here
        //print(newDate) // New formatted Date string
        
        return newDate
    }
    
    
    /// Diviation calculation
    func convertToSeconds(timeString: String, dateFormat type: DateFormatType) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        
        let date: Date = dateFormatter.date(from: timeString)!
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        // let sec = comp.second
        
        let totalSeconds = ((hour! * 60) * 60) + (minute! * 60) //+ sec!
        
        return totalSeconds
    }
    
    
    /// To Show the Date in String format
    func convertToShowFormatDate(dateString: String) -> String {
        print(dateString)
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "yyyy-MM-dd HH:mm"
        //dateFormatterDate.dateFormat = "yyyy-MM-dd HH:mm" //Your date format
        let serverDate: Date = dateFormatterDate.date(from: dateString)! //according to date format your date string
        
        let dateFormatterString = DateFormatter()
        //dateFormatterString.dateFormat = "yyyy-MM-dd hh:mm a"
        dateFormatterString.dateFormat = "yyyy-MM-dd HH:mm" //Your New Date format as per requirement change it own
        let newDate: String = dateFormatterString.string(from: serverDate) //pass Date here
        print(newDate) // New formatted Date string
        
        return newDate
    }
    
    func convertTZ(dateString: String) -> String {
        let newDateString = dateString.map { character -> Character in
            if character == "T" {
                return Character(" ")
            } else if character == "Z" {
                return Character(" ")
            } else {
                return character
            }
        }
        //print(newDateString)
        return convertToShowFormatDate(dateString: String(newDateString))
    }
    
}



