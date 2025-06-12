local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local KEY_FILE = "elysiankey.txt"
local GET_KEY_URL = "https://ads.luarmor.net/get_key?for=-rcwjYmJSdHUO"

do
    local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
    api.script_id = "6bed8d4e831d161296e02fd6e167979c"

    local function saveKey(key)
        if writefile then writefile(KEY_FILE, key) end
    end

    local function loadKey()
        if isfile and isfile(KEY_FILE) then
            return readfile(KEY_FILE)
        end
        return nil
    end

    local function notify(title, text, duration)
        pcall(function()
            StarterGui:SetCore("SendNotification", {Title = title; Text = text; Duration = duration or 5})
        end)
    end

    local function createUI()
        local gui = Instance.new("ScreenGui")
        gui.Name = "LuarmorLoader"
        gui.ResetOnSpawn = false
        gui.Parent = player:WaitForChild("PlayerGui")

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 0, 0, 0)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.BorderSizePixel = 0
        frame.Parent = gui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "Elysian Loader"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 20

        local textbox = Instance.new("TextBox", frame)
        textbox.Text = ""
        textbox.PlaceholderText = "Enter your key..."
        textbox.Size = UDim2.new(0.9, 0, 0, 35)
        textbox.Position = UDim2.new(0.05, 0, 0.35, 0)
        textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 16
        Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 8)

        local loadBtn = Instance.new("TextButton", frame)
        loadBtn.Size = UDim2.new(0.9, 0, 0, 35)
        loadBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
        loadBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        loadBtn.Text = "Load Script"
        loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.TextSize = 16
        Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 8)

        local getKeyBtn = Instance.new("TextButton", frame)
        getKeyBtn.Size = UDim2.new(0.9, 0, 0, 30)
        getKeyBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
        getKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        getKeyBtn.Text = "Get Key"
        getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        getKeyBtn.Font = Enum.Font.Gotham
        getKeyBtn.TextSize = 14
        Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 6)

        local status = Instance.new("TextLabel", frame)
        status.Size = UDim2.new(1, -10, 0, 20)
        status.Position = UDim2.new(0, 5, 1, -25)
        status.BackgroundTransparency = 1
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
        status.Font = Enum.Font.Gotham
        status.TextSize = 14
        status.Text = ""

        local dragging, dragInput, dragStart, startPos
        local function update(input)
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input == dragInput then
                update(input)
            end
        end)

        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 210)}):Play()

        getKeyBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(GET_KEY_URL)
                notify("Luarmor", "Key URL copied to clipboard!", 3)
            else
                status.Text = "Clipboard not supported."
            end
        end)

        loadBtn.MouseButton1Click:Connect(function()
            local key = textbox.Text
            if key == "" then
                status.Text = "Please enter a key."
                return
            end
            status.Text = "Checking key..."
            status.TextColor3 = Color3.fromRGB(255, 255, 0)

            local ok, result = pcall(function()
                return api.check_key(key)
            end)
            if not ok then
                status.Text = "API error. Try again."
                return
            end

            if result.code == "KEY_VALID" then
                script_key = key
                saveKey(key)
                status.Text = "Key valid! Loading..."
                status.TextColor3 = Color3.fromRGB(100, 255, 100)
                notify("Luarmor", "Key valid!", 3)
                wait(0.5)
                local outTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
                outTween:Play()
                outTween.Completed:Wait()
                gui:Destroy()
                api.load_script()
            else
                local msgs = {
                    KEY_INCORRECT = "Key is wrong or deleted.",
                    KEY_HWID_LOCKED = "Key HWID locked.",
                    KEY_EXPIRED = "Key expired.",
                    KEY_BANNED = "Key banned."
                }
                status.Text = msgs[result.code] or ("Error: " .. result.message)
                status.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end)

        return gui
    end

    local existingKey = loadKey()
    if existingKey then
        local ok, result = pcall(function()
            return api.check_key(existingKey)
        end)
        if ok and result.code == "KEY_VALID" then
            script_key = existingKey
            notify("Luarmor", "Key valid!", 3)
            api.load_script()
        else
            createUI()
        end
    else
        createUI()
    end
end
