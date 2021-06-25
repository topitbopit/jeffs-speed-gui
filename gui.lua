local JFR = loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/Jeff-2.3-Framework/main/lib.lua'))()


--[[indep from ui variables]]--
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextAction= game:GetService("ContextActionService")

local scriptversion = "2.2.2"
local plr = game.Players.LocalPlayer

local ws_speed = 30
local cf_speed = 30
local pa_speed = 30
local gl_speed = 30
local overdrive = 1
local gl_offset = 0

local gl_ind = true 
local gl_indcolor = Color3.fromHSV(0.6, 0.9, 0.9)
local gl_offset_reset = false

local chase_target = nil
local annoy_power = 9

local smoothcam = true

local gl_indpart = Instance.new("Part")
local gl_indpart_bb = Instance.new("BillboardGui")
local gl_indpart_tx = Instance.new("TextLabel")

gl_indpart.Transparency = 1
gl_indpart.Size = Vector3.new(1, 1, 1)
gl_indpart.Parent = game.Workspace
gl_indpart.Name = "GLIDEINDICATOR"
gl_indpart.Anchored = true
gl_indpart.CanCollide = false

gl_indpart_bb.Parent = gl_indpart
gl_indpart_bb.AlwaysOnTop = true
gl_indpart_bb.Size = UDim2.new(1, 25, 1, 25)
gl_indpart_bb.Enabled = false

gl_indpart_tx.Parent = gl_indpart_bb
gl_indpart_tx.BackgroundTransparency = 1
gl_indpart_tx.Font = Enum.Font.Nunito
gl_indpart_tx.Size = UDim2.new(1, 0, 1, 0)
gl_indpart_tx.Text = "x"
gl_indpart_tx.TextScaled = true
gl_indpart_tx.TextStrokeTransparency = 0
gl_indpart_tx.TextColor3 = gl_indcolor



local smoothcam_part = Instance.new("Part")

smoothcam_part.Transparency = 1
smoothcam_part.Size = Vector3.new(1, 1, 1)
smoothcam_part.Parent = game.Workspace
smoothcam_part.Name = "SMOOTHCAM"
smoothcam_part.Anchored = true
smoothcam_part.CanCollide = false

local hotkeytables = {
    PageDown = "PDn",
    PageUp = "PUp",
    RightShift = "<font size='15'>RShift</font>",
    LeftShift = "<font size='15'>LShift</font>",
    Return = "<font size='15'>REnter</font>",
    KeypadEnter = "<font size='15'>KPEnt</font>",
    KeypadOne = "KP1",
    KeypadTwo = "KP2",
    KeypadThree = "KP3",
    KeypadFour = "KP4",
    KeypadFive = "KP5",
    KeypadSix = "KP6",
    KeypadSeven = "KP7",
    KeypadEight = "KP8",
    KeypadNine = "KP9",
    KeypadZero = "KP0",
    CapsLock = "<font size='15'>Caps</font>",
    LeftAlt = "<font size='15'>LAlt</font>",
    RightAlt = "<font size='15'>RAlt</font>",
    RightControl = "<font size='15'>RCtrl</font>",
    LeftControl = "<font size='15'>LCtrl</font>",
    QuotedDouble = "<font size='15'>Quote</font>",
    Space = "<font size='15'>Spc</font>",
    Escape = "<font size='15'>Esc</font>",
    Delete = "<font size='15'>Del</font>"
}

local bindto = function(name, value,func) 
    name = name or "nil"
    value = value or Enum.RenderPriority.Character.Value + 2
    RunService:BindToRenderStep(name,value,func)
end
local unbindfrom = function(name)
    name = name or "nil"
    RunService:UnbindFromRenderStep(name) 
end

local bindaction = function(name, func, key)
    ContextAction:BindAction(name, function(a, b) if b == Enum.UserInputState.Begin then func() end end, false, key) 
end

local unbindaction = function(name)
    ContextAction:UnbindAction(name)

end


--local JFR = loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/Jeff-2.3-Framework/main/lib.lua', true))()

local newhotkey = function(name, parent, args, bound, unbound)
    local f = JFR.NewTextBox(name.."Hotkey", parent, args, function() 
        
        local tb = JFR.GetInstance(name.."Hotkey")
        local t = tb.Text
        if t:len() == 1 then
            t = t:upper() 
        end
        
        if pcall(function() return Enum.KeyCode[t] end) then
            h = Enum.KeyCode[t]
            if ("Hotkey: "..h.Name):len() >= 13 then
                local temp = h.Name:gsub("%l","", 4)
                    
                if hotkeytables[h.Name] then
                    tb.Text = "Hotkey: "..hotkeytables[h.Name]
                else
                    tb.Text = "Hotkey: <font size='"..tostring(20 - temp:len()).."'>"..temp.."</font>"
                
                end
            else
                tb.Text = "Hotkey: "..h.Name
            end
            
            bindaction(name.."Hotkey",function()
                JFR.SetInstanceValue(name, not JFR.GetInstanceValue(name))
                if JFR.GetInstanceValue(name) then
                    JFR.OpenObject(JFR.GetInstance(name))
                    bound()
                else
                    JFR.CloseObject(JFR.GetInstance(name))
                    unbound()
                end
                
            
            end, h)
        else
            tb.Text = "No hotkey"
            unbindaction(name.."Hotkey")
        end
    end)
    
end

local function NewSelector(size, place, parent)
    size = size or 7 
    place = place or 0
    parent = parent or nil
    local f = Instance.new("ImageLabel")
    f.Image = "rbxassetid://6956257983"
    f.Size = UDim2.new(0, size, 0, size)
    f.Position = UDim2.new(0, place, 0, 0)
    f.BackgroundTransparency = 1
    f.ZIndex = 280    
    f.Parent = parent
    return f
end

local function NewlineOnLabel(inst)
    JFR.NewBoard("", inst.Parent, {Position = UDim2.new(0, 30 + inst.TextBounds.X, 0, inst.Position.Y.Offset+12.5), Size = UDim2.new(0, 360 - inst.TextBounds.X,0, 2), BackgroundColor3 = JFR.Theme.shade7, ZIndex = 200})
end

local function NewLine(inst, y)
    JFR.NewBoard("", inst, {Position = UDim2.new(0, 10, 0, y), Size = UDim2.new(0, 380, 0, 2), BackgroundColor3 = JFR.Theme.shade7, ZIndex = 200})
end

local function StartGradient(parent, y, x)
    x = x or 400
    y = y or 2
    
    local f = Instance.new("ImageLabel")
    f.Image = "rbxassetid://6947150722"
    f.Position = UDim2.new(0, 2, 0, y)
    f.Parent = parent
    f.Size = UDim2.new(0, x, 0, 50)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.ZIndex = 125
