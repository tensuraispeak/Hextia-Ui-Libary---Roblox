-- Load Hexstia
local Hextia = loadstring(game:HttpGet("https://pastebin.com/raw/ZyuGd8ie"))()

-- Create main window
local Window = Hextia:CreateWindow("Hexstia Example UI", Vector2.new(450, 250))

-- Create 'Controls' section
local Controls = Window:CreateSection("Controls")

-- Add button
Controls:AddButton("AutoSell", function()
    -- your code here
end)

-- Add Info Label
Controls:AddLabel("Status: Idle")

-- Create another section
local Extra = Window:CreateSection("Extras")

-- Add another button
Extra:AddButton("Print Hello", function()
    print("Hello from Hexstia!")
end)
