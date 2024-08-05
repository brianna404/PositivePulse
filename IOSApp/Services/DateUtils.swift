//
//  DateUtils.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 04.08.24.
//

import Foundation

class DateUtils {
    // Function to format a date string from one format to another with default values for 
    static func formatDate(dateString: String, fromFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ", toFormat: String = "dd.MM.yyy HH:mm") -> String {
        // create inputFormatter
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = fromFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        // create outputFormatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = toFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // atempt to format original date string
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date) // Return formatted date string
        } else {
            return dateString // Fallback if parsing fails
        }
    }
    
    // Function to get the date from one week ago and format it to JSON date format
    static func getDateFromOneWeekAgo(format: String = "yyyy-MM-dd") -> String {
        let today = Date()
        
        // calculate the day from one week ago
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: today)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        // return the formatted date string
        return dateFormatter.string(from: oneWeekAgo)
    }
}