end
local function EndGradient(parent, y, x)
    x = x or 400
    y = y or -50
    
    local f = Instance.new("ImageLabel")
    f.Image = "rbxassetid://6947474904"
    f.Position = UDim2.new(0, 2, 1, y)
    f.Parent = parent
    f.Size = UDim2.new(0, x, 0, 50)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.ZIndex = 125
end

JFR.SetFont(Enum.Font["Nunito"])
JFR.SetBold(false)
JFR.SetRoundAmount(7)
JFR.SetRoundifyEnabled(true)

local num = math.random(7, 10) / 10
JFR.SetTheme({r = num, g = num, b = num + (math.random(1,4) / 10)})



--init y values
local y = 15;
local page = "Page_Home"

--Screen gui
local screen = JFR.GetScreen()
screen.Name = "jspeed-"..scriptversion

--Background
local bg = JFR.NewBoard("no", screen, {Position = UDim2.new(0.7, 0, 1.3, 0), Size = UDim2.new(0, 500, 0, 250), Nodrag = true}, true)
local parentb = JFR.GetParentBoard()



--Extra gui stuff
JFR.NewText("Title", bg, {Position = UDim2.new(0, 15, 0, 15), Size = UDim2.new(0, 400, 0, 25), Text = "Jeff Speed GUI <font size='15'>v"..scriptversion.."</font>", TextSize = 35, TextYAlignment = Enum.TextYAlignment.Center})
JFR.NewBoard("Shadow", bg, {ZIndex = 0, Position = UDim2.new(0, 3, 0, 3), Size = UDim2.new(0, 500, 0, 265), BackgroundTransparency = 0.3, BackgroundColor3 = JFR.Theme.shadow})
JFR.NewBoard("Roundedbottom1", bg, {Position = UDim2.new(0, 0, 1, -10), Size = UDim2.new(0, 125, 0, 25), BackgroundColor3 = JFR.Theme.shade4})
JFR.NewBoard("Roundedbottom2", bg, {Position = UDim2.new(0, 100, 1, -10), Size = UDim2.new(0, 25, 0, 25), BackgroundColor3 = JFR.Theme.shade3, Unroundify = true})
JFR.NewBoard("Roundedbottom3", bg, {Position = UDim2.new(0, 115, 1, -10), Size = UDim2.new(0, 385, 0, 25), BackgroundColor3 = JFR.Theme.shade3})
JFR.NewBoard("Outline1", bg, {Position = UDim2.new(0, 100, 0, 50), Size = UDim2.new(0, 2, 0, 200), BackgroundColor3 = JFR.Theme.shade6, ZIndex = 200})
JFR.NewBoard("Outline2", bg, {Position = UDim2.new(0, 0, 0, 50), Size = UDim2.new(0, 500, 0, 2), BackgroundColor3 = JFR.Theme.shade6, ZIndex = 200})

--Menus
local page_home = JFR.NewMenu("Page_Home", bg, {Position = UDim2.new(0, 100, 0, 250), CanvasSize = UDim2.new(0, 100, 0, 100)})
local page_mods = JFR.NewMenu("Page_Mods", bg, {Position = UDim2.new(0, 100, 0, 250), CanvasSize = UDim2.new(0, 100, 0, 450), Invisible = true})
local page_keys = JFR.NewMenu("Page_Keys", bg, {Position = UDim2.new(0, 100, 0, 250), CanvasSize = UDim2.new(0, 100, 0, 100), Invisible = true})
local page_sett = JFR.NewMenu("Page_Settings", bg, {Position = UDim2.new(0, 100, 0, 250), CanvasSize = UDim2.new(0, 100, 0, 400), Invisible = true})
local page_info = JFR.NewMenu("Page_Info", bg, {Position = UDim2.new(0, 100, 0, 250), CanvasSize = UDim2.new(0, 100, 0, 800), Invisible = true})


--Tabs
local menu_tabs = JFR.NewMenu("Menu_Tabs", bg, {Position = UDim2.new(0, 0, 0, 250), Size = UDim2.new(0, 100, 0, 200), CanvasSize = UDim2.new(0, 80, 0, 100), BackgroundColor3 = JFR.Theme.shade4})
JFR.NewButton("Tab_Home", menu_tabs, {Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 75, 0, 25), Text = "Home"}, {on = function() 
    JFR.OpenObject(JFR.GetInstance("Tab_Home"));
    JFR.CloseObject(JFR.GetInstance("Tab_Mods"));
    JFR.CloseObject(JFR.GetInstance("Tab_Keys"));
    JFR.CloseObject(JFR.GetInstance("Tab_Settings"));
    JFR.CloseObject(JFR.GetInstance("Tab_Misc"));

    JFR.GetInstance("Page_Home").Visible = true
    JFR.GetInstance("Page_Mods").Visible = false
    JFR.GetInstance("Page_Keys").Visible = false
    JFR.GetInstance("Page_Settings").Visible = false
    JFR.GetInstance("Page_Info").Visible = false
    
    page = "Page_Home"
end})
JFR.OpenObject(JFR.GetInstance("Tab_Home"))
y=y+40;
JFR.NewButton("Tab_Mods", menu_tabs, {Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 75, 0, 25), Text = "Mods"}, {on = function()
    JFR.CloseObject(JFR.GetInstance("Tab_Home"));
    JFR.OpenObject(JFR.GetInstance("Tab_Mods"));
    JFR.CloseObject(JFR.GetInstance("Tab_Keys"));
    JFR.CloseObject(JFR.GetInstance("Tab_Settings"));
    JFR.CloseObject(JFR.GetInstance("Tab_Misc"));

    JFR.GetInstance("Page_Home").Visible = false
    JFR.GetInstance("Page_Mods").Visible = true
    JFR.GetInstance("Page_Keys").Visible = false
    JFR.GetInstance("Page_Settings").Visible = false
    JFR.GetInstance("Page_Info").Visible = false
    
    page = "Page_Mods"
end})
y=y+40;
JFR.NewButton("Tab_Keys", menu_tabs, {Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 75, 0, 25), Text = "Hotkeys"}, {on = function() 
    JFR.CloseObject(JFR.GetInstance("Tab_Home"));
    JFR.CloseObject(JFR.GetInstance("Tab_Mods"));
    JFR.OpenObject(JFR.GetInstance("Tab_Keys"));
    JFR.CloseObject(JFR.GetInstance("Tab_Settings"));
    JFR.CloseObject(JFR.GetInstance("Tab_Misc"));

    JFR.GetInstance("Page_Home").Visible = false
    JFR.GetInstance("Page_Mods").Visible = false
    JFR.GetInstance("Page_Keys").Visible = true
    JFR.GetInstance("Page_Settings").Visible = false
    JFR.GetInstance("Page_Info").Visible = false
    
    page = "Page_Keys"
end})
y=y+40;
JFR.NewButton("Tab_Settings", menu_tabs, {Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 75, 0, 25), Text = "Settings"}, {on = function() 
    JFR.CloseObject(JFR.GetInstance("Tab_Home"));
    JFR.CloseObject(JFR.GetInstance("Tab_Mods"));
    JFR.CloseObject(JFR.GetInstance("Tab_Keys"));
    JFR.OpenObject(JFR.GetInstance("Tab_Settings"));
    JFR.CloseObject(JFR.GetInstance("Tab_Misc"));

    JFR.GetInstance("Page_Home").Visible = false
    JFR.GetInstance("Page_Mods").Visible = false
    JFR.GetInstance("Page_Keys").Visible = false
    JFR.GetInstance("Page_Settings").Visible = true
    JFR.GetInstance("Page_Info").Visible = false
    
    page = "Page_Settings"
end})
y=y+40;
JFR.NewButton("Tab_Misc", menu_tabs, {Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 75, 0, 25), Text = "Info"}, {on = function() 
    JFR.CloseObject(JFR.GetInstance("Tab_Home"));
    JFR.CloseObject(JFR.GetInstance("Tab_Mods"));
    JFR.CloseObject(JFR.GetInstance("Tab_Keys"));
    JFR.CloseObject(JFR.GetInstance("Tab_Settings"));
    JFR.OpenObject(JFR.GetInstance("Tab_Misc"));

    JFR.GetInstance("Page_Home").Visible = false
    JFR.GetInstance("Page_Mods").Visible = false
    JFR.GetInstance("Page_Keys").Visible = false
    JFR.GetInstance("Page_Settings").Visible = false
    JFR.GetInstance("Page_Info").Visible = true
    
    page = "Page_Info"
end})

