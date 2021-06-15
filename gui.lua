--[[Jeff's Speed GUI v2.0.0]]--
--Made by topit
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextAction= game:GetService("ContextActionService")

local scriptversion = "2.0.0"
local plr = game.Players.LocalPlayer

local ws_speed = 30
local cf_speed = 50
local pa_speed = 50
local gl_speed = 3
local overdrive = 1

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


local JFR = loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/Jeff-2.3-Framework/main/lib.lua', true))()

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

local function NewSelector(size, place)
    size = size or 7 
    place = place or 0
    local f = Instance.new("ImageLabel")
    f.Image = "rbxassetid://6956257983"
    f.Size = UDim2.new(0, size, 0, size)
    f.Position = UDim2.new(0, place, 0, 0)
    f.BackgroundTransparency = 1
    f.ZIndex = 220    
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
local page_mods = JFR.NewMenu("Page_Mods", bg, {Position = UDim2.new(0, 100, 0, 250), CanvasSize = UDim2.new(0, 100, 0, 330), Invisible = true})
local page_keys = JFR.NewMenu("Page_Keys", bg, {Position = UDim2.new(0, 100, 0, 250), CanvasSize = UDim2.new(0, 100, 0, 100), Invisible = true})
local page_info = JFR.NewMenu("Page_Info", bg, {Position = UDim2.new(0, 100, 0, 250), CanvasSize = UDim2.new(0, 100, 0, 100), Invisible = true})

--Tabs
local menu_tabs = JFR.NewMenu("Menu_Tabs", bg, {Position = UDim2.new(0, 0, 0, 250), Size = UDim2.new(0, 100, 0, 200), CanvasSize = UDim2.new(0, 80, 0, 100), BackgroundColor3 = JFR.Theme.shade4})
JFR.NewButton("Tab_Home", menu_tabs, {Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 75, 0, 25), Text = "Home"}, {on = function() 
    JFR.OpenObject(JFR.GetInstance("Tab_Home"   ));
    JFR.CloseObject(JFR.GetInstance("Tab_Mods"  ));
    JFR.CloseObject(JFR.GetInstance("Tab_Keys"));
    JFR.CloseObject(JFR.GetInstance("Tab_Misc"  ));

    JFR.GetInstance("Page_Home"    ).Visible = true
    JFR.GetInstance("Page_Mods"    ).Visible = false
    JFR.GetInstance("Page_Keys"  ).Visible = false
    JFR.GetInstance("Page_Info"    ).Visible = false
    
    page = "Page_Home"
end})
JFR.OpenObject(JFR.GetInstance("Tab_Home"))
y=y+40;
JFR.NewButton("Tab_Mods", menu_tabs, {Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 75, 0, 25), Text = "Modes"}, {on = function()
    JFR.CloseObject(JFR.GetInstance("Tab_Home"    ));
    JFR.OpenObject(JFR.GetInstance("Tab_Mods"     ));
    JFR.CloseObject(JFR.GetInstance("Tab_Keys"  ));
    JFR.CloseObject(JFR.GetInstance("Tab_Misc"    ));

    JFR.GetInstance("Page_Home"    ).Visible = false
    JFR.GetInstance("Page_Mods"    ).Visible = true
    JFR.GetInstance("Page_Keys"  ).Visible = false
    JFR.GetInstance("Page_Info"    ).Visible = false
    
    page = "Page_Mods"
end})
y=y+40;
JFR.NewButton("Tab_Keys", menu_tabs, {Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 75, 0, 25), Text = "Hotkeys"}, {on = function() 
    JFR.CloseObject(JFR.GetInstance("Tab_Home"    ));
    JFR.CloseObject(JFR.GetInstance("Tab_Mods"    ));
    JFR.OpenObject(JFR.GetInstance("Tab_Keys"   ));
    JFR.CloseObject(JFR.GetInstance("Tab_Misc"    ));

    JFR.GetInstance("Page_Home"    ).Visible = false
    JFR.GetInstance("Page_Mods"    ).Visible = false
    JFR.GetInstance("Page_Keys"  ).Visible = true
    JFR.GetInstance("Page_Info"    ).Visible = false
    
    page = "Page_Keys"
end})
y=y+40;
JFR.NewButton("Tab_Misc", menu_tabs, {Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(0, 75, 0, 25), Text = "Info"}, {on = function() 
    JFR.CloseObject(JFR.GetInstance("Tab_Home"    ));
    JFR.CloseObject(JFR.GetInstance("Tab_Mods"    ));
    JFR.CloseObject(JFR.GetInstance("Tab_Keys"  ));
    JFR.OpenObject(JFR.GetInstance("Tab_Misc"     ));

    JFR.GetInstance("Page_Home"    ).Visible = false
    JFR.GetInstance("Page_Mods"    ).Visible = false
    JFR.GetInstance("Page_Keys"  ).Visible = false
    JFR.GetInstance("Page_Info"    ).Visible = true
    
    page = "Page_Info"
end})
JFR.NewButton("MinimizeButton", bg, {Position = UDim2.new(1, -60, 0, 5), Size = UDim2.new(0, 25, 0, 25), BackgroundColor3 = JFR.Theme.shade7, Text = "-", TextSize = 14}, {
    on = function()
        
        JFR.TweenSize(parentb, UDim2.new(0, parentb.Size.X.Offset, 0, 50), 0.75, Enum.EasingDirection.Out)
        JFR.TweenSize(JFR.GetInstance("Shadow"), UDim2.new(0, parentb.Size.X.Offset, 0, 50), 0.75, Enum.EasingDirection.Out)
        
        local function YoMom(a)
            JFR.Async(function() 
                JFR.TweenSize(a, UDim2.new(a.Size.X.Scale, a.Size.X.Offset, a.Size.Y.Scale, 0), 0.75, Enum.EasingDirection.Out)
                wait(0.75)
                a.Visible = false
            end)
        end
        YoMom(JFR.GetInstance("Page_Home"))
        YoMom(JFR.GetInstance("Page_Info"))
        YoMom(JFR.GetInstance("Page_Keys"))
        YoMom(JFR.GetInstance("Page_Mods"))
        YoMom(JFR.GetInstance("Menu_Tabs"))
        
        YoMom(JFR.GetInstance("Outline1"))
        YoMom(JFR.GetInstance("Outline2"))
        
        YoMom(JFR.GetInstance("Roundedbottom3"))
        YoMom(JFR.GetInstance("Roundedbottom2"))
        YoMom(JFR.GetInstance("Roundedbottom1"))

    end,
    off = function() 
        
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
        YorMom(JFR.GetInstance("Menu_Tabs"), 200)
        
        
        JFR.GetInstance("Page_Home"    ).Visible = false
        JFR.GetInstance("Page_Info"    ).Visible = false
        JFR.GetInstance("Page_Keys"  ).Visible = false
        JFR.GetInstance("Page_Mods"    ).Visible = false
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
end})


