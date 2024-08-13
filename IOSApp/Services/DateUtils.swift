//
//  DateUtils.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 04.08.24.
//

import Foundation

class DateUtils {
    // Function to convert a date string into a Date obejct
    static func dateFromString(_ dateString: String, fromFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        return dateFormatter.date(from: dateString)
    }
    
    // Function to format a date string from one format to another with default values for German format without seconds
    static func formatDate(dateString: String, fromFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ", toFormat: String = "dd.MM.yyyy HH:mm") -> String {
        // Create inputFormatter
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = fromFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Create outputFormatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = toFormat
        outputFormatter.locale = Locale(identifier: "de_DE")
        
        // Attempt to format the original date string
        if let date = inputFormatter.date(from: dateString) {
            // Return formatted date string
            return outputFormatter.string(from: date)
        } else {
            // Fallback if parsing fails
            return dateString
        }
    }
    
    // Function to get a past date in the specified format
    static func dateAgo(daysAgo: Int) -> String? {
        let currentDate = Date()
        if let dateAgo = Calendar.current.date(byAdding: .day, value: -daysAgo, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter.string(from: dateAgo)
        }
        return nil
    }
    
    // Function to get the date from one week ago and format it to JSON date format
    static func getDateFromOneWeekAgo(format: String = "yyyy-MM-dd") -> String {
        let today = Date()
        
        // calculate the day from one week ago
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: today)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "de_DE")
        
        // return the formatted date string
        return dateFormatter.string(from: oneWeekAgo)
    }
}