JFR.NewButton("MinimizeButton", bg, {Position = UDim2.new(1, -60, 0, 5), Size = UDim2.new(0, 25, 0, 25), BackgroundColor3 = JFR.Theme.shade7, Text = "-", TextSize = 14}, {
    on = function()
        JFR.GetInstance("MinimizeButton").Text = "+"
        
        JFR.TweenSize(parentb, UDim2.new(0, parentb.Size.X.Offset, 0, 50), 0.75, Enum.EasingDirection.Out)
        JFR.TweenSize(JFR.GetInstance("Shadow"), UDim2.new(0, parentb.Size.X.Offset, 0, 50), 0.75, Enum.EasingDirection.Out)
        
        local function YoMom(a)
            JFR.Async(function() 
                JFR.TweenSize(a, UDim2.new(a.Size.X.Scale, a.Size.X.Offset, a.Size.Y.Scale, 0), 0.75, Enum.EasingDirection.Out)
                wait(0.75)
                if a.Size.Y.Offset == 0 then 
                    a.Visible = false
                end
            end)
        end
        YoMom(JFR.GetInstance("Page_Home"))
        YoMom(JFR.GetInstance("Page_Info"))
        YoMom(JFR.GetInstance("Page_Keys"))
        YoMom(JFR.GetInstance("Page_Mods"))
        YoMom(JFR.GetInstance("Page_Settings"))
        YoMom(JFR.GetInstance("Menu_Tabs"))
        
        YoMom(JFR.GetInstance("Outline1"))
        YoMom(JFR.GetInstance("Outline2"))
        
        YoMom(JFR.GetInstance("Roundedbottom3"))
        YoMom(JFR.GetInstance("Roundedbottom2"))
        YoMom(JFR.GetInstance("Roundedbottom1"))

    end,
    off = function() 
        JFR.GetInstance("MinimizeButton").Text = "-"
        local function YorMom(a, y)
            JFR.Async(function()
                a.Visible = true
                JFR.TweenSize(a, UDim2.new(a.Size.X.Scale, a.Size.X.Offset, a.Size.Y.Scale, y), 0.75, Enum.EasingDirection.Out)
            end)
        end
        
        JFR.TweenSize(parentb, UDim2.new(0, parentb.Size.X.Offset, 0, 250), 0.75, Enum.EasingDirection.Out)
        JFR.TweenSize(JFR.GetInstance("Shadow"), UDim2.new(0, parentb.Size.X.Offset, 0, 265), 0.75, Enum.EasingDirection.Out)
    
        YorMom(JFR.GetInstance("Page_Home"), 200)
        YorMom(JFR.GetInstance("Page_Info"), 200)
        YorMom(JFR.GetInstance("Page_Keys"), 200)
        YorMom(JFR.GetInstance("Page_Mods"), 200)
        YorMom(JFR.GetInstance("Page_Settings"), 200)
        YorMom(JFR.GetInstance("Menu_Tabs"), 200)
        
        
        JFR.GetInstance("Page_Home"    ).Visible = false
        JFR.GetInstance("Page_Info"    ).Visible = false
        JFR.GetInstance("Page_Keys"  ).Visible = false
        JFR.GetInstance("Page_Mods"    ).Visible = false
        JFR.GetInstance("Page_Settings"    ).Visible = false
        JFR.GetInstance(page).Visible = true
        
    
        YorMom(JFR.GetInstance("Outline1"), 200)
        YorMom(JFR.GetInstance("Outline2"), 2)
    
        YorMom(JFR.GetInstance("Roundedbottom1"), 25)
        YorMom(JFR.GetInstance("Roundedbottom2"), 25)
        YorMom(JFR.GetInstance("Roundedbottom3"), 25)


    end
})

JFR.NewButton("CloseButton", bg, {Position = UDim2.new(1, -30, 0, 5), Size = UDim2.new(0, 25, 0, 25), BackgroundColor3 = JFR.Theme.shade7, Text = "X", TextSize = 14}, {on = function()
    JFR.TweenPosition(parentb, UDim2.new(parentb.Position.X.Scale, parentb.Position.X.Offset, 1.1, 0), 0.75, Enum.EasingDirection.In)
    JFR.TweenCustom(parentb, {Size = UDim2.new(0, parentb.Size.X.Offset, 0, 0)}, 0.75, Enum.EasingDirection.In)
    wait(0.25)
    JFR.FadeOut(parentb, 1)
    wait(0.5)
    screen:Destroy() 
    
    
    unbindaction("SpeedCFrameHotkey")
    unbindaction("SpeedWsHotkey")
    unbindaction("SpeedGlideHotkey")
    unbindaction("SpeedPartHotkey")
    
    
    unbindfrom("jspeed-gl") 
    pcall(function() glidepart:Destroy() end)
    gl_indpart:Destroy()
    
    unbindfrom("jspeed-pa")
    pcall(function() speedpart:Destroy() end)
    
    unbindfrom("jspeed-ws")
    unbindfrom("jspeed-cf")
    
    unbindfrom("jspeed-smoothcam")
    pcall(function() smoothcam_part:Destroy() end)
    
    game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
    pcall(function() plr.Character.HumanoidRootPart.BodyPosition:Destroy() end)
end})