StartGradient(JFR.GetInstance("Page_Home"))
EndGradient(JFR.GetInstance("Page_Home"))

StartGradient(JFR.GetInstance("Page_Info"))
EndGradient(JFR.GetInstance("Page_Info"))

StartGradient(JFR.GetInstance("Page_Keys"))
EndGradient(JFR.GetInstance("Page_Keys"))

StartGradient(JFR.GetInstance("Page_Mods"))
EndGradient(JFR.GetInstance("Page_Mods"))


y=5;
JFR.NewText("HomeText1", page_home, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Home", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("HomeText1"))

y=y+30;
JFR.NewText("HomeText2", page_home, {Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(0, 400, 0, 75), Text = " Jeff Speed GUI made by topit<br/>Check out what the new features are in the <b>info</b> tab<br/><br/>Join the discord: <br/><br/><br/><br/>Version "..scriptversion, TextSize = 20})
NewLine(page_home, 165)

JFR.NewButton("HomeDiscord", page_home, {Position = UDim2.new(0, 10, 0, 120), Size = UDim2.new(0, 380, 0, 25), Text = "Copy invite to clipboard"}, {on = function() setclipboard("https://discord.gg/XsHXPZSAae") JFR.Async(function() JFR.GetInstance("HomeDiscord").Text = "Copied" wait(1) JFR.GetInstance("HomeDiscord").Text = "Copy invite to clipboard" end) end})

y=5;
JFR.NewText("SpeedText1", page_mods, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Speedhack modes", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("SpeedText1"))
y=y+50;

JFR.NewButton("SpeedWs", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Walkspeed <font size='10'>("..tostring(ws_speed)..")</font>", TextSize = 20}, {on = function() 
    RunService:BindToRenderStep("jspeed-ws",Enum.RenderPriority.Character.Value + 5, function() 
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
end)


y=y+50;



JFR.NewButton("SpeedCFrame", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "CFrame <font size='10'>("..tostring(cf_speed)..")</font>", TextSize = 20}, {on = function() 
    RunService:BindToRenderStep("jspeed-cf",Enum.RenderPriority.Character.Value + 5, function() 
        plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + (plr.Character.Humanoid.MoveDirection * ((cf_speed / 25) * overdrive))
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
end)
y=y+50;




JFR.NewButton("SpeedPart", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Part <font size='10'>("..tostring(pa_speed)..")</font>", TextSize = 20}, {on = function() 
    speedpart = Instance.new("Part")
    speedpart.Parent = game.Workspace
    speedpart.Name = "loolollo"
    speedpart.CanCollide = true
    speedpart.Transparency = 0
    RunService:BindToRenderStep("jspeed-pa",Enum.RenderPriority.Character.Value + 5, function() 
        speedpart.CFrame = plr.Character.HumanoidRootPart.CFrame - plr.Character.HumanoidRootPart.CFrame.LookVector
        speedpart.Velocity = plr.Character.HumanoidRootPart.CFrame.LookVector * (pa_speed * overdrive)
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
end)




y=y+50;


JFR.NewButton("SpeedGlide", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Glide <font size='10'>("..tostring(gl_speed)..")</font>", TextSize = 20}, {on = function() 
    glidepart = Instance.new("BodyPosition")
    glidepart.Parent = plr.Character.HumanoidRootPart
    glidepart.D = 9999
    glidepart.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    glidepart.P = 1234567
    glidepart.Position = plr.Character.HumanoidRootPart.Position
    RunService:BindToRenderStep("jspeed-gl",Enum.RenderPriority.Character.Value + 5, function() 
        glidepart.Position = glidepart.Position + (plr.Character.Humanoid.MoveDirection * (gl_speed * overdrive))
    end) 
end, off = function() 
RunService:UnbindFromRenderStep("jspeed-gl")
glidepart:Destroy()
end})

JFR.NewBoard("SpeedGlideSlider", page_mods, {Position = UDim2.new(0.375, 0, 0, y+9), Size = UDim2.new(0, 220, 0, 7), ZIndex = 200})

sel = NewSelector(10, gl_speed* 25)
local gl_vals = {}
sel.Parent = JFR.GetInstance("SpeedGlideSlider")
JFR.MakeSlider(sel, JFR.GetInstance("SpeedGlideSlider"), gl_vals, function() 
    gl_speed = gl_vals[3] / 25
    JFR.GetInstance("SpeedGlide").Text="Glide <font size='10'>("..tostring(gl_speed)..")</font>"
end)

y=y+50;

JFR.NewText("SpeedOverdrive", page_mods, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "Overdrive multiplier: "..tostring(overdrive), TextSize = 20})

JFR.NewBoard("SpeedOverdriveSlider", page_mods, {Position = UDim2.new(0.55, 0, 0, y+9), Size = UDim2.new(0, 150, 0, 7), ZIndex = 200})

sel = NewSelector(10, (overdrive/25)+1)
local ov_vals = {}
sel.Parent = JFR.GetInstance("SpeedOverdriveSlider")
JFR.MakeSlider(sel, JFR.GetInstance("SpeedOverdriveSlider"), ov_vals, function() 
    overdrive = (ov_vals[3] / 25) + 1
    JFR.GetInstance("SpeedOverdrive").Text="Overdrive multiplier: "..tostring(overdrive)
end)

y=y+50;

y=5;
JFR.NewText("KeysText1", page_keys, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Hotkeys", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("KeysText1"))
y=y+50;
newhotkey("SpeedWs", page_keys, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "No hotkey", TextSize = 20, ClearTextOnFocus = true}, 
function() 
    bindto("jspeed-ws",nil,function() 
        plr.Character.Humanoid.WalkSpeed = ws_speed * overdrive
    end) 
end, 
function() 
    unbindfrom("jspeed-ws") 
    plr.Character.Humanoid.WalkSpeed = 16
end)
newhotkey("SpeedCFrame", page_keys, {Position = UDim2.new(0.375, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "No hotkey", TextSize = 20, ClearTextOnFocus = true}, 
function() 
    bindto("jspeed-cf",nil,function() 
        plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + (plr.Character.Humanoid.MoveDirection * ((cf_speed / 25) * overdrive))
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
    speedpart.Transparency = 0
    RunService:BindToRenderStep("jspeed-pa",Enum.RenderPriority.Character.Value + 5, function() 
        speedpart.CFrame = plr.Character.HumanoidRootPart.CFrame - plr.Character.HumanoidRootPart.CFrame.LookVector
        speedpart.Velocity = plr.Character.HumanoidRootPart.CFrame.LookVector * (pa_speed * overdrive)
    end) 
end, 
function() 
    speedpart:Destroy()
    unbindfrom("jspeed-pa") 
end)
JFR.NewText("", page_keys, {Position = UDim2.new(0.075, 10, 0, y+30), Size = UDim2.new(0, 400, 0, 25), Text = "Walkspeed", TextSize = 20})
JFR.NewText("", page_keys, {Position = UDim2.new(0.375, 25, 0, y+30), Size = UDim2.new(0, 400, 0, 25), Text = "CFrame", TextSize = 20})
JFR.NewText("", page_keys, {Position = UDim2.new(0.675, 10, 0, y+30), Size = UDim2.new(0, 400, 0, 25), Text = "Part", TextSize = 20})
y=y+50;
newhotkey("SpeedGlide", page_keys, {Position = UDim2.new(0.075, 0, 0, y), Size = UDim2.new(0, 100, 0, 25), Text = "No hotkey", TextSize = 20, ClearTextOnFocus = true}, 
function() 
    glidepart = Instance.new("BodyPosition")
    glidepart.Parent = plr.Character.HumanoidRootPart
    glidepart.D = 9999
    glidepart.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    glidepart.P = 1234567
    glidepart.Position = plr.Character.HumanoidRootPart.Position
    RunService:BindToRenderStep("jspeed-gl",Enum.RenderPriority.Character.Value + 5, function() 
        glidepart.Position = glidepart.Position + (plr.Character.Humanoid.MoveDirection * (gl_speed * overdrive))
    end) 
end, 
function() 
    glidepart:Destroy()
    unbindfrom("jspeed-gl") 
end)
JFR.NewText("", page_keys, {Position = UDim2.new(0.075, 10, 0, y+30), Size = UDim2.new(0, 400, 0, 25), Text = "Glide", TextSize = 20})
y=5;
JFR.NewText("InfoText1", page_info, {Position = UDim2.new(0.05, -10, 0, y), Size = UDim2.new(0, 400, 0, 25), Text = "Information", TextSize = 20})
NewlineOnLabel(JFR.GetInstance("InfoText1"))

JFR.NewText("InfoText2", page_info, {Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(0, 400, 0, 400), Text = " <font size='27'><i>Version 2.0.0</i></font><br/> - Completely remade GUI<br/> - Added new Glide mode which is similar to CFrame<br/> - Added sliders for speed setting<br/> - Added overdrive, which is a multiplier for every<br/>speed setting", TextSize = 20})

local dragarea = Instance.new("Frame")
dragarea.Size = UDim2.new(0, 500, 0, 50)
dragarea.Position = UDim2.new(0, 0, 0, 0)
dragarea.Parent = parentb
dragarea.BackgroundTransparency = 0.9 
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
