//
//  ComplicationController.swift
//  GoodTime WatchKit Extension
//
//  Created by Andrey Kasatkin on 9/28/18.
//  Copyright © 2018 Andrey Kasatkin. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        var entry: CLKComplicationTimelineEntry?
        
        let currentTime = UserDefaults.standard.string(forKey: "time") ?? ""
        
        if (complication.family == .modularSmall)
        {
            entry = getEntryForModularSmall(currentTime)
        }
        else if (complication.family == .modularLarge)
        {
            entry = getEntryForModularLarge(currentTime)
        }
        else if (complication.family == .circularSmall)
        {
            entry = getEntryForCircularSmall(currentTime)
        }
        else if (complication.family == .utilitarianLarge)
        {
            entry = getEntryForUtilitarianLarge(currentTime)
        }
        else if (complication.family == .utilitarianSmall || complication.family == .utilitarianSmallFlat)
        {
            entry = getEntryForUtilitarianSmall(currentTime)
        }
        else if (complication.family == .extraLarge)
        {
            entry = getEntryForExtraLarge(currentTime)
        }
        else if (complication.family == .graphicCorner)
        {
            entry = getEntryForGraphicCorner(currentTime)
        }
        else if (complication.family == .graphicCircular)
        {
            entry = getEntryForGraphicCircular(currentTime)
        }
        
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let currentTime = "5:14"
        var template: CLKComplicationTemplate?
        if (complication.family == .modularSmall)
        {
            template = getTemplateForModularSmall(currentTime)
        }
        else if (complication.family == .modularLarge)
        {
            template = getTemplateForModularLarge(currentTime)
        }
        else if (complication.family == .circularSmall)
        {
            template = getTemplateForCircularSmall(currentTime)
        }
        else if (complication.family == .utilitarianLarge)
        {
            template = getTemplateForUtilitarianLarge(currentTime)
        }
        else if (complication.family == .utilitarianSmall || complication.family == .utilitarianSmallFlat)
        {
            template = getTemplateForUtilitarianSmall(currentTime)
        }
        else if (complication.family == .extraLarge)
        {
            template = getTemplateForExtraLarge(currentTime)
        }
        else if (complication.family == .graphicCorner)
        {
            template = getTemplateForGraphicCorner(currentTime)
        }
        else if (complication.family == .graphicCircular)
        {
            template = getTemplateForGraphicCircular(currentTime)
        }
        /*else if (complication.family == .graphicBezel)
        {
            template = getTemplateForExtraLarge(currentTime)
        }
        else if (complication.family == .graphicRectangular)
        {
            template = getTemplateForExtraLarge(currentTime)
        }*/
        
        handler(template)
    }
    
    //MARK: - templates for various complication types
    
    func getEntryForModularSmall(_ currentTime: String) -> CLKComplicationTimelineEntry
    {
        let small = getTemplateForModularSmall(currentTime)
        return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: small)
    }
    
    func getTemplateForModularSmall(_ currentTime: String) -> CLKComplicationTemplateModularSmallStackText
    {
        let smallStack = CLKComplicationTemplateModularSmallStackText()
        
        let line1 = CLKSimpleTextProvider()
        line1.text = currentTime//String(format: "%@", formatStepsForSmall(totalSteps))
        line1.shortText = line1.text
        line1.tintColor = UIColor.white
        smallStack.line1TextProvider = line1
        
        let line2 = CLKSimpleTextProvider()
        line2.text =  NSLocalizedString("used", comment: "")
        line2.shortText = line2.text
        line2.tintColor = UIColor(red: 103.0/255.0, green: 171.0/255.0, blue: 229.0/255.0, alpha: 1)
        smallStack.line2TextProvider = line2
        
        return smallStack
    }
    
    func getEntryForModularLarge(_ currentTime: String) -> CLKComplicationTimelineEntry
    {
        let large = getTemplateForModularLarge(currentTime)
        return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: large)
    }
    
    func getTemplateForModularLarge(_ currentTime: String) -> CLKComplicationTemplateModularLargeTallBody
    {
        let tall = CLKComplicationTemplateModularLargeTallBody()
        
        let header = CLKSimpleTextProvider()
        header.text = NSLocalizedString("Used", comment: "")
        header.shortText = header.text
        header.tintColor = UIColor(red: 103.0/255.0, green: 171.0/255.0, blue: 229.0/255.0, alpha: 1)
        tall.headerTextProvider = header
        
        let body = CLKSimpleTextProvider()
        body.text = currentTime
        body.shortText = body.text
        body.tintColor = UIColor.white
        tall.bodyTextProvider = body
        
        return tall
    }
    
    func getEntryForCircularSmall(_ currentTime: String) -> CLKComplicationTimelineEntry
    {
        let circular = getTemplateForCircularSmall(currentTime)
        return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: circular)
    }
    
    func getTemplateForCircularSmall(_ currentTime: String) -> CLKComplicationTemplateCircularSmallStackText
    {
        let circularStack = CLKComplicationTemplateCircularSmallStackText()
        
        let line1 = CLKSimpleTextProvider()
        line1.text = currentTime
        line1.shortText = line1.text
        line1.tintColor = UIColor.white
        circularStack.line1TextProvider = line1
        
        let line2 = CLKSimpleTextProvider()
        line2.text =  NSLocalizedString("used", comment: "")
        line2.shortText = line2.text
        line2.tintColor = UIColor(red: 103.0/255.0, green: 171.0/255.0, blue: 229.0/255.0, alpha: 1)
        circularStack.line2TextProvider = line2
        
        return circularStack
    }
    
    func getEntryForUtilitarianLarge(_ currentTime: String) -> CLKComplicationTimelineEntry
    {
        let large = getTemplateForUtilitarianLarge(currentTime)
        return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: large)
    }
    
    func getTemplateForUtilitarianLarge(_ currentTime: String) -> CLKComplicationTemplateUtilitarianLargeFlat
    {
        let flat = CLKComplicationTemplateUtilitarianLargeFlat()
     
        let text = CLKSimpleTextProvider()
        text.text = currentTime
        text.shortText = String(format: "%@ Used", currentTime)
        text.tintColor = UIColor.white
        flat.textProvider = text
        
        return flat
    }
    
    func getEntryForUtilitarianSmall(_ currentTime: String) -> CLKComplicationTimelineEntry
    {
        let small = getTemplateForUtilitarianSmall(currentTime)
        return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: small)
    }
    
    func getTemplateForUtilitarianSmall(_ currentTime: String) -> CLKComplicationTemplateUtilitarianSmallFlat
    {
        let flat = CLKComplicationTemplateUtilitarianSmallFlat()
        
        let text = CLKSimpleTextProvider()
        text.text = currentTime
        text.shortText = text.text
        text.tintColor = UIColor.white
        flat.textProvider = text
        
        return flat
    }
    
    func getEntryForExtraLarge(_ currentTime: String) -> CLKComplicationTimelineEntry
    {
        let xLarge = getTemplateForExtraLarge(currentTime)
        return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: xLarge)
    }
    
    func getTemplateForExtraLarge(_ currentTime: String) -> CLKComplicationTemplateExtraLargeStackText
    {
        let xLarge = CLKComplicationTemplateExtraLargeStackText()
        
        let header = CLKSimpleTextProvider()
        header.text = NSLocalizedString("Used", comment: "")
        header.shortText = header.text
        header.tintColor = UIColor(red: 103.0/255.0, green: 171.0/255.0, blue: 229.0/255.0, alpha: 1)
        xLarge.line1TextProvider = header
        
        let body = CLKSimpleTextProvider()
        body.text = currentTime
        body.shortText = body.text
        body.tintColor = UIColor.white
        xLarge.line2TextProvider = body
        
        return xLarge
    }

    //curves over the corner
    func getEntryForGraphicCorner(_ currentTime: String) -> CLKComplicationTimelineEntry
    {
       let cornerTemplate = getTemplateForGraphicCorner(currentTime)
        return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: cornerTemplate)
    }
    
    func getTemplateForGraphicCorner(_ currentTime: String) -> CLKComplicationTemplateGraphicCornerGaugeText
    {
        let lowTempText = CLKSimpleTextProvider(text: "0h")
        lowTempText.tintColor = UIColor.cyan
        
        let highTempText = CLKSimpleTextProvider(text: "8h")
        highTempText.tintColor = UIColor.red
        
        let currentTempText = CLKSimpleTextProvider(text: currentTime)
        
        let weatherColors = [UIColor.cyan, UIColor.yellow, UIColor.red]
        
        let totalTime = UserDefaults.standard.integer(forKey: "totalTime")
        let fraction = Float(totalTime) / Float(28800);
        
        let weatherColorLocations = [0.0, fraction, 1.0]
        
        let cornerTemplate = CLKComplicationTemplateGraphicCornerGaugeText()
        let weatherGaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: weatherColors, gaugeColorLocations:weatherColorLocations as [NSNumber], fillFraction: fraction)
        cornerTemplate.gaugeProvider = weatherGaugeProvider
        cornerTemplate.leadingTextProvider = lowTempText
        cornerTemplate.trailingTextProvider = highTempText
        cornerTemplate.outerTextProvider = currentTempText
        
        return cornerTemplate
    }
    
    func getEntryForGraphicCircular(_ currentTime: String) -> CLKComplicationTimelineEntry
    {
        let circularTemplate = getTemplateForGraphicCircular(currentTime)
        return CLKComplicationTimelineEntry(date: Date(), complicationTemplate: circularTemplate)
    }
    
    func getTemplateForGraphicCircular(_ currentTime: String) -> CLKComplicationTemplateGraphicCircular
    {
        let lowTempText = CLKSimpleTextProvider(text: "0h")
        lowTempText.tintColor = UIColor.cyan
        
        let highTempText = CLKSimpleTextProvider(text: "8h")
        highTempText.tintColor = UIColor.red
        
        let currentTempText = CLKSimpleTextProvider(text: currentTime)
        
        let weatherColors = [UIColor.cyan, UIColor.yellow, UIColor.red]
        
        let totalTime = UserDefaults.standard.integer(forKey: "totalTime") 
        let fraction = Float(totalTime) / Float(28800);
        
        let weatherColorLocations = [0.0, fraction, 1.0]
        
        let circularTemplate = CLKComplicationTemplateGraphicCircularOpenGaugeRangeText()
        let weatherGaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColors: weatherColors, gaugeColorLocations:weatherColorLocations as [NSNumber], fillFraction: fraction)
        circularTemplate.gaugeProvider = weatherGaugeProvider
        circularTemplate.leadingTextProvider = lowTempText
        circularTemplate.trailingTextProvider = highTempText
        circularTemplate.centerTextProvider = currentTempText
        
        return circularTemplate
    }
    
    class func refreshComplication()
    {
        let server = CLKComplicationServer.sharedInstance()
        if let allComplications = server.activeComplications
        {
            for complication in allComplications
            {
                server.reloadTimeline(for: complication)
            }
        }
    }
    
}