StartGradient(JFR.GetInstance("Page_Home"))
EndGradient(JFR.GetInstance("Page_Home"))

StartGradient(JFR.GetInstance("Page_Info"))
EndGradient(JFR.GetInstance("Page_Info"))

StartGradient(JFR.GetInstance("Page_Keys"))
EndGradient(JFR.GetInstance("Page_Keys"))

StartGradient(JFR.GetInstance("Page_Mods"))
EndGradient(JFR.GetInstance("Page_Mods"))

StartGradient(JFR.GetInstance("Page_Settings"))
EndGradient(JFR.GetInstance("Page_Settings"))

y=5;
JFR.NewText("HomeText1", page_home, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Home", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("HomeText1"))

y=y+30;
JFR.NewText("HomeText2", page_home, {Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(0, 400, 0, 75), Text = " Jeff Speed GUI made by topit<br/>Check out what the new features are in the <b>info</b> tab<br/><br/>Join the discord: <br/><br/><br/><br/>Version "..scriptversion, TextSize = 20})
NewLine(page_home, 165)

JFR.NewButton("HomeDiscord", page_home, {Position = UDim2.new(0.075, 0, 0, 120), Size = UDim2.new(0, 340, 0, 25), Text = "Copy invite to clipboard"}, {on = function() setclipboard("https://discord.gg/XsHXPZSAae") JFR.Async(function() JFR.GetInstance("HomeDiscord").Text = "Copied" wait(1) JFR.GetInstance("HomeDiscord").Text = "Copy invite to clipboard" end) end})

y=5;
JFR.NewText("SpeedText1", page_mods, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Modules", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("SpeedText1"))
y=y+30;

JFR.NewButton("SpeedWs", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Walkspeed <font size='10'>("..tostring(ws_speed)..")</font>", TextSize = 20}, {on = function() 
    bindto("jspeed-ws",Enum.RenderPriority.Character.Value + 5, function() 
        plr.Character.Humanoid.WalkSpeed = ws_speed * overdrive
    end) 
end, off = function() 
RunService:UnbindFromRenderStep("jspeed-ws") 
plr.Character.Humanoid.WalkSpeed = 16
end})

JFR.NewBoard("SpeedWsSlider", page_mods, {Position = UDim2.new(0.375, 0, 0, y+9), Size = UDim2.new(0, 220, 0, 7), ZIndex = 200})

local sel = NewSelector(10, ws_speed)
local ws_vals = {}
sel.Parent = JFR.GetInstance("SpeedWsSlider")
JFR.MakeSlider(sel, JFR.GetInstance("SpeedWsSlider"), ws_vals, function() 
    ws_speed = ws_vals[3]
    JFR.GetInstance("SpeedWs").Text="Walkspeed <font size='10'>("..tostring(ws_speed)..")</font>"
end, true)


y=y+30;



JFR.NewButton("SpeedCFrame", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "CFrame <font size='10'>("..tostring(cf_speed)..")</font>", TextSize = 20}, {on = function() 
    bindto("jspeed-cf",Enum.RenderPriority.Character.Value + 5, function() 
        plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + (plr.Character.Humanoid.MoveDirection * ((cf_speed / 50) * overdrive))
    end) 
end, off = function() 
RunService:UnbindFromRenderStep("jspeed-cf") 
end})

JFR.NewBoard("SpeedCFrameSlider", page_mods, {Position = UDim2.new(0.375, 0, 0, y+9), Size = UDim2.new(0, 220, 0, 7), ZIndex = 200})

sel = NewSelector(10, cf_speed)
local cf_vals = {}
sel.Parent = JFR.GetInstance("SpeedCFrameSlider")
JFR.MakeSlider(sel, JFR.GetInstance("SpeedCFrameSlider"), cf_vals, function() 
    cf_speed = cf_vals[3]
    JFR.GetInstance("SpeedCFrame").Text="CFrame <font size='10'>("..tostring(cf_speed)..")</font>"
end, true)
y=y+30;




JFR.NewButton("SpeedPart", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Part <font size='10'>("..tostring(pa_speed)..")</font>", TextSize = 20}, {on = function() 
    speedpart = Instance.new("Part")
    speedpart.Parent = game.Workspace
    speedpart.Name = "loolollo"
    speedpart.CanCollide = true
    speedpart.Transparency = 0.5
    bindto("jspeed-pa",Enum.RenderPriority.Character.Value + 5, function() 
    
        speedpart.CFrame = plr.Character.HumanoidRootPart.CFrame - plr.Character.HumanoidRootPart.CFrame.LookVector
        speedpart.Velocity = plr.Character.HumanoidRootPart.CFrame.LookVector * ((pa_speed * 1.5) * overdrive)
    end) 
end, off = function() 
RunService:UnbindFromRenderStep("jspeed-pa")
speedpart:Destroy()
end})

JFR.NewBoard("SpeedPartSlider", page_mods, {Position = UDim2.new(0.375, 0, 0, y+9), Size = UDim2.new(0, 220, 0, 7), ZIndex = 200})

sel = NewSelector(10, pa_speed)
local pa_vals = {}
sel.Parent = JFR.GetInstance("SpeedPartSlider")
JFR.MakeSlider(sel, JFR.GetInstance("SpeedPartSlider"), pa_vals, function() 
    pa_speed = pa_vals[3]
    JFR.GetInstance("SpeedPart").Text="Part <font size='10'>("..tostring(pa_speed)..")</font>"
end, true)




y=y+30;


JFR.NewButton("SpeedGlide", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Glide <font size='10'>("..tostring(gl_speed)..")</font>", TextSize = 20}, {on = function() 
    glidepart = Instance.new("BodyPosition")
    glidepart.Parent = plr.Character.HumanoidRootPart
    glidepart.D = 9999
    glidepart.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    glidepart.P = 1234567
    glidepart.Position = plr.Character.HumanoidRootPart.Position
    
    gl_indpart_bb.Enabled = gl_ind
    if gl_offset_reset then
        gl_offset = 0
        JFR.GetInstance("GlideOffset").Text = "Glide vertical offset: "..tostring(gl_offset)
        JFR.TweenCustom(glideoffsetsel, {Position = UDim2.new(0, 70, glideoffsetsel.Position.Y.Scale,glideoffsetsel.Position.Y.Offset )}, 0.25)
    end
    
    local y = glidepart.Position.Y
    bindto("jspeed-gl",Enum.RenderPriority.Character.Value + 5, function()
        local v = glidepart.Position + (plr.Character.Humanoid.MoveDirection * ((gl_speed / 50) * overdrive))
        glidepart.Position = Vector3.new(v.X, y+gl_offset, v.Z)
        gl_indpart.Position = glidepart.Position
        
    end) 
    
end, off = function() 
    RunService:UnbindFromRenderStep("jspeed-gl")
    glidepart:Destroy()
    gl_indpart_bb.Enabled = false
    pcall(function() plr.Character.HumanoidRootPart.BodyPosition:Destroy() end)
end})

