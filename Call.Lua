# Hexstia - Roblox UI Library

Hexstia is a lightweight, customizable UI library for Roblox scripts, designed to be easy to use and integrate.

## Features
- Simple API for creating windows, buttons, toggles, sliders, and more
- Modular and easy to extend
- No dependencies or external themes required

## Installation

just call the libary

## Usage

```lua
-- Load Hexstia library
local Hexstia = loadstring(game:HttpGet("https://pastebin.com/raw/jYD69UHg"))()

-- Create a new window
local window = Hexstia:CreateWindow("My Script UI")

-- Add a button
local button = window:AddButton("Click Me", function()
    print("Button clicked!")
end)

-- Add a toggle
local toggle = window:AddToggle("Enable Feature", false, function(state)
    print("Toggle state:", state)
end)

-- Add a slider
local slider = window:AddSlider("Adjust Value", 0, 100, 50, function(value)
    print("Slider value:", value)
end)
