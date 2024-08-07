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
    
    // Function to format a date string from one format to another with default values for
    static func formatDate(dateString: String, fromFormat: String = "yyyy-MM-dd HH:mm:ss", toFormat: String = "dd.MM.yyyy HH:mm") -> String {
        // create inputFormatter
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = fromFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        // create outputFormatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = toFormat
        outputFormatter.locale = Locale(identifier: "de_DE")
        
        // atempt to format original date string
        if let date = inputFormatter.date(from: dateString) {
            // print("Successfully parsed date: \(date)")
            return outputFormatter.string(from: date) // Return formatted date string
        } else {
            // print("Failed to parse date: \(dateString)")
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
        dateFormatter.locale = Locale(identifier: "de_DE")
        
        // return the formatted date string
        return dateFormatter.string(from: oneWeekAgo)
    }
}