JFR.NewBoard("GlideSlider", page_mods, {Position = UDim2.new(0.375, 0, 0, y+9), Size = UDim2.new(0, 220, 0, 7), ZIndex = 200})

sel = NewSelector(10, gl_speed)
local gl_vals = {}
sel.Parent = JFR.GetInstance("GlideSlider")
JFR.MakeSlider(sel, JFR.GetInstance("GlideSlider"), gl_vals, function() 
    gl_speed = gl_vals[3]
    JFR.GetInstance("SpeedGlide").Text="Glide <font size='10'>("..tostring(gl_speed):sub(1,5)..")</font>"
end, true)

y=y+30;

JFR.NewText("GlideOffset", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Glide vertical offset: "..tostring(gl_offset), TextSize = 20})

JFR.NewBoard("GlideOffsetSlider", page_mods, {Position = UDim2.new(0.55, 0, 0, y+9), Size = UDim2.new(0, 150, 0, 7), ZIndex = 200})

y=y+30;
JFR.NewText("SpeedOverdrive", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Overdrive multiplier: "..tostring(overdrive), TextSize = 20})

JFR.NewBoard("SpeedOverdriveSlider", page_mods, {Position = UDim2.new(0.55, 0, 0, y+9), Size = UDim2.new(0, 150, 0, 7), ZIndex = 200})

sel = NewSelector(10, (overdrive/25)+1)
local ov_vals = {}
sel.Parent = JFR.GetInstance("SpeedOverdriveSlider")
JFR.MakeSlider(sel, JFR.GetInstance("SpeedOverdriveSlider"), ov_vals, function() 
    overdrive = (ov_vals[3] / 20) + 1
    JFR.GetInstance("SpeedOverdrive").Text="Overdrive multiplier: "..tostring(overdrive)
end, true)

glideoffsetsel = NewSelector(10, (gl_offset)+70)
local glo_vals = {}
glideoffsetsel.Parent = JFR.GetInstance("GlideOffsetSlider")
JFR.MakeSlider(glideoffsetsel, JFR.GetInstance("GlideOffsetSlider"), glo_vals, function() 
    gl_offset = (glo_vals[3])-70
    JFR.GetInstance("GlideOffset").Text="Glide vertical offset: "..tostring(gl_offset)
end, true)



y=y+30;
JFR.NewText("MiscText1", page_mods, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Misc", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("MiscText1"))
y=y+30;

JFR.NewButton("PlayerAnnoy", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Fling player", TextSize = 20}, {on = function() 
    
    if pcall(function() return chase_target.Character.Head end) then
        game.Workspace.CurrentCamera.CameraSubject = chase_target.Character.Humanoid
        annoy_connection = chase_target.CharacterAdded:Connect(function() 
            game.Workspace.CurrentCamera.CameraSubject = chase_target.Character:WaitForChild("Humanoid", 1)
        end)
    end
    if glidepart then glidepart:Destroy() end
    
    glidepart = Instance.new("BodyPosition")
    glidepart.Parent = plr.Character.HumanoidRootPart
    glidepart.D = 451 - annoy_power
    glidepart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    glidepart.P = 9999999 + (annoy_power * 100000)
    glidepart.Position = plr.Character.HumanoidRootPart.Position
    pcall(function() glidepart.Position = chase_target.Character.HumanoidRootPart.Position end)
    
    
    gl_indpart_bb.Enabled = gl_ind
    
    bindto("jspeed-gl",Enum.RenderPriority.Character.Value + 5, function()
        pcall(function() glidepart.Position = chase_target.Character.HumanoidRootPart.Position + Vector3.new(math.random(-annoy_power/50, annoy_power/50) + 1, math.random(-annoy_power/100, annoy_power/100), math.random(-annoy_power/50, annoy_power/50) + 1) end)
        gl_indpart.Position = glidepart.Position
        
    end)
end, off = function() 
    RunService:UnbindFromRenderStep("jspeed-gl")
    gl_indpart_bb.Enabled = false
    
    pcall(function() annoy_connection:Disconnect() end)
    game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
    
    glidepart.D = 9999
    wait()
    glidepart:Destroy()
    for i,v in pairs(plr.Character:GetDescendants()) do
        pcall(function() 
            v.Velocity = Vector3.new(0, 0, 0)
            v.RotVelocity = Vector3.new(0, 0, 0) 
        end)
    end
    pcall(function() plr.Character.HumanoidRootPart.BodyPosition:Destroy() end)
end})
JFR.NewTextBox("PlayerBox", page_mods, {Position = UDim2.new(0.375, 0, 0, y), Size = UDim2.new(0, 220, 0, 25), Text = "Enter a player", ClearTextOnFocus = true, TextSize = 18}, function()
    local plrs = {}
    chase_target = nil
    local text = JFR.GetInstance("PlayerBox").Text:lower()
    JFR.GetInstance("PlayerBox").Text = "Scanning..."
    
    
    for _,v in pairs(game.Players:GetChildren()) do
        if v.Name:lower():match(text) then
            table.insert(plrs, v)
        end
    end
    
    local count = table.getn(plrs)
    
    if count > 1 then
        for _,v in pairs(plrs) do
            if v.Name:lower():sub(1,#text) == text then
                chase_target = v
                JFR.GetInstance("PlayerBox").Text = "Chose <font color='rgb(255,255,135)'>"..chase_target.Name.."</font><font size='10'> ("..count.." matches)</font>"
                break
            end
        end
        
        if chase_target == nil then 
            chase_target = plrs[1]
            JFR.GetInstance("PlayerBox").Text = "Chose <font color='rgb(255,255,135)'>"..chase_target.Name.."</font><font size='10'> ("..count.." matches)</font>"
        end
        
    elseif count == 1 then
        chase_target = plrs[1]
        JFR.GetInstance("PlayerBox").Text = "Got <font color='rgb(255,255,135)'>"..chase_target.Name.."</font><font size='10'> ("..count.." match)</font>"
    else
        JFR.GetInstance("PlayerBox").Text = "No players found"
    end
end)

y=y+30;
JFR.NewText("PASliderT", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Fling power: "..tostring(annoy_power), TextSize = 20})

JFR.NewBoard("PASlider", page_mods, {Position = UDim2.new(0.375, 0, 0, y+9), Size = UDim2.new(0, 220, 0, 5), ZIndex = 180})


local avalues = {false, nil, 60, 0}

JFR.MakeSlider(NewSelector(10, 4, JFR.GetInstance("PASlider")), JFR.GetInstance("PASlider"), avalues, function() 
    annoy_power = 1 + (avalues[3] * 2)
    JFR.GetInstance("PASliderT").Text = "Fling power: "..tostring(annoy_power)
end, true)

y=y+50;

JFR.NewButton("Flight", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Flight", TextSize = 20}, {on = function() 
    glidepart = Instance.new("BodyPosition")
    glidepart.Parent = plr.Character.HumanoidRootPart
    glidepart.D = 9999
    glidepart.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    glidepart.P = 1234567
    glidepart.Position = plr.Character.HumanoidRootPart.Position
    
    
    gl_indpart_bb.Enabled = gl_ind
    
    bindto("jspeed-gl",Enum.RenderPriority.Character.Value + 5, function()
        local humrp = plr.Character.HumanoidRootPart
        glidepart.Position = (CFrame.new(glidepart.Position, glidepart.Position + game.Workspace.Camera.CFrame.LookVector) * (UserInputService:IsKeyDown(Enum.KeyCode.D) and CFrame.new(((gl_speed / 50) * overdrive), 0, 0) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.S) and CFrame.new(0, 0, ((gl_speed / 50) * overdrive)) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.A) and CFrame.new(-((gl_speed / 50) * overdrive), 0, 0) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.W) and CFrame.new(0, 0, -((gl_speed / 50) * overdrive)) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.Q) and CFrame.new(0, -((gl_speed / 50) * overdrive), 0) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.E) and CFrame.new(0, ((gl_speed / 50) * overdrive), 0) or CFrame.new(0, 0, 0))).Position
        gl_indpart.Position = glidepart.Position
        
    end)
