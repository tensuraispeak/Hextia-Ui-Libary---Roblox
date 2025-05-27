local Hextia = loadstring(game:HttpGet("https://pastebin.com/raw/jYD69UHg"))() -- this is how to call it

-- Create a window
local window = Hextia:CreateWindow("Example Window", Vector2.new(400, 300))

-- Add a section
local mainSection = window:CreateSection("Main Controls")

-- Add a button
mainSection:AddButton("Click Me", function()
    print("Button clicked!")
end)

-- Add a toggle
mainSection:AddToggle("Toggle Feature", false, function(state)
    print("Toggle is now", state)
end)

-- Add a slider
mainSection:AddSlider("Volume", 0, 100, 50, function(value)
    print("Slider value:", value)
end)

-- Add a textbox
mainSection:AddTextbox("Name", "Player", function(text)
    print("Entered text:", text)
end)

-- Add a dropdown
mainSection:AddDropdown("Select Option", {"Option 1", "Option 2", "Option 3"}, function(selected)
    print("Selected option:", selected)
end)
