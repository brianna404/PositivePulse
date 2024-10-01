//
//  DateUtils.swift
//  IOSApp
//
//  Created by Brianna Kruschke on 04.08.24.
//

import Foundation

/// A utility class containing all date manipulation functions for the app.
class DateUtils {
    
    /// Converts a date string into a `Date` object.
    ///
    /// - Parameters:
    ///   - dateString: The date string to convert.
    ///   - fromFormat: The format of the input date string.
    /// - Returns: A `Date` object if the conversion is successful; otherwise, `nil`.
    static func dateFromString(_ dateString: String, fromFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        return dateFormatter.date(from: dateString)
    }
    
    /// Formats a date string from one format to another.
    ///
    /// - Parameters:
    ///   - dateString: The original date string to format.
    ///   - fromFormat: The format of the original date string. Defaults to ISO8601 format.
    ///   - toFormat: The desired output date format. Defaults to German date and time format.
    /// - Returns: A formatted date string if parsing is successful; otherwise, the original date string.
    static func formatDate(
        dateString: String,
        fromFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ",
        toFormat: String = "dd.MM.yyyy HH:mm"
    ) -> String {
        // Create input formatter
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = fromFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Create output formatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = toFormat
        outputFormatter.locale = Locale(identifier: "de_DE")
        
        // Attempt to parse and format the date string
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            // Return original string if parsing fails
            return dateString
        }
    }
    
    /// Calculates a date string representing a past date based on the number of days ago.
    ///
    /// - Parameter daysAgo: The number of days in the past.
    /// - Returns: A date string in the format "yyyy-MM-dd" representing the past date, or `nil` if calculation fails.
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
}