end, off = function() 
    RunService:UnbindFromRenderStep("jspeed-gl")
    gl_indpart_bb.Enabled = false
    
    glidepart:Destroy()
    pcall(function() plr.Character.HumanoidRootPart.BodyPosition:Destroy() end)
end})

JFR.NewButton("Flightfling", page_mods, {Position = UDim2.new(0.375, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Fling (fly)", TextSize = 20}, {on = function() 
    game.Workspace.CurrentCamera.CameraSubject = gl_indpart
    
    glidepart = Instance.new("BodyPosition")
    glidepart.Parent = plr.Character.HumanoidRootPart
    glidepart.D = 451 - annoy_power
    glidepart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    glidepart.P = 9999999 + (annoy_power * 100000)
    glidepart.Position = plr.Character.HumanoidRootPart.Position
    local pos = plr.Character.HumanoidRootPart.CFrame
    
    
    gl_indpart_bb.Enabled = gl_ind
    
    bindto("jspeed-gl",Enum.RenderPriority.Character.Value + 5, function()
        game.Workspace.CurrentCamera.CameraSubject = gl_indpart
        pos = (CFrame.new(pos.Position, pos.Position + game.Workspace.Camera.CFrame.LookVector) * (UserInputService:IsKeyDown(Enum.KeyCode.D) and CFrame.new(((gl_speed / 50) * overdrive), 0, 0) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.S) and CFrame.new(0, 0, ((gl_speed / 50) * overdrive)) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.A) and CFrame.new(-((gl_speed / 50) * overdrive), 0, 0) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.W) and CFrame.new(0, 0, -((gl_speed / 50) * overdrive)) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.Q) and CFrame.new(0, -((gl_speed / 50) * overdrive), 0) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.E) and CFrame.new(0, ((gl_speed / 50) * overdrive), 0) or CFrame.new(0, 0, 0)))--.Position
        glidepart.Position = pos.Position + Vector3.new(math.random(-annoy_power/50, annoy_power/50) + 1, math.random(-annoy_power/100, annoy_power/100), math.random(-annoy_power/50, annoy_power/50) + 1)
        gl_indpart.Position = pos.Position
        
    end)
end, off = function() 
    RunService:UnbindFromRenderStep("jspeed-gl")
    gl_indpart_bb.Enabled = false
    
    glidepart.D = 9999
    wait()
    glidepart:Destroy()
    for i,v in pairs(plr.Character:GetDescendants()) do
        pcall(function() 
            v.Velocity = Vector3.new(0, 0, 0)
            v.RotVelocity = Vector3.new(0, 0, 0) 
        end)
    end
    pcall(function() plr.Character.HumanoidRootPart.BodyPosition:Destroy() end)
    
    pcall(function() game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid end)
