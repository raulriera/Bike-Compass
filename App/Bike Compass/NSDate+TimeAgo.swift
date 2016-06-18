//
//  NSDate+TimeAgo.swift
//  Bike Compass
//
//  Created by Raúl Riera on 02/05/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//  https://gist.githubusercontent.com/jacks205/4a77fb1703632eb9ae79/raw/950e6b7e86143d805e65f618d5386225b038c37d/timeago.swift
//

import Foundation

func timeAgoSinceDate(_ date:Date, numericDates:Bool = true) -> String {
    let calendar = Calendar.current()
    let now = Date()
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = calendar.components([Calendar.Unit.minute , Calendar.Unit.hour , Calendar.Unit.day , Calendar.Unit.weekOfYear , Calendar.Unit.month , Calendar.Unit.year , Calendar.Unit.second], from: earliest, to: latest, options: Calendar.Options())
    
    if (components.year >= 2) {
        return "\(components.year) years ago"
    } else if (components.year >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month >= 2) {
        return "\(components.month) months ago"
    } else if (components.month >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear >= 2) {
        return "\(components.weekOfYear) weeks ago"
    } else if (components.weekOfYear >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day >= 2) {
        return "\(components.day) days ago"
    } else if (components.day >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour >= 2) {
        return "\(components.hour) hours ago"
    } else if (components.hour >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute >= 2) {
        return "\(components.minute) minutes ago"
    } else if (components.minute >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second >= 3) {
        return "\(components.second) seconds ago"
    } else {
        return "Just now"
    }
    
}
