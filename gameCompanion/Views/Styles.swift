//
//  Styles.swift
//  gameCompanion
//
//  Created by Dirk Boller on 21.08.20.
//  Copyright © 2020 Dirk Boller. All rights reserved.
//

import SwiftUI

struct GradientMenuStyle: MenuStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        if #available(iOS 15.0, *) {
            Menu(configuration)
                .foregroundColor(Color.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(named: "ButtonLight")!), Color(uiColor: UIColor(named: "ButtonDark")!)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15.0)
        } else {
            // Fallback on earlier versions
            Menu(configuration)
                .foregroundColor(Color.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15.0)
        }
    }
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .foregroundColor(Color.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(named: "ButtonLight")!), Color(uiColor: UIColor(named: "ButtonDark")!)]), startPoint: .leading, endPoint: .trailing))
            //  .background(configuration.isPressed ? Color.green : Color.yellow)
                .cornerRadius(15.0)
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        } else {
            // Fallback on earlier versions
            configuration.label
                .foregroundColor(Color.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            //  .background(configuration.isPressed ? Color.green : Color.yellow)
                .cornerRadius(15.0)
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        }
    }
}

struct GradientSettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .foregroundColor(Color.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(named: "ButtonSettingsLight")!), Color(uiColor: UIColor(named: "ButtonSettingsDark")!)]), startPoint: .leading, endPoint: .trailing))
            //  .background(configuration.isPressed ? Color.green : Color.yellow)
                .cornerRadius(15.0)
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        } else {
            // Fallback on earlier versions
            configuration.label
                .foregroundColor(Color.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            //  .background(configuration.isPressed ? Color.green : Color.yellow)
                .cornerRadius(15.0)
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        }
    }
}

struct SmallGradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .foregroundColor(Color.white)
                .padding(.all, CGFloat(8))
                .background(LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(named: "ButtonLight")!), Color(uiColor: UIColor(named: "ButtonDark")!)]), startPoint: .leading, endPoint: .trailing))
            //  .background(configuration.isPressed ? Color.green : Color.yellow)
                .cornerRadius(10.0)
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        } else {
            // Fallback on earlier versions
            configuration.label
                .foregroundColor(Color.white)
                .padding(.all, CGFloat(8))
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            //  .background(configuration.isPressed ? Color.green : Color.yellow)
                .cornerRadius(10.0)
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        }
    }
}

struct BigGradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .foregroundColor(Color.white)
                .padding(.all, CGFloat(30))
                .background(LinearGradient(gradient: Gradient(colors: [Color(uiColor: UIColor(named: "ButtonLight")!), Color(uiColor: UIColor(named: "ButtonDark")!)]), startPoint: .leading, endPoint: .trailing))
            //  .background(configuration.isPressed ? Color.green : Color.yellow)
                .cornerRadius(15.0)
            
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        } else {
            configuration.label
                .foregroundColor(Color.white)
                .padding(.all, CGFloat(30))
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            //  .background(configuration.isPressed ? Color.green : Color.yellow)
                .cornerRadius(15.0)
            
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        }
    }
}

struct OrangeRoundedBorderStyle : TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color(uiColor: UIColor(named: "UIBackground")!), lineWidth: 1)
            )
        
    }
}


struct Styles_Previews: PreviewProvider {
    @State static var sampleText = "Text"
    static var previews: some View {
        VStack {
            Button(action: {}, label: { Text("SmallGradientButton")}).buttonStyle(SmallGradientButtonStyle()).padding()
            Button(action: {}, label: { Text("GradientButton")}).buttonStyle(GradientButtonStyle()).padding()
            Button(action: {}, label: { Text("BigGradientButton")}).buttonStyle(BigGradientButtonStyle()).padding()
            TextField("InputField", text: $sampleText).textFieldStyle(OrangeRoundedBorderStyle()).padding()
        }
    }
}