end})
JFR.NewButton("Flightfling", page_mods, {Position = UDim2.new(0.675, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Fling all", TextSize = 20}, {on = function() 
    game.Workspace.CurrentCamera.CameraSubject = gl_indpart
    
    glidepart = Instance.new("BodyPosition")
    glidepart.Parent = plr.Character.HumanoidRootPart
    glidepart.D = 451 - annoy_power
    glidepart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    glidepart.P = 9999999 + (annoy_power * 1000)
    glidepart.Position = plr.Character.HumanoidRootPart.Position
    local pos = plr.Character.HumanoidRootPart.CFrame
    
    
    gl_indpart_bb.Enabled = gl_ind

    chase_target = plr
    
    bindto("jspeed-gl",Enum.RenderPriority.Character.Value + 5, function()
        pcall(function() glidepart.Position = chase_target.Character.HumanoidRootPart.Position + Vector3.new(math.random(-3,3), math.random(-3,3), math.random(-3,3)) + chase_target.Character.Humanoid.MoveDirection end)
        pcall(function() gl_indpart.Position = chase_target.Character.HumanoidRootPart.Position end)
        
    end)

    for i,v in pairs(game:GetService("Players"):GetChildren()) do
        if pcall(function() return v.Character.Head end) then
            chase_target = v

            wait(0.2)
        end
    end

    RunService:UnbindFromRenderStep("jspeed-gl")
    gl_indpart_bb.Enabled = false
    
    pcall(function() 
        glidepart.D = 9999
        glidepart.Position = gl_indpart.Position + Vector3.new(0, 80, 0)
    end)
    wait(0.5)
    glidepart:Destroy()
    for i,v in pairs(plr.Character:GetDescendants()) do
        pcall(function() 
            v.Velocity = Vector3.new(0, 0, 0)
            v.RotVelocity = Vector3.new(0, 0, 0) 
        end)
    end
    pcall(function() plr.Character.HumanoidRootPart.BodyPosition:Destroy() end)
    
    pcall(function() game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid end)
end, off = function() 
    RunService:UnbindFromRenderStep("jspeed-gl")
    gl_indpart_bb.Enabled = false
    
    pcall(function() 
        glidepart.D = 9999
        glidepart.Position = gl_indpart.Position + Vector3.new(0, 80, 0)
    end)
    wait(0.3)
    glidepart:Destroy()
    for i,v in pairs(plr.Character:GetDescendants()) do
        pcall(function() 
            v.Velocity = Vector3.new(0, 0, 0)
            v.RotVelocity = Vector3.new(0, 0, 0) 
        end)
    end
    pcall(function() plr.Character.HumanoidRootPart.BodyPosition:Destroy() end)
    
    pcall(function() game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid end)
end})
y=5;
JFR.NewText("KeysText1", page_keys, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Hotkeys", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("KeysText1"))
y=y+50;
newhotkey("SpeedWs", page_keys, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "No hotkey", TextSize = 20, ClearTextOnFocus = true}, 
function() 
    bindto("jspeed-ws",Enum.RenderPriority.Character.Value + 5, function() 
        plr.Character.Humanoid.WalkSpeed = ws_speed * overdrive
    end) 
end, 
function() 
    unbindfrom("jspeed-ws") 
    plr.Character.Humanoid.WalkSpeed = 16
end)
newhotkey("SpeedCFrame", page_keys, {Position = UDim2.new(0.375, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "No hotkey", TextSize = 20, ClearTextOnFocus = true}, 
function() 
    bindto("jspeed-cf",Enum.RenderPriority.Character.Value + 5, function() 
        plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + (plr.Character.Humanoid.MoveDirection * ((cf_speed / 50) * overdrive))
    end) 
end, 
function() 
    unbindfrom("jspeed-cf") 
end)
newhotkey("SpeedPart", page_keys, {Position = UDim2.new(0.675, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "No hotkey", TextSize = 20, ClearTextOnFocus = true}, 
function() 
    speedpart = Instance.new("Part")
    speedpart.Parent = game.Workspace
    speedpart.Name = "loolollo"
    speedpart.CanCollide = true
    speedpart.Transparency = 0.5
    bindto("jspeed-pa",Enum.RenderPriority.Character.Value + 5, function() 
    
        speedpart.CFrame = plr.Character.HumanoidRootPart.CFrame - plr.Character.HumanoidRootPart.CFrame.LookVector
        speedpart.Velocity = plr.Character.HumanoidRootPart.CFrame.LookVector * ((pa_speed * 1.5) * overdrive)
    end) 
end, 
function() 
    speedpart:Destroy()
    unbindfrom("jspeed-pa") 
end)
JFR.NewText("", page_keys, {Position = UDim2.new(0.075, 13, 0, y+30), Size = UDim2.new(0, 400, 0, 25), Text = "Walkspeed", TextSize = 20})
JFR.NewText("", page_keys, {Position = UDim2.new(0.375, 25, 0, y+30), Size = UDim2.new(0, 400, 0, 25), Text = "CFrame", TextSize = 20})
JFR.NewText("", page_keys, {Position = UDim2.new(0.675, 30, 0, y+30), Size = UDim2.new(0, 400, 0, 25), Text = "Part", TextSize = 20})
y=y+50;
newhotkey("SpeedGlide", page_keys, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "No hotkey", TextSize = 20, ClearTextOnFocus = true}, 
function() 
    glidepart = Instance.new("BodyPosition")
    glidepart.Parent = plr.Character.HumanoidRootPart
    glidepart.D = 9999
    glidepart.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    glidepart.P = 1234567
    glidepart.Position = plr.Character.HumanoidRootPart.Position
    
    gl_indpart_bb.Enabled = gl_ind
    if gl_offset_reset then
        gl_offset = 0
        JFR.GetInstance("GlideOffset").Text = "Glide vertical offset: "..tostring(gl_offset)
        JFR.TweenCustom(glideoffsetsel, {Position = UDim2.new(0, 70, glideoffsetsel.Position.Y.Scale,glideoffsetsel.Position.Y.Offset )}, 0.25)
    end
    
    local y = glidepart.Position.Y
    bindto("jspeed-gl",Enum.RenderPriority.Character.Value + 5, function()
        local v = glidepart.Position + (plr.Character.Humanoid.MoveDirection * ((gl_speed / 50) * overdrive))
        glidepart.Position = Vector3.new(v.X, y+gl_offset, v.Z)
        gl_indpart.Position = glidepart.Position
        
    end)
end, 
function() 
    glidepart:Destroy()
    unbindfrom("jspeed-gl") 
    gl_indpart_bb.Enabled = false
end)
JFR.NewText("", page_keys, {Position = UDim2.new(0.075, 30, 0, y+30), Size = UDim2.new(0, 400, 0, 25), Text = "Glide", TextSize = 20})
newhotkey("Flight", page_keys, {Position = UDim2.new(0.375, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "No hotkey", TextSize = 20, ClearTextOnFocus = true}, 
function()
    glidepart = Instance.new("BodyPosition")
    glidepart.Parent = plr.Character.HumanoidRootPart
    glidepart.D = 9999
    glidepart.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    glidepart.P = 1234567
    glidepart.Position = plr.Character.HumanoidRootPart.Position
    
    
    gl_indpart_bb.Enabled = gl_ind
    
    bindto("jspeed-gl",Enum.RenderPriority.Character.Value + 5, function()
        local humrp = plr.Character.HumanoidRootPart
        glidepart.Position = (CFrame.new(glidepart.Position, glidepart.Position + game.Workspace.Camera.CFrame.LookVector) * (UserInputService:IsKeyDown(Enum.KeyCode.D) and CFrame.new(((gl_speed / 50) * overdrive), 0, 0) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.S) and CFrame.new(0, 0, ((gl_speed / 50) * overdrive)) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.A) and CFrame.new(-((gl_speed / 50) * overdrive), 0, 0) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.W) and CFrame.new(0, 0, -((gl_speed / 50) * overdrive)) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.Q) and CFrame.new(0, -((gl_speed / 50) * overdrive), 0) or CFrame.new(0, 0, 0)) * (UserInputService:IsKeyDown(Enum.KeyCode.E) and CFrame.new(0, ((gl_speed / 50) * overdrive), 0) or CFrame.new(0, 0, 0))).Position
        gl_indpart.Position = glidepart.Position
        
    end)
end, function() 
    RunService:UnbindFromRenderStep("jspeed-gl")
    gl_indpart_bb.Enabled = false
    
    glidepart:Destroy()
    pcall(function() plr.Character.HumanoidRootPart.BodyPosition:Destroy() end)
end)
JFR.NewText("", page_keys, {Position = UDim2.new(0.375, 30, 0, y+30), Size = UDim2.new(0, 400, 0, 25), Text = "Flight", TextSize = 20})


