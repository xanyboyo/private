--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88    @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  CONVERTER 
]=]

-- Instances: 59 | Scripts: 10 | Modules: 0 | Tags: 0
local G2L = {};

-- StarterGui.Ohyeah
G2L["1"] = Instance.new("ScreenGui", game:GetService("CoreGui"));
G2L["1"]["Enabled"] = true;
G2L["1"]["Name"] = [[Hello]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;


-- StarterGui.Ohyeah.Frame
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["2"]["Size"] = UDim2.new(0, 318, 0, 396);
G2L["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);


-- StarterGui.Ohyeah.Frame.UICorner
G2L["3"] = Instance.new("UICorner", G2L["2"]);
G2L["3"]["CornerRadius"] = UDim.new(0.04, 0);


-- StarterGui.Ohyeah.Frame.UIGradient
G2L["4"] = Instance.new("UIGradient", G2L["2"]);
G2L["4"]["Rotation"] = 45;
G2L["4"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(17, 17, 17)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(53, 53, 53))};


-- StarterGui.Ohyeah.Frame.ScrollingFrame
G2L["5"] = Instance.new("ScrollingFrame", G2L["2"]);
G2L["5"]["Active"] = true;
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["CanvasPosition"] = Vector2.new(0, 200);
G2L["5"]["VerticalScrollBarInset"] = Enum.ScrollBarInset.Always;
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["5"]["Size"] = UDim2.new(1, 0, 0.88889, 0);
G2L["5"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["Position"] = UDim2.new(0, 0, 0.11111, 0);
G2L["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["ScrollBarThickness"] = 10;
G2L["5"]["BackgroundTransparency"] = 1;


-- StarterGui.Ohyeah.Frame.ScrollingFrame.UIGridLayout
G2L["6"] = Instance.new("UIGridLayout", G2L["5"]);
G2L["6"]["CellSize"] = UDim2.new(1, 0, 0.15, 0);
G2L["6"]["CellPadding"] = UDim2.new(0.01, 0, 0.01, 0);


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin2
G2L["7"] = Instance.new("Frame", G2L["5"]);
G2L["7"]["BorderSizePixel"] = 0;
G2L["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7"]["Name"] = [[Admin2]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin2.LocalScript
G2L["8"] = Instance.new("LocalScript", G2L["7"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin2.Button
G2L["9"] = Instance.new("TextButton", G2L["7"]);
G2L["9"]["BorderSizePixel"] = 0;
G2L["9"]["TextSize"] = 14;
G2L["9"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9"]["SelectionOrder"] = 5;
G2L["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["9"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["9"]["BackgroundTransparency"] = 1;
G2L["9"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["9"]["Text"] = [[]];
G2L["9"]["Name"] = [[Button]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin2.Logo
G2L["a"] = Instance.new("ImageLabel", G2L["7"]);
G2L["a"]["BorderSizePixel"] = 0;
G2L["a"]["ScaleType"] = Enum.ScaleType.Fit;
G2L["a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["a"]["Image"] = [[rbxassetid://1352543873]];
G2L["a"]["Size"] = UDim2.new(0.16883, 0, 1, 0);
G2L["a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["a"]["BackgroundTransparency"] = 1;
G2L["a"]["Name"] = [[Logo]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin2.Label
G2L["b"] = Instance.new("TextLabel", G2L["7"]);
G2L["b"]["TextWrapped"] = true;
G2L["b"]["TextStrokeTransparency"] = 0;
G2L["b"]["BorderSizePixel"] = 0;
G2L["b"]["TextSize"] = 14;
G2L["b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["b"]["TextScaled"] = true;
G2L["b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["b"]["BackgroundTransparency"] = 1;
G2L["b"]["Size"] = UDim2.new(0.83117, 0, 0.98485, 0);
G2L["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b"]["Text"] = [[Infinite Yield]];
G2L["b"]["Name"] = [[Label]];
G2L["b"]["Position"] = UDim2.new(0.16883, 0, 0, 0);


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin2.UIGradient
G2L["c"] = Instance.new("UIGradient", G2L["7"]);
G2L["c"]["Rotation"] = 180;
G2L["c"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(17, 17, 17)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(53, 53, 53))};


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin
G2L["d"] = Instance.new("Frame", G2L["5"]);
G2L["d"]["BorderSizePixel"] = 0;
G2L["d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["d"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d"]["Name"] = [[Admin]];
G2L["d"]["BackgroundTransparency"] = 1;


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin.Label
G2L["e"] = Instance.new("TextLabel", G2L["d"]);
G2L["e"]["TextWrapped"] = true;
G2L["e"]["TextStrokeTransparency"] = 0;
G2L["e"]["BorderSizePixel"] = 0;
G2L["e"]["TextSize"] = 14;
G2L["e"]["TextScaled"] = true;
G2L["e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["e"]["BackgroundTransparency"] = 1;
G2L["e"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["e"]["Text"] = [[▲Admin▲]];
G2L["e"]["Name"] = [[Label]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin.TextButton
G2L["f"] = Instance.new("TextButton", G2L["d"]);
G2L["f"]["BorderSizePixel"] = 0;
G2L["f"]["TextSize"] = 14;
G2L["f"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["f"]["SelectionOrder"] = 5;
G2L["f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["f"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["f"]["BackgroundTransparency"] = 1;
G2L["f"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["f"]["Text"] = [[]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin.TextButton.LocalScript
G2L["10"] = Instance.new("LocalScript", G2L["f"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin3
G2L["11"] = Instance.new("Frame", G2L["5"]);
G2L["11"]["BorderSizePixel"] = 0;
G2L["11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["11"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["11"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["11"]["Name"] = [[Admin3]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin3.LocalScript
G2L["12"] = Instance.new("LocalScript", G2L["11"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin3.Button
G2L["13"] = Instance.new("TextButton", G2L["11"]);
G2L["13"]["BorderSizePixel"] = 0;
G2L["13"]["TextSize"] = 14;
G2L["13"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["13"]["SelectionOrder"] = 5;
G2L["13"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["13"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["13"]["BackgroundTransparency"] = 1;
G2L["13"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["13"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["13"]["Text"] = [[]];
G2L["13"]["Name"] = [[Button]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin3.Logo
G2L["14"] = Instance.new("ImageLabel", G2L["11"]);
G2L["14"]["BorderSizePixel"] = 0;
G2L["14"]["SliceCenter"] = Rect.new(0, -1000, 250, 0);
G2L["14"]["SliceScale"] = 100;
G2L["14"]["ScaleType"] = Enum.ScaleType.Crop;
G2L["14"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["14"]["Image"] = [[rbxassetid://78004580800700]];
G2L["14"]["TileSize"] = UDim2.new(2, 0, 1.5, 0);
G2L["14"]["Size"] = UDim2.new(0.16883, 0, 1, 0);
G2L["14"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["14"]["BackgroundTransparency"] = 1;
G2L["14"]["Name"] = [[Logo]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin3.Label
G2L["15"] = Instance.new("TextLabel", G2L["11"]);
G2L["15"]["TextWrapped"] = true;
G2L["15"]["TextStrokeTransparency"] = 0;
G2L["15"]["BorderSizePixel"] = 0;
G2L["15"]["TextSize"] = 14;
G2L["15"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["15"]["TextScaled"] = true;
G2L["15"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["15"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["15"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["15"]["BackgroundTransparency"] = 1;
G2L["15"]["Size"] = UDim2.new(0.83117, 0, 0.98485, 0);
G2L["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["15"]["Text"] = [[Fates Admin]];
G2L["15"]["Name"] = [[Label]];
G2L["15"]["Position"] = UDim2.new(0.16883, 0, 0, 0);


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin3.UIGradient
G2L["16"] = Instance.new("UIGradient", G2L["11"]);
G2L["16"]["Rotation"] = 180;
G2L["16"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(17, 17, 17)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(53, 53, 53))};


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin1
G2L["17"] = Instance.new("Frame", G2L["5"]);
G2L["17"]["BorderSizePixel"] = 0;
G2L["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["17"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["17"]["Name"] = [[Admin1]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin1.LocalScript
G2L["18"] = Instance.new("LocalScript", G2L["17"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin1.Button
G2L["19"] = Instance.new("TextButton", G2L["17"]);
G2L["19"]["BorderSizePixel"] = 0;
G2L["19"]["TextSize"] = 14;
G2L["19"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19"]["SelectionOrder"] = 5;
G2L["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["19"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["19"]["BackgroundTransparency"] = 1;
G2L["19"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19"]["Text"] = [[]];
G2L["19"]["Name"] = [[Button]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin1.Logo
G2L["1a"] = Instance.new("ImageLabel", G2L["17"]);
G2L["1a"]["BorderSizePixel"] = 0;
G2L["1a"]["SliceCenter"] = Rect.new(0, -1000, 250, 0);
G2L["1a"]["SliceScale"] = 100;
G2L["1a"]["ScaleType"] = Enum.ScaleType.Crop;
G2L["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a"]["Image"] = [[rbxassetid://74901749710189]];
G2L["1a"]["TileSize"] = UDim2.new(2, 0, 1.5, 0);
G2L["1a"]["Size"] = UDim2.new(0.16883, 0, 1, 0);
G2L["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a"]["BackgroundTransparency"] = 1;
G2L["1a"]["Name"] = [[Logo]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin1.Label
G2L["1b"] = Instance.new("TextLabel", G2L["17"]);
G2L["1b"]["TextWrapped"] = true;
G2L["1b"]["TextStrokeTransparency"] = 0;
G2L["1b"]["BorderSizePixel"] = 0;
G2L["1b"]["TextSize"] = 14;
G2L["1b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["1b"]["TextScaled"] = true;
G2L["1b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1b"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1b"]["BackgroundTransparency"] = 1;
G2L["1b"]["Size"] = UDim2.new(0.83117, 0, 0.98485, 0);
G2L["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1b"]["Text"] = [[Nameless Admin]];
G2L["1b"]["Name"] = [[Label]];
G2L["1b"]["Position"] = UDim2.new(0.16883, 0, 0, 0);


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin1.UIGradient
G2L["1c"] = Instance.new("UIGradient", G2L["17"]);
G2L["1c"]["Rotation"] = 180;
G2L["1c"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(17, 17, 17)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(53, 53, 53))};


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script
G2L["1d"] = Instance.new("Frame", G2L["5"]);
G2L["1d"]["BorderSizePixel"] = 0;
G2L["1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1d"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["1d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1d"]["Name"] = [[Script]];
G2L["1d"]["BackgroundTransparency"] = 1;


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script.Label
G2L["1e"] = Instance.new("TextLabel", G2L["1d"]);
G2L["1e"]["TextWrapped"] = true;
G2L["1e"]["TextStrokeTransparency"] = 0;
G2L["1e"]["BorderSizePixel"] = 0;
G2L["1e"]["TextSize"] = 14;
G2L["1e"]["TextScaled"] = true;
G2L["1e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1e"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
G2L["1e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1e"]["BackgroundTransparency"] = 1;
G2L["1e"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["1e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1e"]["Text"] = [[▲Scripting▲]];
G2L["1e"]["Name"] = [[Label]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script.TextButton
G2L["1f"] = Instance.new("TextButton", G2L["1d"]);
G2L["1f"]["BorderSizePixel"] = 0;
G2L["1f"]["TextSize"] = 14;
G2L["1f"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1f"]["SelectionOrder"] = 5;
G2L["1f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1f"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["1f"]["BackgroundTransparency"] = 1;
G2L["1f"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1f"]["Text"] = [[]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script.TextButton.LocalScript
G2L["20"] = Instance.new("LocalScript", G2L["1f"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script1
G2L["21"] = Instance.new("Frame", G2L["5"]);
G2L["21"]["BorderSizePixel"] = 0;
G2L["21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["21"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["21"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["21"]["Name"] = [[Script1]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script1.LocalScript
G2L["22"] = Instance.new("LocalScript", G2L["21"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script1.Button
G2L["23"] = Instance.new("TextButton", G2L["21"]);
G2L["23"]["BorderSizePixel"] = 0;
G2L["23"]["TextSize"] = 14;
G2L["23"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["23"]["SelectionOrder"] = 5;
G2L["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["23"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["23"]["BackgroundTransparency"] = 1;
G2L["23"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["23"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["23"]["Text"] = [[]];
G2L["23"]["Name"] = [[Button]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script1.Logo
G2L["24"] = Instance.new("ImageLabel", G2L["21"]);
G2L["24"]["BorderSizePixel"] = 0;
G2L["24"]["ScaleType"] = Enum.ScaleType.Fit;
G2L["24"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["24"]["Image"] = [[rbxassetid://106021785006233]];
G2L["24"]["Size"] = UDim2.new(0.16883, 0, 1, 0);
G2L["24"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["24"]["BackgroundTransparency"] = 1;
G2L["24"]["Name"] = [[Logo]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script1.Label
G2L["25"] = Instance.new("TextLabel", G2L["21"]);
G2L["25"]["TextWrapped"] = true;
G2L["25"]["TextStrokeTransparency"] = 0;
G2L["25"]["BorderSizePixel"] = 0;
G2L["25"]["TextSize"] = 14;
G2L["25"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["25"]["TextScaled"] = true;
G2L["25"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["25"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["25"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["25"]["BackgroundTransparency"] = 1;
G2L["25"]["Size"] = UDim2.new(0.83117, 0, 0.98485, 0);
G2L["25"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["25"]["Text"] = [[OctoSpy]];
G2L["25"]["Name"] = [[Label]];
G2L["25"]["Position"] = UDim2.new(0.16883, 0, 0, 0);


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script1.UIGradient
G2L["26"] = Instance.new("UIGradient", G2L["21"]);
G2L["26"]["Rotation"] = 180;
G2L["26"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(17, 17, 17)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(53, 53, 53))};


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script2
G2L["27"] = Instance.new("Frame", G2L["5"]);
G2L["27"]["BorderSizePixel"] = 0;
G2L["27"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["27"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["27"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["27"]["Name"] = [[Script2]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script2.LocalScript
G2L["28"] = Instance.new("LocalScript", G2L["27"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script2.Button
G2L["29"] = Instance.new("TextButton", G2L["27"]);
G2L["29"]["BorderSizePixel"] = 0;
G2L["29"]["TextSize"] = 14;
G2L["29"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["29"]["SelectionOrder"] = 5;
G2L["29"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["29"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["29"]["BackgroundTransparency"] = 1;
G2L["29"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["29"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["29"]["Text"] = [[]];
G2L["29"]["Name"] = [[Button]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script2.Logo
G2L["2a"] = Instance.new("ImageLabel", G2L["27"]);
G2L["2a"]["BorderSizePixel"] = 0;
G2L["2a"]["ScaleType"] = Enum.ScaleType.Fit;
G2L["2a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2a"]["Image"] = [[rbxassetid://106021785006233]];
G2L["2a"]["Size"] = UDim2.new(0.16883, 0, 1, 0);
G2L["2a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2a"]["BackgroundTransparency"] = 1;
G2L["2a"]["Name"] = [[Logo]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script2.Label
G2L["2b"] = Instance.new("TextLabel", G2L["27"]);
G2L["2b"]["TextWrapped"] = true;
G2L["2b"]["TextStrokeTransparency"] = 0;
G2L["2b"]["BorderSizePixel"] = 0;
G2L["2b"]["TextSize"] = 14;
G2L["2b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["2b"]["TextScaled"] = true;
G2L["2b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2b"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["2b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2b"]["BackgroundTransparency"] = 1;
G2L["2b"]["Size"] = UDim2.new(0.83117, 0, 0.98485, 0);
G2L["2b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2b"]["Text"] = [[SimpleSpy]];
G2L["2b"]["Name"] = [[Label]];
G2L["2b"]["Position"] = UDim2.new(0.16883, 0, 0, 0);


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script2.UIGradient
G2L["2c"] = Instance.new("UIGradient", G2L["27"]);
G2L["2c"]["Rotation"] = 180;
G2L["2c"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(17, 17, 17)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(53, 53, 53))};


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script3
G2L["2d"] = Instance.new("Frame", G2L["5"]);
G2L["2d"]["BorderSizePixel"] = 0;
G2L["2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2d"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["2d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2d"]["Name"] = [[Script3]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script3.LocalScript
G2L["2e"] = Instance.new("LocalScript", G2L["2d"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script3.Button
G2L["2f"] = Instance.new("TextButton", G2L["2d"]);
G2L["2f"]["BorderSizePixel"] = 0;
G2L["2f"]["TextSize"] = 14;
G2L["2f"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2f"]["SelectionOrder"] = 5;
G2L["2f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["2f"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["2f"]["BackgroundTransparency"] = 1;
G2L["2f"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["2f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2f"]["Text"] = [[]];
G2L["2f"]["Name"] = [[Button]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script3.Logo
G2L["30"] = Instance.new("ImageLabel", G2L["2d"]);
G2L["30"]["BorderSizePixel"] = 0;
G2L["30"]["ScaleType"] = Enum.ScaleType.Fit;
G2L["30"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["30"]["Image"] = [[rbxassetid://106021785006233]];
G2L["30"]["Size"] = UDim2.new(0.16883, 0, 1, 0);
G2L["30"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["30"]["BackgroundTransparency"] = 1;
G2L["30"]["Name"] = [[Logo]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script3.Label
G2L["31"] = Instance.new("TextLabel", G2L["2d"]);
G2L["31"]["TextWrapped"] = true;
G2L["31"]["TextStrokeTransparency"] = 0;
G2L["31"]["BorderSizePixel"] = 0;
G2L["31"]["TextSize"] = 14;
G2L["31"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["31"]["TextScaled"] = true;
G2L["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["31"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["31"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["31"]["BackgroundTransparency"] = 1;
G2L["31"]["Size"] = UDim2.new(0.83117, 0, 0.98485, 0);
G2L["31"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["31"]["Text"] = [[TurtleSpy]];
G2L["31"]["Name"] = [[Label]];
G2L["31"]["Position"] = UDim2.new(0.16883, 0, 0, 0);


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script3.UIGradient
G2L["32"] = Instance.new("UIGradient", G2L["2d"]);
G2L["32"]["Rotation"] = 180;
G2L["32"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(17, 17, 17)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(53, 53, 53))};


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script4
G2L["33"] = Instance.new("Frame", G2L["5"]);
G2L["33"]["BorderSizePixel"] = 0;
G2L["33"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["33"]["Size"] = UDim2.new(0, 100, 0, 100);
G2L["33"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["33"]["Name"] = [[Script4]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script4.LocalScript
G2L["34"] = Instance.new("LocalScript", G2L["33"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script4.Button
G2L["35"] = Instance.new("TextButton", G2L["33"]);
G2L["35"]["BorderSizePixel"] = 0;
G2L["35"]["TextSize"] = 14;
G2L["35"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
G2L["35"]["SelectionOrder"] = 5;
G2L["35"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["35"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["35"]["BackgroundTransparency"] = 1;
G2L["35"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["35"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["35"]["Text"] = [[]];
G2L["35"]["Name"] = [[Button]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script4.Logo
G2L["36"] = Instance.new("ImageLabel", G2L["33"]);
G2L["36"]["BorderSizePixel"] = 0;
G2L["36"]["ScaleType"] = Enum.ScaleType.Fit;
G2L["36"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["36"]["Image"] = [[rbxassetid://106021785006233]];
G2L["36"]["Size"] = UDim2.new(0.16883, 0, 1, 0);
G2L["36"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["36"]["BackgroundTransparency"] = 1;
G2L["36"]["Name"] = [[Logo]];


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script4.Label
G2L["37"] = Instance.new("TextLabel", G2L["33"]);
G2L["37"]["TextWrapped"] = true;
G2L["37"]["TextStrokeTransparency"] = 0;
G2L["37"]["BorderSizePixel"] = 0;
G2L["37"]["TextSize"] = 14;
G2L["37"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["37"]["TextScaled"] = true;
G2L["37"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["37"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["37"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["37"]["BackgroundTransparency"] = 1;
G2L["37"]["Size"] = UDim2.new(0.83117, 0, 0.98485, 0);
G2L["37"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["37"]["Text"] = [[Dex Explorer]];
G2L["37"]["Name"] = [[Label]];
G2L["37"]["Position"] = UDim2.new(0.16883, 0, 0, 0);


-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script4.UIGradient
G2L["38"] = Instance.new("UIGradient", G2L["33"]);
G2L["38"]["Rotation"] = 180;
G2L["38"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromRGB(17, 17, 17)),ColorSequenceKeypoint.new(1.000, Color3.fromRGB(53, 53, 53))};


-- StarterGui.Ohyeah.Frame.TextLabel
G2L["39"] = Instance.new("TextLabel", G2L["2"]);
G2L["39"]["TextWrapped"] = true;
G2L["39"]["TextStrokeTransparency"] = 0;
G2L["39"]["BorderSizePixel"] = 0;
G2L["39"]["TextSize"] = 14;
G2L["39"]["TextScaled"] = true;
G2L["39"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["39"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["39"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["39"]["BackgroundTransparency"] = 1;
G2L["39"]["Size"] = UDim2.new(0, 318, 0, 44);
G2L["39"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["39"]["Text"] = [[ScriptHub]];


-- StarterGui.Ohyeah.Frame.UIStroke
G2L["3a"] = Instance.new("UIStroke", G2L["2"]);
G2L["3a"]["Thickness"] = 0.02;
G2L["3a"]["StrokeSizingMode"] = Enum.StrokeSizingMode.ScaledSize;
G2L["3a"]["Color"] = Color3.fromRGB(44, 44, 44);


-- StarterGui.Ohyeah.Frame.LocalScript
G2L["3b"] = Instance.new("LocalScript", G2L["2"]);



-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin2.LocalScript
local function C_8()
local script = G2L["8"];
	script.Parent.Button.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",true))
	end)
end;
task.spawn(C_8);
-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin.TextButton.LocalScript
local function C_10()
local script = G2L["10"];
	local guisVisible = true
	local label = script.Parent.Parent.Label
	local button = script.Parent
	local text = {
		["true"] = "▲Admin▲";
		["false"] = "▼Admin▼";
	}
	
	button.MouseButton1Click:Connect(function()
		guisVisible = not guisVisible
		for i,v in pairs(script.Parent.Parent.Parent:GetChildren()) do
			if v.Name ~= "Admin" and string.find(v.Name,"Admin") then
				v.Visible = guisVisible
				label.Text = text[tostring(guisVisible)]
			end
		end
	end)
end;
task.spawn(C_10);
-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin3.LocalScript
local function C_12()
local script = G2L["12"];
	script.Parent.Button.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua"))();
	end)
end;
task.spawn(C_12);
-- StarterGui.Ohyeah.Frame.ScrollingFrame.Admin1.LocalScript
local function C_18()
local script = G2L["18"];
	script.Parent.Button.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))()
	end)
end;
task.spawn(C_18);
-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script.TextButton.LocalScript
local function C_20()
local script = G2L["20"];
	local guisVisible = true
	local label = script.Parent.Parent.Label
	local button = script.Parent
	local text = {
		["true"] = "▲Scripting▲";
		["false"] = "▼Scripting▼";
	}
	
	button.MouseButton1Click:Connect(function()
		guisVisible = not guisVisible
		for i,v in pairs(script.Parent.Parent.Parent:GetChildren()) do
			if v.Name ~= "Script" and string.find(v.Name,"Script") then
				v.Visible = guisVisible
				label.Text = text[tostring(guisVisible)]
			end
		end
	end)
end;
task.spawn(C_20);
-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script1.LocalScript
local function C_22()
local script = G2L["22"];
	script.Parent.Button.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/InfernusScripts/Octo-Spy/refs/heads/main/Main.lua", true))()
	end)
end;
task.spawn(C_22);
-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script2.LocalScript
local function C_28()
local script = G2L["28"];
	script.Parent.Button.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))();
	end)
end;
task.spawn(C_28);
-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script3.LocalScript
local function C_2e()
local script = G2L["2e"];
	script.Parent.Button.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))();
	end)
end;
task.spawn(C_2e);
-- StarterGui.Ohyeah.Frame.ScrollingFrame.Script4.LocalScript
local function C_34()
local script = G2L["34"];
	script.Parent.Button.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
	end)
end;
task.spawn(C_34);
-- StarterGui.Ohyeah.Frame.LocalScript
local function C_3b()
local script = G2L["3b"];
	-- Simple Dragging Script - Makes script.Parent draggable
	-- Just put this script inside any Frame and it becomes draggable
	
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	
	local Frame = script.Parent
	
	local Dragging = false
	local DragInput
	local MousePos
	local FramePos
	
	Frame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			MousePos = Input.Position
			FramePos = Frame.Position
	
			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)
	
	Frame.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			DragInput = Input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - MousePos
	
			TweenService:Create(
				Frame, 
				TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), 
				{
					Position = UDim2.new(
						FramePos.X.Scale,
						FramePos.X.Offset + Delta.X, 
						FramePos.Y.Scale, 
						FramePos.Y.Offset + Delta.Y
					)
				}
			):Play()
		end
	end)
end;
task.spawn(C_3b);

return G2L["1"], require;