y=5;
JFR.NewText("SettingsText1", page_sett, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Settings", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("SettingsText1"))

y=y+30;

JFR.NewButton("GlideInd", page_sett, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Glide indicator", TextSize = 20}, {on = function() 
    gl_ind = true
end, off = function() 
    gl_ind = false
    gl_indpart_bb.Enabled = false
end})
JFR.OpenObject(JFR.GetInstance("GlideInd"))
JFR.SetInstanceValue("GlideInd", true)

JFR.NewButton("ResetGlide", page_sett, {Position = UDim2.new(0.375, 0, 0, y), Size = UDim2.new(0, 220, 0, 25), Text = "Reset glide offset on enable", TextSize = 20}, {on = function() 
    gl_offset_reset = true
end, off = function() 
    gl_offset_reset = false
end})

y=y+40;
JFR.NewText("", page_sett, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Indicator color (HSV)", TextSize = 20})

local colorprev = JFR.NewBoard("GlideIndPreview", page_sett, {BackgroundColor3 = gl_indcolor, Position = UDim2.new(0.375, 40, 0, y), Size = UDim2.new(0, 180, 0, 25), ZIndex = 200})
y=y+40;
JFR.NewBoard("GlideIndColorHbg", page_sett, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), ZIndex = 180})
JFR.NewBoard("GlideIndColorSbg", page_sett, {Position = UDim2.new(0.375, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), ZIndex = 180})
JFR.NewBoard("GlideIndColorVbg", page_sett, {Position = UDim2.new(0.675, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), ZIndex = 180})


local hvalues = {false, nil, 60, 0}
local svalues = {false, nil, 90, 0}
local vvalues = {false, nil, 90, 0}

JFR.MakeSlider(NewSelector(10, 60, JFR.GetInstance("GlideIndColorHbg")), JFR.GetInstance("GlideIndColorHbg"), hvalues, function() 
    gl_indcolor = Color3.fromHSV(
        hvalues[3]/100,
        svalues[3]/100,
        vvalues[3]/100
    )
    colorprev.BackgroundColor3 = gl_indcolor
    gl_indpart_tx.TextColor3 = gl_indcolor
end, true)

JFR.MakeSlider(NewSelector(10, 90, JFR.GetInstance("GlideIndColorSbg")), JFR.GetInstance("GlideIndColorSbg"), svalues, function() 
    gl_indcolor = Color3.fromHSV(
        hvalues[3]/100,
        svalues[3]/100,
        vvalues[3]/100
    )
    colorprev.BackgroundColor3 = gl_indcolor
    gl_indpart_tx.TextColor3 = gl_indcolor
end, true)

JFR.MakeSlider(NewSelector(10, 90, JFR.GetInstance("GlideIndColorVbg")), JFR.GetInstance("GlideIndColorVbg"), vvalues, function() 
    gl_indcolor = Color3.fromHSV(
        hvalues[3]/100,
        svalues[3]/100,
        vvalues[3]/100
    )
    colorprev.BackgroundColor3 = gl_indcolor
    gl_indpart_tx.TextColor3 = gl_indcolor
end, true)

y=y+40;


JFR.NewButton("SmoothCam", page_sett, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 220, 0, 25), Text = "Smooth camera", TextSize = 20}, {on = function() 
    game.Workspace.CurrentCamera.CameraSubject = smoothcam_part
    smoothcam_part.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 1.5, 0)
    
    bindto("jspeed-smoothcam", Enum.RenderPriority.Camera.Value + 5, function()
        game.Workspace.CurrentCamera.CameraSubject = smoothcam_part
        pcall(function() JFR.TweenCustom(smoothcam_part, {Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0) + (plr.Character.Humanoid.MoveDirection / 2)}) end)
    end)
end, off = function() 
    unbindfrom("jspeed-smoothcam")
    game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
end})




y=5;

JFR.NewText("InfoText1", page_info, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Information", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("InfoText1"))

JFR.NewText("InfoText2", page_info, {Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(0, 400, 0, 700), Text = " "..
    "<font size='24'><i>Version 2.2.2</i></font><br/> - Made fling work even better (hopefully)<br/> - Fixed minimization issues <br/> - Added fling all module that doesn&apos;t work that well<br/> but exists<br/>"..
    "<font size='24'><i>Version 2.2.1</i></font><br/> - Made fling work better<br/> - Made smoothcam not break when the camera subject changed <br/> - Added a fly module <br/> - Added a fling fly module<br/>"..
    "<font size='24'><i>Version 2.2.0</i></font><br/> - Added an option to reset the glide vertical<br/>offset every time you enable glide<br/> - Added a smooth camera setting for glide mode<br/> - Added a fling module in the Mods page<br/> - Balanced speed settings so glide and cframe don&apos;t need<br/>overdrive<br/> - Increased overdrive speed cap<br/> - Fixed settings menu staying on minimize<br/>"..
    "<font size='24'><i>Version 2.1.0</i></font><br/> - Changed how the speed setting works for<br/>CFrame and Glide modes (0-210, like the others)<br/> - Added an indicator where glide tries to send you<br/> - Added height setting for glide mode<br/> - Fixed some text being not centered<br/> - Fixed a slightly transparent frame showing when<br/>it shouldn&apos;t be<br/> - Added settings menu<br/> - Made mod menu more condensed<br/>"..
    "<font size='24'><i>Version 2.0.0</i></font><br/> - Completely remade GUI<br/> - Added new Glide mode which is similar to CFrame<br/> - Added sliders for speed setting<br/> - Added overdrive, which is a multiplier for every<br/>speed setting", TextSize = 18})

local dragarea = Instance.new("Frame")
dragarea.Size = UDim2.new(0, 500, 0, 50)
dragarea.Position = UDim2.new(0, 0, 0, 0)
dragarea.Parent = parentb
dragarea.BackgroundTransparency = 1 
dragarea.BorderSizePixel = 0 

local temp = {}
dragarea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        temp[1] = true
        temp[2] = parentb.Position
        
        tdc3 = game:GetService("UserInputService").InputChanged:Connect(function(input2)
            if input2.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input2.Position - input.Position

                JFR.TweenPosition(parentb, UDim2.new(temp[2].X.Scale, temp[2].X.Offset + delta.X, temp[2].Y.Scale, temp[2].Y.Offset + delta.Y), 0.75)
            end
        end)
    end
end)

dragarea.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        temp[1] = false
        tdc3:Disconnect()
        
    end
end) 











JFR.Ready()
JFR.SendMessage({Horizontal = true, Text = "<font size='30'>Loaded <b>Jeff Speed GUI</b>.<br/>Check out <b>info</b> to see new changes</font>", Size = UDim2.new(0, 500, 0, 75), Position = UDim2.new(0.05, 0, 0.9, 0), Delay = 3})
