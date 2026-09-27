
repeat task.wait() until game:IsLoaded()

local cloneref = cloneref or function(o) return o end
local UserInputService = cloneref(game:GetService('UserInputService'))
local TweenService = cloneref(game:GetService('TweenService'))
local HttpService = cloneref(game:GetService('HttpService'))
local RunService = cloneref(game:GetService('RunService'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Debris = cloneref(game:GetService('Debris'))
local ReplicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local Stats = cloneref(game:GetService('Stats'))
local LocalizationService = cloneref(game:GetService('LocalizationService'))
local SoundService = cloneref(game:GetService('SoundService'))

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
LocalPlayer = Players.LocalPlayer

pcall(function()
    if getgenv()._VanishUnload then
        getgenv()._VanishUnload()
    end
end)
task.wait(0.15)
pcall(function()
    local parents = {}
    pcall(function()
        if typeof(gethui) == "function" then table.insert(parents, gethui()) end
    end)
    pcall(function()
        table.insert(parents, game:GetService("CoreGui"))
    end)
    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        if lp then table.insert(parents, lp:FindFirstChild("PlayerGui")) end
    end)
    local killNames = {
        VanishCurveOverlay = true,
        ManualSpamPanel = true,
        VanishWatermark = true,
    }
    for _, parent in ipairs(parents) do
        if not parent then continue end
        for _, child in ipairs(parent:GetChildren()) do
            if killNames[child.Name] or (typeof(child.Name) == "string" and child.Name:find("Sigma", 1, true) == 1) then
                pcall(function() child:Destroy() end)
            end
        end
    end
    if getgenv()._VanishUI then
        pcall(function() getgenv()._VanishUI:Destroy() end)
        getgenv()._VanishUI = nil
    end
    local cam = workspace.CurrentCamera
    if cam then
        local folder = cam:FindFirstChild("AcrylicBlur")
        if folder then pcall(function() folder:Destroy() end) end
    end
end)
getgenv()._VanishAlive = true
getgenv()._VanishConns = {}
getgenv()._VanishGuis = {}

pcall(function()
    local oldFire = getgenv()._VanishOldFire
    local hookfn = hookfunction or getgenv().hookfunction
    if type(oldFire) == "function" and type(hookfn) == "function" then
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        local sample = remotes and remotes:FindFirstChildWhichIsA("RemoteEvent")
        if sample then
            pcall(hookfn, sample.FireServer, oldFire)
        end
    end
    getgenv()._VanishOldFire = nil
    getgenv()._VanishOnFire = nil
end)
pcall(function()
    local hookmeta = hookmetamethod or (getgenv and getgenv().hookmetamethod)
    local oldNc = getgenv()._VanishOldNamecall
    if type(oldNc) == "function" and type(hookmeta) == "function" then
        pcall(hookmeta, game, "__namecall", oldNc)
    end
    local oldIndex = getgenv()._VanishOldIndex
    if type(oldIndex) == "function" and type(hookmeta) == "function" then
        pcall(hookmeta, game, "__index", oldIndex)
    end
    getgenv()._VanishOldNamecall = nil
    getgenv()._VanishOldIndex = nil
end)
pcall(function()
    local oldIndex = getgenv()._VanishOldRemoteIndex
    if type(oldIndex) ~= "function" or type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" then
        getgenv()._VanishOldRemoteIndex = nil
        return
    end
    local sample = Instance.new("RemoteEvent")
    local meta = getrawmetatable(sample)
    pcall(function()
        sample:Destroy()
    end)
    if type(meta) ~= "table" then
        getgenv()._VanishOldRemoteIndex = nil
        return
    end
    setreadonly(meta, false)
    meta.__index = oldIndex
    setreadonly(meta, true)
    getgenv()._VanishOldRemoteIndex = nil
end)
pcall(function()
    if mouse1release then mouse1release() end
end)

pcall(function()
    local hookfn = hookfunction or getgenv().hookfunction
    local genv = getgenv()
    if type(hookfn) ~= "function" then
        return
    end
    if type(genv._VanishOldGetfenv) == "function" and type(getfenv) == "function" then
        pcall(hookfn, getfenv, genv._VanishOldGetfenv)
    end
    if type(genv._VanishOldDebugInfo) == "function" and type(debug) == "table" and type(debug.info) == "function" then
        pcall(hookfn, debug.info, genv._VanishOldDebugInfo)
    end
    if type(genv._VanishOldClone) == "function" and type(clonefunction) == "function" then
        pcall(hookfn, clonefunction, genv._VanishOldClone)
    end
    if type(genv._VanishOldIsL) == "function" and type(islclosure) == "function" then
        pcall(hookfn, islclosure, genv._VanishOldIsL)
    end
    if type(genv._VanishOldCheckClosure) == "function" and type(checkclosure) == "function" then
        pcall(hookfn, checkclosure, genv._VanishOldCheckClosure)
    end
    if type(genv._VanishOldIsExecutor) == "function" and type(isexecutorclosure) == "function" then
        pcall(hookfn, isexecutorclosure, genv._VanishOldIsExecutor)
    end
    genv._VanishOldGetfenv = nil
    genv._VanishOldDebugInfo = nil
    genv._VanishOldClone = nil
    genv._VanishOldIsL = nil
    genv._VanishOldCheckClosure = nil
    genv._VanishOldIsExecutor = nil
    genv._VanishBacSpoof = nil
    genv._AllusiveHashBypass = nil
end)

local Library = (function()
local function detect_roblox_lang()
    local locale = ""
    pcall(function()
        locale = tostring(LocalPlayer.LocaleId or "")
    end)
    if locale == "" or locale == "nil" then
        pcall(function()
            locale = tostring(LocalizationService.RobloxLocaleId or "")
        end)
    end
    if locale == "" or locale == "nil" then
        pcall(function()
            locale = tostring(LocalizationService.SystemLocaleId or "")
        end)
    end
    locale = string.lower(tostring(locale or "en-us"))
    local code = locale:match("^([a-z]+)") or "en"
    return code, locale
end

local ROBLOX_LANG, ROBLOX_LOCALE = detect_roblox_lang()

local LANG_UI = {
    en = {
        CheckboxEnabled = "Enabled", CheckboxDisabled = "Disabled", SliderValue = "Value",
        DropdownSelect = "Select", DropdownNone = "None", DropdownSelected = "Selected",
        ButtonClick = "Click", TextboxEnter = "Enter", ModuleEnabled = "Enabled",
        ModuleDisabled = "Disabled", TabGeneral = "General", TabSettings = "Settings",
        Loading = "Loading...", Error = "Error", Success = "Success",
    },
    th = {
        CheckboxEnabled = "เปิด", CheckboxDisabled = "ปิด", SliderValue = "ค่า",
        DropdownSelect = "เลือก", DropdownNone = "ไม่มี", DropdownSelected = "ที่เลือก",
        ButtonClick = "คลิก", TextboxEnter = "ตกลง", ModuleEnabled = "เปิด",
        ModuleDisabled = "ปิด", TabGeneral = "ทั่วไป", TabSettings = "ตั้งค่า",
        Loading = "กำลังโหลด...", Error = "ผิดพลาด", Success = "สำเร็จ",
    },
    es = {
        CheckboxEnabled = "Activado", CheckboxDisabled = "Desactivado", SliderValue = "Valor",
        DropdownSelect = "Seleccionar", DropdownNone = "Ninguno", DropdownSelected = "Seleccionado",
        ButtonClick = "Clic", TextboxEnter = "Entrar", ModuleEnabled = "Activado",
        ModuleDisabled = "Desactivado", TabGeneral = "General", TabSettings = "Ajustes",
        Loading = "Cargando...", Error = "Error", Success = "Éxito",
    },
    pt = {
        CheckboxEnabled = "Ativado", CheckboxDisabled = "Desativado", SliderValue = "Valor",
        DropdownSelect = "Selecionar", DropdownNone = "Nenhum", DropdownSelected = "Selecionado",
        ButtonClick = "Clique", TextboxEnter = "Entrar", ModuleEnabled = "Ativado",
        ModuleDisabled = "Desativado", TabGeneral = "Geral", TabSettings = "Configurações",
        Loading = "Carregando...", Error = "Erro", Success = "Sucesso",
    },
    id = {
        CheckboxEnabled = "Aktif", CheckboxDisabled = "Nonaktif", SliderValue = "Nilai",
        DropdownSelect = "Pilih", DropdownNone = "Tidak ada", DropdownSelected = "Dipilih",
        ButtonClick = "Klik", TextboxEnter = "Masuk", ModuleEnabled = "Aktif",
        ModuleDisabled = "Nonaktif", TabGeneral = "Umum", TabSettings = "Pengaturan",
        Loading = "Memuat...", Error = "Error", Success = "Berhasil",
    },
    vi = {
        CheckboxEnabled = "Bật", CheckboxDisabled = "Tắt", SliderValue = "Giá trị",
        DropdownSelect = "Chọn", DropdownNone = "Không", DropdownSelected = "Đã chọn",
        ButtonClick = "Nhấn", TextboxEnter = "Nhập", ModuleEnabled = "Bật",
        ModuleDisabled = "Tắt", TabGeneral = "Chung", TabSettings = "Cài đặt",
        Loading = "Đang tải...", Error = "Lỗi", Success = "Thành công",
    },
    fr = {
        CheckboxEnabled = "Activé", CheckboxDisabled = "Désactivé", SliderValue = "Valeur",
        DropdownSelect = "Sélectionner", DropdownNone = "Aucun", DropdownSelected = "Sélectionné",
        ButtonClick = "Clic", TextboxEnter = "Entrée", ModuleEnabled = "Activé",
        ModuleDisabled = "Désactivé", TabGeneral = "Général", TabSettings = "Paramètres",
        Loading = "Chargement...", Error = "Erreur", Success = "Succès",
    },
    de = {
        CheckboxEnabled = "Aktiv", CheckboxDisabled = "Inaktiv", SliderValue = "Wert",
        DropdownSelect = "Auswählen", DropdownNone = "Keine", DropdownSelected = "Ausgewählt",
        ButtonClick = "Klick", TextboxEnter = "Enter", ModuleEnabled = "Aktiv",
        ModuleDisabled = "Inaktiv", TabGeneral = "Allgemein", TabSettings = "Einstellungen",
        Loading = "Laden...", Error = "Fehler", Success = "Erfolg",
    },
    ja = {
        CheckboxEnabled = "オン", CheckboxDisabled = "オフ", SliderValue = "値",
        DropdownSelect = "選択", DropdownNone = "なし", DropdownSelected = "選択中",
        ButtonClick = "クリック", TextboxEnter = "入力", ModuleEnabled = "オン",
        ModuleDisabled = "オフ", TabGeneral = "一般", TabSettings = "設定",
        Loading = "読み込み中...", Error = "エラー", Success = "成功",
    },
    ko = {
        CheckboxEnabled = "켜짐", CheckboxDisabled = "꺼짐", SliderValue = "값",
        DropdownSelect = "선택", DropdownNone = "없음", DropdownSelected = "선택됨",
        ButtonClick = "클릭", TextboxEnter = "입력", ModuleEnabled = "켜짐",
        ModuleDisabled = "꺼짐", TabGeneral = "일반", TabSettings = "설정",
        Loading = "로딩 중...", Error = "오류", Success = "성공",
    },
    zh = {
        CheckboxEnabled = "开启", CheckboxDisabled = "关闭", SliderValue = "数值",
        DropdownSelect = "选择", DropdownNone = "无", DropdownSelected = "已选",
        ButtonClick = "点击", TextboxEnter = "输入", ModuleEnabled = "开启",
        ModuleDisabled = "关闭", TabGeneral = "通用", TabSettings = "设置",
        Loading = "加载中...", Error = "错误", Success = "成功",
    },
    ru = {
        CheckboxEnabled = "Вкл", CheckboxDisabled = "Выкл", SliderValue = "Значение",
        DropdownSelect = "Выбрать", DropdownNone = "Нет", DropdownSelected = "Выбрано",
        ButtonClick = "Клик", TextboxEnter = "Ввод", ModuleEnabled = "Вкл",
        ModuleDisabled = "Выкл", TabGeneral = "Основное", TabSettings = "Настройки",
        Loading = "Загрузка...", Error = "Ошибка", Success = "Успех",
    },
    tr = {
        CheckboxEnabled = "Açık", CheckboxDisabled = "Kapalı", SliderValue = "Değer",
        DropdownSelect = "Seç", DropdownNone = "Yok", DropdownSelected = "Seçili",
        ButtonClick = "Tıkla", TextboxEnter = "Gir", ModuleEnabled = "Açık",
        ModuleDisabled = "Kapalı", TabGeneral = "Genel", TabSettings = "Ayarlar",
        Loading = "Yükleniyor...", Error = "Hata", Success = "Başarılı",
    },
}

local LANG_STRINGS = {
    th = {
        ["Combat"] = "การต่อสู้", ["Client"] = "ไคลเอนต์", ["Visuals"] = "ภาพ", ["Blatant"] = "โจ่งแจ้ง",
        ["Sword"] = "ดาบ", ["Settings"] = "ตั้งค่า", ["UI Options"] = "ตัวเลือก UI",
        ["Transparency"] = "ความโปร่งใส", ["Unload"] = "ยกเลิก", ["Server Tools"] = "เครื่องมือเซิร์ฟเวอร์",
        ["Rejoin"] = "เข้าใหม่", ["Server Hop"] = "เปลี่ยนเซิร์ฟเวอร์", ["Staff Detection"] = "ตรวจจับสตาฟ",
        ["Enabled"] = "เปิด", ["Action Mode"] = "โหมดการทำงาน", ["Auto Parry"] = "ออโต้พาร์รี่",
        ["Parry Type"] = "ประเภทพาร์รี่", ["Curve Type"] = "ประเภทเคิร์ฟ", ["Parry Accuracy"] = "ความแม่นยำพาร์รี่",
        ["Randomize Accuracy"] = "สุ่มความแม่นยำ", ["Cooldown Protection"] = "กันคูลดาวน์",
        ["Auto Ability"] = "ออโต้สกิล", ["Notify"] = "แจ้งเตือน", ["Auto Spam"] = "ออโต้สแปม",
        ["Manual Spam"] = "แมนนวลสแปม", ["Spam Type"] = "ประเภทสแปม", ["Animation Fix"] = "แก้แอนิเมชัน",
        ["Spam Threshold"] = "เกณฑ์สแปม", ["Distance Multiplier"] = "ตัวคูณระยะ",
        ["Ability Detection"] = "ตรวจจับสกิล", ["Anti Abilities"] = "กันสกิล", ["Walkspeed"] = "ความเร็วเดิน",
        ["Jump Power"] = "แรงกระโดด", ["Infinite Jump"] = "กระโดดไม่จำกัด", ["Cosmetics"] = "เครื่องสำอาง",
        ["Ability ESP"] = "ESP สกิล", ["Remote was found, #fuck bladeball !!"] = "พบ Remote แล้ว, #fuck bladeball !!",
        ["ON"] = "เปิด", ["OFF"] = "ปิด", ["Staff Detected"] = "พบสตาฟ",
        ["Automatically parries incoming balls"] = "พาร์รี่ลูกบอลอัตโนมัติ",
        ["Automatically spams parries"] = "สแปมพาร์รี่อัตโนมัติ",
        ["Manually spam parries"] = "สแปมพาร์รี่ด้วยตนเอง",
        ["Skip auto parry during your abilities"] = "ข้ามออโต้พาร์รี่ตอนใช้สกิล",
        ["These abilities won't affect you"] = "สกิลเหล่านี้จะไม่กระทบคุณ",
        ["Transparency and unload"] = "ความโปร่งใสและยกเลิกสคริปต์",
        ["Rejoin and hop servers"] = "เข้าใหม่และเปลี่ยนเซิร์ฟเวอร์",
        ["Detect Blade Ball moderators"] = "ตรวจจับโมเดอเรเตอร์ Blade Ball",
        ["Couldn't find a server"] = "หาเซิร์ฟเวอร์ไม่เจอ",
        ["No other servers found"] = "ไม่พบเซิร์ฟเวอร์อื่น",
        ["Mobile Curve"] = "เคิร์ฟมือถือ",
        ["Speed"] = "ความเร็ว", ["Power"] = "พลัง",
        ["Show Platform"] = "แสดงแพลตฟอร์ม", ["Ability Visualizer"] = "แสดงสกิล",
        ["Ability Exploit"] = "เอ็กซ์พลอยต์สกิล", ["Remote"] = "รีโมต",
        ["Mouse Click"] = "คลิกเมาส์",
    },
    es = {
        ["Combat"] = "Combate", ["Client"] = "Cliente", ["Visuals"] = "Visuales", ["Blatant"] = "Obvio",
        ["Sword"] = "Espada", ["Settings"] = "Ajustes", ["UI Options"] = "Opciones de UI",
        ["Transparency"] = "Transparencia", ["Unload"] = "Descargar", ["Server Tools"] = "Herramientas de servidor",
        ["Rejoin"] = "Reentrar", ["Server Hop"] = "Cambiar servidor", ["Staff Detection"] = "Detección de staff",
        ["Enabled"] = "Activado", ["Action Mode"] = "Modo de acción", ["Auto Parry"] = "Auto Parry",
        ["Parry Type"] = "Tipo de parry", ["Curve Type"] = "Tipo de curva", ["Parry Accuracy"] = "Precisión de parry",
        ["Notify"] = "Notificar", ["Auto Spam"] = "Auto Spam", ["Manual Spam"] = "Spam manual",
        ["Staff Detected"] = "Staff detectado",
        ["Remote was found, #fuck bladeball !!"] = "Remote encontrado, #fuck bladeball !!",
        ["Walkspeed"] = "Velocidad", ["Jump Power"] = "Salto", ["Infinite Jump"] = "Salto infinito",
        ["Cosmetics"] = "Cosméticos", ["Ability ESP"] = "ESP de habilidad",
    },
    pt = {
        ["Combat"] = "Combate", ["Client"] = "Cliente", ["Visuals"] = "Visuais", ["Blatant"] = "Óbvio",
        ["Sword"] = "Espada", ["Settings"] = "Configurações", ["UI Options"] = "Opções de UI",
        ["Transparency"] = "Transparência", ["Unload"] = "Descarregar", ["Server Tools"] = "Ferramentas do servidor",
        ["Rejoin"] = "Reentrar", ["Server Hop"] = "Trocar servidor", ["Staff Detection"] = "Detecção de staff",
        ["Enabled"] = "Ativado", ["Auto Parry"] = "Auto Parry", ["Notify"] = "Notificar",
        ["Auto Spam"] = "Auto Spam", ["Manual Spam"] = "Spam manual",
        ["Remote was found, #fuck bladeball !!"] = "Remote encontrado, #fuck bladeball !!",
        ["Staff Detected"] = "Staff detectado", ["Walkspeed"] = "Velocidade", ["Jump Power"] = "Pulo",
        ["Infinite Jump"] = "Pulo infinito", ["Cosmetics"] = "Cosméticos",
    },
    id = {
        ["Combat"] = "Combat", ["Client"] = "Klien", ["Visuals"] = "Visual", ["Blatant"] = "Blatant",
        ["Sword"] = "Pedang", ["Settings"] = "Pengaturan", ["UI Options"] = "Opsi UI",
        ["Transparency"] = "Transparansi", ["Unload"] = "Unload", ["Server Tools"] = "Alat Server",
        ["Rejoin"] = "Rejoin", ["Server Hop"] = "Server Hop", ["Staff Detection"] = "Deteksi Staff",
        ["Enabled"] = "Aktif", ["Auto Parry"] = "Auto Parry", ["Notify"] = "Notifikasi",
        ["Remote was found, #fuck bladeball !!"] = "Remote ditemukan, #fuck bladeball !!",
        ["Staff Detected"] = "Staff terdeteksi", ["Walkspeed"] = "Walkspeed", ["Jump Power"] = "Jump Power",
        ["Infinite Jump"] = "Infinite Jump", ["Cosmetics"] = "Kosmetik",
    },
    vi = {
        ["Combat"] = "Chiến đấu", ["Client"] = "Client", ["Visuals"] = "Hình ảnh", ["Blatant"] = "Rõ ràng",
        ["Sword"] = "Kiếm", ["Settings"] = "Cài đặt", ["UI Options"] = "Tùy chọn UI",
        ["Enabled"] = "Bật", ["Auto Parry"] = "Auto Parry", ["Notify"] = "Thông báo",
        ["Remote was found, #fuck bladeball !!"] = "Đã tìm thấy Remote, #fuck bladeball !!",
        ["Staff Detected"] = "Phát hiện staff", ["Walkspeed"] = "Tốc độ", ["Jump Power"] = "Nhảy",
        ["Infinite Jump"] = "Nhảy vô hạn", ["Cosmetics"] = "Mỹ phẩm",
    },
    fr = {
        ["Combat"] = "Combat", ["Client"] = "Client", ["Visuals"] = "Visuels", ["Blatant"] = "Flagrant",
        ["Sword"] = "Épée", ["Settings"] = "Paramètres", ["UI Options"] = "Options UI",
        ["Enabled"] = "Activé", ["Auto Parry"] = "Auto Parry", ["Notify"] = "Notifier",
        ["Remote was found, #fuck bladeball !!"] = "Remote trouvé, #fuck bladeball !!",
        ["Staff Detected"] = "Staff détecté", ["Walkspeed"] = "Vitesse", ["Jump Power"] = "Saut",
        ["Infinite Jump"] = "Saut infini", ["Cosmetics"] = "Cosmétiques",
    },
    de = {
        ["Combat"] = "Kampf", ["Client"] = "Client", ["Visuals"] = "Visuals", ["Blatant"] = "Offensichtlich",
        ["Sword"] = "Schwert", ["Settings"] = "Einstellungen", ["UI Options"] = "UI-Optionen",
        ["Enabled"] = "Aktiv", ["Auto Parry"] = "Auto Parry", ["Notify"] = "Benachrichtigen",
        ["Remote was found, #fuck bladeball !!"] = "Remote gefunden, #fuck bladeball !!",
        ["Staff Detected"] = "Staff erkannt", ["Walkspeed"] = "Laufgeschwindigkeit", ["Jump Power"] = "Sprungkraft",
        ["Infinite Jump"] = "Unendlicher Sprung", ["Cosmetics"] = "Kosmetik",
    },
    ja = {
        ["Combat"] = "戦闘", ["Client"] = "クライアント", ["Visuals"] = "ビジュアル", ["Blatant"] = "露骨",
        ["Sword"] = "剣", ["Settings"] = "設定", ["UI Options"] = "UIオプション",
        ["Enabled"] = "有効", ["Auto Parry"] = "オートパリィ", ["Notify"] = "通知",
        ["Remote was found, #fuck bladeball !!"] = "Remoteを検出, #fuck bladeball !!",
        ["Staff Detected"] = "スタッフ検出", ["Walkspeed"] = "歩行速度", ["Jump Power"] = "ジャンプ力",
        ["Infinite Jump"] = "無限ジャンプ", ["Cosmetics"] = "コスメ",
    },
    ko = {
        ["Combat"] = "전투", ["Client"] = "클라이언트", ["Visuals"] = "비주얼", ["Blatant"] = "노골적",
        ["Sword"] = "검", ["Settings"] = "설정", ["UI Options"] = "UI 옵션",
        ["Enabled"] = "켜짐", ["Auto Parry"] = "오토 패리", ["Notify"] = "알림",
        ["Remote was found, #fuck bladeball !!"] = "Remote 발견, #fuck bladeball !!",
        ["Staff Detected"] = "스태프 감지", ["Walkspeed"] = "이동 속도", ["Jump Power"] = "점프력",
        ["Infinite Jump"] = "무한 점프", ["Cosmetics"] = "코스메틱",
    },
    zh = {
        ["Combat"] = "战斗", ["Client"] = "客户端", ["Visuals"] = "视觉", ["Blatant"] = "明显",
        ["Sword"] = "剑", ["Settings"] = "设置", ["UI Options"] = "界面选项",
        ["Enabled"] = "开启", ["Auto Parry"] = "自动格挡", ["Notify"] = "通知",
        ["Remote was found, #fuck bladeball !!"] = "已找到 Remote, #fuck bladeball !!",
        ["Staff Detected"] = "检测到管理员", ["Walkspeed"] = "移速", ["Jump Power"] = "跳跃",
        ["Infinite Jump"] = "无限跳", ["Cosmetics"] = "外观",
    },
    ru = {
        ["Combat"] = "Бой", ["Client"] = "Клиент", ["Visuals"] = "Визуалы", ["Blatant"] = "Явный",
        ["Sword"] = "Меч", ["Settings"] = "Настройки", ["UI Options"] = "Опции UI",
        ["Enabled"] = "Вкл", ["Auto Parry"] = "Авто парирование", ["Notify"] = "Уведомления",
        ["Remote was found, #fuck bladeball !!"] = "Remote найден, #fuck bladeball !!",
        ["Staff Detected"] = "Обнаружен стафф", ["Walkspeed"] = "Скорость", ["Jump Power"] = "Прыжок",
        ["Infinite Jump"] = "Бесконечный прыжок", ["Cosmetics"] = "Косметика",
    },
    tr = {
        ["Combat"] = "Savaş", ["Client"] = "İstemci", ["Visuals"] = "Görseller", ["Blatant"] = "Açık",
        ["Sword"] = "Kılıç", ["Settings"] = "Ayarlar", ["UI Options"] = "UI Seçenekleri",
        ["Enabled"] = "Açık", ["Auto Parry"] = "Otomatik Parry", ["Notify"] = "Bildirim",
        ["Remote was found, #fuck bladeball !!"] = "Remote bulundu, #fuck bladeball !!",
        ["Staff Detected"] = "Yetkili tespit edildi", ["Walkspeed"] = "Yürüme hızı", ["Jump Power"] = "Zıplama",
        ["Infinite Jump"] = "Sınırsız zıplama", ["Cosmetics"] = "Kozmetik",
    },
}

local function L(text)
    if type(text) ~= "string" or text == "" then
        return text
    end
    local pack = LANG_STRINGS[ROBLOX_LANG]
    if pack and pack[text] then
        return pack[text]
    end
    return text
end

local function raise_plugin()
    local setid = setthreadidentity or setidentity or set_thread_identity or setthreadcontext
    if type(setid) == "function" then
        pcall(setid, 8)
    end
end

getgenv()._VanishL = L
getgenv()._VanishLang = ROBLOX_LANG
getgenv()._VanishLocale = ROBLOX_LOCALE

getgenv().GG = {
    Language = LANG_UI[ROBLOX_LANG] or LANG_UI.en,
    SelectedLanguage = ROBLOX_LANG,
    LocaleId = ROBLOX_LOCALE,
}

local SelectedLanguage = ROBLOX_LANG

local env = getgenv()
local protect_gui = env.protect_gui
local protectgui = env.protectgui
local syn = env.syn
local UIACProtection = protect_gui or protectgui or (type(syn) == "table" and syn.protect_gui) or function() end;
local UIName = string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))..string.char(math.random(60,120))

local SecureScreenGui = Instance.new('ScreenGui')
SecureScreenGui.Name = UIName
SecureScreenGui.ResetOnSpawn = false
SecureScreenGui.IgnoreGuiInset = true
SecureScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SecureScreenGui.DisplayOrder = 2147483647
SecureScreenGui.Enabled = true
pcall(function()
    SecureScreenGui.Modal = false
end)
pcall(UIACProtection, SecureScreenGui)
local function parent_screen(gui)
    local function try_parent()
        if gui.Parent then
            return true
        end
        pcall(function()
            if typeof(gethui) == "function" then
                gui.Parent = gethui()
            end
        end)
        if not gui.Parent then
            pcall(function()
                gui.Parent = CoreGui
            end)
        end
        if not gui.Parent then
            local pg = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                pcall(function()
                    gui.Parent = pg
                end)
            end
        end
        return gui.Parent ~= nil
    end
    if try_parent() then
        return
    end
    task.spawn(function()
        local pg = LocalPlayer and LocalPlayer:WaitForChild("PlayerGui", 60)
        if pg and not gui.Parent then
            pcall(function()
                gui.Parent = pg
            end)
        end
        if not gui.Parent then
            try_parent()
        end
    end)
end
parent_screen(SecureScreenGui)

getgenv()._VanishUI = SecureScreenGui
if getgenv()._VanishGuis then
    table.insert(getgenv()._VanishGuis, SecureScreenGui)
end

local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = UIName .. "_n"
NotificationGui.ResetOnSpawn = false
NotificationGui.IgnoreGuiInset = true
NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotificationGui.DisplayOrder = 2147483646
NotificationGui.Enabled = true
pcall(UIACProtection, NotificationGui)
parent_screen(NotificationGui)
getgenv()._VanishNotifyGui = NotificationGui
if getgenv()._VanishGuis then
    table.insert(getgenv()._VanishGuis, NotificationGui)
end

local Lucide
local function response_body(result)
    if type(result) == "string" then
        return result
    end
    if type(result) == "table" then
        return result.Body or result.body
    end
    return nil
end

local function http_get_body(url)
    local body
    pcall(function()
        if syn and syn.request then
            body = response_body(syn.request({ Url = url, Method = "GET" }))
        elseif http_request then
            body = response_body(http_request({ Url = url, Method = "GET" }))
        elseif request then
            body = response_body(request({ Url = url, Method = "GET" }))
        elseif game.HttpGet then
            body = game:HttpGet(url)
        end
    end)
    return body
end

pcall(function()
    local urls = {
        "https://github.com/latte-soft/lucide-roblox/releases/latest/download/lucide-roblox.luau",
        "https://raw.githubusercontent.com/latte-soft/lucide-roblox/master/dist/lucide-roblox.luau",
    }
    for i = 1, #urls do
        local src = http_get_body(urls[i])
        if type(src) == "string" and #src > 200 then
            local chunk
            local ok = pcall(function()
                chunk = loadstring(src)
            end)
            if ok and type(chunk) == "function" then
                local ok2, lib = pcall(chunk)
                if ok2 and type(lib) == "table" and type(lib.GetAsset) == "function" then
                    Lucide = lib
                    break
                end
            end
        end
    end
end)

local LUCIDE_ICON_FALLBACK = {
    search = "rbxassetid://6031154871",
    swords = "rbxassetid://10734975692",
    sword = "rbxassetid://10734975692",
    monitor = "rbxassetid://10747373176",
    laptop = "rbxassetid://10747373176",
    user = "rbxassetid://10747373176",
    settings = "rbxassetid://10734950309",
    ["settings-2"] = "rbxassetid://10734950309",
    skull = "rbxassetid://10747373176",
    eye = "rbxassetid://10747373176",
    crown = "rbxassetid://10709781460",
    bell = "rbxassetid://6031280882",
    ["bell-off"] = "rbxassetid://6031280882",
}

local function apply_lucide_icon(image, icon, size)
    if not image or type(icon) ~= "string" or icon == "" then
        return
    end
    if string.find(icon, "rbxasset", 1, true) or string.find(icon, "http", 1, true) then
        image.Image = icon
        image.ImageRectOffset = Vector2.new()
        image.ImageRectSize = Vector2.new()
        return
    end
    if string.match(icon, "^%d+$") then
        image.Image = "rbxassetid://" .. icon
        image.ImageRectOffset = Vector2.new()
        image.ImageRectSize = Vector2.new()
        return
    end
    local name = string.lower(icon)
    name = string.gsub(name, "_", "-")
    name = string.gsub(name, "%s+", "-")
    if Lucide and Lucide.GetAsset then
        local ok, asset = pcall(Lucide.GetAsset, name, size or 48)
        if ok and type(asset) == "table" and asset.Url then
            image.Image = asset.Url
            image.ImageRectSize = asset.ImageRectSize or Vector2.new()
            image.ImageRectOffset = asset.ImageRectOffset or Vector2.new()
            return
        end
    end
    image.Image = LUCIDE_ICON_FALLBACK[name] or icon
    image.ImageRectOffset = Vector2.new()
    image.ImageRectSize = Vector2.new()
end

local function convertStringToTable(inputString)
    local result = {}
    for value in string.gmatch(inputString, "([^,]+)") do
        local trimmedValue = value:match("^%s*(.-)%s*$")
        table.insert(result, trimmedValue)
    end

    return result
end

local function convertTableToString(inputTable)
    return table.concat(inputTable, ", ")
end

local UserInputService = cloneref(game:GetService('UserInputService'))
local ContentProvider = cloneref(game:GetService('ContentProvider'))
local TweenService = cloneref(game:GetService('TweenService'))
local HttpService = cloneref(game:GetService('HttpService'))
local TextService = cloneref(game:GetService('TextService'))
local RunService = cloneref(game:GetService('RunService'))
local Lighting = cloneref(game:GetService('Lighting'))
local Players = cloneref(game:GetService('Players'))
local CoreGui = cloneref(game:GetService('CoreGui'))
local Debris = cloneref(game:GetService('Debris'))

local mouse = nil
pcall(function()
    mouse = Players.LocalPlayer and Players.LocalPlayer:GetMouse()
end)

pcall(function()
    if type(makefolder) ~= "function" then return end
    if type(isfolder) ~= "function" or not isfolder("AchaoticUI") then pcall(makefolder, "AchaoticUI") end
    if type(isfolder) ~= "function" or not isfolder("AchaoticUI/SakuraModified") then pcall(makefolder, "AchaoticUI/SakuraModified") end
end)

local Connections = setmetatable({
    disconnect = function(self, connection)
        if not self[connection] then
            return
        end

        self[connection]:Disconnect()
        self[connection] = nil
    end,
    disconnect_all = function(self)
        for _, value in self do
            if typeof(value) == 'function' then
                continue
            end

            value:Disconnect()
        end
    end
}, nil)

local Util = setmetatable({
    map = function(self: any, value: number, in_minimum: number, in_maximum: number, out_minimum: number, out_maximum: number)
        return (value - in_minimum) * (out_maximum - out_minimum) / (in_maximum - in_minimum) + out_minimum
    end,
    viewport_point_to_world = function(self: any, location: any, distance: number)
        local unit_ray = workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)

        return unit_ray.Origin + unit_ray.Direction * distance
    end,
    get_offset = function(self: any)
        local viewport_size_Y = workspace.CurrentCamera.ViewportSize.Y

        return self:map(viewport_size_Y, 0, 2560, 8, 56)
    end
}, nil)

local AcrylicBlur = {}
AcrylicBlur.__index = AcrylicBlur

function AcrylicBlur.new(object: GuiObject)
    local self = setmetatable({
        _object = object,
        _folder = nil,
        _frame = nil,
        _root = nil
    }, AcrylicBlur)

    self:setup()

    return self
end

function AcrylicBlur:create_folder()
    local old_folder = workspace.CurrentCamera:FindFirstChild('AcrylicBlur')

    if old_folder then
        Debris:AddItem(old_folder, 0)
    end

    local folder = Instance.new('Folder')
    folder.Name = 'AcrylicBlur'
    folder.Parent = workspace.CurrentCamera

    self._folder = folder
end

function AcrylicBlur:create_depth_of_fields()
    local depth_of_fields = Lighting:FindFirstChild('AcrylicBlur') or Instance.new('DepthOfFieldEffect')
    depth_of_fields.FarIntensity = 0
    depth_of_fields.FocusDistance = 0.05
    depth_of_fields.InFocusRadius = 0.1
    depth_of_fields.NearIntensity = 1
    depth_of_fields.Name = 'AcrylicBlur'
    depth_of_fields.Parent = Lighting

    for _, object in Lighting:GetChildren() do
        if not object:IsA('DepthOfFieldEffect') then
            continue
        end

        if object == depth_of_fields then
            continue
        end

        Connections[object] = object:GetPropertyChangedSignal('FarIntensity'):Connect(function()
            object.FarIntensity = 0
        end)

        object.FarIntensity = 0
    end
end

function AcrylicBlur:create_frame()
    local frame = Instance.new('Frame')
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 1
    frame.Active = false
    frame.ZIndex = 0
    frame.Parent = self._object

    self._frame = frame
end

function AcrylicBlur:create_root()
    local part = Instance.new('Part')
    part.Name = 'Root'
    part.Color = Color3.new(0, 0, 0)
    part.Material = Enum.Material.Glass
    part.Size = Vector3.new(1, 1, 0)
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    pcall(function()
        part.CanTouch = false
    end)
    part.Locked = true
    part.CastShadow = false
    part.Transparency = 0.98
    part.Parent = self._folder

    local specialMesh = Instance.new('SpecialMesh')
    specialMesh.MeshType = Enum.MeshType.Brick
    specialMesh.Offset = Vector3.new(0, 0, -0.000001)
    specialMesh.Parent = part

    self._mesh = specialMesh
    self._root = part
end

function AcrylicBlur:setup()
    self:create_depth_of_fields()
    self:create_folder()
    self:create_root()

    self:create_frame()
    self:render(0.001)

    self:check_quality_level()
end

function AcrylicBlur:render(distance: number)
    local positions = {
        top_left = Vector2.new(),
        top_right = Vector2.new(),
        bottom_right = Vector2.new(),
    }

    local function update_positions(size: any, position: any)
        positions.top_left = position
        positions.top_right = position + Vector2.new(size.X, 0)
        positions.bottom_right = position + size
    end

    local function update()
        local top_left = positions.top_left
        local top_right = positions.top_right
        local bottom_right = positions.bottom_right

        local top_left3D = Util:viewport_point_to_world(top_left, distance)
        local top_right3D = Util:viewport_point_to_world(top_right, distance)
        local bottom_right3D = Util:viewport_point_to_world(bottom_right, distance)

        local width = (top_right3D - top_left3D).Magnitude
        local height = (top_right3D - bottom_right3D).Magnitude

        if not self._root then
            return
        end

        self._root.CFrame = CFrame.fromMatrix((top_left3D + bottom_right3D) / 2, workspace.CurrentCamera.CFrame.XVector, workspace.CurrentCamera.CFrame.YVector, workspace.CurrentCamera.CFrame.ZVector)
        local mesh = self._mesh
        if mesh == nil or mesh.Parent == nil then
            mesh = self._root:FindFirstChildOfClass("SpecialMesh") or self._root:FindFirstChild("Mesh")
            self._mesh = mesh
        end
        if mesh ~= nil then
            mesh.Scale = Vector3.new(width, height, 0)
        end
    end

    local function on_change()
        local offset = Util:get_offset()
        local size = self._frame.AbsoluteSize - Vector2.new(offset, offset)
        local position = self._frame.AbsolutePosition + Vector2.new(offset / 2, offset / 2)

        update_positions(size, position)
        task.spawn(update)
    end

    Connections['cframe_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(update)
    Connections['viewport_size_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(update)
    Connections['field_of_view_update'] = workspace.CurrentCamera:GetPropertyChangedSignal('FieldOfView'):Connect(update)

    Connections['frame_absolute_position'] = self._frame:GetPropertyChangedSignal('AbsolutePosition'):Connect(on_change)
    Connections['frame_absolute_size'] = self._frame:GetPropertyChangedSignal('AbsoluteSize'):Connect(on_change)

    task.spawn(update)
end

function AcrylicBlur:check_quality_level()
    local game_settings = UserSettings().GameSettings
    local quality_level = game_settings.SavedQualityLevel.Value

    if quality_level < 8 then
        self:change_visiblity(false)
    end

    Connections['quality_level'] = game_settings:GetPropertyChangedSignal('SavedQualityLevel'):Connect(function()
        local game_settings = UserSettings().GameSettings
        local quality_level = game_settings.SavedQualityLevel.Value

        self:change_visiblity(quality_level >= 8)
    end)
end

function AcrylicBlur:change_visiblity(state: boolean)
    self._root.Transparency = state and 0.98 or 1
end

local Config = setmetatable({
    save = function(self: any, file_name: any, config: any)
        local success_save, result = pcall(function()
            local flags = HttpService:JSONEncode(config)
            writefile('AchaoticUI/SakuraModified/'..file_name..'.json', flags)
        end)

        if not success_save then
            warn('failed to save config', result)
        end
    end,
    load = function(self: any, file_name: any, config: any)
        local success_load, result = pcall(function()
            if not isfile('AchaoticUI/SakuraModified/'..file_name..'.json') then
                self:save(file_name, config)

                return
            end

            local flags = readfile('AchaoticUI/SakuraModified/'..file_name..'.json')

            if not flags then
                self:save(file_name, config)

                return
            end

            return HttpService:JSONDecode(flags)
        end)

        if not success_load then
            warn('failed to load config', result)
        end

        if type(result) ~= "table" then
            result = {}
        end
        if type(result._flags) ~= "table" then
            result._flags = {}
        end
        if type(result._keybinds) ~= "table" then
            result._keybinds = {}
        end
        if type(result._library) ~= "table" then
            result._library = {}
        end

        return result
    end
}, nil)

local Library = {
    _config = Config:load(game.GameId),
    _theme = {
        PrimaryColor = Color3.fromRGB(255, 255, 255)
    },

    _choosing_keybind = false,
    _device = nil,

    _ui_open = true,
    _ui_scale = 1,
    _ui_loaded = false,
    _ui = nil,

    _dragging = false,
    _drag_start = nil,
    _container_position = nil
}
Library.__index = Library

function Library.new(config)
    local self = setmetatable({
        _loaded = false,
        _tab = 0,
    }, Library)

    local currentconfig = config or {
        title = "March",
        PrimaryColor = Color3.fromRGB(255, 255, 255),
    }

    self:create_ui(currentconfig)

    return self
end

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "RobloxCoreGuis"
NotificationContainer.Size = UDim2.new(0, 300, 0, 0)
NotificationContainer.Position = UDim2.new(0.8, 0, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.ClipsDescendants = false
NotificationContainer.Parent = NotificationGui or SecureScreenGui
NotificationContainer.AutomaticSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = NotificationContainer

function Library.SendNotification(settings)
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 60)
    Notification.BackgroundTransparency = 1
    Notification.BorderSizePixel = 0
    Notification.Name = "Notification"
    Notification.Parent = NotificationContainer
    Notification.AutomaticSize = Enum.AutomaticSize.Y

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Notification

    local InnerFrame = Instance.new("Frame")
    InnerFrame.Size = UDim2.new(1, 0, 0, 60)
    InnerFrame.Position = UDim2.new(0, 0, 0, 0)
    InnerFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    InnerFrame.BackgroundTransparency = 0.12
    InnerFrame.BorderSizePixel = 0
    InnerFrame.Name = "InnerFrame"
    InnerFrame.Parent = Notification
    InnerFrame.AutomaticSize = Enum.AutomaticSize.Y

    local InnerUICorner = Instance.new("UICorner")
    InnerUICorner.CornerRadius = UDim.new(0, 8)
    InnerUICorner.Parent = InnerFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(70, 70, 70)
    UIStroke.Transparency = 0.55
    UIStroke.Thickness = 1
    UIStroke.Parent = InnerFrame

    local AccentBar = Instance.new("Frame")
    AccentBar.Name = "AccentBar"
    AccentBar.Size = UDim2.new(0, 3, 1, -16)
    AccentBar.AnchorPoint = Vector2.new(0, 0.5)
    AccentBar.Position = UDim2.new(0, 8, 0.5, 0)
    AccentBar.BorderSizePixel = 0
    AccentBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    if typeof(Library._theme.PrimaryColor) == "Color3" then
        AccentBar.BackgroundColor3 = Library._theme.PrimaryColor
    end
    AccentBar.Parent = InnerFrame

    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(1, 0)
    AccentCorner.Parent = AccentBar

    local Title = Instance.new("TextLabel")
    Title.Text = settings.title or "Notification Title"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Title.TextSize = 13
    Title.Size = UDim2.new(1, -26, 0, 18)
    Title.Position = UDim2.new(0, 18, 0, 7)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.TextWrapped = true
    Title.TextTruncate = Enum.TextTruncate.AtEnd
    Title.AutomaticSize = Enum.AutomaticSize.Y
    Title.Parent = InnerFrame

    local Body = Instance.new("TextLabel")
    Body.Text = settings.text or ""
    Body.TextColor3 = Color3.fromRGB(175, 175, 175)
    Body.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    Body.TextSize = 12
    Body.Size = UDim2.new(1, -26, 0, 30)
    Body.Position = UDim2.new(0, 18, 0, 27)
    Body.BackgroundTransparency = 1
    Body.TextXAlignment = Enum.TextXAlignment.Left
    Body.TextYAlignment = Enum.TextYAlignment.Top
    Body.TextWrapped = true
    Body.AutomaticSize = Enum.AutomaticSize.Y
    Body.Parent = InnerFrame

    task.spawn(function()
        task.wait(0.1)
        local totalHeight = Title.TextBounds.Y + Body.TextBounds.Y + 18
        InnerFrame.Size = UDim2.new(1, 0, 0, totalHeight)
    end)

    task.spawn(function()
        local tweenIn = TweenService:Create(InnerFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 10 + NotificationContainer.Size.Y.Offset)
        })
        tweenIn:Play()
        local duration = settings.duration or 5
        task.wait(duration)
        local tweenOut = TweenService:Create(InnerFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 310, 0, 10 + NotificationContainer.Size.Y.Offset)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            Notification:Destroy()
        end)
    end)
end

function Library:get_screen_scale()
    local camera = workspace.CurrentCamera
    local viewport_size_x = (camera and camera.ViewportSize.X) or 1400

    self._ui_scale = math.clamp(viewport_size_x / 1400, 0.45, 1)
end

function Library:get_device()
    local device = 'Unknown'

    if not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        device = 'PC'
    elseif UserInputService.TouchEnabled then
        device = 'Mobile'
    elseif UserInputService.GamepadEnabled then
        device = 'Console'
    end

    self._device = device
end

function Library:removed(action: any)
    self._ui.AncestryChanged:Once(action)
end

function Library:flag_type(flag: any, flag_type: any)
    if not Library._config._flags[flag] then
        return
    end

    return typeof(Library._config._flags[flag]) == flag_type
end

Library._option_registry = Library._option_registry or {}

function Library:register_option(kind: string, flag: string, setter)
    if type(flag) ~= "string" or flag == "" or type(setter) ~= "function" then
        return
    end
    Library._option_registry = Library._option_registry or {}
    table.insert(Library._option_registry, { kind = kind, flag = flag, set = setter })
end

function Library:remove_table_value(__table: any, table_value: string)
    for index, value in __table do
        if value ~= table_value then
            continue
        end

        table.remove(__table, index)
    end
end

function Library:create_ui(config)
    config = config or {}
    config.PrimaryColor = Color3.fromRGB(255, 255, 255)
    self._theme = config
    local SecureScreenGui = SecureScreenGui

    local Container = Instance.new('Frame')
    Container.ClipsDescendants = true
    Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Container.Name = 'Container'
    Container.BackgroundTransparency = 0.05000000074505806
    Container.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 0, 0, 0)
    Container.Active = true
    Container.BorderSizePixel = 0
    Container.Parent = SecureScreenGui

    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Container

    local UIStroke = Instance.new('UIStroke')
    UIStroke.Color = Color3.fromRGB(90, 90, 90)
    UIStroke.Transparency = 0.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Container

    local Handler = Instance.new('Frame')
    Handler.BackgroundTransparency = 1
    Handler.Name = 'Handler'
    Handler.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Handler.Size = UDim2.new(0, 698, 0, 519)
    Handler.BorderSizePixel = 0
    Handler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Handler.Parent = Container

    local Tabs = Instance.new('ScrollingFrame')
    Tabs.ScrollBarImageTransparency = 1
    Tabs.ScrollBarThickness = 0
    Tabs.Name = 'Tabs'
    Tabs.Size = UDim2.new(0, 129, 0, 401)
    Tabs.Selectable = false
    Tabs.AutomaticCanvasSize = Enum.AutomaticSize.XY
    Tabs.BackgroundTransparency = 1
    Tabs.Position = UDim2.new(0.026097271591424942, 0, 0.1111111119389534, 0)
    Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Tabs.BorderSizePixel = 0
    Tabs.CanvasSize = UDim2.new(0, 0, 0.5, 0)
    Tabs.ZIndex = 5
    Tabs.Parent = Handler

    local UIListLayout = Instance.new('UIListLayout')
    UIListLayout.Padding = UDim.new(0, 4)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Tabs

    local ClientName = Instance.new('TextLabel')
    ClientName.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    ClientName.TextColor3 = config.PrimaryColor
    ClientName.TextTransparency = 0.20000000298023224
    ClientName.Text = config.title
    ClientName.Name = 'ClientName'
    ClientName.AutomaticSize = Enum.AutomaticSize.X
    ClientName.Size = UDim2.new(0, 0, 0, 13)
    ClientName.AnchorPoint = Vector2.new(0, 0.5)
    ClientName.Position = UDim2.new(0.0560000017285347, 0, 0.054999999701976776, 0)
    ClientName.BackgroundTransparency = 1
    ClientName.TextXAlignment = Enum.TextXAlignment.Left
    ClientName.BorderSizePixel = 0
    ClientName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ClientName.TextSize = 13
    ClientName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClientName.Parent = Handler

    local UIGradient = Instance.new('UIGradient')
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 155, 155)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    UIGradient.Parent = ClientName

    local CreditNote = Instance.new('TextLabel')
    CreditNote.Name = 'CreditNote'
    CreditNote.BackgroundTransparency = 1
    CreditNote.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    CreditNote.TextSize = 11
    CreditNote.TextColor3 = Color3.fromRGB(160, 160, 160)
    CreditNote.TextTransparency = 0.15
    CreditNote.TextXAlignment = Enum.TextXAlignment.Center
    CreditNote.TextTruncate = Enum.TextTruncate.AtEnd
    CreditNote.Text = 'Developed by @lowktermed & @internaldata'
    CreditNote.AnchorPoint = Vector2.new(0.5, 0)
    CreditNote.Position = UDim2.new(0.48, 0, 0, 12)
    CreditNote.Size = UDim2.new(0, 300, 0, 16)
    CreditNote.ZIndex = 10
    CreditNote.Parent = Handler

    local Pin = Instance.new('Frame')
    Pin.Name = 'Pin'
    Pin.Position = UDim2.fromOffset(18, math.floor(0.1111111119389534 * 519 + 11 + 22))
    Pin.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Pin.Size = UDim2.new(0, 2, 0, 16)
    Pin.BorderSizePixel = 0
    Pin.BackgroundColor3 = config.PrimaryColor
    Pin.Parent = Handler

    local UICorner = Instance.new('UICorner')
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Pin

    local Icon = Instance.new('ImageLabel')
    Icon.ImageColor3 = config.PrimaryColor
    Icon.ScaleType = Enum.ScaleType.Fit
    Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.Image = 'rbxassetid://100375298524189'
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0.02500000037252903, 0, 0.054999999701976776, 0)
    Icon.Name = 'Icon'
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.BorderSizePixel = 0
    Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Icon.Parent = Handler

    local Divider = Instance.new('Frame')
    Divider.Name = 'Divider'
    Divider.BackgroundTransparency = 0.5
    Divider.Position = UDim2.new(0.23499999940395355, 0, 0, 0)
    Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Divider.Size = UDim2.new(0, 1, 0, 519)
    Divider.BorderSizePixel = 0
    Divider.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    Divider.Parent = Handler

    local Profile = Instance.new('Frame')
    Profile.Name = 'Profile'
    Profile.BackgroundTransparency = 1
    Profile.AnchorPoint = Vector2.new(0, 1)
    Profile.Position = UDim2.new(0, 18, 1, -14)
    Profile.Size = UDim2.new(0, 140, 0, 32)
    Profile.ZIndex = 6
    Profile.Parent = Handler

    local Avatar = Instance.new('ImageLabel')
    Avatar.Name = 'Avatar'
    Avatar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Avatar.BorderSizePixel = 0
    Avatar.Size = UDim2.new(0, 32, 0, 32)
    Avatar.Position = UDim2.new(0, 0, 0, 0)
    Avatar.Image = ''
    Avatar.ScaleType = Enum.ScaleType.Fit
    Avatar.ZIndex = 6
    Avatar.Parent = Profile

    local AvatarCorner = Instance.new('UICorner')
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = Avatar

    local DisplayName = Instance.new('TextLabel')
    DisplayName.Name = 'DisplayName'
    DisplayName.BackgroundTransparency = 1
    DisplayName.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    DisplayName.TextSize = 12
    DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
    DisplayName.TextTransparency = 0.05
    DisplayName.TextXAlignment = Enum.TextXAlignment.Left
    DisplayName.TextTruncate = Enum.TextTruncate.AtEnd
    DisplayName.Size = UDim2.new(0, 100, 0, 14)
    DisplayName.Position = UDim2.new(0, 40, 0, 1)
    DisplayName.Text = LocalPlayer.DisplayName
    DisplayName.ZIndex = 6
    DisplayName.Parent = Profile

    local UserName = Instance.new('TextLabel')
    UserName.Name = 'UserName'
    UserName.BackgroundTransparency = 1
    UserName.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    UserName.TextSize = 10
    UserName.TextColor3 = Color3.fromRGB(180, 180, 180)
    UserName.TextTransparency = 0.25
    UserName.TextXAlignment = Enum.TextXAlignment.Left
    UserName.TextTruncate = Enum.TextTruncate.AtEnd
    UserName.Size = UDim2.new(0, 100, 0, 12)
    UserName.Position = UDim2.new(0, 40, 0, 17)
    UserName.Text = '@' .. LocalPlayer.Name
    UserName.ZIndex = 6
    UserName.Parent = Profile

    task.spawn(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and type(content) == 'string' and content ~= '' then
            Avatar.Image = content
        end
    end)

    local Sections = Instance.new('Folder')
    Sections.Name = 'Sections'
    Sections.Parent = Handler

    local tab_registry = {}
    local category_headers = {}
    local current_category = nil
    local section_frames = {}
    local selected_left = nil
    local selected_right = nil
    local selected_tab_btn = nil
    self._tab_registry = tab_registry
    self._sections_folder = Sections
    self._tabs_frame = Tabs

    local SearchHolder = Instance.new('Frame')
    SearchHolder.Name = 'SearchHolder'
    SearchHolder.AnchorPoint = Vector2.new(1, 0)
    SearchHolder.Position = UDim2.new(1, -16, 0, 10)
    SearchHolder.Size = UDim2.new(0, 164, 0, 24)
    SearchHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    SearchHolder.BackgroundTransparency = 0.05
    SearchHolder.BorderSizePixel = 0
    SearchHolder.ZIndex = 10
    SearchHolder.Parent = Handler

    local SearchCorner = Instance.new('UICorner')
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchHolder

    local SearchStroke = Instance.new('UIStroke')
    SearchStroke.Color = Color3.fromRGB(90, 90, 90)
    SearchStroke.Transparency = 0.35
    SearchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SearchStroke.Parent = SearchHolder

    local SearchIcon = Instance.new('ImageLabel')
    SearchIcon.Name = 'SearchIcon'
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Size = UDim2.new(0, 13, 0, 13)
    SearchIcon.Position = UDim2.new(0, 7, 0.5, -6.5)
    SearchIcon.ImageColor3 = Color3.fromRGB(160, 160, 160)
    SearchIcon.ScaleType = Enum.ScaleType.Fit
    SearchIcon.ZIndex = 11
    SearchIcon.Parent = SearchHolder
    apply_lucide_icon(SearchIcon, "search", 48)

    local SearchBox = Instance.new('TextBox')
    SearchBox.Name = 'SearchBox'
    SearchBox.BackgroundTransparency = 1
    SearchBox.Size = UDim2.new(1, -30, 1, 0)
    SearchBox.Position = UDim2.new(0, 24, 0, 0)
    SearchBox.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    SearchBox.TextSize = 11
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.PlaceholderColor3 = Color3.fromRGB(160, 160, 160)
    SearchBox.PlaceholderText = "Search modules..."
    SearchBox.Text = ""
    SearchBox.ClearTextOnFocus = false
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.TextYAlignment = Enum.TextYAlignment.Center
    SearchBox.ZIndex = 11
    SearchBox.Parent = SearchHolder

    local currentLeftSection = nil
    local currentRightSection = nil
    local searchQuery = ""

    local function apply_module_search()
        local query = string.lower(tostring(searchQuery or ""))
        local function filter_section(section)
            if not section then
                return
            end
            for _, child in ipairs(section:GetChildren()) do
                if child.Name == "Module" and child:IsA("Frame") then
                    local header = child:FindFirstChild("Header")
                    local nameLabel = header and header:FindFirstChild("ModuleName")
                    local title = string.lower(tostring((nameLabel and nameLabel.Text) or child.Name))
                    child.Visible = query == "" or string.find(title, query, 1, true) ~= nil
                end
            end
        end
        filter_section(currentLeftSection)
        filter_section(currentRightSection)
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchQuery = SearchBox.Text
        apply_module_search()
    end)

    local Minimize = Instance.new('TextButton')
    Minimize.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    Minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
    Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Minimize.Text = ''
    Minimize.AutoButtonColor = false
    Minimize.Name = 'Minimize'
    Minimize.BackgroundTransparency = 1
    Minimize.Position = UDim2.new(0.020057305693626404, 0, 0.02922755666077137, 0)
    Minimize.Size = UDim2.new(0, 24, 0, 24)
    Minimize.BorderSizePixel = 0
    Minimize.TextSize = 14
    Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.Parent = Handler

    local UIScale = Instance.new('UIScale')
    UIScale.Parent = Container

    self._ui = SecureScreenGui
    self._toggle_key = "Insert"

    local function on_drag(input: InputObject, process: boolean)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self._dragging = true
            self._drag_start = input.Position
            self._container_position = Container.Position

            Connections['container_input_ended'] = input.Changed:Connect(function()
                if input.UserInputState ~= Enum.UserInputState.End then
                    return
                end

                Connections:disconnect('container_input_ended')
                self._dragging = false
            end)
        end
    end

    local function update_drag(input: any)
        local delta = input.Position - self._drag_start
        local position = UDim2.new(self._container_position.X.Scale, self._container_position.X.Offset + delta.X, self._container_position.Y.Scale, self._container_position.Y.Offset + delta.Y)

        TweenService:Create(Container, TweenInfo.new(0.2), {
            Position = position
        }):Play()
    end

    local function drag(input: InputObject, process: boolean)
        if not self._dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            update_drag(input)
        end
    end

    Connections['container_input_began'] = Container.InputBegan:Connect(on_drag)
    Connections['input_changed'] = UserInputService.InputChanged:Connect(drag)

    self:removed(function()
        self._ui = nil
        Connections:disconnect_all()
    end)

    function self:Update1Run(a)
        if a == "nil" then
            Container.BackgroundTransparency = 0.05000000074505806
        else
            pcall(function()
                Container.BackgroundTransparency = tonumber(a)
            end)
        end
    end;

    function self:UIVisiblity()
        SecureScreenGui.Enabled = not SecureScreenGui.Enabled
    end;

    function self:change_visiblity(state: boolean)
        if state then
            TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(698, 519)
            }):Play()
        else
            TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(104.5, 52)
            }):Play()
        end
    end

    function self:load()
        local content = {}

        for _, object in SecureScreenGui:GetDescendants() do
            if not object:IsA('ImageLabel') then
                continue
            end

            table.insert(content, object)
        end

        task.spawn(function()
            pcall(function()
                ContentProvider:PreloadAsync(content)
            end)
        end)
        raise_plugin()
        pcall(function()
            self:get_device()
        end)

        if self._device == 'Mobile' or self._device == 'Unknown' then
            pcall(function()
                self:get_screen_scale()
                UIScale.Scale = self._ui_scale
                local camera = workspace.CurrentCamera
                if camera then
                    Connections['ui_scale'] = camera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
                        self:get_screen_scale()
                        UIScale.Scale = self._ui_scale
                    end)
                end
            end)
        end

        TweenService:Create(Container, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(698, 519)
        }):Play()

        pcall(function()
            AcrylicBlur.new(Container)
        end)
        raise_plugin()
        self._ui_loaded = true
    end

    function self:update_tabs(tab: TextButton)
        if not tab then
            return
        end
        local info = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        for _, object in Tabs:GetChildren() do
            if object.Name ~= 'Tab' or not object:IsA('GuiButton') then
                continue
            end

            local label = object:FindFirstChild('TextLabel')
            local icon = object:FindFirstChild('Icon')
            local gradient = label and label:FindFirstChildOfClass('UIGradient')

            if object == tab then
                do
                    local order = tonumber(object.LayoutOrder) or 0
                    local extra = 0
                    for _, header in ipairs(category_headers) do
                        if header.order < order then
                            extra += header.height + 4
                        end
                    end
                    local hidden = 0
                    for _, child in ipairs(Tabs:GetChildren()) do
                        if child.Name == "Tab" and child:IsA("GuiButton") and not child.Visible then
                            local child_order = tonumber(child.LayoutOrder) or 0
                            if child_order < order then
                                hidden += 1
                            end
                        end
                    end
                    local pinY = math.floor(0.1111111119389534 * 519 + order * 42 + 11 + extra - hidden * 42)
                    TweenService:Create(Pin, info, {
                        Position = UDim2.fromOffset(18, pinY)
                    }):Play()
                    TweenService:Create(object, info, {
                        BackgroundTransparency = 0.5
                    }):Play()
                    if label then
                        TweenService:Create(label, info, {
                            TextTransparency = 0.2,
                            TextColor3 = config.PrimaryColor
                        }):Play()
                    end
                    if gradient then
                        TweenService:Create(gradient, info, {
                            Offset = Vector2.new(1, 0)
                        }):Play()
                    end
                    if icon then
                        TweenService:Create(icon, info, {
                            ImageTransparency = 0.2,
                            ImageColor3 = config.PrimaryColor
                        }):Play()
                    end
                end
                continue
            end

            do
                TweenService:Create(object, info, {
                    BackgroundTransparency = 1
                }):Play()
                if label then
                    TweenService:Create(label, info, {
                        TextTransparency = 0.7,
                        TextColor3 = (typeof(getgenv()._VanishUIText) == "Color3" and getgenv()._VanishUIText or Color3.fromRGB(255, 255, 255))
                    }):Play()
                end
                if gradient then
                    TweenService:Create(gradient, info, {
                        Offset = Vector2.new(0, 0)
                    }):Play()
                end
                if icon then
                    TweenService:Create(icon, info, {
                        ImageTransparency = 0.8,
                        ImageColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                end
            end
        end
    end

    function self:update_sections(left_section: ScrollingFrame, right_section: ScrollingFrame)
        currentLeftSection = left_section
        currentRightSection = right_section
        selected_left = left_section
        selected_right = right_section

        local function place_column(column, x)
            if not column then
                return
            end
            column.AnchorPoint = Vector2.new(0, 0.5)
            column.Position = UDim2.fromOffset(x, 275)
            column.Size = UDim2.fromOffset(243, 445)
            column.Parent = Handler
        end
        place_column(left_section, 181)
        place_column(right_section, 439)

        for _, object in section_frames do
            if object == left_section or object == right_section then
                object.Visible = true
                continue
            end
            object.Visible = false
        end
        apply_module_search()
    end

    function self:select_tab_index(index: number)
        local entry = tab_registry[index]
        if not entry then
            return false
        end
        selected_tab_btn = entry.tab
        self:update_tabs(entry.tab)
        self:update_sections(entry.left, entry.right)
        return true
    end

    function self:create_category(name: string)
        name = tostring(L(name) or name or "Category")
        if name == "" or name == "nil" then
            name = "Category"
        end
        local order = (self._tab or 0) - 0.5
        local cat = { order = order, height = 18, members = {}, collapsed = false, token = 0 }
        current_category = cat
        table.insert(category_headers, cat)

        local Category = Instance.new('TextButton')
        Category.Name = 'Category'
        Category.Text = ''
        Category.AutoButtonColor = false
        Category.BackgroundTransparency = 1
        Category.Size = UDim2.new(0, 129, 0, 18)
        Category.LayoutOrder = order
        Category.Parent = Tabs

        local Label = Instance.new('TextLabel')
        Label.Name = 'Label'
        Label.BackgroundTransparency = 1
        Label.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        Label.TextColor3 = Color3.fromRGB(150, 150, 150)
        Label.TextTransparency = 0.2
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Text = string.upper(name)
        Label.TextSize = 10
        Label.Size = UDim2.new(1, -20, 1, 0)
        Label.Position = UDim2.new(0, 2, 0, 0)
        Label.Parent = Category

        local Arrow = Instance.new('ImageLabel')
        Arrow.Name = 'Arrow'
        Arrow.BackgroundTransparency = 1
        Arrow.AnchorPoint = Vector2.new(1, 0.5)
        Arrow.Position = UDim2.new(1, -2, 0.5, 0)
        Arrow.Size = UDim2.new(0, 12, 0, 12)
        Arrow.Image = ''
        Arrow.ImageColor3 = Color3.fromRGB(150, 150, 150)
        Arrow.ImageTransparency = 0.2
        Arrow.ScaleType = Enum.ScaleType.Fit
        pcall(function()
            apply_lucide_icon(Arrow, "chevron-down", 48)
        end)
        Arrow.Parent = Category

        local fade_info = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        local function paint_tab(tab, show)
            local label = tab:FindFirstChild('TextLabel')
            local icon = tab:FindFirstChild('Icon')
            local gradient = label and label:FindFirstChildOfClass('UIGradient')
            local selected = (tab == selected_tab_btn)
            if show then
                if selected then
                    TweenService:Create(tab, fade_info, { BackgroundTransparency = 0.5 }):Play()
                    if label then
                        TweenService:Create(label, fade_info, { TextTransparency = 0.2, TextColor3 = config.PrimaryColor }):Play()
                    end
                    if gradient then
                        TweenService:Create(gradient, fade_info, { Offset = Vector2.new(1, 0) }):Play()
                    end
                    if icon then
                        TweenService:Create(icon, fade_info, { ImageTransparency = 0.2, ImageColor3 = config.PrimaryColor }):Play()
                    end
                else
                    TweenService:Create(tab, fade_info, { BackgroundTransparency = 1 }):Play()
                    if label then
                        TweenService:Create(label, fade_info, { TextTransparency = 0.7, TextColor3 = (typeof(getgenv()._VanishUIText) == "Color3" and getgenv()._VanishUIText or Color3.fromRGB(255, 255, 255)) }):Play()
                    end
                    if gradient then
                        TweenService:Create(gradient, fade_info, { Offset = Vector2.new(0, 0) }):Play()
                    end
                    if icon then
                        TweenService:Create(icon, fade_info, { ImageTransparency = 0.8, ImageColor3 = Color3.fromRGB(255, 255, 255) }):Play()
                    end
                end
            else
                TweenService:Create(tab, fade_info, { BackgroundTransparency = 1 }):Play()
                if label then
                    TweenService:Create(label, fade_info, { TextTransparency = 1 }):Play()
                end
                if icon then
                    TweenService:Create(icon, fade_info, { ImageTransparency = 1 }):Play()
                end
            end
        end

        Category.MouseButton1Click:Connect(function()
            cat.token += 1
            local token = cat.token
            cat.collapsed = not cat.collapsed
            TweenService:Create(Arrow, fade_info, { Rotation = cat.collapsed and -90 or 0 }):Play()
            if cat.collapsed then
                for _, tab in ipairs(cat.members) do
                    paint_tab(tab, false)
                end
                TweenService:Create(Pin, fade_info, { BackgroundTransparency = 1 }):Play()
                task.delay(0.5, function()
                    if cat.collapsed and token == cat.token then
                        for _, tab in ipairs(cat.members) do
                            tab.Visible = false
                        end
                        Pin.Visible = false
                    end
                end)
            else
                for _, tab in ipairs(cat.members) do
                    tab.Visible = true
                    paint_tab(tab, true)
                end
                if selected_tab_btn and selected_tab_btn.Parent == Tabs and selected_tab_btn.Visible then
                    Pin.Visible = true
                    TweenService:Create(Pin, fade_info, { BackgroundTransparency = 0 }):Play()
                    self:update_tabs(selected_tab_btn)
                else
                    Pin.Visible = false
                end
            end
        end)

        return Category
    end

    function self:create_tab(title: string, icon: string)
        title = tostring(L(title) or title or "Tab")
        if title == "" or title == "nil" then
            title = "Tab"
        end
        local TabManager = {}

        local text_width = math.clamp(#title * 7, 40, 96)
        local first_tab = not Tabs:FindFirstChild('Tab')

        local Tab = Instance.new('TextButton')
        Tab.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        Tab.Font = Enum.Font.Gotham
        Tab.TextColor3 = Color3.fromRGB(0, 0, 0)
        Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Tab.Text = ''
        Tab.AutoButtonColor = false
        Tab.BackgroundTransparency = 1
        Tab.Name = 'Tab'
        Tab.Size = UDim2.new(0, 129, 0, 38)
        Tab.BorderSizePixel = 0
        Tab.TextSize = 14
        Tab.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        Tab.Parent = Tabs
        Tab.LayoutOrder = self._tab
        if current_category then
            table.insert(current_category.members, Tab)
        end

        local UICorner = Instance.new('UICorner')
        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = Tab

        local TextLabel = Instance.new('TextLabel')
        TextLabel.Name = 'TextLabel'
        TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextTransparency = 0.15
        TextLabel.Text = title
        TextLabel.Size = UDim2.new(0, text_width, 0, 16)
        TextLabel.AnchorPoint = Vector2.new(0, 0.5)
        TextLabel.Position = UDim2.new(0.2400001734495163, 0, 0.5, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.BorderSizePixel = 0
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.TextSize = 13
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.Parent = Tab

        local UIGradient = Instance.new('UIGradient')
        UIGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.7, Color3.fromRGB(210, 210, 210)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 170, 170))
        }
        UIGradient.Parent = TextLabel

        local Icon = Instance.new('ImageLabel')
        Icon.ScaleType = Enum.ScaleType.Fit
        Icon.ImageTransparency = 0.800000011920929
        Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.Position = UDim2.new(0.10000000149011612, 0, 0.5, 0)
        Icon.Name = 'Icon'
        Icon.Image = ''
        Icon.Size = UDim2.new(0, 12, 0, 12)
        pcall(function()
            apply_lucide_icon(Icon, icon, 48)
        end)
        Icon.BorderSizePixel = 0
        Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Icon.Parent = Tab

        local LeftSection = Instance.new('ScrollingFrame')
        LeftSection.Name = 'LeftSection'
        LeftSection.AutomaticCanvasSize = Enum.AutomaticSize.XY
        LeftSection.ScrollBarThickness = 0
        LeftSection.Size = UDim2.new(0, 243, 0, 445)
        LeftSection.Selectable = false
        LeftSection.AnchorPoint = Vector2.new(0, 0.5)
        LeftSection.ScrollBarImageTransparency = 1
        LeftSection.BackgroundTransparency = 1
        LeftSection.Position = UDim2.fromOffset(181, 275)
        LeftSection.BorderColor3 = Color3.fromRGB(0, 0, 0)
        LeftSection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LeftSection.BorderSizePixel = 0
        LeftSection.CanvasSize = UDim2.new(0, 0, 0.5, 0)
        LeftSection.Visible = false
        LeftSection.ZIndex = 2
        LeftSection.Parent = Handler
        table.insert(section_frames, LeftSection)

        local UIListLayout = Instance.new('UIListLayout')
        UIListLayout.Padding = UDim.new(0, 11)
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = LeftSection

        local UIPadding = Instance.new('UIPadding')
        UIPadding.PaddingTop = UDim.new(0, 1)
        UIPadding.Parent = LeftSection

        local RightSection = Instance.new('ScrollingFrame')
        RightSection.Name = 'RightSection'
        RightSection.AutomaticCanvasSize = Enum.AutomaticSize.XY
        RightSection.ScrollBarThickness = 0
        RightSection.Size = UDim2.new(0, 243, 0, 445)
        RightSection.Selectable = false
        RightSection.AnchorPoint = Vector2.new(0, 0.5)
        RightSection.ScrollBarImageTransparency = 1
        RightSection.BackgroundTransparency = 1
        RightSection.Position = UDim2.fromOffset(439, 275)
        RightSection.BorderColor3 = Color3.fromRGB(0, 0, 0)
        RightSection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        RightSection.BorderSizePixel = 0
        RightSection.CanvasSize = UDim2.new(0, 0, 0.5, 0)
        RightSection.Visible = false
        RightSection.ZIndex = 2
        RightSection.Parent = Handler
        table.insert(section_frames, RightSection)

        local UIListLayoutR = Instance.new('UIListLayout')
        UIListLayoutR.Padding = UDim.new(0, 11)
        UIListLayoutR.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayoutR.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayoutR.Parent = RightSection

        local UIPaddingR = Instance.new('UIPadding')
        UIPaddingR.PaddingTop = UDim.new(0, 1)
        UIPaddingR.Parent = RightSection

        LeftSection.ChildAdded:Connect(function()
            task.defer(apply_module_search)
        end)
        RightSection.ChildAdded:Connect(function()
            task.defer(apply_module_search)
        end)

        local tab_index = self._tab
        self._tab += 1

        table.insert(tab_registry, {
            tab = Tab,
            left = LeftSection,
            right = RightSection,
            title = title,
            index = tab_index,
        })

        local function select_this_tab()
            selected_tab_btn = Tab
            self:update_tabs(Tab)
            self:update_sections(LeftSection, RightSection)
        end

        if first_tab then
            select_this_tab()
        end

        Tab.MouseButton1Click:Connect(select_this_tab)

        function TabManager:create_module(settings: any)
            raise_plugin()
            if type(settings) ~= "table" then
                settings = {}
            end
            local raw_title = settings.title
            if settings.title then settings.title = L(settings.title) end
            if settings.description then settings.description = L(settings.description) end
            if type(settings.title) ~= "string" or settings.title == "" or settings.title == "nil" then
                settings.title = (type(raw_title) == "string" and raw_title ~= "" and raw_title) or "Module"
            end
            if type(settings.description) ~= "string" then
                settings.description = ""
            end

            local LayoutOrderModule = 0;

            local ModuleManager = {
                _state = false,
                _size = 0,
                _multiplier = 0
            }

            if settings.section == 'right' then
                settings.section = RightSection
            else
                settings.section = LeftSection
            end

            local Module = Instance.new('Frame')
            Module.ClipsDescendants = true
            Module.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Module.BackgroundTransparency = 0.5
            Module.Position = UDim2.new(0.004115226212888956, 0, 0, 0)
            Module.Name = 'Module'
            Module.Size = UDim2.new(0, 241, 0, 93)
            Module.BorderSizePixel = 0
            Module.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            raise_plugin()
            Module.Parent = settings.section

            local UIListLayout = Instance.new('UIListLayout')
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = Module

            local UICorner = Instance.new('UICorner')
            UICorner.CornerRadius = UDim.new(0, 5)
            UICorner.Parent = Module

            local UIStroke = Instance.new('UIStroke')
            UIStroke.Color = Color3.fromRGB(90, 90, 90)
            UIStroke.Transparency = 0.5
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Parent = Module

            local Header = Instance.new('TextButton')
            Header.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            Header.TextColor3 = Color3.fromRGB(0, 0, 0)
            Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Header.Text = ''
            Header.AutoButtonColor = false
            Header.BackgroundTransparency = 1
            Header.Name = 'Header'
            Header.Size = UDim2.new(0, 241, 0, 93)
            Header.BorderSizePixel = 0
            Header.TextSize = 14
            Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Header.Parent = Module

            local Icon = Instance.new('ImageLabel')
            Icon.ImageColor3 = config.PrimaryColor
            Icon.ScaleType = Enum.ScaleType.Fit
            Icon.ImageTransparency = 0.699999988079071
            Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.Image = 'rbxassetid://79095934438045'
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0.07100000232458115, 0, 0.8199999928474426, 0)
            Icon.Name = 'Icon'
            Icon.Size = UDim2.new(0, 15, 0, 15)
            Icon.BorderSizePixel = 0
            Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon.Parent = Header

            local ModuleName = Instance.new('TextLabel')
            ModuleName.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            ModuleName.Font = Enum.Font.GothamBold
            ModuleName.TextColor3 = config.PrimaryColor
            ModuleName.TextTransparency = 0.20000000298023224
            if not settings.rich then
                ModuleName.Text = settings.title or "Module"
            else
                ModuleName.RichText = true
                ModuleName.Text = settings.richtext or "<font color='rgb(255,0,0)'>"..(settings.title or "Module").."</font> user"
            end;
            ModuleName.Name = 'ModuleName'
            ModuleName.Size = UDim2.new(0, 176, 0, 13)
            ModuleName.AnchorPoint = Vector2.new(0, 0.5)
            ModuleName.Position = UDim2.new(0.0729999989271164, 0, 0.23999999463558197, 0)
            ModuleName.BackgroundTransparency = 1
            ModuleName.TextXAlignment = Enum.TextXAlignment.Left
            ModuleName.BorderSizePixel = 0
            ModuleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ModuleName.TextSize = 13
            ModuleName.TextTruncate = Enum.TextTruncate.AtEnd
            ModuleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ModuleName.Parent = Header

            local notify_flag = tostring(settings.flag or "Module") .. "_Notify"
            ModuleManager._notify = Library._config._flags[notify_flag] == true

            local NotifyBell = Instance.new("ImageButton")
            NotifyBell.Name = "NotifyBell"
            NotifyBell.AutoButtonColor = false
            NotifyBell.BackgroundTransparency = 1
            NotifyBell.BorderSizePixel = 0
            NotifyBell.AnchorPoint = Vector2.new(1, 0.5)
            NotifyBell.Position = UDim2.new(1, -8, 0.24, 0)
            NotifyBell.Size = UDim2.fromOffset(16, 16)
            NotifyBell.ScaleType = Enum.ScaleType.Fit
            NotifyBell.ZIndex = 5
            NotifyBell.Parent = Header

            local function paint_bell()
                if ModuleManager._notify then
                    NotifyBell.ImageColor3 = config.PrimaryColor
                    NotifyBell.ImageTransparency = 0
                    apply_lucide_icon(NotifyBell, "bell", 48)
                else
                    NotifyBell.ImageColor3 = Color3.fromRGB(180, 180, 180)
                    NotifyBell.ImageTransparency = 0.55
                    apply_lucide_icon(NotifyBell, "bell-off", 48)
                end
            end
            paint_bell()

            NotifyBell.MouseButton1Click:Connect(function()
                ModuleManager._block_header_click = true
                task.defer(function()
                    ModuleManager._block_header_click = false
                end)
                ModuleManager._notify = not ModuleManager._notify
                Library._config._flags[notify_flag] = ModuleManager._notify
                pcall(function()
                    Config:save(game.GameId, Library._config)
                end)
                paint_bell()
            end)

            local Description = Instance.new('TextLabel')
            Description.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            Description.TextColor3 = config.PrimaryColor
            Description.TextTransparency = 0.699999988079071
            Description.Text = settings.description or ""
            Description.Name = 'Description'
            Description.Size = UDim2.new(0, 205, 0, 13)
            Description.AnchorPoint = Vector2.new(0, 0.5)
            Description.Position = UDim2.new(0.0729999989271164, 0, 0.41999998688697815, 0)
            Description.BackgroundTransparency = 1
            Description.TextXAlignment = Enum.TextXAlignment.Left
            Description.BorderSizePixel = 0
            Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Description.TextSize = 10
            Description.TextTruncate = Enum.TextTruncate.AtEnd
            Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Description.Parent = Header

            local Toggle = Instance.new('Frame')
            Toggle.Name = 'Toggle'
            Toggle.BackgroundTransparency = 0.699999988079071
            Toggle.Position = UDim2.new(0.8199999928474426, 0, 0.7570000290870667, 0)
            Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.Size = UDim2.new(0, 25, 0, 12)
            Toggle.BorderSizePixel = 0
            Toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.Parent = Header

            local UICorner = Instance.new('UICorner')
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Toggle

            local Circle = Instance.new('Frame')
            Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            Circle.BackgroundTransparency = 0.20000000298023224
            Circle.Position = UDim2.new(0, 0, 0.5, 0)
            Circle.Name = 'Circle'
            Circle.Size = UDim2.new(0, 12, 0, 12)
            Circle.BorderSizePixel = 0
            Circle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            Circle.Parent = Toggle

            local UICorner = Instance.new('UICorner')
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Circle

            local Keybind = Instance.new('TextButton')
            Keybind.Name = 'Keybind'
            Keybind.Text = ''
            Keybind.AutoButtonColor = false
            Keybind.BackgroundTransparency = 0.699999988079071
            Keybind.Position = UDim2.new(0.15000000596046448, 0, 0.7350000143051147, 0)
            Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Keybind.Size = UDim2.new(0, 33, 0, 15)
            Keybind.BorderSizePixel = 0
            Keybind.BackgroundColor3 = config.PrimaryColor
            Keybind.Parent = Header

            local UICorner = Instance.new('UICorner')
            UICorner.CornerRadius = UDim.new(0, 3)
            UICorner.Parent = Keybind

            local TextLabel = Instance.new('TextLabel')
            TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.Text = 'None'
            TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel.Size = UDim2.new(0, 25, 0, 13)
            TextLabel.BackgroundTransparency = 1
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            TextLabel.BorderSizePixel = 0
            TextLabel.TextSize = 10
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.Parent = Keybind

            local Divider = Instance.new('Frame')
            Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Divider.AnchorPoint = Vector2.new(0.5, 0)
            Divider.BackgroundTransparency = 0.5
            Divider.Position = UDim2.new(0.5, 0, 0.6200000047683716, 0)
            Divider.Name = 'Divider'
            Divider.Size = UDim2.new(0, 241, 0, 1)
            Divider.BorderSizePixel = 0
            Divider.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            Divider.Parent = Header

            local Divider = Instance.new('Frame')
            Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Divider.AnchorPoint = Vector2.new(0.5, 0)
            Divider.BackgroundTransparency = 0.5
            Divider.Position = UDim2.new(0.5, 0, 1, 0)
            Divider.Name = 'Divider'
            Divider.Size = UDim2.new(0, 241, 0, 1)
            Divider.BorderSizePixel = 0
            Divider.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
            Divider.Parent = Header

            local Options = Instance.new('Frame')
            Options.Name = 'Options'
            Options.BackgroundTransparency = 1
            Options.Position = UDim2.new(0, 0, 1, 0)
            Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Options.Size = UDim2.new(0, 241, 0, 8)
            Options.BorderSizePixel = 0
            Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Options.Parent = Module

            local UIPadding = Instance.new('UIPadding')
            UIPadding.PaddingTop = UDim.new(0, 8)
            UIPadding.Parent = Options

            local UIListLayout = Instance.new('UIListLayout')
            UIListLayout.Padding = UDim.new(0, 5)
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = Options

            ModuleManager._block_header_click = false
            local function mark_option_input()
                ModuleManager._block_header_click = true
                task.defer(function()
                    ModuleManager._block_header_click = false
                end)
            end

            if settings.always_open then
                Toggle.Visible = false
                Keybind.Visible = false
                ModuleManager._state = true
            end

            function ModuleManager:refresh_open(animate)
                local option_height = math.max(0, (self._size or 0) + (self._multiplier or 0))
                Options.AutomaticSize = Enum.AutomaticSize.None
                Module.AutomaticSize = Enum.AutomaticSize.None
                Options.Visible = true
                Options.Size = UDim2.fromOffset(241, math.max(8, option_height))
                local open = self._state or settings.always_open
                local target = open and UDim2.fromOffset(241, 93 + option_height) or UDim2.fromOffset(241, 93)
                if animate and not settings.always_open then
                    TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = target
                    }):Play()
                else
                    Module.Size = target
                end
            end

            function ModuleManager:change_state(state: boolean)
                if settings.always_open then
                    state = true
                end
                self._state = state
                self:refresh_open(true)

                if self._state then
                    TweenService:Create(Toggle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = config.PrimaryColor
                    }):Play()

                    TweenService:Create(Circle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = config.PrimaryColor,
                        Position = UDim2.fromScale(0.53, 0.5)
                    }):Play()
                else
                    TweenService:Create(Toggle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    }):Play()

                    TweenService:Create(Circle, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                        Position = UDim2.fromScale(0, 0.5)
                    }):Play()
                end

                pcall(function()
                    Library._config._flags[settings.flag] = self._state
                    Config:save(game.GameId, Library._config)
                end)

                if settings.callback then
                    pcall(settings.callback, self._state)
                end

                if self._notify and not settings.always_open then
                    pcall(Library.SendNotification, {
                        title = settings.title or "Module",
                        text = self._state and "ON" or "OFF",
                        duration = 2,
                    })
                end
            end

            function ModuleManager:connect_keybind()
                if not Library._config._keybinds[settings.flag] then
                    return
                end

                Connections[settings.flag..'_keybind'] = UserInputService.InputBegan:Connect(function(input: InputObject)
                    if Library._choosing_keybind then
                        return
                    end
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then
                        return
                    end
                    if tostring(input.KeyCode) ~= Library._config._keybinds[settings.flag] then
                        return
                    end

                    self:change_state(not self._state)
                end)
            end

            function ModuleManager:scale_keybind(empty: boolean?)
                if Library._config._keybinds[settings.flag] and not empty then
                    local keybind_string = string.gsub(tostring(Library._config._keybinds[settings.flag]), 'Enum.KeyCode.', '')
                    local font_size = { X = math.max(12, #keybind_string * 7) }
                    pcall(function()
                        local font_params = Instance.new('GetTextBoundsParams')
                        font_params.Text = keybind_string
                        font_params.Font = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.Bold)
                        font_params.Size = 10
                        font_params.Width = 10000
                        font_size = TextService:GetTextBoundsAsync(font_params)
                    end)
                    Keybind.Size = UDim2.fromOffset(font_size.X + 6, 15)
                    TextLabel.Size = UDim2.fromOffset(font_size.X, 13)
                else
                    Keybind.Size = UDim2.fromOffset(31, 15)
                    TextLabel.Size = UDim2.fromOffset(25, 13)
                end
            end

            if not settings.always_open and settings.flag and Library._config._flags[settings.flag] == true then
                ModuleManager._state = true
                if settings.callback then
                    pcall(settings.callback, ModuleManager._state)
                end

                Toggle.BackgroundColor3 = config.PrimaryColor
                Circle.BackgroundColor3 = config.PrimaryColor
                Circle.Position = UDim2.fromScale(0.53, 0.5)
            elseif not settings.always_open then
                ModuleManager._state = false
                Module.Size = UDim2.fromOffset(241, 93)
            end

            if settings.flag and type(Library._config._keybinds) == "table" and Library._config._keybinds[settings.flag] then
                local keybind_string = string.gsub(tostring(Library._config._keybinds[settings.flag]), 'Enum.KeyCode.', '')
                TextLabel.Text = keybind_string

                ModuleManager:connect_keybind()
                ModuleManager:scale_keybind()
            end

            local function begin_module_keybind()
                if Library._choosing_keybind then
                    return
                end

                Library._choosing_keybind = true

                Connections['keybind_choose_start'] = UserInputService.InputBegan:Connect(function(input: InputObject)
                    if input.UserInputType ~= Enum.UserInputType.Keyboard then
                        return
                    end

                    if input.KeyCode == Enum.KeyCode.Unknown then
                        return
                    end

                    if input.KeyCode == Enum.KeyCode.Backspace then
                        ModuleManager:scale_keybind(true)

                        Library._config._keybinds[settings.flag] = nil
                        Config:save(game.GameId, Library._config)

                        TextLabel.Text = 'None'

                        if Connections[settings.flag..'_keybind'] then
                            Connections[settings.flag..'_keybind']:Disconnect()
                            Connections[settings.flag..'_keybind'] = nil
                        end

                        Connections['keybind_choose_start']:Disconnect()
                        Connections['keybind_choose_start'] = nil

                        Library._choosing_keybind = false

                        return
                    end

                    Connections['keybind_choose_start']:Disconnect()
                    Connections['keybind_choose_start'] = nil

                    Library._config._keybinds[settings.flag] = tostring(input.KeyCode)
                    Config:save(game.GameId, Library._config)

                    if Connections[settings.flag..'_keybind'] then
                        Connections[settings.flag..'_keybind']:Disconnect()
                        Connections[settings.flag..'_keybind'] = nil
                    end

                    ModuleManager:connect_keybind()
                    ModuleManager:scale_keybind()

                    Library._choosing_keybind = false

                    local keybind_string = string.gsub(tostring(Library._config._keybinds[settings.flag]), 'Enum.KeyCode.', '')
                    TextLabel.Text = keybind_string
                end)
            end

            Connections[settings.flag..'_input_began'] = Header.InputBegan:Connect(function(input: InputObject)
                if input.UserInputType ~= Enum.UserInputType.MouseButton3 then
                    return
                end
                begin_module_keybind()
            end)

            Keybind.Active = true
            Keybind.InputBegan:Connect(function(input: InputObject)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end
                begin_module_keybind()
            end)

            Header.MouseButton1Click:Connect(function()
                if ModuleManager._block_header_click then
                    return
                end
                if settings.always_open then
                    ModuleManager._state = true
                    ModuleManager._preview_open = nil
                    ModuleManager:refresh_open()
                    return
                end
                ModuleManager:change_state(not ModuleManager._state)
            end)

            function ModuleManager:create_paragraph(settings: any)
                raise_plugin()
                LayoutOrderModule = LayoutOrderModule + 1;

                local ParagraphManager = {}

                if self._size == 0 then
                    self._size = 11
                end

                self._size += settings.customScale or 70

                self:refresh_open()

                local Paragraph = Instance.new('Frame')
                Paragraph.BackgroundColor3 = config.PrimaryColor
                Paragraph.BackgroundTransparency = 0.85
                Paragraph.Size = UDim2.new(0, 207, 0, 30)
                Paragraph.BorderSizePixel = 0
                Paragraph.Name = "Paragraph"
                Paragraph.AutomaticSize = Enum.AutomaticSize.Y
                Paragraph.Parent = Options
                Paragraph.LayoutOrder = LayoutOrderModule;

                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Paragraph

                local Title = Instance.new('TextLabel')
                Title.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                Title.Text = settings.title or "Title"
                Title.Size = UDim2.new(1, -10, 0, 20)
                Title.Position = UDim2.new(0, 5, 0, 5)
                Title.BackgroundTransparency = 1
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.TextYAlignment = Enum.TextYAlignment.Center
                Title.TextSize = 12
                Title.AutomaticSize = Enum.AutomaticSize.XY
                Title.Parent = Paragraph

                local Body = Instance.new('TextLabel')
                Body.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Body.TextColor3 = Color3.fromRGB(220, 220, 220)

                if not settings.rich then
                    Body.Text = settings.text or "Paragrah"
                else
                    Body.RichText = true
                    Body.Text = settings.richtext or "<font color='rgb(255,0,0)'>"..(settings.title or "Paragraph").."</font> user"
                end

                Body.Size = UDim2.new(1, -10, 0, 20)
                Body.Position = UDim2.new(0, 5, 0, 30)
                Body.BackgroundTransparency = 1
                Body.TextXAlignment = Enum.TextXAlignment.Left
                Body.TextYAlignment = Enum.TextYAlignment.Top
                Body.TextSize = 11
                Body.TextWrapped = true
                Body.AutomaticSize = Enum.AutomaticSize.XY
                Body.Parent = Paragraph

                Paragraph.MouseEnter:Connect(function()
                    TweenService:Create(Paragraph, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.75
                    }):Play()
                end)

                Paragraph.MouseLeave:Connect(function()
                    TweenService:Create(Paragraph, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.85
                    }):Play()
                end)

                return ParagraphManager
            end

            function ModuleManager:create_text(settings: any)
                raise_plugin()
                LayoutOrderModule = LayoutOrderModule + 1

                local TextManager = {}

                if self._size == 0 then
                    self._size = 11
                end

                self._size += settings.customScale or 50

                self:refresh_open()

                local TextFrame = Instance.new('Frame')
                TextFrame.BackgroundColor3 = config.PrimaryColor
                TextFrame.BackgroundTransparency = 0.85
                TextFrame.Size = UDim2.new(0, 207, 0, settings.CustomYSize)
                TextFrame.BorderSizePixel = 0
                TextFrame.Name = "Text"
                TextFrame.AutomaticSize = Enum.AutomaticSize.Y
                TextFrame.Parent = Options
                TextFrame.LayoutOrder = LayoutOrderModule

                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = TextFrame

                local Body = Instance.new('TextLabel')
                Body.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Body.TextColor3 = Color3.fromRGB(220, 220, 220)

                if not settings.rich then
                    Body.Text = settings.text or "Text"
                else
                    Body.RichText = true
                    Body.Text = settings.richtext or "<font color='rgb(255,0,0)'>Text</font> user"
                end

                Body.Size = UDim2.new(1, -10, 1, 0)
                Body.Position = UDim2.new(0, 5, 0, 5)
                Body.BackgroundTransparency = 1
                Body.TextXAlignment = Enum.TextXAlignment.Left
                Body.TextYAlignment = Enum.TextYAlignment.Top
                Body.TextSize = 10
                Body.TextWrapped = true
                Body.AutomaticSize = Enum.AutomaticSize.XY
                Body.Parent = TextFrame

                TextFrame.MouseEnter:Connect(function()
                    TweenService:Create(TextFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.75
                    }):Play()
                end)

                TextFrame.MouseLeave:Connect(function()
                    TweenService:Create(TextFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0.85
                    }):Play()
                end)

                function TextManager:Set(new_settings)
                    if not new_settings.rich then
                        Body.Text = new_settings.text or "Skibidi"
                    else
                        Body.RichText = true
                        Body.Text = new_settings.richtext or "<font color='rgb(255,0,0)'>Text</font> user"
                    end
                end;

                return TextManager
            end
            function ModuleManager:create_textbox(settings: any)
                raise_plugin()
                if type(settings) == "table" and settings.title then settings.title = L(settings.title) end
                LayoutOrderModule = LayoutOrderModule + 1

                local TextboxManager = {
                    _text = ""
                }

                if self._size == 0 then
                    self._size = 11
                end

                self._size += 39
                self:refresh_open()

                local Holder = Instance.new("Frame")
                Holder.Name = "Textbox"
                Holder.BackgroundTransparency = 1
                Holder.Size = UDim2.new(0, 207, 0, 34)
                Holder.BorderSizePixel = 0
                Holder.Parent = Options
                Holder.LayoutOrder = LayoutOrderModule

                local Label = Instance.new("TextLabel")
                Label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextTransparency = 0.2
                Label.Text = settings.title or "Enter text"
                Label.Size = UDim2.new(1, 0, 0, 13)
                Label.BackgroundTransparency = 1
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.BorderSizePixel = 0
                Label.Parent = Holder
                Label.TextSize = 10

                local Textbox = Instance.new("TextBox")
                Textbox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                Textbox.PlaceholderColor3 = Color3.fromRGB(170, 170, 170)
                Textbox.PlaceholderText = settings.placeholder or "Enter text..."
                Textbox.Text = tostring(Library._config._flags[settings.flag] or settings.default or "")
                Textbox.Name = "Textbox"
                Textbox.Size = UDim2.new(1, 0, 0, 18)
                Textbox.Position = UDim2.new(0, 0, 0, 16)
                Textbox.BorderSizePixel = 0
                Textbox.TextSize = 12
                Textbox.TextXAlignment = Enum.TextXAlignment.Left
                Textbox.ClearTextOnFocus = false
                Textbox.BackgroundColor3 = config.PrimaryColor
                Textbox.BackgroundTransparency = 0.85
                Textbox.Parent = Holder

                local TextPadding = Instance.new("UIPadding")
                TextPadding.PaddingLeft = UDim.new(0, 6)
                TextPadding.PaddingRight = UDim.new(0, 4)
                TextPadding.Parent = Textbox

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Textbox

                function TextboxManager:get_text()
                    return Textbox.Text
                end

                function TextboxManager:set_text(text)
                    self._text = tostring(text or "")
                    Textbox.Text = self._text
                    Library._config._flags[settings.flag] = self._text
                    pcall(function()
                        Config:save(game.GameId, Library._config)
                    end)
                end

                function TextboxManager:update_text(text: string)
                    self:set_text(text)
                    pcall(settings.callback, self._text)
                end

                if Library:flag_type(settings.flag, "string") then
                    TextboxManager:update_text(Library._config._flags[settings.flag])
                end

                Textbox.FocusLost:Connect(function(_enter)
                    TextboxManager:update_text(Textbox.Text)
                end)

                Textbox:GetPropertyChangedSignal("Text"):Connect(function()
                    TextboxManager._text = Textbox.Text
                end)

                Library:register_option("textbox", settings.flag, function(v)
                    TextboxManager:update_text(tostring(v or ""))
                end)

                return TextboxManager
            end

            function ModuleManager:create_checkbox(settings: any)
                raise_plugin()
                if type(settings) == "table" and settings.title then settings.title = L(settings.title) end
                LayoutOrderModule = LayoutOrderModule + 1
                local CheckboxManager = { _state = false }

                if self._size == 0 then
                    self._size = 11
                end
                self._size += 20
                self:refresh_open()

                local Checkbox = Instance.new("TextButton")
                Checkbox.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Checkbox.TextColor3 = Color3.fromRGB(0, 0, 0)
                Checkbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Checkbox.Text = ""
                Checkbox.AutoButtonColor = false
                Checkbox.BackgroundTransparency = 1
                Checkbox.Name = "Checkbox"
                Checkbox.Size = UDim2.new(0, 207, 0, 15)
                Checkbox.BorderSizePixel = 0
                Checkbox.TextSize = 14
                Checkbox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Checkbox.Parent = Options
                Checkbox.LayoutOrder = LayoutOrderModule

                local TitleLabel = Instance.new("TextLabel")
                TitleLabel.Name = "TitleLabel"
                if SelectedLanguage == "th" then
                    TitleLabel.FontFace = Font.new("rbxasset://fonts/families/NotoSansThai.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TitleLabel.TextSize = 13
                else
                    TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TitleLabel.TextSize = 11
                end
                TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TitleLabel.TextTransparency = 0.2
                TitleLabel.Text = settings.title or "Skibidi"
                TitleLabel.Size = UDim2.new(1, -40, 0, 13)
                TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
                TitleLabel.Position = UDim2.new(0, 0, 0.5, 0)
                TitleLabel.BackgroundTransparency = 1
                TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
                TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
                TitleLabel.Parent = Checkbox

                local KeybindBox = Instance.new("Frame")
                KeybindBox.Name = "KeybindBox"
                KeybindBox.Size = UDim2.fromOffset(14, 14)
                KeybindBox.Position = UDim2.new(1, -35, 0.5, 0)
                KeybindBox.AnchorPoint = Vector2.new(0, 0.5)
                KeybindBox.BackgroundColor3 = config.PrimaryColor
                KeybindBox.BorderSizePixel = 0
                KeybindBox.Parent = Checkbox

                local KeybindCorner = Instance.new("UICorner")
                KeybindCorner.CornerRadius = UDim.new(0, 4)
                KeybindCorner.Parent = KeybindBox

                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Name = "KeybindLabel"
                KeybindLabel.Size = UDim2.new(1, 0, 1, 0)
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                KeybindLabel.TextScaled = false
                KeybindLabel.TextSize = 10
                KeybindLabel.Font = Enum.Font.SourceSans
                KeybindLabel.Text = Library._config._keybinds[settings.flag]
                    and string.gsub(tostring(Library._config._keybinds[settings.flag]), "Enum.KeyCode.", "")
                    or "..."
                KeybindLabel.Parent = KeybindBox

                local Box = Instance.new("Frame")
                Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Box.AnchorPoint = Vector2.new(1, 0.5)
                Box.BackgroundTransparency = 0.9
                Box.Position = UDim2.new(1, 0, 0.5, 0)
                Box.Name = "Box"
                Box.Size = UDim2.new(0, 15, 0, 15)
                Box.BorderSizePixel = 0
                Box.BackgroundColor3 = config.PrimaryColor
                Box.Parent = Checkbox

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 4)
                BoxCorner.Parent = Box

                local Fill = Instance.new("Frame")
                Fill.AnchorPoint = Vector2.new(0.5, 0.5)
                Fill.BackgroundTransparency = 0.2
                Fill.Position = UDim2.new(0.5, 0, 0.5, 0)
                Fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Fill.Name = "Fill"
                Fill.BorderSizePixel = 0
                Fill.BackgroundColor3 = config.PrimaryColor
                Fill.Parent = Box

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 3)
                FillCorner.Parent = Fill

                function CheckboxManager:change_state(state: boolean)
                    self._state = state
                    if self._state then
                        TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0.7
                        }):Play()
                        TweenService:Create(Fill, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(9, 9)
                        }):Play()
                    else
                        TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            BackgroundTransparency = 0.9
                        }):Play()
                        TweenService:Create(Fill, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(0, 0)
                        }):Play()
                    end
                    pcall(function()
                        Library._config._flags[settings.flag] = self._state
                        Config:save(game.GameId, Library._config)
                    end)
                    if settings.callback then
                        pcall(settings.callback, self._state)
                    end
                end

                if Library:flag_type(settings.flag, "boolean") then
                    CheckboxManager:change_state(Library._config._flags[settings.flag])
                end

                Checkbox.MouseButton1Click:Connect(function()
                    mark_option_input()
                    CheckboxManager:change_state(not CheckboxManager._state)
                end)

                Checkbox.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.UserInputType ~= Enum.UserInputType.MouseButton3 then return end
                    if Library._choosing_keybind then return end

                    Library._choosing_keybind = true
                    local chooseConnection
                    chooseConnection = UserInputService.InputBegan:Connect(function(keyInput, processed)
                        if processed then return end
                        if keyInput.UserInputType ~= Enum.UserInputType.Keyboard then return end
                        if keyInput.KeyCode == Enum.KeyCode.Unknown then return end

                        if keyInput.KeyCode == Enum.KeyCode.Backspace then
                            ModuleManager:scale_keybind(true)
                            Library._config._keybinds[settings.flag] = nil
                            Config:save(game.GameId, Library._config)
                            KeybindLabel.Text = "..."
                            if Connections[settings.flag .. "_keybind"] then
                                Connections[settings.flag .. "_keybind"]:Disconnect()
                                Connections[settings.flag .. "_keybind"] = nil
                            end
                            chooseConnection:Disconnect()
                            Library._choosing_keybind = false
                            return
                        end

                        chooseConnection:Disconnect()
                        Library._config._keybinds[settings.flag] = tostring(keyInput.KeyCode)
                        Config:save(game.GameId, Library._config)
                        if Connections[settings.flag .. "_keybind"] then
                            Connections[settings.flag .. "_keybind"]:Disconnect()
                            Connections[settings.flag .. "_keybind"] = nil
                        end
                        ModuleManager:connect_keybind()
                        ModuleManager:scale_keybind()
                        Library._choosing_keybind = false

                        local keybind_string = string.gsub(tostring(Library._config._keybinds[settings.flag]), "Enum.KeyCode.", "")
                        KeybindLabel.Text = keybind_string
                    end)
                end)

                local keyPressConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        local storedKey = Library._config._keybinds[settings.flag]
                        if storedKey and tostring(input.KeyCode) == storedKey then
                            CheckboxManager:change_state(not CheckboxManager._state)
                        end
                    end
                end)
                Connections[settings.flag .. "_keypress"] = keyPressConnection

                Library:register_option("checkbox", settings.flag, function(v)
                    local s = v
                    if type(v) == "table" then
                        s = v.checked
                    end
                    CheckboxManager:change_state(s == true or s == 1 or s == "true")
                end)

                return CheckboxManager
            end

            function ModuleManager:create_button(settings: any)
                raise_plugin()
                if type(settings) == "table" and settings.title then settings.title = L(settings.title) end
                LayoutOrderModule = LayoutOrderModule + 1

                if self._size == 0 then
                    self._size = 11
                end
                self._size += 24
                self:refresh_open()

                local Button = Instance.new("TextButton")
                Button.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Button.TextSize = 11
                Button.Size = UDim2.new(0, 207, 0, 20)
                Button.BackgroundColor3 = config.PrimaryColor
                Button.BackgroundTransparency = 0.85
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.Text = settings.title or "Button"
                Button.AutoButtonColor = false
                Button.TextTransparency = 0.2
                Button.BorderSizePixel = 0
                Button.Parent = Options
                Button.LayoutOrder = LayoutOrderModule

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button

                Button.MouseButton1Click:Connect(function()
                    mark_option_input()
                    if settings.callback then
                        task.defer(function()
                            pcall(settings.callback)
                        end)
                    end
                end)

                return Button
            end

            function ModuleManager:create_divider(settings: any)
                raise_plugin()
                LayoutOrderModule = LayoutOrderModule + 1;

                if self._size == 0 then
                    self._size = 11
                end

                self._size += 27
                self:refresh_open()

                local dividerHeight = 1
                local dividerWidth = 207

                local OuterFrame = Instance.new('Frame')
                OuterFrame.Size = UDim2.new(0, dividerWidth, 0, 20)
                OuterFrame.BackgroundTransparency = 1
                OuterFrame.Name = 'OuterFrame'
                OuterFrame.Parent = Options
                OuterFrame.LayoutOrder = LayoutOrderModule

                if settings and settings.showtopic then
                    local TextLabel = Instance.new('TextLabel')
                    TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    TextLabel.TextTransparency = 0
                    TextLabel.Text = settings.title
                    TextLabel.Size = UDim2.new(0, 153, 0, 13)
                    TextLabel.Position = UDim2.new(0.5, 0, 0.501, 0)
                    TextLabel.BackgroundTransparency = 1
                    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
                    TextLabel.BorderSizePixel = 0
                    TextLabel.AnchorPoint = Vector2.new(0.5,0.5)
                    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    TextLabel.TextSize = 11
                    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    TextLabel.ZIndex = 3;
                    TextLabel.TextStrokeTransparency = 0;
                    TextLabel.Parent = OuterFrame
                end;

                if not settings or settings and not settings.disableline then

                    local Divider = Instance.new('Frame')
                    Divider.Size = UDim2.new(1, 0, 0, dividerHeight)
                    Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Divider.BorderSizePixel = 0
                    Divider.Name = 'Divider'
                    Divider.Parent = OuterFrame
                    Divider.ZIndex = 2;
                    Divider.Position = UDim2.new(0, 0, 0.5, -dividerHeight / 2)

                    local Gradient = Instance.new('UIGradient')
                    Gradient.Parent = Divider
                    Gradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                    })
                    Gradient.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.5, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                    Gradient.Rotation = 0

                    local UICorner = Instance.new('UICorner')
                    UICorner.CornerRadius = UDim.new(0, 2)
                    UICorner.Parent = Divider

                end;

                return true;
            end

            function ModuleManager:create_slider(settings: any)
                raise_plugin()
                if type(settings) == "table" and settings.title then settings.title = L(settings.title) end

                LayoutOrderModule = LayoutOrderModule + 1

                local SliderManager = {}

                if self._size == 0 then
                    self._size = 11
                end

                self._size += 27
                self:refresh_open()

                local Slider = Instance.new('TextButton')
                Slider.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal);
                Slider.TextSize = 14;
                Slider.TextColor3 = Color3.fromRGB(0, 0, 0)
                Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Slider.Text = ''
                Slider.AutoButtonColor = false
                Slider.BackgroundTransparency = 1
                Slider.Name = 'Slider'
                Slider.Size = UDim2.new(0, 207, 0, 22)
                Slider.BorderSizePixel = 0
                Slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Slider.Parent = Options
                Slider.LayoutOrder = LayoutOrderModule

                local TextLabel = Instance.new('TextLabel')
                if GG.SelectedLanguage == "th" then
                    TextLabel.FontFace = Font.new("rbxasset://fonts/families/NotoSansThai.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TextLabel.TextSize = 13;
                else
                    TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TextLabel.TextSize = 11;
                end;
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextTransparency = 0.20000000298023224
                TextLabel.Text = settings.title
                TextLabel.Size = UDim2.new(0, 153, 0, 13)
                TextLabel.Position = UDim2.new(0, 0, 0.05000000074505806, 0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel.BorderSizePixel = 0
                TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.Parent = Slider

                local Drag = Instance.new('Frame')
                Drag.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Drag.AnchorPoint = Vector2.new(0.5, 1)
                Drag.BackgroundTransparency = 0.8999999761581421
                Drag.Position = UDim2.new(0.5, 0, 0.949999988079071, 0)
                Drag.Name = 'Drag'
                Drag.Size = UDim2.new(0, 207, 0, 4)
                Drag.BorderSizePixel = 0
                Drag.BackgroundColor3 = config.PrimaryColor
                Drag.Parent = Slider

                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(1, 0)
                UICorner.Parent = Drag

                local Fill = Instance.new('Frame')
                Fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Fill.AnchorPoint = Vector2.new(0, 0.5)
                Fill.BackgroundTransparency = 0.5
                Fill.Position = UDim2.new(0, 0, 0.5, 0)
                Fill.Name = 'Fill'
                Fill.Size = UDim2.new(0, 103, 0, 4)
                Fill.BorderSizePixel = 0
                Fill.BackgroundColor3 = config.PrimaryColor
                Fill.Parent = Drag

                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 3)
                UICorner.Parent = Fill

                local UIGradient = Instance.new('UIGradient')
                UIGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(79, 79, 79))
                }
                UIGradient.Parent = Fill

                local Circle = Instance.new('Frame')
                Circle.AnchorPoint = Vector2.new(1, 0.5)
                Circle.Name = 'Circle'
                Circle.Position = UDim2.new(1, 0, 0.5, 0)
                Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Circle.Size = UDim2.new(0, 6, 0, 6)
                Circle.BorderSizePixel = 0
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.Parent = Fill

                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(1, 0)
                UICorner.Parent = Circle

                local Value = Instance.new('TextLabel')
                Value.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                Value.TextColor3 = Color3.fromRGB(255, 255, 255)
                Value.TextTransparency = 0.20000000298023224
                Value.Text = '50'
                Value.Name = 'Value'
                Value.Size = UDim2.new(0, 42, 0, 13)
                Value.AnchorPoint = Vector2.new(1, 0)
                Value.Position = UDim2.new(1, 0, 0, 0)
                Value.BackgroundTransparency = 1
                Value.TextXAlignment = Enum.TextXAlignment.Right
                Value.BorderSizePixel = 0
                Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Value.TextSize = 10
                Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Value.Parent = Slider

                function SliderManager:set_percentage(percentage: number, from_drag)
                    local rounded_number = 0

                    if settings.round_number then
                        rounded_number = math.floor(percentage)
                    else
                        rounded_number = math.floor(percentage * 10) / 10
                    end

                    percentage = (percentage - settings.minimum_value) / (settings.maximum_value - settings.minimum_value)

                    local drag_width = Drag.AbsoluteSize.X
                    if drag_width <= 0 then
                        drag_width = Drag.Size.X.Offset
                    end
                    local slider_size = math.clamp(percentage, 0.02, 1) * drag_width
                    local number_threshold = math.clamp(rounded_number, settings.minimum_value, settings.maximum_value)

                    local previous = Library._config._flags[settings.flag]
                    Library._config._flags[settings.flag] = number_threshold
                    Value.Text = tostring(number_threshold)

                    TweenService:Create(Fill, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.fromOffset(slider_size, Drag.Size.Y.Offset)
                    }):Play()

                    if from_drag and previous == number_threshold then
                        return
                    end
                    if settings.callback then
                        pcall(settings.callback, number_threshold)
                    end
                end

                function SliderManager:update()
                    local mouse_position = (mouse.X - Drag.AbsolutePosition.X) / math.max(Drag.AbsoluteSize.X, 1)
                    local percentage = settings.minimum_value + (settings.maximum_value - settings.minimum_value) * mouse_position

                    self:set_percentage(percentage, true)
                end

                local slider_dragging = false
                function SliderManager:input()
                    if slider_dragging then
                        return
                    end
                    slider_dragging = true
                    mark_option_input()
                    Connections:disconnect('slider_drag_'..settings.flag)
                    Connections:disconnect('slider_touch_'..settings.flag)
                    Connections:disconnect('slider_input_'..settings.flag)

                    SliderManager:update()

                    Connections['slider_drag_'..settings.flag] = mouse.Move:Connect(function()
                        SliderManager:update()
                    end)

                    Connections['slider_touch_'..settings.flag] = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
                            SliderManager:update()
                        end
                    end)

                    Connections['slider_input_'..settings.flag] = UserInputService.InputEnded:Connect(function(input: InputObject, process: boolean)
                        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                            return
                        end

                        slider_dragging = false
                        Connections:disconnect('slider_drag_'..settings.flag)
                        Connections:disconnect('slider_touch_'..settings.flag)
                        Connections:disconnect('slider_input_'..settings.flag)

                        if not settings.ignoresaved then
                            Config:save(game.GameId, Library._config);
                        end;
                    end)
                end

                if Library:flag_type(settings.flag, 'number') then
                    if not settings.ignoresaved then
                        SliderManager:set_percentage(Library._config._flags[settings.flag]);
                    else
                        SliderManager:set_percentage(settings.value);
                    end;
                else
                    SliderManager:set_percentage(settings.value);
                end;

                Slider.MouseButton1Down:Connect(function()
                    SliderManager:input()
                end)
                Slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        SliderManager:input()
                    end
                end)

                Library:register_option("slider", settings.flag, function(v)
                    local n = tonumber(v)
                    if n then
                        SliderManager:set_percentage(n)
                    end
                end)

                return SliderManager
            end

            function ModuleManager:create_colorpicker(settings: any)
                raise_plugin()
                if type(settings) ~= "table" then
                    settings = {}
                end
                if type(settings.title) == "string" then settings.title = L(settings.title) end

                LayoutOrderModule = LayoutOrderModule + 1

                local ColorpickerManager = { _color = Color3.fromRGB(255, 255, 255) }

                if self._size == 0 then
                    self._size = 11
                end
                self._size += 95
                self:refresh_open()

                local function parse_hex(str)
                    if type(str) ~= "string" then return nil end
                    str = str:gsub("#", ""):gsub("%s+", "")
                    if not str:match("^[%x]+$") then return nil end
                    if #str == 3 then
                        str = str:sub(1, 1):rep(2) .. str:sub(2, 2):rep(2) .. str:sub(3, 3):rep(2)
                    end
                    if #str ~= 6 then return nil end
                    local ok, color = pcall(Color3.fromHex, str)
                    if ok and typeof(color) == "Color3" then return color end
                    return nil
                end

                local function to_hex(color)
                    return string.format("%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
                end

                local Picker = Instance.new('Frame')
                Picker.BackgroundTransparency = 1
                Picker.Name = 'ColorPicker'
                Picker.Size = UDim2.new(0, 207, 0, 90)
                Picker.BorderSizePixel = 0
                Picker.Parent = Options
                Picker.LayoutOrder = LayoutOrderModule

                local TextLabel = Instance.new('TextLabel')
                TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextTransparency = 0.20000000298023224
                TextLabel.Text = settings.title or "Color"
                TextLabel.Size = UDim2.new(0, 160, 0, 13)
                TextLabel.Position = UDim2.new(0, 0, 0, 2)
                TextLabel.BackgroundTransparency = 1
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel.BorderSizePixel = 0
                TextLabel.TextSize = 11
                TextLabel.Parent = Picker

                local Preview = Instance.new('Frame')
                Preview.Name = 'Preview'
                Preview.Size = UDim2.new(0, 36, 0, 16)
                Preview.Position = UDim2.new(1, -36, 0, 0)
                Preview.BorderSizePixel = 0
                Preview.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Preview.Parent = Picker

                local PreviewCorner = Instance.new('UICorner')
                PreviewCorner.CornerRadius = UDim.new(0, 4)
                PreviewCorner.Parent = Preview

                local PreviewStroke = Instance.new('UIStroke')
                PreviewStroke.Color = Color3.fromRGB(90, 90, 90)
                PreviewStroke.Transparency = 0.2
                PreviewStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                PreviewStroke.Parent = Preview

                local presets = {
                    "FFFFFF", "FF3B3B", "FF8C1A", "FFE135",
                    "3BFF5C", "00E5FF", "3B82FF", "9B30FF",
                    "FF4FD8", "A0A0A0", "3A3A3A", "000000",
                }
                local swatches = {}
                for i, hex in ipairs(presets) do
                    local swatch = Instance.new('TextButton')
                    swatch.Text = ''
                    swatch.AutoButtonColor = false
                    swatch.Name = 'Swatch'
                    swatch.Size = UDim2.new(0, 28, 0, 16)
                    swatch.Position = UDim2.new(0, ((i - 1) % 6) * 32, 0, 27 + math.floor((i - 1) / 6) * 20)
                    swatch.BorderSizePixel = 0
                    swatch.BackgroundColor3 = parse_hex(hex) or Color3.fromRGB(255, 255, 255)
                    swatch:SetAttribute("Hex", hex)
                    swatch.Parent = Picker
                    local corner = Instance.new('UICorner')
                    corner.CornerRadius = UDim.new(0, 3)
                    corner.Parent = swatch
                    local stroke = Instance.new('UIStroke')
                    stroke.Color = Color3.fromRGB(90, 90, 90)
                    stroke.Transparency = 0.4
                    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    stroke.Parent = swatch
                    table.insert(swatches, swatch)
                end

                local HexLabel = Instance.new('TextLabel')
                HexLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                HexLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
                HexLabel.TextTransparency = 0.2
                HexLabel.Text = "Custom"
                HexLabel.Size = UDim2.new(0, 60, 0, 22)
                HexLabel.Position = UDim2.new(0, 0, 0, 68)
                HexLabel.BackgroundTransparency = 1
                HexLabel.TextXAlignment = Enum.TextXAlignment.Left
                HexLabel.TextSize = 10
                HexLabel.Parent = Picker

                local HexBox = Instance.new('TextBox')
                HexBox.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                HexBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                HexBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
                HexBox.PlaceholderText = "#FFFFFF"
                HexBox.Text = ""
                HexBox.ClearTextOnFocus = false
                HexBox.TextSize = 11
                HexBox.Size = UDim2.new(0, 142, 0, 22)
                HexBox.Position = UDim2.new(0, 65, 0, 68)
                HexBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                HexBox.BackgroundTransparency = 0.1
                HexBox.BorderSizePixel = 0
                HexBox.Parent = Picker

                local HexCorner = Instance.new('UICorner')
                HexCorner.CornerRadius = UDim.new(0, 4)
                HexCorner.Parent = HexBox

                function ColorpickerManager:set_color(color, skip_save)
                    if typeof(color) ~= "Color3" then return end
                    self._color = color
                    local hex = to_hex(color)
                    Preview.BackgroundColor3 = color
                    HexBox.Text = "#" .. hex
                    for _, sw in ipairs(swatches) do
                        local stroke = sw:FindFirstChildOfClass("UIStroke")
                        if stroke then
                            if sw:GetAttribute("Hex") == hex then
                                stroke.Color = Color3.fromRGB(255, 255, 255)
                                stroke.Transparency = 0
                            else
                                stroke.Color = Color3.fromRGB(90, 90, 90)
                                stroke.Transparency = 0.4
                            end
                        end
                    end
                    Library._config._flags[settings.flag] = "#" .. hex
                    if not skip_save then
                        pcall(function()
                            Config:save(game.GameId, Library._config)
                        end)
                    end
                    if settings.callback then
                        pcall(settings.callback, color)
                    end
                end

                for _, swatch in ipairs(swatches) do
                    swatch.MouseButton1Click:Connect(function()
                        mark_option_input()
                        ColorpickerManager:set_color(swatch.BackgroundColor3)
                    end)
                end

                HexBox.FocusLost:Connect(function(enterPressed)
                    if not enterPressed then return end
                    mark_option_input()
                    local color = parse_hex(HexBox.Text)
                    if color then
                        ColorpickerManager:set_color(color)
                    else
                        HexBox.Text = "#" .. to_hex(ColorpickerManager._color)
                    end
                end)

                local initial = Color3.fromRGB(255, 255, 255)
                if type(settings.value) == "string" then
                    initial = parse_hex(settings.value) or initial
                elseif typeof(settings.value) == "Color3" then
                    initial = settings.value
                end
                local saved = Library._config and Library._config._flags and Library._config._flags[settings.flag]
                if type(saved) == "string" then
                    initial = parse_hex(saved) or initial
                end
                ColorpickerManager:set_color(initial, true)

                Library:register_option("colorpicker", settings.flag, function(v)
                    local c = nil
                    if typeof(v) == "Color3" then
                        c = v
                    else
                        pcall(function()
                            c = parse_hex(tostring(v or ""))
                        end)
                    end
                    if typeof(c) == "Color3" then
                        ColorpickerManager:set_color(c)
                    end
                end)

                return ColorpickerManager
            end

            function ModuleManager:create_dropdown(settings: any)
                raise_plugin()
                if type(settings) ~= "table" then
                    settings = {}
                end
                if type(settings.options) == "function" then
                    local ok, result = pcall(settings.options)
                    settings.options = (ok and type(result) == "table") and result or {}
                elseif type(settings.options) ~= "table" then
                    settings.options = {}
                end
                if type(settings) == "table" then
                    if settings.title then settings.title = L(settings.title) end
                    if type(settings.options) == "table" then
                        local opts = {}
                        for i, opt in ipairs(settings.options) do
                            opts[i] = L(tostring(opt))
                        end
                        settings.options = opts
                    end
                end

                if not settings.Order then
                    LayoutOrderModule = LayoutOrderModule + 1;
                end;

                local DropdownManager = {
                    _state = false,
                    _size = 0
                }

                if not settings.Order then
                    if self._size == 0 then
                        self._size = 11
                    end

                    self._size += 44
                end;

                if not settings.Order then
                    self:refresh_open()
                end

                local Dropdown = Instance.new('TextButton')
                Dropdown.FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                Dropdown.TextColor3 = Color3.fromRGB(0, 0, 0)
                Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Dropdown.Text = ''
                Dropdown.AutoButtonColor = false
                Dropdown.BackgroundTransparency = 1
                Dropdown.Name = 'Dropdown'
                Dropdown.Size = UDim2.new(0, 207, 0, 39)
                Dropdown.BorderSizePixel = 0
                Dropdown.TextSize = 14
                Dropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Dropdown.Parent = Options

                if not settings.Order then
                    Dropdown.LayoutOrder = LayoutOrderModule;
                else
                    Dropdown.LayoutOrder = settings.OrderValue;
                end;

                if not Library._config._flags[settings.flag] then
                    Library._config._flags[settings.flag] = {};
                end;

                local TextLabel = Instance.new('TextLabel')
                if GG.SelectedLanguage == "th" then
                    TextLabel.FontFace = Font.new("rbxasset://fonts/families/NotoSansThai.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                    TextLabel.TextSize = 13;
                else
                    TextLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                    TextLabel.TextSize = 11;
                end;
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextTransparency = 0.20000000298023224
                TextLabel.Text = settings.title
                TextLabel.Size = UDim2.new(0, 207, 0, 13)
                TextLabel.BackgroundTransparency = 1
                TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextLabel.BorderSizePixel = 0
                TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.Parent = Dropdown

                local Box = Instance.new('Frame')
                Box.ClipsDescendants = true
                Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Box.AnchorPoint = Vector2.new(0.5, 0)
                Box.BackgroundTransparency = 0.8999999761581421
                Box.Position = UDim2.new(0.5, 0, 1.2000000476837158, 0)
                Box.Name = 'Box'
                Box.Size = UDim2.new(0, 207, 0, 22)
                Box.BorderSizePixel = 0
                Box.BackgroundColor3 = config.PrimaryColor
                Box.Parent = TextLabel

                local UICorner = Instance.new('UICorner')
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = Box

                local Header = Instance.new('Frame')
                Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Header.AnchorPoint = Vector2.new(0.5, 0)
                Header.BackgroundTransparency = 1
                Header.Position = UDim2.new(0.5, 0, 0, 0)
                Header.Name = 'Header'
                Header.Size = UDim2.new(0, 207, 0, 22)
                Header.BorderSizePixel = 0
                Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Header.Parent = Box

                local CurrentOption = Instance.new('TextLabel')
                CurrentOption.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                CurrentOption.TextColor3 = Color3.fromRGB(255, 255, 255)
                CurrentOption.TextTransparency = 0.20000000298023224
                CurrentOption.Name = 'CurrentOption'
                CurrentOption.Size = UDim2.new(0, 161, 0, 13)
                CurrentOption.AnchorPoint = Vector2.new(0, 0.5)
                CurrentOption.Position = UDim2.new(0.04999988153576851, 0, 0.5, 0)
                CurrentOption.BackgroundTransparency = 1
                CurrentOption.TextXAlignment = Enum.TextXAlignment.Left
                CurrentOption.BorderSizePixel = 0
                CurrentOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
                CurrentOption.TextSize = 10
                CurrentOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                CurrentOption.Parent = Header
                local UIGradient = Instance.new('UIGradient')
                UIGradient.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.704, 0),
                    NumberSequenceKeypoint.new(0.872, 0.36250001192092896),
                    NumberSequenceKeypoint.new(1, 1)
                }
                UIGradient.Parent = CurrentOption

                local Arrow = Instance.new('ImageLabel')
                Arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Arrow.AnchorPoint = Vector2.new(0, 0.5)
                Arrow.Image = 'rbxassetid://84232453189324'
                Arrow.BackgroundTransparency = 1
                Arrow.Position = UDim2.new(0.9100000262260437, 0, 0.5, 0)
                Arrow.Name = 'Arrow'
                Arrow.Size = UDim2.new(0, 8, 0, 8)
                Arrow.BorderSizePixel = 0
                Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Arrow.Parent = Header

                local Options = Instance.new('ScrollingFrame')
                Options.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
                Options.Active = true
                Options.ScrollBarImageTransparency = 1
                Options.AutomaticCanvasSize = Enum.AutomaticSize.XY
                Options.ScrollBarThickness = 0
                Options.Name = 'Options'
                Options.Size = UDim2.new(0, 207, 0, 0)
                Options.BackgroundTransparency = 1
                Options.Position = UDim2.new(0, 0, 1, 0)
                Options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Options.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Options.BorderSizePixel = 0
                Options.CanvasSize = UDim2.new(0, 0, 0.5, 0)
                Options.Parent = Box

                local UIListLayout = Instance.new('UIListLayout')
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Parent = Options

                local UIPadding = Instance.new('UIPadding')
                UIPadding.PaddingTop = UDim.new(0, -1)
                UIPadding.PaddingLeft = UDim.new(0, 10)
                UIPadding.Parent = Options

                local UIListLayout = Instance.new('UIListLayout')
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Parent = Box

                local function for_each_option(handler)
                    for _, object in Options:GetChildren() do
                        local opt = nil
                        if object.Name == "Option" then
                            opt = object
                        elseif object.Name == "OptionRow" then
                            opt = object:FindFirstChild("Option")
                        end
                        if opt then
                            handler(opt)
                        end
                    end
                end

                function DropdownManager:update(option: string)

                    if settings.multi_dropdown then

                        if not Library._config._flags[settings.flag] then
                            Library._config._flags[settings.flag] = {};
                        end;

                        local CurrentTargetValue = nil;

                        if #Library._config._flags[settings.flag] > 0 then

                            CurrentTargetValue = convertTableToString(Library._config._flags[settings.flag]);

                        end;

                        local selected = {}

                        if CurrentTargetValue then
                            for value in string.gmatch(CurrentTargetValue, "([^,]+)") do

                                local trimmedValue = value:match("^%s*(.-)%s*$")

                                if trimmedValue ~= "Label" then
                                    table.insert(selected, trimmedValue)
                                end
                            end
                        else
                            for value in string.gmatch(CurrentOption.Text, "([^,]+)") do

                                local trimmedValue = value:match("^%s*(.-)%s*$")

                                if trimmedValue ~= "Label" then
                                    table.insert(selected, trimmedValue)
                                end
                            end
                        end;

                        local CurrentTextGet = convertStringToTable(CurrentOption.Text);

                        local optionSkibidi = "nil"
                        if type(option) == "table" or typeof(option) == "Instance" then
                            optionSkibidi = (option :: any).Name
                        else
                            optionSkibidi = option
                        end

                        local found = false
                        for i, v in pairs(CurrentTextGet) do
                            if v == optionSkibidi then
                                table.remove(CurrentTextGet, i);
                                break;
                            end
                        end

                        CurrentOption.Text = table.concat(selected, ", ")
                        local OptionsChild = {}

                        for_each_option(function(object)
                            table.insert(OptionsChild, object.Text)
                            if table.find(selected, object.Text) then
                                object.TextTransparency = 0.2
                            else
                                object.TextTransparency = 0.6
                            end
                        end)

                        CurrentTargetValue = convertStringToTable(CurrentOption.Text);

                        for index, v in CurrentTargetValue do
                            if not table.find(OptionsChild, v) and table.find(selected, v) then
                                table.remove(selected, index)
                            end;
                        end;

                        CurrentOption.Text = table.concat(selected, ", ");

                        Library._config._flags[settings.flag] = convertStringToTable(CurrentOption.Text);
                    else

                        if typeof(option) == "string" then
                            CurrentOption.Text = option
                        elseif type(option) == "table" or typeof(option) == "Instance" then
                            CurrentOption.Text = (option :: any).Name
                        else
                            CurrentOption.Text = tostring(option)
                        end
                        for_each_option(function(object)
                            if object.Text == CurrentOption.Text then
                                object.TextTransparency = 0.2
                            else
                                object.TextTransparency = 0.6
                            end
                        end)
                        Library._config._flags[settings.flag] = option
                    end

                    Config:save(game.GameId, Library._config)

                    settings.callback(option)
                end

                local CurrentDropSizeState = 0;

                function DropdownManager:unfold_settings()
                    if not ModuleManager._state then
                        return
                    end

                    self._state = not self._state

                    if self._state then
                        ModuleManager._multiplier += self._size

                        CurrentDropSizeState = self._size;

                        TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
                        }):Play()

                        TweenService:Create(Module.Options, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(241, ModuleManager._size + ModuleManager._multiplier)
                        }):Play()

                        TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(207, 39 + self._size)
                        }):Play()

                        TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(207, 22 + self._size)
                        }):Play()

                        TweenService:Create(Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Rotation = 180
                        }):Play()
                    else
                        ModuleManager._multiplier -= self._size

                        CurrentDropSizeState = 0;

                        TweenService:Create(Module, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(241, 93 + ModuleManager._size + ModuleManager._multiplier)
                        }):Play()

                        TweenService:Create(Module.Options, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(241, ModuleManager._size + ModuleManager._multiplier)
                        }):Play()

                        TweenService:Create(Dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(207, 39)
                        }):Play()

                        TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(207, 22)
                        }):Play()

                        TweenService:Create(Arrow, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                            Rotation = 0
                        }):Play()
                    end
                end

                if #settings.options > 0 then
                    DropdownManager._size = 3

                    for index, value in settings.options do
                        local optionName = (typeof(value) == "string" and value) or value.Name
                        local OptionParent = Options
                        if settings.option_keybinds then
                            local OptionRow = Instance.new('Frame')
                            OptionRow.Name = 'OptionRow'
                            OptionRow.Size = UDim2.new(0, 186, 0, 16)
                            OptionRow.BackgroundTransparency = 1
                            OptionRow.BorderSizePixel = 0
                            OptionRow.Parent = Options
                            OptionParent = OptionRow
                        end

                        local Option = Instance.new('TextButton')
                        Option.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                        Option.Active = false
                        Option.TextTransparency = 0.6000000238418579
                        Option.AnchorPoint = Vector2.new(0, 0.5)
                        Option.TextSize = 10
                        Option.Size = settings.option_keybinds and UDim2.new(0, 154, 0, 16) or UDim2.new(0, 186, 0, 16)
                        Option.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        Option.Text = optionName
                        Option.AutoButtonColor = false
                        Option.Name = 'Option'
                        Option.BackgroundTransparency = 1
                        Option.TextXAlignment = Enum.TextXAlignment.Left
                        Option.Selectable = false
                        Option.Position = settings.option_keybinds and UDim2.new(0, 0, 0.5, 0) or UDim2.new(0.04999988153576851, 0, 0.34210526943206787, 0)
                        Option.BorderSizePixel = 0
                        Option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        Option.Parent = OptionParent

                        local UIGradient = Instance.new('UIGradient')
                        UIGradient.Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(0.704, 0),
                            NumberSequenceKeypoint.new(0.872, 0.36250001192092896),
                            NumberSequenceKeypoint.new(1, 1)
                        }
                        UIGradient.Parent = Option

                        if settings.option_keybinds then
                            local bindFlag = tostring(settings.flag) .. '_Bind_' .. tostring(optionName)
                            local BindBtn = Instance.new('TextButton')
                            BindBtn.Name = 'Bind'
                            BindBtn.Size = UDim2.fromOffset(26, 14)
                            BindBtn.AnchorPoint = Vector2.new(1, 0.5)
                            BindBtn.Position = UDim2.new(1, 0, 0.5, 0)
                            BindBtn.BackgroundColor3 = config.PrimaryColor
                            BindBtn.BackgroundTransparency = 0.85
                            BindBtn.BorderSizePixel = 0
                            BindBtn.AutoButtonColor = false
                            BindBtn.Text = ''
                            BindBtn.ZIndex = 4
                            BindBtn.Parent = OptionParent

                            local BindCorner = Instance.new('UICorner')
                            BindCorner.CornerRadius = UDim.new(0, 3)
                            BindCorner.Parent = BindBtn

                            local BindStroke = Instance.new('UIStroke')
                            BindStroke.Color = Color3.fromRGB(255, 255, 255)
                            BindStroke.Transparency = 0.72
                            BindStroke.Thickness = 1
                            BindStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                            BindStroke.Parent = BindBtn

                            local BindLabel = Instance.new('TextLabel')
                            BindLabel.Name = 'BindLabel'
                            BindLabel.Size = UDim2.new(1, -2, 1, 0)
                            BindLabel.Position = UDim2.new(0, 1, 0, 0)
                            BindLabel.BackgroundTransparency = 1
                            BindLabel.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                            BindLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                            BindLabel.TextSize = 8
                            BindLabel.TextTruncate = Enum.TextTruncate.AtEnd
                            BindLabel.ZIndex = 5
                            BindLabel.Parent = BindBtn

                            local function bind_label_text()
                                local stored = Library._config._keybinds[bindFlag]
                                if stored then
                                    return string.gsub(tostring(stored), 'Enum.KeyCode.', '')
                                end
                                return '...'
                            end

                            BindLabel.Text = bind_label_text()

                            BindBtn.MouseButton1Click:Connect(function()
                                if Library._choosing_keybind then
                                    return
                                end
                                Library._choosing_keybind = true
                                BindLabel.Text = '...'
                                BindBtn.BackgroundColor3 = config.PrimaryColor
                                BindBtn.BackgroundTransparency = 0.7

                                local conn
                                conn = UserInputService.InputBegan:Connect(function(input)
                                    if input.UserInputType ~= Enum.UserInputType.Keyboard then
                                        return
                                    end
                                    if input.KeyCode == Enum.KeyCode.Unknown then
                                        return
                                    end
                                    conn:Disconnect()
                                    if input.KeyCode == Enum.KeyCode.Backspace then
                                        Library._config._keybinds[bindFlag] = nil
                                    else
                                        Library._config._keybinds[bindFlag] = tostring(input.KeyCode)
                                    end
                                    BindLabel.Text = bind_label_text()
                                    BindBtn.BackgroundColor3 = config.PrimaryColor
                                    BindBtn.BackgroundTransparency = 0.85
                                    Library._choosing_keybind = false
                                    Config:save(game.GameId, Library._config)
                                end)
                            end)

                            Connections[bindFlag .. '_option'] = UserInputService.InputBegan:Connect(function(input, process)
                                if process or Library._choosing_keybind then
                                    return
                                end
                                local stored = Library._config._keybinds[bindFlag]
                                if stored and tostring(input.KeyCode) == stored then
                                    DropdownManager:update(value)
                                end
                            end)
                        end

                        Option.MouseButton1Click:Connect(function()
                            mark_option_input()
                            if not Library._config._flags[settings.flag] then
                                Library._config._flags[settings.flag] = {};
                            end;

                            if settings.multi_dropdown then
                                if table.find(Library._config._flags[settings.flag], value) then
                                    Library:remove_table_value(Library._config._flags[settings.flag], value)
                                else
                                    table.insert(Library._config._flags[settings.flag], value)
                                end
                            end

                            DropdownManager:update(value)
                        end)

                        if index > settings.maximum_options then
                            continue
                        end

                        DropdownManager._size += 16
                        Options.Size = UDim2.fromOffset(207, DropdownManager._size)
                    end
                end

                function DropdownManager:New(value)
                    Dropdown:Destroy(true);
                    value.OrderValue = Dropdown.LayoutOrder
                    ModuleManager._multiplier -= CurrentDropSizeState
                    return ModuleManager:create_dropdown(value)
                end;

                if Library:flag_type(settings.flag, 'string') then
                    DropdownManager:update(Library._config._flags[settings.flag])
                elseif settings.options[1] ~= nil then
                    DropdownManager:update(settings.options[1])
                end

                Dropdown.MouseButton1Click:Connect(function()
                    mark_option_input()
                    DropdownManager:unfold_settings()
                end)

                Library:register_option("dropdown", settings.flag, function(v)
                    if type(v) == "string" then
                        DropdownManager:update(v)
                    end
                end)

                return DropdownManager
            end

            function ModuleManager:create_feature(settings)
                raise_plugin()
                local checked = false;

                LayoutOrderModule = LayoutOrderModule + 1

                if self._size == 0 then
                    self._size = 11
                end

                self._size += 20
                self:refresh_open()

                local FeatureContainer = Instance.new("Frame")
                FeatureContainer.Size = UDim2.new(0, 207, 0, 16)
                FeatureContainer.BackgroundTransparency = 1
                FeatureContainer.Parent = Options
                FeatureContainer.LayoutOrder = LayoutOrderModule

                local UIListLayout = Instance.new("UIListLayout")
                UIListLayout.FillDirection = Enum.FillDirection.Horizontal
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Parent = FeatureContainer

                local FeatureButton = Instance.new("TextButton")
                FeatureButton.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                FeatureButton.TextSize = 11;
                FeatureButton.Size = UDim2.new(1, -35, 0, 16)
                FeatureButton.BackgroundColor3 = config.PrimaryColor
                FeatureButton.BackgroundTransparency = 0.85
                FeatureButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                FeatureButton.Text = "    " .. settings.title or "    " .. "Feature"
                FeatureButton.AutoButtonColor = false
                FeatureButton.TextXAlignment = Enum.TextXAlignment.Left
                FeatureButton.TextTransparency = 0.2
                FeatureButton.BorderSizePixel = 0
                FeatureButton.Parent = FeatureContainer

                local FeatureCorner = Instance.new("UICorner")
                FeatureCorner.CornerRadius = UDim.new(0, 4)
                FeatureCorner.Parent = FeatureButton

                local RightContainer = Instance.new("Frame")
                RightContainer.Size = UDim2.new(0, 45, 0, 16)
                RightContainer.BackgroundTransparency = 1
                RightContainer.Parent = FeatureContainer

                local RightLayout = Instance.new("UIListLayout")
                RightLayout.Padding = UDim.new(0.1, 0)
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Parent = RightContainer

                local KeybindBox = Instance.new("TextLabel")
                KeybindBox.FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal);
                KeybindBox.Size = UDim2.new(0, 15, 0, 15)
                KeybindBox.BackgroundColor3 = config.PrimaryColor
                KeybindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindBox.TextSize = 11
                KeybindBox.BackgroundTransparency = 1
                KeybindBox.LayoutOrder = 2;
                KeybindBox.Parent = RightContainer

                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Size = UDim2.new(1, 0, 1, 0)
                KeybindButton.BackgroundTransparency = 1
                KeybindButton.TextTransparency = 1
                KeybindButton.Parent = KeybindBox

                local CheckboxCorner = Instance.new("UICorner", KeybindBox)
                CheckboxCorner.CornerRadius = UDim.new(0, 3)

                local UIStroke = Instance.new("UIStroke", KeybindBox)
                UIStroke.Color = config.PrimaryColor
                UIStroke.Thickness = 1
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                if not Library._config._flags then
                    Library._config._flags = {}
                end

                if not Library._config._flags[settings.flag] then
                    Library._config._flags[settings.flag] = {
                        checked = false,
                        BIND = settings.default or "Unknown"
                    }
                end

                checked = Library._config._flags[settings.flag].checked
                KeybindBox.Text = Library._config._flags[settings.flag].BIND

                if KeybindBox.Text == "Unknown" then
                    KeybindBox.Text = "...";
                end;

                local UseF_Var = nil;

                if not settings.disablecheck then
                    local Checkbox = Instance.new("TextButton")
                    Checkbox.Size = UDim2.new(0, 15, 0, 15)
                    Checkbox.BackgroundColor3 = checked and config.PrimaryColor or Color3.fromRGB(28, 28, 28)
                    Checkbox.Text = ""
                    Checkbox.Parent = RightContainer
                    Checkbox.LayoutOrder = 1;

                    local UIStroke = Instance.new("UIStroke", Checkbox)
                    UIStroke.Color = config.PrimaryColor
                    UIStroke.Thickness = 1
                    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

                    local CheckboxCorner = Instance.new("UICorner")
                    CheckboxCorner.CornerRadius = UDim.new(0, 3)
                    CheckboxCorner.Parent = Checkbox

                    local function toggleState()
                        checked = not checked
                        Checkbox.BackgroundColor3 = checked and config.PrimaryColor or Color3.fromRGB(28, 28, 28)
                        Library._config._flags[settings.flag].checked = checked
                        Config:save(game.GameId, Library._config)
                        if settings.callback then
                            settings.callback(checked)
                        end
                    end

                    UseF_Var = toggleState

                    Checkbox.MouseButton1Click:Connect(toggleState)

                else

                    UseF_Var = function()
                        settings.button_callback();
                    end;

                end;

                KeybindButton.MouseButton1Click:Connect(function()
                    KeybindBox.Text = "..."
                    local inputConnection
                    inputConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            local newKey = input.KeyCode.Name
                            Library._config._flags[settings.flag].BIND = newKey
                            if newKey ~= "Unknown" then
                                KeybindBox.Text = newKey;
                            end;
                            Config:save(game.GameId, Library._config)
                            inputConnection:Disconnect()
                        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                            Library._config._flags[settings.flag].BIND = "Unknown"
                            KeybindBox.Text = "..."
                            Config:save(game.GameId, Library._config)
                            inputConnection:Disconnect()
                        end
                    end)
                    Connections["keybind_input_" .. settings.flag] = inputConnection
                end)

                local keyPressConnection
                keyPressConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode.Name == Library._config._flags[settings.flag].BIND then
                            UseF_Var();
                        end
                    end
                end)
                Connections["keybind_press_" .. settings.flag] = keyPressConnection

                FeatureButton.MouseButton1Click:Connect(function()
                    mark_option_input()
                    if settings.button_callback then
                        settings.button_callback()
                    end
                end)

                if not settings.disablecheck then
                    settings.callback(checked);
                end;

                return FeatureContainer
            end

            ModuleManager._module = Module
            ModuleManager._section = settings.section

            Library:register_option("module", settings.flag, function(v)
                ModuleManager:change_state(v == true)
            end)

            return ModuleManager
        end

        return TabManager
    end

    Connections['library_visiblity'] = UserInputService.InputBegan:Connect(function(input: InputObject, process: boolean)
        if process then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end
        if input.KeyCode ~= Enum.KeyCode.Insert and input.KeyCode ~= Enum.KeyCode.LeftControl then
            return
        end

        self._ui_open = not self._ui_open
        self:change_visiblity(self._ui_open)
    end)

    self._ui.Container.Handler.Minimize.MouseButton1Click:Connect(function()
        self._ui_open = not self._ui_open
        self:change_visiblity(self._ui_open)
    end)

    return self
end

getgenv()._VanishRaisePlugin = raise_plugin
getgenv()._VanishLibConnections = Connections
getgenv()._VanishConfig = Config

return Library
end)()

local syn = getgenv().syn
local protect_gui = getgenv().protect_gui
local protectgui = getgenv().protectgui
local UIACProtection = protect_gui or protectgui or (type(syn) == "table" and syn.protect_gui) or function() end
local raise_plugin = getgenv()._VanishRaisePlugin or function() end

local function response_body(result)
    if type(result) == "string" then
        return result
    end
    if type(result) == "table" then
        return result.Body or result.body
    end
    return nil
end

local L = getgenv()._VanishL or function(t) return t end
local library = Library.new({
    title = L("Vanish Premium"),
    PrimaryColor = Color3.fromRGB(255, 255, 255)
})

pcall(function()
    local function AnimateGif(ImageLabel, Width, Height, Rows, Columns, NumberOfFrames, ImageID, FPS)
        if ImageID then ImageLabel.Image = ImageID end
        local RobloxMaxImageSize = 2048
        local RealWidth, RealHeight
        if math.max(Width, Height) > RobloxMaxImageSize then
            if Width > Height then
                RealWidth = RobloxMaxImageSize
                RealHeight = (RealWidth / Width) * Height
            else
                RealHeight = RobloxMaxImageSize
                RealWidth = (RealHeight / Height) * Width
            end
        else
            RealWidth, RealHeight = Width, Height
        end
        local FrameSize = Vector2.new(RealWidth / Columns, RealHeight / Rows)
        ImageLabel.ImageRectSize = FrameSize
        local CurrentRow, CurrentColumn = 0, 0
        local Offsets = {}
        for i = 1, NumberOfFrames do
            table.insert(Offsets, Vector2.new(CurrentColumn * FrameSize.X, CurrentRow * FrameSize.Y))
            CurrentColumn += 1
            if CurrentColumn >= Columns then
                CurrentColumn = 0
                CurrentRow += 1
            end
        end
        local TimeInterval = FPS and 1 / FPS or 0.1
        local Index = 0
        task.spawn(function()
            while task.wait(TimeInterval) and ImageLabel and ImageLabel:IsDescendantOf(game) do
                Index += 1
                ImageLabel.ImageRectOffset = Offsets[Index]
                if Index >= NumberOfFrames then
                    Index = 0
                end
            end
        end)
    end

    local function find_title_icon()
        local ui = library and (library._ui or library.ui)
        local handler = ui and ui:FindFirstChild("Handler", true)
        if handler then
            local icon = handler:FindFirstChild("Icon")
            if icon and icon:IsA("ImageLabel") then
                return icon
            end
        end
        local roots = {CoreGui}
        if LocalPlayer then
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then table.insert(roots, pg) end
        end
        for _, root in ipairs(roots) do
            for _, inst in ipairs(root:GetDescendants()) do
                if inst:IsA("TextLabel") and inst.Name == "ClientName" and inst.Text == "Vanish Premium" then
                    local titleIcon = inst.Parent and inst.Parent:FindFirstChild("Icon")
                    if titleIcon and titleIcon:IsA("ImageLabel") then
                        return titleIcon
                    end
                end
            end
        end
        return nil
    end

    local icon = find_title_icon()
    if not icon then return end
    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    icon.ScaleType = Enum.ScaleType.Fit
    local gifFps = UserInputService.TouchEnabled and 4 or 10
    AnimateGif(icon, 60, 40, 2, 3, 5, "rbxassetid://74080484918102", gifFps)
end)

library:create_category("Main Options")
local CombatTab = library:create_tab("Combat", "swords")
local MiscTab = library:create_tab("Client", "user")
local VisualsTab = library:create_tab("Visuals", "eye")
local BlatantTab = library:create_tab("Blatant", "skull")
local SwordTab = library:create_tab("Sword", "sword")
local SettingsTab = library:create_tab("Misc", "box")
library:create_category("Misc")
local ProtectionsTab = library:create_tab("Protections", "shield")

do
    pcall(function()
        if library and library.Update1Run then
            library:Update1Run("0")
        end
    end)
end

do
    local TeleportService = cloneref(game:GetService("TeleportService"))
    local cc_keywords = {
        "record", "recording", "clip", "clipping", "youtube", "youtu",
        "twitch", "tiktok", "stream", "streamer", "streaming", "vlog",
        "camera", "filming", "content", "creator",
    }
    local cc_action = "Notification"
    local cc_seen = {}
    local cc_alerted = false
    local cc_conn = nil

    local function is_cc_player(plr)
        if not plr or plr == LocalPlayer then
            return false
        end
        if cc_seen[plr.UserId] ~= nil then
            return cc_seen[plr.UserId]
        end
        local hay = string.lower(plr.Name .. " " .. plr.DisplayName)
        local hit = false
        for _, kw in ipairs(cc_keywords) do
            if string.find(hay, kw, 1, true) then
                hit = true
                break
            end
        end
        cc_seen[plr.UserId] = hit
        return hit
    end

    local function cc_notify(title, text, duration)
        local ok = pcall(function()
            Library.SendNotification({
                title = title,
                text = text,
                duration = duration or 3,
            })
        end)
        if not ok then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = title,
                    Text = text,
                    Duration = duration or 3,
                })
            end)
        end
    end

    local function handle_cc_found(plr)
        if cc_alerted then
            return
        end
        cc_alerted = true
        local name = (plr and plr.DisplayName) or "Unknown"
        if cc_action == "Kick" then
            cc_notify("Content Creator", name .. " — rejoining...", 3)
            task.delay(0.75, function()
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
            end)
            return
        end
        cc_notify("Content Creator", name .. " might be recording", 6)
    end

    local function check_cc_player(plr)
        if is_cc_player(plr) then
            handle_cc_found(plr)
        end
    end

    local function start_cc_detection()
        table.clear(cc_seen)
        cc_alerted = false
        for _, plr in ipairs(Players:GetPlayers()) do
            task.spawn(check_cc_player, plr)
        end
        if cc_conn then
            return
        end
        cc_conn = Players.PlayerAdded:Connect(function(plr)
            if not getgenv().AntiContentCreator then
                return
            end
            task.spawn(check_cc_player, plr)
        end)
    end

    local function stop_cc_detection()
        if cc_conn then
            cc_conn:Disconnect()
            cc_conn = nil
        end
        table.clear(cc_seen)
        cc_alerted = false
        getgenv().AntiContentCreator = false
    end

    getgenv()._Vanish_StopCC = stop_cc_detection

    local cc_module = ProtectionsTab:create_module({
        title = "Anti Content Creator",
        description = "Detect players that may record",
        flag = "AntiContentCreatorModule",
        section = "left",
        callback = function() end
    })

    cc_module:create_checkbox({
        title = "Enabled",
        flag = "AntiContentCreator",
        callback = function(state)
            getgenv().AntiContentCreator = (state == true or state == 1 or state == "true")
            if getgenv().AntiContentCreator then
                start_cc_detection()
            else
                stop_cc_detection()
            end
        end
    })

    cc_module:create_dropdown({
        title = "Action Mode",
        flag = "AntiContentCreator_Action",
        options = { "Notification", "Kick" },
        maximum_options = 2,
        callback = function(value)
            if typeof(value) == "table" then
                value = value[1] or value.Name or value.name or value.value or value.Value
            end
            value = (value ~= nil and tostring(value)) or nil
            if value == "Notification" or value == "Kick" then
                cc_action = value
            end
        end
    })
end

do
    local ae_conn = nil
    local ae_track = {}
    local ae_flagged = {}
    local ae_accum = 0
    local ae_action = "Notification"

    local function ae_get_state(hum)
        local st = nil
        pcall(function()
            st = hum:GetState()
        end)
        return st
    end

    local function ae_get_lin_vel(root)
        local v = nil
        pcall(function()
            v = root.AssemblyLinearVelocity
        end)
        if typeof(v) ~= "Vector3" then
            pcall(function()
                v = root.Velocity
            end)
        end
        if typeof(v) ~= "Vector3" then
            v = Vector3.zero
        end
        return v
    end

    local function ae_get_ang_vel(root)
        local w = nil
        pcall(function()
            w = root.AssemblyAngularVelocity
        end)
        if typeof(w) ~= "Vector3" then
            pcall(function()
                w = root.RotVelocity
            end)
        end
        if typeof(w) ~= "Vector3" then
            w = Vector3.zero
        end
        return w
    end

    local function ae_bind(plr, char, root)
        local t = {
            char = char,
            pos = root.Position,
            clock = os.clock(),
            spawn_grace_until = os.clock() + 3,
            speed = 0,
            walkspeed = 0,
            jump = 0,
            rise = 0,
            tp = 0,
            spin = 0,
        }
        ae_track[plr.UserId] = t
        return t
    end

    local function ae_bump(t, key)
        t[key] = (t[key] or 0) + 1
        return t[key]
    end

    local function ae_cool(t, key)
        if (t[key] or 0) > 0 then
            t[key] = t[key] - 1
        end
    end

    local function ae_handle_found(plr, evidence)
        if ae_flagged[plr.UserId] then
            return
        end
        ae_flagged[plr.UserId] = true
        local name = (plr and plr.DisplayName) or "Unknown"
        if ae_action == "Kick" then
            pcall(Library.SendNotification, {
                title = "Anti Exploit",
                text = "Cheater: " .. name .. " (" .. evidence .. ") — rejoining...",
                duration = 3
            })
            task.delay(0.75, function()
                pcall(function()
                    cloneref(game:GetService("TeleportService")):Teleport(game.PlaceId, LocalPlayer)
                end)
            end)
            return
        end
        pcall(Library.SendNotification, {
            title = "Anti Exploit",
            text = "Cheater: " .. name .. " (" .. evidence .. ")",
            duration = 6
        })
    end

    local function ae_check_player(plr, tick_dt)
        if not plr or plr == LocalPlayer then
            return
        end
        if ae_flagged[plr.UserId] then
            return
        end
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then
            return
        end
        local alive = hum.Health > 0
        local state = ae_get_state(hum)
        if not alive or state == Enum.HumanoidStateType.Dead then
            ae_track[plr.UserId] = nil
            return
        end
        local anchored = false
        pcall(function()
            anchored = root.Anchored
        end)
        if anchored then
            return
        end
        local seated = false
        pcall(function()
            seated = hum.Seated
        end)
        if seated then
            return
        end
        local now = os.clock()
        local t = ae_track[plr.UserId]
        if not t or t.char ~= char then
            ae_bind(plr, char, root)
            return
        end
        if now < t.spawn_grace_until then
            t.pos = root.Position
            t.clock = now
            return
        end
        local dt = math.clamp(now - t.clock, 0.05, 2)
        t.clock = now
        local delta = root.Position - t.pos
        t.pos = root.Position
        local flat_dist = Vector3.new(delta.X, 0, delta.Z).Magnitude
        local flat_speed = flat_dist / dt

        -- 1. Real movement speed (studs/sec vs their own WalkSpeed, sustained 1.5s)
        local ws = 16
        pcall(function()
            ws = hum.WalkSpeed
        end)
        local speed_cap = math.max(30, ws * 1.5 + 8)
        if flat_speed > speed_cap then
            if ae_bump(t, "speed") >= 3 then
                ae_handle_found(plr, "speed " .. math.floor(flat_speed) .. " studs/s")
                return
            end
        else
            ae_cool(t, "speed")
        end

        -- 2. WalkSpeed tamper (extreme value held, not a one-frame spike)
        if ws > 45 then
            if ae_bump(t, "walkspeed") >= 3 then
                ae_handle_found(plr, "walkspeed " .. math.floor(ws))
                return
            end
        else
            ae_cool(t, "walkspeed")
        end

        -- 3. Jump tamper (extreme value held)
        local jp, jh = 50, 7.2
        pcall(function() jp = hum.JumpPower end)
        pcall(function() jh = hum.JumpHeight end)
        if jp > 100 or jh > 20 then
            if ae_bump(t, "jump") >= 3 then
                ae_handle_found(plr, "jump power")
                return
            end
        else
            ae_cool(t, "jump")
        end

        -- 4. Fly (rising through the air with no jump, sustained 2.5s)
        local flying_state = state ~= Enum.HumanoidStateType.Jumping
            and state ~= Enum.HumanoidStateType.Swimming
            and state ~= Enum.HumanoidStateType.Climbing
            and state ~= Enum.HumanoidStateType.Seated
            and state ~= Enum.HumanoidStateType.Ragdoll
            and state ~= Enum.HumanoidStateType.Physics
            and state ~= Enum.HumanoidStateType.PlatformStanding
        local airborne = false
        pcall(function()
            airborne = (hum.FloorMaterial == Enum.Material.Air)
        end)
        local vel = ae_get_lin_vel(root)
        if flying_state and airborne and vel.Y > 4 then
            if ae_bump(t, "rise") >= 5 then
                ae_handle_found(plr, "fly (rising with no jump)")
                return
            end
        else
            ae_cool(t, "rise")
        end

        -- 5. Teleport (impossible displacement, confirmed twice)
        local moved = delta.Magnitude
        if moved > 60 and (moved / dt) > 150 and dt < 1.2 then
            if ae_bump(t, "tp") >= 2 then
                ae_handle_found(plr, "teleport (" .. math.floor(moved) .. " studs)")
                return
            end
        else
            ae_cool(t, "tp")
        end

        -- 6. Spin / fling (violent rotation held for 2s, tumbling excluded)
        local tumbling = state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Physics
        local spin_mag = ae_get_ang_vel(root).Magnitude
        if not tumbling and spin_mag > 60 then
            if ae_bump(t, "spin") >= 4 then
                ae_handle_found(plr, "spin (" .. math.floor(spin_mag) .. " rad/s)")
                return
            end
        else
            ae_cool(t, "spin")
        end
    end

    local function ae_stop()
        if ae_conn then
            pcall(function()
                ae_conn:Disconnect()
            end)
            ae_conn = nil
        end
        table.clear(ae_track)
        table.clear(ae_flagged)
        ae_accum = 0
        getgenv().AntiExploit = false
    end

    local function ae_start()
        if ae_conn then
            return
        end
        table.clear(ae_track)
        table.clear(ae_flagged)
        ae_accum = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if plr ~= LocalPlayer and char and root then
                ae_bind(plr, char, root)
            end
        end
        ae_conn = RunService.Heartbeat:Connect(function(dt)
            if not getgenv().AntiExploit then
                return
            end
            ae_accum += dt
            if ae_accum < 0.5 then
                return
            end
            ae_accum = 0
            local tick_dt = 0.5
            for _, plr in ipairs(Players:GetPlayers()) do
                ae_check_player(plr, tick_dt)
            end
        end)
    end

    getgenv()._Vanish_StopAntiExploit = ae_stop

    local ae_module = ProtectionsTab:create_module({
        title = "Anti Exploit",
        description = "Kicks you if a cheater is found",
        flag = "AntiExploitModule",
        section = "right",
        callback = function() end
    })

    ae_module:create_checkbox({
        title = "Enabled",
        flag = "AntiExploit",
        callback = function(state)
            getgenv().AntiExploit = (state == true or state == 1 or state == "true")
            if getgenv().AntiExploit then
                ae_start()
            else
                ae_stop()
            end
        end
    })

    ae_module:create_dropdown({
        title = "Action Mode",
        flag = "AntiExploit_Action",
        options = { "Notification", "Kick" },
        maximum_options = 2,
        callback = function(value)
            if typeof(value) == "table" then
                value = value[1] or value.Name or value.name or value.value or value.Value
            end
            value = (value ~= nil and tostring(value)) or nil
            if value == "Notification" or value == "Kick" then
                ae_action = value
            end
        end
    })
end

pcall(function()
    if library and not library._ui_loaded then
        library:load()
    end
end)

local function Notify(settings)
    local tr = getgenv()._VanishL or function(t) return t end
    local title = tr(settings.Title or settings.title or "Vanish")
    local text = tr(settings.Content or settings.text or "")
    local duration = settings.Duration or settings.duration or 3
    pcall(function()
        local notifyGui = getgenv()._VanishNotifyGui
        if typeof(notifyGui) == "Instance" then
            (notifyGui :: ScreenGui).Enabled = true
        end
    end)
    local ok = pcall(Library.SendNotification, {
        title = title,
        text = text,
        duration = duration
    })
    if not ok then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = duration,
            })
        end)
    end
end

local function section_notify_on(flag)
    local flags = Library and Library._config and Library._config._flags
    return type(flags) == "table" and flags[tostring(flag) .. "_Notify"] == true
end

local function dropdown_value(value)
    if type(value) == "table" then
        value = value[1] or value.Name or value.name or value.value or value.Value
    end
    if value == nil then return nil end
    return tostring(value)
end

local function toggle_state(value)
    return value == true or value == 1 or value == "true" or value == "on" or value == "On"
end

getgenv().UIWatermark = true

do
    local TeleportService = cloneref(game:GetService("TeleportService"))

    local server_tools_module = SettingsTab:create_module({
        title = "Server Tools",
        description = "Rejoin and hop servers",
        flag = "ServerToolsModule",
        section = "left",
        always_open = true,
        callback = function() end
    })

    server_tools_module:create_button({
        title = "Rejoin",
        callback = function()
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
        end
    })

    server_tools_module:create_button({
        title = "Server Hop",
        callback = function()
            task.spawn(function()
                local placeId = game.PlaceId
                local jobId = game.JobId
                local ok, result = pcall(function()
                    local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&excludeFullGames=true&limit=100"
                    local body
                    if syn and syn.request then
                        body = response_body(syn.request({ Url = url, Method = "GET" }))
                    elseif http_request then
                        body = response_body(http_request({ Url = url, Method = "GET" }))
                    elseif request then
                        body = response_body(request({ Url = url, Method = "GET" }))
                    else
                        body = game:HttpGet(url)
                    end
                    return HttpService:JSONDecode(body)
                end)
                if not ok or type(result) ~= "table" or type(result.data) ~= "table" then
                    Notify({ title = "Server Hop", text = "Couldn't find a server", duration = 3 })
                    return
                end
                for _, server in ipairs(result.data) do
                    if server.id ~= jobId and (server.playing or 0) < (server.maxPlayers or 0) then
                        pcall(function()
                            TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                        end)
                        return
                    end
                end
                Notify({ title = "Server Hop", text = "No other servers found", duration = 3 })
            end)
        end
    })

end

do
    pcall(function()
        if getgenv()._Vanish_StaffDet_Stop then
            getgenv()._Vanish_StaffDet_Stop()
            getgenv()._Vanish_StaffDet_Stop = nil
        end
    end)

    local TeleportService = cloneref(game:GetService("TeleportService"))
    local STAFF_GROUP_ID = 12836673
    local STAFF_MIN_RANK = 2
    local staff_detected = {}
    local staff_action = "Notification"
    local staff_player_added = nil
    local staff_alerted = false

    local function is_staff_player(plr)
        if not plr or plr == LocalPlayer then
            return false
        end
        if staff_detected[plr.UserId] ~= nil then
            return staff_detected[plr.UserId]
        end
        local ok, result = pcall(function()
            return plr:IsInGroup(STAFF_GROUP_ID) and plr:GetRankInGroup(STAFF_GROUP_ID) >= STAFF_MIN_RANK
        end)
        local is_staff = ok and result == true
        staff_detected[plr.UserId] = is_staff
        return is_staff
    end

    local function handle_staff_found(plr)
        if staff_alerted then
            return
        end
        staff_alerted = true
        local name = (plr and plr.Name) or "Unknown"
        if staff_action == "Kick" then
            Notify({ title = "Staff Detected", text = name .. " — rejoining...", duration = 3 })
            task.delay(0.75, function()
                pcall(function()
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end)
            end)
            return
        end
        Notify({ title = "Staff Detected", text = name .. " joined the server", duration = 6 })
    end

    local function check_staff_player(plr)
        if is_staff_player(plr) then
            handle_staff_found(plr)
        end
    end

    local function start_staff_detection()
        table.clear(staff_detected)
        staff_alerted = false
        for _, plr in ipairs(Players:GetPlayers()) do
            task.spawn(check_staff_player, plr)
        end
        if staff_player_added then
            return
        end
        staff_player_added = Players.PlayerAdded:Connect(function(plr)
            if not getgenv().StaffDetection then
                return
            end
            task.spawn(check_staff_player, plr)
        end)
    end

    local function stop_staff_detection()
        if staff_player_added then
            staff_player_added:Disconnect()
            staff_player_added = nil
        end
        table.clear(staff_detected)
        staff_alerted = false
        getgenv().StaffDetection = false
    end

    getgenv()._Vanish_StaffDet_Stop = stop_staff_detection

    local staff_prot_module = ProtectionsTab:create_module({
        title = "Staff Detection",
        description = "Detect Blade Ball moderators",
        flag = "StaffDetectionProtModule",
        section = "right",
        callback = function() end
    })

    staff_prot_module:create_checkbox({
        title = "Enabled",
        flag = "StaffDetectionProt",
        callback = function(state)
            getgenv().StaffDetection = toggle_state(state)
            if getgenv().StaffDetection then
                start_staff_detection()
            else
                stop_staff_detection()
            end
        end
    })

    staff_prot_module:create_dropdown({
        title = "Action Mode",
        flag = "StaffDetectionProt_Action",
        options = { "Notification", "Kick" },
        maximum_options = 2,
        callback = function(value)
            value = dropdown_value(value)
            if value == "Notification" or value == "Kick" then
                staff_action = value
            end
        end
    })

end

local performance_module = SettingsTab:create_module({
    title = "Performance",
    description = "FPS and graphics options",
    flag = "PerformanceModule",
    section = "right",
    callback = function(state)
        getgenv().PerformanceEnabled = toggle_state(state)
        pcall(function()
            if getgenv()._Vanish_ApplyPerformance then
                getgenv()._Vanish_ApplyPerformance()
            end
        end)
    end
})

performance_module:create_checkbox({
    title = "Unlock FPS",
    flag = "UnlockFPSToggle",
    callback = function(value)
        getgenv().UnlockFPS = toggle_state(value)
        pcall(function()
            if getgenv()._Vanish_ApplyPerformance then
                getgenv()._Vanish_ApplyPerformance()
            end
        end)
    end
})

performance_module:create_checkbox({
    title = "FPS Boost",
    flag = "FPSBoostToggle",
    callback = function(value)
        getgenv().FPSBoost = toggle_state(value)
        pcall(function()
            if getgenv()._Vanish_ApplyPerformance then
                getgenv()._Vanish_ApplyPerformance()
            end
        end)
    end
})

performance_module:create_checkbox({
    title = "Low Graphics",
    flag = "LowGraphicsToggle",
    callback = function(value)
        getgenv().LowGraphics = toggle_state(value)
        pcall(function()
            if getgenv()._Vanish_ApplyPerformance then
                getgenv()._Vanish_ApplyPerformance()
            end
        end)
    end
})

local config_code_module = SettingsTab:create_module({
    title = "Configs",
    description = "Import and export options as code",
    flag = "ConfigCodeModule",
    section = "right",
    callback = function() end
})

local function config_obf_encode(s)
    local parts = {}
    for i = 1, #s do
        parts[i] = tostring(string.byte(s, i))
    end
    return table.concat(parts, "_")
end

local function config_obf_decode(code)
    if type(code) ~= "string" or code == "" then
        return nil
    end
    if not code:match("^[%d_]+$") then
        return nil
    end
    local bytes = {}
    for num in code:gmatch("(%d+)") do
        local b = tonumber(num)
        if not b or b < 0 or b > 255 then
            return nil
        end
        bytes[#bytes + 1] = string.char(b)
    end
    if #bytes == 0 then
        return nil
    end
    return table.concat(bytes)
end

local CONFIG_CODE_SKIP = { ConfigCodeBox = true }

local config_code_box = config_code_module:create_textbox({
    title = "Config Code",
    flag = "ConfigCodeBox",
    placeholder = "Paste config code here...",
    default = "",
    callback = function() end
})

config_code_module:create_button({
    title = "Export Code",
    callback = function()
        local flags = (Library and Library._config and Library._config._flags) or {}
        local clean = {}
        for k, v in pairs(flags) do
            if not CONFIG_CODE_SKIP[k] then
                clean[k] = v
            end
        end
        local ok, code = pcall(HttpService.JSONEncode, HttpService, { game = game.PlaceId, flags = clean })
        if not ok or type(code) ~= "string" or code == "" then
            pcall(function()
                Notify({ title = "Configs", text = "Export failed", duration = 3 })
            end)
            return
        end
        code = config_obf_encode(code)
        pcall(function()
            config_code_box:set_text(code)
        end)
        if type(setclipboard) == "function" then
            pcall(setclipboard, code)
        end
        pcall(function()
            Notify({ title = "Configs", text = "Code copied to clipboard", duration = 3 })
        end)
    end
})

config_code_module:create_button({
    title = "Import Code",
    callback = function()
        local code = ""
        pcall(function()
            code = config_code_box:get_text()
        end)
        if type(code) ~= "string" or code == "" then
            pcall(function()
                Notify({ title = "Configs", text = "Paste a code first", duration = 3 })
            end)
            return
        end
        local ok, data = pcall(HttpService.JSONDecode, HttpService, config_obf_decode(code) or code)
        if not ok or type(data) ~= "table" or type(data.flags) ~= "table" then
            pcall(function()
                Notify({ title = "Configs", text = "Invalid config code", duration = 3 })
            end)
            return
        end
        local applied, failed = 0, 0
        for _, entry in ipairs(Library._option_registry or {}) do
            if not CONFIG_CODE_SKIP[entry.flag] then
                local v = data.flags[entry.flag]
                if v ~= nil then
                    if pcall(entry.set, v) then
                        applied += 1
                    else
                        failed += 1
                    end
                end
            end
        end
        pcall(function()
            local savedConfig = (getgenv() :: any)._VanishConfig
            if type(savedConfig) == "table" and type(savedConfig.save) == "function" then
                savedConfig:save(game.GameId, Library._config)
            end
        end)
        pcall(function()
            local text = "Imported " .. applied .. " options"
            if failed > 0 then
                text ..= " (" .. failed .. " failed)"
            end
            Notify({ title = "Configs", text = text, duration = 3 })
        end)
    end
})


if library and library.Update1Run then
    library:Update1Run("0")
end

pcall(function()
    if library and library.load and not library._ui_loaded then
        library:load()
    end
    if library and library.select_tab_index then
        library:select_tab_index(1)
    end
end)

local Alive = workspace:FindFirstChild("Alive")
local Runtime = workspace:FindFirstChild("Runtime")
if not Alive or not Runtime then
    task.spawn(function()
        if not Alive then
            Alive = workspace:WaitForChild("Alive", 60)
        end
        if not Runtime then
            Runtime = workspace:WaitForChild("Runtime", 60)
        end
    end)
end
local BallsFolder = workspace:FindFirstChild("Balls")
local TrainingBallsFolder = workspace:FindFirstChild("TrainingBalls")
local DataPingItem
pcall(function()
    DataPingItem = Stats.Network.ServerStatsItem['Data Ping']
end)
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Alive" then
        Alive = child
    elseif child.Name == "Runtime" then
        Runtime = child
    elseif child.Name == "Balls" then
        BallsFolder = child
    elseif child.Name == "TrainingBalls" then
        TrainingBallsFolder = child
    end
end)
workspace.ChildRemoved:Connect(function(child)
    if child == BallsFolder then
        BallsFolder = workspace:FindFirstChild("Balls")
    elseif child == TrainingBallsFolder then
        TrainingBallsFolder = workspace:FindFirstChild("TrainingBalls")
    elseif child == Alive then
        Alive = workspace:FindFirstChild("Alive")
    elseif child == Runtime then
        Runtime = workspace:FindFirstChild("Runtime")
    end
end)

local ping_cached = 0
local ping_cached_at = 0
local function get_data_ping()
    local now = os.clock()
    if now - ping_cached_at < 0.12 then
        return ping_cached
    end
    local ping = 0
    if DataPingItem then
        local ok, value = pcall(function()
            return DataPingItem:GetValue()
        end)
        if ok and type(value) == "number" then
            ping_cached = value
            ping_cached_at = now
            return value
        end
    end
    pcall(function()
        ping = Stats.Network.ServerStatsItem['Data Ping']:GetValue()
    end)
    if type(ping) ~= "number" or ping <= 0 then
        pcall(function()
            local perf = Stats:FindFirstChild("PerformanceStats")
            if perf then ping = perf.Ping:GetValue() end
        end)
    end
    ping_cached = ping
    ping_cached_at = now
    return ping
end

local System = {
    __properties = {
        __autoparry_enabled = false,
        __manual_spam_enabled = false,
        __auto_spam_enabled = false,
        __curve_mode = 1,
        __accuracy = 75,
        __divisor_multiplier = 1.2474747474747474,
        __parried = false,
        __parried_until = 0,
        __training_parried = false,
        __spam_threshold = 1.5,
        __auto_spam_distance_multiplier = 1,
        __spam_sensitivity = 1,
        __parries = 0,
        __tornado_time = tick(),
        __first_parry_done = false,
        __spam_auto_decay_at = {},
        __spam_latched = false,
        __spam_latch_lost_at = 0,
        __randomized_accuracy_enabled = false,
        __random_accuracy_min = 1,
        __random_accuracy_max = 100,
        __is_mobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled,
        __mobile_guis = {} :: {[string]: any},
        __connections = {
            __auto_spam = nil,
            __auto_spam_hb = nil,
            __manual_spam = nil,
            __autoparry = nil,
            __autoparry_hb = nil,
            __parry_watch = nil,
        } :: {[string]: any},
        __last_mc_at = 0,
        __ball_tracking = nil,
        __spam_alive_ref = nil,
        __parry_watch = nil,
        __manual_spam_ui = nil,
        __manual_spam_ui_created = false,
        __parried_at = 0,
    },
    __config = {
        __curve_names = {'Camera', 'Random', 'Accelerated', 'Backwards', 'Slow', 'High', 'RandomTarget', 'Left', 'Right', 'Delay'},
    },
    curve = {
        get_cframe = function()
            return CFrame.new()
        end,
    },
    parry = {
        execute = function() end,
        execute_fast = function() end,
    },
} :: any

getgenv()._VanishSystem = System

local revertedRemotes = {}
local Parry_Key = nil

local function og_get_event_data()
    local out = {}
    local camera = workspace.CurrentCamera
    if not camera then return out end
    local alive_folder = Alive or workspace:FindFirstChild("Alive")
    if not alive_folder then return out end
    for _, character in ipairs(alive_folder:GetChildren()) do
        if character.PrimaryPart then
            local ok, sp = pcall(function()
                return camera:WorldToScreenPoint(character.PrimaryPart.Position)
            end)
            if ok then
                out[character.Name] = sp
            end
        end
    end
    return out
end

local function og_get_mouse_vec()
    local camera = workspace.CurrentCamera
    if System.__properties.__is_mobile and camera then
        local vp = camera.ViewportSize
        return { vp.X / 2, vp.Y / 2 }
    end
    local ok, mouse = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if ok and mouse then
        return { mouse.X, mouse.Y }
    end
    if camera then
        local vp = camera.ViewportSize
        return { vp.X / 2, vp.Y / 2 }
    end
    return { 0, 0 }
end

local pry_parry_signal = nil
local pry_fn_direct = nil
local pry_bound_controller = nil
local pry_init_tried = false
local _PARRY_REMOTE = {
    ready = false,
    parryRemote = nil,
}

local function find_allusive_pry()
    local controllers = ReplicatedStorage:FindFirstChild("Controllers")
    if not controllers then
        return nil
    end
    for _, child in ipairs(controllers:GetChildren()) do
        if type(child.Name) == "string" and child.Name:find("SwordsController", 1, true) == 1 then
            local pry = child:FindFirstChild("PRY")
            if pry then
                return pry
            end
        end
    end
    return nil
end

local function refresh_parry_keys()
end

local function signal_still_bound()
    return pry_parry_signal ~= nil and pry_bound_controller ~= nil and pry_bound_controller.Parent ~= nil
end

local function ensure_pry_signal(force)
    if not force and (pry_parry_signal or type(pry_fn_direct) == "function") then
        if not pry_bound_controller or pry_bound_controller.Parent then
            return true
        end
    end

    local previous_signal = pry_parry_signal
    local previous_fn = pry_fn_direct
    local previous_bound = pry_bound_controller
    local built = nil
    local bound = nil
    local ok = pcall(function()
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        if not controllers then
            return
        end
        for _, child in ipairs(controllers:GetChildren()) do
            if type(child.Name) == "string" and child.Name:find("SwordsController", 1, true) == 1 then
                local pry = child:FindFirstChild("PRY")
                if pry then
                    local okReq, pryFn = pcall(require, pry)
                    if okReq and type(pryFn) == "function" then
                        pry_fn_direct = pryFn
                        local packages = ReplicatedStorage:FindFirstChild("Packages")
                        local signalMod = packages and packages:FindFirstChild("Signal")
                        local okSig, Signal = pcall(require, signalMod)
                        if okSig and type(Signal) == "table" and type(Signal.new) == "function" then
                            local sig = Signal.new()
                            sig:Connect(pryFn)
                            built = sig
                            bound = child
                        end
                    end
                end
                break
            end
        end
    end)

    if ok and built then
        pry_parry_signal = built
        pry_bound_controller = bound
        pry_init_tried = true
        _PARRY_REMOTE.ready = true
        return true
    end

    pry_parry_signal = previous_signal
    pry_fn_direct = previous_fn or pry_fn_direct
    pry_bound_controller = previous_bound
    return pry_parry_signal ~= nil or type(pry_fn_direct) == "function"
end

local last_combat_fire = 0

local function take_combat_fire()
    local now = os.clock()
    if now - last_combat_fire < 0.012 then
        return false
    end
    last_combat_fire = now
    return true
end

local function fire_allusive_remote(curve_cframe, event_data, aim)
    if not ensure_pry_signal(false) then
        return false
    end
    local sig = pry_parry_signal
    local fire_fn = sig and sig.Fire
    if type(fire_fn) ~= "function" then
        return false
    end
    if typeof(curve_cframe) ~= "CFrame" then
        curve_cframe = System.curve.get_cframe()
    end
    if type(event_data) ~= "table" then
        event_data = og_get_event_data()
    end
    if type(aim) ~= "table" then
        aim = og_get_mouse_vec()
    end
    if pcall(fire_fn, sig, 0.5, curve_cframe, event_data, aim, false) == true then
        return true
    end
    if type(pry_fn_direct) == "function" then
        return pcall(pry_fn_direct, 0.5, curve_cframe, event_data, aim, false) == true
    end
    return false
end

local function fire_allusive_remote_burst(curve_cframe, event_data, aim, count)
    if not signal_still_bound() then
        ensure_pry_signal(false)
    end
    local sig = pry_parry_signal
    if not sig then
        return false
    end
    local fire_fn = sig.Fire
    count = count or 15
    local ok = pcall(function()
        for _ = 1, count do
            fire_fn(sig, 0.5, curve_cframe, event_data, aim, false)
        end
    end)
    if ok then
        _PARRY_REMOTE.ready = true
        return true
    end
    return false
end

task.spawn(function()
    pcall(function()
        ensure_pry_signal(false)
    end)
    local controllers = ReplicatedStorage:FindFirstChild("Controllers")
    if controllers then
        controllers.ChildAdded:Connect(function(child)
            if type(child.Name) == "string" and child.Name:find("SwordsController", 1, true) == 1 then
                if not signal_still_bound() then
                    task.defer(function()
                        ensure_pry_signal(false)
                    end)
                end
            end
        end)
    end
    while getgenv()._VanishAlive ~= false do
        if not signal_still_bound() then
            pcall(function()
                ensure_pry_signal(false)
            end)
        end
        task.wait(2)
    end
end)

getgenv()._VanishCaptured = nil
getgenv()._VanishVotes = nil
getgenv()._VanishKey = nil
getgenv()._VanishLearnHits = nil
getgenv()._VanishDualMetas = nil
getgenv()._VanishRemoteRewarmAt = nil

local AbilityDetect = {}
local AbilityState = {
    time_hole_hold = false,
    time_hole_hold_since = 0,
    time_hole_release_until = 0,
    own_time_hole = false,
    sof_active = false,
    sof_count = 0,
    tornado_time = 0,
    infinity_active = false,
    deathslash_active = false,
    enemy_infinity = false,
    enemy_deathslash = false,
    enemy_timehole = false,
    enemy_timehole_until = 0,
    enemy_sof = false,
    enemy_duality_until = 0,
    forcefield_active = false,
    duality_active = false,
    duality_incoming = false,
    duality_until = 0,
}
local SOF_MAX_PARRIES = 36
local SOF_PARRY_DELAY = 0.05
local sof_attr_conn = nil
local ability_attr_conn = nil
local RuntimeFolder = workspace:FindFirstChild("Runtime")

local function detections_on()
    return getgenv().DetectionsEnabled == true
end

local function detection_flag(name)
    return detections_on() and getgenv()[name] == true
end

local function read_remote_active(...)
    local args = { ... }
    for i = #args, 1, -1 do
        local value = args[i]
        if type(value) == "boolean" then
            return value
        end
    end
    return args[1] == true
end

local function is_local_player_ref(player)
    if player == nil then
        return false
    end
    if player == LocalPlayer then
        return true
    end
    if player == LocalPlayer.Name or player == LocalPlayer.DisplayName then
        return true
    end
    if typeof(player) == "Instance" then
        if player:IsA("Player") then
            return player == LocalPlayer
        end
        if player:IsA("Model") then
            return Players:GetPlayerFromCharacter(player) == LocalPlayer
        end
    end
    local ref = tostring(player)
    return ref == LocalPlayer.Name or ref == LocalPlayer.DisplayName or ref == tostring(LocalPlayer.UserId)
end

local function equipped_ability()
    return LocalPlayer:GetAttribute("CurrentlyEquippedAbility")
        or LocalPlayer:GetAttribute("EquippedAbility")
end

local function ability_name_is(name, ...)
    if type(name) ~= "string" or name == "" then
        return false
    end
    local folded = string.lower(name)
    folded = folded:gsub("[%s_%-]+", "")
    for i = 1, select("#", ...) do
        local want = select(i, ...)
        if type(want) == "string" and folded == string.lower(want):gsub("[%s_%-]+", "") then
            return true
        end
    end
    return false
end

local function find_net_remote(remoteName)
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    local index = packages and packages:FindFirstChild("_Index")
    if not index then
        return nil
    end
    for _, child in ipairs(index:GetChildren()) do
        if type(child.Name) == "string" and child.Name:find("sleitnick_net", 1, true) then
            local netFolder = child:FindFirstChild("net")
            local remote = netFolder and netFolder:FindFirstChild(remoteName)
            if remote then
                return remote
            end
        end
    end
    return nil
end

function AbilityDetect.mark_tornado()
    AbilityState.tornado_time = tick()
    if System and System.__properties then
        System.__properties.__tornado_time = AbilityState.tornado_time
    end
end

function AbilityDetect.is_tornado_active()
    local runtime = RuntimeFolder or workspace:FindFirstChild("Runtime")
    RuntimeFolder = runtime
    local tornado = runtime and runtime:FindFirstChild("Tornado")
    if not tornado then
        return false
    end
    local started = AbilityState.tornado_time or 0
    if started <= 0 then
        return false
    end
    return (tick() - started) < (tornado:GetAttribute("TornadoTime") or 1) + 0.314159
end

function AbilityDetect.has_singularity_cape()
    local char = LocalPlayer.Character
    local root = char and (char.PrimaryPart or char:FindFirstChild("HumanoidRootPart"))
    return root ~= nil and root:FindFirstChild("SingularityCape") ~= nil
end

function AbilityDetect.has_forcefield(char)
    char = char or LocalPlayer.Character
    if not char then
        return false
    end
    if char:FindFirstChildOfClass("ForceField") then
        return true
    end
    if char:FindFirstChild("Forcefield") or char:FindFirstChild("ForceField") then
        return true
    end
    local root = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
    if root and (root:FindFirstChild("Forcefield") or root:FindFirstChild("ForceField")) then
        return true
    end
    if AbilityState.forcefield_active then
        return true
    end
    return ability_name_is(equipped_ability(), "Forcefield", "Force Field") and char:GetAttribute("AbilityActive") == true
end

function AbilityDetect.refresh_equipped_state(char)
    char = char or LocalPlayer.Character
    local equipped = equipped_ability()
    local active = char and char:GetAttribute("AbilityActive") == true
    if ability_name_is(equipped, "Forcefield", "Force Field") then
        AbilityState.forcefield_active = active == true or AbilityDetect.has_forcefield(char)
    elseif not AbilityDetect.has_forcefield(char) then
        AbilityState.forcefield_active = false
    end
    if ability_name_is(equipped, "Slash of Duality", "Slash Of Duality", "Duality") then
        AbilityState.duality_active = active == true
    elseif tick() >= (AbilityState.duality_until or 0) then
        AbilityState.duality_active = false
    end
    if ability_name_is(equipped, "Slashes of Fury", "Slash of Fury", "Slashes Of Fury") then
        if active then
            AbilityState.sof_active = true
        elseif char and char:GetAttribute("FuryCatch") == nil then
            AbilityState.sof_active = false
        end
    end
    if ability_name_is(equipped, "Time Hole", "TimeHole") then
        AbilityState.own_time_hole = active == true or LocalPlayer:GetAttribute("TimeHoleActivate") ~= nil
    end
end

function AbilityDetect.mark_duality_incoming(duration)
    AbilityState.duality_incoming = true
    AbilityState.duality_until = tick() + (duration or 3)
end

function AbilityDetect.is_duality_incoming(part, model)
    if tick() < (AbilityState.duality_until or 0) then
        AbilityState.duality_incoming = true
        return true
    end
    local char = LocalPlayer.Character
    if char then
        local highlight = char:FindFirstChildWhichIsA("Highlight")
        if highlight and highlight.Enabled ~= false then
            local outline = highlight.OutlineColor
            if typeof(outline) == "Color3" and (outline.R + outline.G + outline.B) < 0.35 then
                AbilityState.duality_incoming = true
                return true
            end
        end
    end
    local ball = part or (model and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")))
    if ball then
        local attr = ball:GetAttribute("Duality")
            or ball:GetAttribute("SlashOfDuality")
            or ball:GetAttribute("duality")
            or (model and (model:GetAttribute("Duality") or model:GetAttribute("SlashOfDuality")))
        if attr == true or attr == "Dark" or attr == "Light" or attr == "Dual" then
            AbilityState.duality_incoming = true
            return true
        end
        local transparency = 0
        pcall(function()
            transparency = math.max(ball.Transparency or 0, ball.LocalTransparencyModifier or 0)
        end)
        if transparency >= 0.75 then
            AbilityState.duality_incoming = true
            return true
        end
    end
    AbilityState.duality_incoming = false
    return false
end

function AbilityDetect.should_skip_local()
    local char = LocalPlayer.Character
    if char and char:GetAttribute("DoNotParry") then
        return true
    end
    AbilityDetect.refresh_equipped_state(char)
    if AbilityDetect.has_singularity_cape() and (not detections_on() or getgenv().SingularityDetection ~= false) then
        if not detections_on() or detection_flag("SingularityDetection") then
            return true
        end
    end
    if detection_flag("PulsedDetection") and char and char:GetAttribute("Pulsed") then
        return true
    end
    if detection_flag("ForcefieldDetection") and AbilityDetect.has_forcefield(char) then
        return true
    end
    if detection_flag("TimeHoleDetection") and AbilityState.own_time_hole then
        return true
    end
    if detection_flag("SlashOfFuryDetection") and AbilityState.sof_active then
        return true
    end
    if detection_flag("DualityDetection") and AbilityState.duality_active then
        return true
    end
    return false
end

local function using_own_ability(...)
    local args_n = select("#", ...)
    for i = 1, args_n do
        local value = select(i, ...)
        if typeof(value) ~= "string" and is_local_player_ref(value) then
            return true
        end
    end
    local char = LocalPlayer.Character
    if not char or char:GetAttribute("AbilityActive") ~= true then
        return false
    end
    return ability_name_is(equipped_ability(), ...)
end

local ability_hold_since = {}
local ability_hold_done = {}
local function timed_ability_hold(name, active, limit)
    if not active then
        ability_hold_since[name] = nil
        ability_hold_done[name] = nil
        return false
    end
    if ability_hold_done[name] then
        return false
    end
    if not ability_hold_since[name] then
        ability_hold_since[name] = tick()
    end
    if tick() - ability_hold_since[name] > limit then
        ability_hold_done[name] = true
        return false
    end
    return true
end

function AbilityDetect.ability_hold()
    if timed_ability_hold("infinity", AbilityState.enemy_infinity or AbilityState.infinity_active, 2.2) then
        return true
    end
    if timed_ability_hold("death", AbilityState.enemy_deathslash or AbilityState.deathslash_active, 1.6) then
        return true
    end
    if timed_ability_hold("sof", AbilityState.enemy_sof, 2.4) then
        return true
    end
    if timed_ability_hold("timehole", AbilityState.enemy_timehole or AbilityState.time_hole_hold, 1.8) then
        return true
    end
    if tick() < (AbilityState.time_hole_release_until or 0) then
        return true
    end
    return false
end

function AbilityDetect.enemy_incoming()
    return false
end

function AbilityDetect.parry_enemy_target()
    if not AbilityDetect.enemy_incoming() then
        return false
    end
    if not (System and System.ball and System.ball.get_all and System.parry and System.parry.execute) then
        return false
    end
    for _, entry in ipairs(System.ball.get_all()) do
        if System.ball.is_targeting_me(entry) then
            pcall(System.parry.execute)
            return true
        end
    end
    return false
end

local enemy_sof_token = 0
function AbilityDetect.watch_enemy_sof()
    enemy_sof_token = enemy_sof_token + 1
    local token = enemy_sof_token
    task.spawn(function()
        local n = 0
        while token == enemy_sof_token and AbilityState.enemy_sof and n < SOF_MAX_PARRIES and getgenv()._VanishAlive ~= false do
            n = n + 1
            pcall(function()
                if System and System.parry and System.parry.execute then
                    System.parry.execute()
                end
            end)
            task.wait(SOF_PARRY_DELAY)
        end
    end)
end

local dragon_seen = {}
local dragon_watch_ready = false
local dragon_ball_state = {}
local dragon_updated = 0
local dragon_holds = {}

local function dragon_name(name)
    if type(name) ~= "string" then
        return false
    end
    return string.find(string.lower(name), "dragon", 1, true) ~= nil
end

local function remember_dragon(inst)
    if typeof(inst) ~= "Instance" or not dragon_name(inst.Name) then
        return
    end
    local model = inst:FindFirstAncestorOfClass("Model")
    while model do
        if Players:GetPlayerFromCharacter(model) then
            return
        end
        model = model.Parent and model.Parent:FindFirstAncestorOfClass("Model")
    end
    dragon_seen[inst] = true
end

local function ensure_dragon_watch()
    if dragon_watch_ready then
        return
    end
    dragon_watch_ready = true
    local function watch_root(root)
        if not root then
            return
        end
        for _, child in ipairs(root:GetDescendants()) do
            remember_dragon(child)
        end
        root.DescendantAdded:Connect(remember_dragon)
    end
    watch_root(workspace:FindFirstChild("Runtime"))
    workspace.DescendantAdded:Connect(remember_dragon)
end

local function dragon_position(inst)
    if not inst or not inst.Parent then
        return nil
    end
    if inst:IsA("BasePart") then
        return inst.Position
    end
    if inst:IsA("Attachment") then
        return inst.WorldPosition
    end
    if inst:IsA("Model") then
        if inst.PrimaryPart then
            return inst.PrimaryPart.Position
        end
    end
    local part = inst:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

function AbilityDetect.update_dragon()
    local now = tick()
    if now - dragon_updated < 0.03 then
        return
    end
    dragon_updated = now
    ensure_dragon_watch()
    local runtime = workspace:FindFirstChild("Runtime")
    if runtime then
        for _, child in ipairs(runtime:GetChildren()) do
            remember_dragon(child)
        end
    end
    for _, child in ipairs(workspace:GetChildren()) do
        remember_dragon(child)
    end
    local root = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
    local holds = {}
    local dragons = {}
    if root then
        for inst in pairs(dragon_seen) do
            if not inst.Parent then
                dragon_seen[inst] = nil
            else
                local pos = dragon_position(inst)
                if pos and (pos - root.Position).Magnitude <= 80 then
                    table.insert(dragons, pos)
                end
            end
        end
    end
    if root and #dragons > 0 and System and System.ball and System.ball.get_all then
        local alive = {}
        for _, entry in ipairs(System.ball.get_all()) do
            local ball = entry and entry.part
            if ball and ball.Parent then
                alive[ball] = true
                local engaging = false
                local contacted = false
                for _, pos in ipairs(dragons) do
                    local gap = (pos - ball.Position).Magnitude
                    if gap <= 36 then
                        engaging = true
                    end
                    if gap <= 10 then
                        contacted = true
                    end
                end
                local st = dragon_ball_state[ball]
                if not engaging then
                    dragon_ball_state[ball] = nil
                else
                    if not st then
                        st = {}
                        dragon_ball_state[ball] = st
                    end
                    local vel = ball.AssemblyLinearVelocity
                    local zoomies = ball:FindFirstChild("zoomies")
                    if zoomies and zoomies.VectorVelocity then
                        vel = zoomies.VectorVelocity
                    end
                    local speed = vel.Magnitude
                    local unit = speed > 1 and vel.Unit or nil
                    if contacted and not st.contact_at then
                        st.contact_at = now
                        st.contact_vel = unit
                    end
                    if not st.contact_at then
                        holds[ball] = true
                    else
                        local changed = unit and st.contact_vel and st.contact_vel:Dot(unit) < 0.55
                        local waited = now - st.contact_at >= 0.12
                        if changed or waited then
                            st.hit = true
                            local to_me = root.Position - ball.Position
                            local coming = speed > 5 and to_me.Magnitude > 1 and vel:Dot(to_me) > 0
                            if not coming then
                                holds[ball] = true
                            end
                        else
                            holds[ball] = true
                        end
                    end
                end
            end
        end
        for ball in pairs(dragon_ball_state) do
            if not alive[ball] then
                dragon_ball_state[ball] = nil
            end
        end
    else
        dragon_ball_state = {}
    end
    dragon_holds = holds
end

function AbilityDetect.dragon_hold(ball)
    AbilityDetect.update_dragon()
    return ball ~= nil and dragon_holds[ball] == true
end

function AbilityDetect.should_skip_ball(part, model)
    if AbilityDetect.is_tornado_active() then
        return true
    end
    if part and part:FindFirstChild("ComboCounter") then
        return true
    end
    if detection_flag("InfinityDetection") and AbilityState.infinity_active then
        return true
    end
    if detection_flag("DeathSlashDetection") and AbilityState.deathslash_active then
        return true
    end
    if detection_flag("TimeHoleDetection") then
        if AbilityState.time_hole_hold then
            if AbilityState.time_hole_hold_since > 0 and (tick() - AbilityState.time_hole_hold_since) > 8 then
                AbilityState.time_hole_hold = false
                AbilityState.time_hole_hold_since = 0
            else
                return true
            end
        end
        if tick() < (AbilityState.time_hole_release_until or 0) then
            return true
        end
        if AbilityState.own_time_hole then
            return true
        end
    end
    if detection_flag("SlashOfFuryDetection") and AbilityState.sof_active then
        return true
    end
    if detection_flag("ForcefieldDetection") and AbilityDetect.has_forcefield() then
        return true
    end
    if detection_flag("DualityDetection") and AbilityState.duality_active then
        return true
    end
    return false
end

function AbilityDetect.setup()
    local hooked_remotes = {}

    local function hook_remote_event(remote, handler)
        if not remote or hooked_remotes[remote] then
            return
        end
        if not remote:IsA("RemoteEvent") and not remote:IsA("UnreliableRemoteEvent") then
            return
        end
        hooked_remotes[remote] = true
        remote.OnClientEvent:Connect(handler)
    end

    local function bind_named_remote(remote)
        if not remote then
            return
        end
        local name = remote.Name
        if name == "InfinityBall" then
            hook_remote_event(remote, function(...)
                local args = { ... }
                local active = read_remote_active(...)
                if using_own_ability(args[1], args[2], "Infinity") then
                    AbilityState.infinity_active = active
                    AbilityState.enemy_infinity = false
                else
                    AbilityState.infinity_active = false
                    AbilityState.enemy_infinity = active
                end
            end)
        elseif name == "DeathBall" then
            hook_remote_event(remote, function(...)
                local args = { ... }
                local active = read_remote_active(...)
                if using_own_ability(args[1], args[2], "Death Slash", "DeathSlash", "Death") then
                    AbilityState.deathslash_active = active
                    AbilityState.enemy_deathslash = false
                else
                    AbilityState.deathslash_active = false
                    AbilityState.enemy_deathslash = active
                end
            end)
        elseif name == "TimeHoleHoldBall" then
            hook_remote_event(remote, function(...)
                local args = { ... }
                local active = read_remote_active(...)
                local mine = using_own_ability(args[1], args[2], "Time Hole", "TimeHole") or AbilityState.own_time_hole
                if mine then
                    local was = AbilityState.time_hole_hold
                    AbilityState.time_hole_hold = active
                    if AbilityState.time_hole_hold then
                        AbilityState.time_hole_hold_since = tick()
                    else
                        AbilityState.time_hole_hold_since = 0
                        if was then
                            AbilityState.time_hole_release_until = tick() + 1
                        end
                    end
                else
                    AbilityState.time_hole_hold = false
                    AbilityState.enemy_timehole = active
                end
            end)
        elseif name == "Forcefield" or name == "ForceField" or name == "ForcefieldBall" or name:find("Forcefield", 1, true) or name:find("ForceField", 1, true) then
            hook_remote_event(remote, function(...)
                AbilityState.forcefield_active = read_remote_active(...)
            end)
        elseif name:find("Duality", 1, true) or name:find("duality", 1, true) then
            hook_remote_event(remote, function(...)
                local args = { ... }
                local active = read_remote_active(...)
                if using_own_ability(args[1], args[2], "Slash of Duality", "Slash Of Duality", "Duality") then
                    if active then
                        AbilityDetect.mark_duality_incoming(3.5)
                    end
                end
            end)
        end
    end

    task.spawn(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 120)
        if remotes then
            for _, child in ipairs(remotes:GetChildren()) do
                pcall(bind_named_remote, child)
            end
            remotes.ChildAdded:Connect(function(child)
                task.defer(function()
                    pcall(bind_named_remote, child)
                end)
            end)
            pcall(function()
                bind_named_remote(remotes:WaitForChild("InfinityBall", 30))
            end)
            pcall(function()
                bind_named_remote(remotes:WaitForChild("DeathBall", 30))
            end)
            pcall(function()
                bind_named_remote(remotes:WaitForChild("TimeHoleHoldBall", 30))
            end)
        end

        pcall(function()
            LocalPlayer.AttributeChanged:Connect(function(attr)
                if attr == "TimeHoleActivate" then
                    AbilityState.own_time_hole = LocalPlayer:GetAttribute("TimeHoleActivate") ~= nil
                elseif attr == "CurrentlyEquippedAbility" or attr == "EquippedAbility" then
                    AbilityDetect.refresh_equipped_state(LocalPlayer.Character)
                end
            end)
            AbilityState.own_time_hole = LocalPlayer:GetAttribute("TimeHoleActivate") ~= nil
        end)
    end)

    task.spawn(function()
        local function hook_net(name, handler)
            local remote = find_net_remote(name)
            if remote then
                hook_remote_event(remote, handler)
            end
        end
        hook_net("RE/TimeHoleActivate", function(...)
            local args = { ... }
            if is_local_player_ref(args[1]) or using_own_ability(args[1], args[2], "Time Hole", "TimeHole") then
                AbilityState.own_time_hole = true
            else
                AbilityState.own_time_hole = false
                AbilityState.enemy_timehole = true
            end
        end)
        hook_net("RE/TimeHoleDeactivate", function(...)
            local args = { ... }
            local mine = is_local_player_ref(args[1]) or (args[1] == nil and AbilityState.own_time_hole)
            if mine then
                AbilityState.own_time_hole = false
                return
            end
            AbilityState.enemy_timehole = false
        end)
        hook_net("RE/SlashesOfFuryActivate", function(...)
            local args = { ... }
            if is_local_player_ref(args[1]) or using_own_ability("Slashes of Fury", "Slash of Fury", "Slashes Of Fury") then
                AbilityState.sof_active = true
                AbilityState.sof_count = 0
                AbilityState.enemy_sof = false
            else
                AbilityState.enemy_sof = true
            end
        end)
        hook_net("RE/SlashesOfFuryEnd", function()
            AbilityState.sof_active = false
            AbilityState.sof_count = 0
            AbilityState.enemy_sof = false
        end)
        hook_net("RE/SlashesOfFuryParry", function()
            AbilityState.sof_count = (AbilityState.sof_count or 0) + 1
        end)
        hook_net("RE/SlashesOfFuryCatch", function(...)
            local args = { ... }
            local mine = is_local_player_ref(args[1]) or AbilityState.sof_active or using_own_ability("Slashes of Fury", "Slash of Fury", "Slashes Of Fury")
            if mine then
                AbilityState.sof_active = true
                AbilityState.sof_count = 0
                if getgenv().SlashOfFuryDetection == true and System and System.parry then
                    task.spawn(function()
                        local n = 0
                        while AbilityState.sof_active and n < SOF_MAX_PARRIES and getgenv()._VanishAlive ~= false do
                            n = n + 1
                            pcall(System.parry.execute)
                            task.wait(SOF_PARRY_DELAY)
                        end
                    end)
                end
            else
                AbilityState.enemy_sof = true
            end
        end)
        for _, name in ipairs({
            "RE/SlashOfDuality",
            "RE/SlashOfDualityActivate",
            "RE/DualityActivate",
            "RE/DualitySlash",
            "RE/DualityLight",
            "RE/DualityDark",
            "RE/SlashOfDualityUse",
        }) do
            hook_net(name, function(...)
                local args = { ... }
                if using_own_ability(args[1], args[2], "Slash of Duality", "Slash Of Duality", "Duality") then
                    AbilityDetect.mark_duality_incoming(3.5)
                end
            end)
        end
        local packages = ReplicatedStorage:FindFirstChild("Packages") or ReplicatedStorage:WaitForChild("Packages", 30)
        local index = packages and (packages:FindFirstChild("_Index") or packages:WaitForChild("_Index", 30))
        if index then
            for _, child in ipairs(index:GetChildren()) do
                if type(child.Name) == "string" and child.Name:find("sleitnick_net", 1, true) then
                    local netFolder = child:FindFirstChild("net")
                    if netFolder then
                        for _, remote in ipairs(netFolder:GetChildren()) do
                            local lower = string.lower(remote.Name)
                            if lower:find("duality", 1, true) or lower:find("forcefield", 1, true) then
                                pcall(bind_named_remote, remote)
                            end
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        local runtime = workspace:FindFirstChild("Runtime") or workspace:WaitForChild("Runtime", 120)
        if not runtime then return end
        RuntimeFolder = runtime
        if runtime:FindFirstChild("Tornado") then
            AbilityDetect.mark_tornado()
        end
        runtime.ChildAdded:Connect(function(child)
            if child.Name == "Tornado" then
                AbilityDetect.mark_tornado()
            end
        end)
    end)

    local sof_spam_token = 0

    local function run_sof_spam(char)
        if getgenv().SlashOfFuryDetection ~= true then
            return
        end
        sof_spam_token = sof_spam_token + 1
        local token = sof_spam_token
        task.spawn(function()
            local n = 0
            while token == sof_spam_token
                and n < SOF_MAX_PARRIES
                and AbilityState.sof_active
                and char
                and char.Parent
                and getgenv()._VanishAlive ~= false
            do
                if getgenv().SlashOfFuryDetection ~= true then
                    break
                end
                n = n + 1
                if System and System.parry and System.parry.execute then
                    pcall(System.parry.execute)
                end
                task.wait(SOF_PARRY_DELAY)
                if token ~= sof_spam_token then
                    break
                end
            end
        end)
    end

    local function bind_character(char)
        if sof_attr_conn then
            pcall(function() sof_attr_conn:Disconnect() end)
            sof_attr_conn = nil
        end
        if ability_attr_conn then
            pcall(function() ability_attr_conn:Disconnect() end)
            ability_attr_conn = nil
        end
        sof_spam_token = sof_spam_token + 1
        AbilityState.sof_active = false
        AbilityState.forcefield_active = false
        AbilityState.duality_active = false
        if not char then
            return
        end
        AbilityDetect.refresh_equipped_state(char)
        ability_attr_conn = char.AttributeChanged:Connect(function(attr)
            if attr == "AbilityActive" or attr == "CurrentlyEquippedAbility" or attr == "EquippedAbility" then
                AbilityDetect.refresh_equipped_state(char)
            end
            if attr == "AbilityActive" then
                local active = char:GetAttribute("AbilityActive") == true
                local equipped = equipped_ability()
                if ability_name_is(equipped, "Slashes of Fury", "Slash of Fury", "Slashes Of Fury") then
                    AbilityState.sof_active = active
                    if not active then
                        sof_spam_token = sof_spam_token + 1
                    end
                elseif ability_name_is(equipped, "Forcefield", "Force Field") then
                    AbilityState.forcefield_active = active
                elseif ability_name_is(equipped, "Slash of Duality", "Slash Of Duality", "Duality") then
                    AbilityState.duality_active = active
                    if active then
                        AbilityDetect.mark_duality_incoming(3.5)
                    end
                elseif ability_name_is(equipped, "Time Hole", "TimeHole") then
                    AbilityState.own_time_hole = active or LocalPlayer:GetAttribute("TimeHoleActivate") ~= nil
                end
            end
            if attr == "FuryCatch" then
                if char:GetAttribute("FuryCatch") == nil then
                    sof_spam_token = sof_spam_token + 1
                    return
                end
                AbilityState.sof_active = true
                run_sof_spam(char)
            end
        end)
        sof_attr_conn = ability_attr_conn
    end
    if LocalPlayer.Character then
        bind_character(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(bind_character)
end
AbilityDetect.setup()

local Workspace = workspace

local hook = hookfunction or (getgenv and getgenv().hookfunction)
if type(hook) ~= "function" then
    hook = function(fn)
        return fn
    end
end

local HASH = "5455ef47-de02-4074-808c-8d82c2cd12ec"

local byte, char = string.byte, string.char
local floor, bxor = math.floor, bit32.bxor

local captured = {
    remote = nil,
    sessionKey = nil,
    token = nil,
    timing = nil,
    tailBool = false,
    args = nil,
}
local votes = {}
local key
local remote_found_notified = false

local function notify_remote_found()
    if remote_found_notified then return end
    remote_found_notified = true
    task.defer(function()
        pcall(function()
            Notify({ title = "Vanish Premium", text = "Remote was found, #fuck bladeball !!", duration = 4 })
        end)
    end)
end

local function timestamp()
    return tostring(floor(Workspace:GetServerTimeNow() * 100))
end

local function learn(token, stamp)
    if #token ~= #stamp then return false end

    for i = 1, #token do
        local value = bxor(byte(token, i), (byte(stamp, i) + i) % 256)
        local counts = votes[i] or {}
        votes[i] = counts
        counts[value] = (counts[value] or 0) + 1
    end

    local nextKey = {}
    for i = 1, #token do
        local best, highest = 0, -1
        for value, count in pairs(votes[i]) do
            if count > highest then
                best, highest = value, count
            end
        end
        nextKey[i] = best
    end

    key = nextKey
    return true
end

local function makeToken()
    if not key then return end

    local stamp = timestamp()
    if #stamp ~= #key then
        votes = {}
        key = nil
        return
    end
    local token = {}

    for i = 1, #stamp do
        local value = key[i] or key[#key]
        if not value then return end
        token[i] = char(bxor((byte(stamp, i) + i) % 256, value))
    end

    return table.concat(token)
end

local function fresh_timing()
    local old = captured.timing
    local live = nil
    pcall(function()
        live = Workspace:GetServerTimeNow()
    end)
    if typeof(old) == "number" and typeof(live) == "number" and old > 120 and math.abs(live - old) < 120 then
        return live
    end
    if typeof(old) == "number" then
        return old
    end
    if typeof(live) == "number" then
        return live
    end
    return 0.5
end

local function getTail()
    local camera = Workspace.CurrentCamera
    if not camera then return end

    local points = {}
    local alive = Workspace:FindFirstChild("Alive")

    if alive then
        for _, character in ipairs(alive:GetChildren()) do
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                points[character.Name] = camera:WorldToScreenPoint(root.Position)
            end
        end
    end

    local mouse
    pcall(function()
        mouse = UserInputService:GetMouseLocation()
    end)
    if not mouse then
        local vp = camera.ViewportSize
        mouse = { X = vp.X / 2, Y = vp.Y / 2 }
    end
    return fresh_timing(), camera.CFrame, points,
        { mouse.X, mouse.Y }, captured.tailBool or false
end

local fire
local replay_guard = false

local function replay(curveCFrame, screenPositions, mouseLocation)
    local token = makeToken()
    if not captured.remote or not captured.remote.Parent or not captured.sessionKey or not token then
        if captured.remote and not captured.remote.Parent then
            captured.remote = nil
        end
        return
    end

    local timing, camera, points, mouse, tail = getTail()
    if not timing then
        return
    end

    replay_guard = true
    local ok = pcall(fire, captured.remote, HASH, captured.sessionKey, token,
        timing, curveCFrame or camera, screenPositions or points, mouseLocation or mouse, tail)
    replay_guard = false
    return ok
end

local fireHooked = false
pcall(function()
    fire = hook(Instance.new("RemoteEvent").FireServer, function(self, ...)
        local args = table.pack(...)
        if replay_guard or args[1] ~= HASH or type(args[3]) ~= "string" then
            return fire(self, ...)
        end

        captured = {
            remote = self,
            sessionKey = args[2],
            token = args[3],
            timing = args[4],
            tailBool = args[8],
            args = args,
        }

        learn(args[3], timestamp())
        notify_remote_found()

        return fire(self, ...)
    end)
    fireHooked = type(fire) == "function"
    if not fireHooked then
        task.delay(3, function()
            pcall(function()
                Notify({ title = "Vanish Premium", text = "Remote hook failed - block mode only", duration = 4 })
            end)
        end)
    end
end)
if type(fire) ~= "function" then
    local sample = Instance.new("RemoteEvent")
    fire = sample.FireServer
    pcall(function()
        sample:Destroy()
    end)
end
if type(fire) == "function" then
    getgenv()._VanishOldFire = fire
    getgenv()._VanishOnFire = fireHooked
end

local function fireParry_wh()
    if captured.sessionKey == nil or key == nil then return end
    local cam = workspace.CurrentCamera
    local char = LocalPlayer.Character
    if not cam or not char then return end
    local curveCF
    pcall(function()
        curveCF = System.curve.get_cframe()
    end)
    local screens = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local ok, sp = pcall(function() return cam:WorldToScreenPoint(entity.PrimaryPart.Position) end)
                if ok then screens[tostring(entity)] = sp end
            end
        end
    end
    local vp = cam.ViewportSize
    return replay(curveCF or cam.CFrame, screens, {vp.X/2, vp.Y/2})
end

local function fire_reverted_remotes(curve_cframe, event_data, aim)
    if next(revertedRemotes) == nil then
        return false
    end
    if typeof(curve_cframe) ~= "CFrame" then
        curve_cframe = System.curve.get_cframe()
    end
    if type(event_data) ~= "table" then
        event_data = og_get_event_data()
    end
    if type(aim) ~= "table" then
        aim = og_get_mouse_vec()
    end
    local fired = false
    for remote, original_args in pairs(revertedRemotes) do
        if typeof(remote) == "Instance" and remote.Parent and type(original_args) == "table" then
            local modified_args = {
                original_args[1],
                original_args[2],
                original_args[3],
                curve_cframe,
                event_data,
                aim,
                original_args[7]
            }
            local ok = false
            if remote:IsA("RemoteEvent") and type(fire) == "function" then
                replay_guard = true
                ok = pcall(fire, remote, unpack(modified_args, 1, 7))
                replay_guard = false
            end
            if ok then
                fired = true
            end
        end
    end
    return fired
end

local DualBypassSystem = {
    __properties = {
        __captured_data = nil,
        __first_parry_done = false,
        __test_bypass_enabled = true,
        __use_virtual_input_once = true,
        __virtual_input_used = false,
        __original_metatables = {},
        __active_hooks = {}
    }
}

function DualBypassSystem.isValidRemoteArgs(args)
    return #args == 7 and
        type(args[2]) == "string" and
        type(args[3]) == "number" and
        typeof(args[4]) == "CFrame" and
        type(args[5]) == "table" and
        type(args[6]) == "table" and
        type(args[7]) == "boolean"
end

function DualBypassSystem.hookRemote(remote)
    local okMeta, meta = pcall(getrawmetatable, remote)
    if not okMeta or type(meta) ~= "table" then
        return
    end
    if not DualBypassSystem.__properties.__original_metatables[meta] then
        DualBypassSystem.__properties.__original_metatables[meta] = true
        local okWrite = pcall(setreadonly, meta, false)
        if not okWrite or type(meta.__index) ~= "function" then
            pcall(setreadonly, meta, true)
            return
        end
        setreadonly(meta, false)

        local oldIndex = meta.__index
        if type(getgenv()._VanishOldRemoteIndex) ~= "function" and type(oldIndex) == "function" then
            getgenv()._VanishOldRemoteIndex = oldIndex
        end
        meta.__index = function(self, key)
            if (key == "FireServer" and self:IsA("RemoteEvent")) or
               (key == "InvokeServer" and self:IsA("RemoteFunction")) then
                return function(obj, ...)
                    local args = {...}
                    if DualBypassSystem.isValidRemoteArgs(args) and not DualBypassSystem.__properties.__captured_data then
                        DualBypassSystem.__properties.__captured_data = {
                            remote = obj,
                            args = args
                        }
                    end
                    if not replay_guard and DualBypassSystem.isValidRemoteArgs(args) then
                        revertedRemotes[obj] = args
                        Parry_Key = args[2]
                        notify_remote_found()
                    end
                    return oldIndex(self, key)(obj, unpack(args))
                end
            end
            return oldIndex(self, key)
        end
        setreadonly(meta, true)
    end
end

local function hook_remote_container(container)
    if not container then
        return
    end
    for _, remote in ipairs(container:GetChildren()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            DualBypassSystem.hookRemote(remote)
        end
    end
    container.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            DualBypassSystem.hookRemote(child)
        elseif child.Name == "Remotes" then
            hook_remote_container(child)
        end
    end)
end

pcall(hook_remote_container, ReplicatedStorage)
pcall(hook_remote_container, ReplicatedStorage:FindFirstChild("Remotes"))

function DualBypassSystem.execute_test_bypass()
    if not DualBypassSystem.__properties.__captured_data or not DualBypassSystem.__properties.__test_bypass_enabled then
        return
    end
    local captured = DualBypassSystem.__properties.__captured_data
    local remote = captured.remote
    local original_args = captured.args
    local camera = workspace.CurrentCamera
    local event_data = {}
    if Alive then
        for _, entity in pairs(Alive:GetChildren()) do
            if entity.PrimaryPart then
                local success, screen_point = pcall(function()
                    return camera:WorldToScreenPoint(entity.PrimaryPart.Position)
                end)
                if success then
                    event_data[entity.Name] = screen_point
                end
            end
        end
    end
    local is_mobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local final_aim_target
    if is_mobile then
        local viewport = camera.ViewportSize
        final_aim_target = {viewport.X / 2, viewport.Y / 2}
    else
        local success, mouse = pcall(function()
            return UserInputService:GetMouseLocation()
        end)
        if success then
            final_aim_target = {mouse.X, mouse.Y}
        else
            final_aim_target = {0, 0}
        end
    end
    local modified_args = {
        original_args[1],
        original_args[2],
        original_args[3],
        camera.CFrame,
        event_data,
        final_aim_target,
        original_args[7]
    }
    pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(modified_args))
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(unpack(modified_args))
        end
    end)
end


System.animation = {
    __grab_track = nil,
}

function System.animation.get_sword_name()
    local character = LocalPlayer.Character
    if not character then
        return nil
    end
    return character:GetAttribute("CurrentlyEquippedSword")
        or LocalPlayer:GetAttribute("CurrentlyEquippedSword")
end

function System.animation.get_anim_folder()
    local shared = ReplicatedStorage:FindFirstChild("Shared")
    local collection = shared and shared:FindFirstChild("SwordAPI")
    collection = collection and collection:FindFirstChild("Collection")
    if not collection then
        return nil
    end
    local name = System.animation.get_sword_name()
    if name then
        local ok, data = pcall(function()
            return ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(name)
        end)
        if ok and type(data) == "table" and data.AnimationType then
            local folder = collection:FindFirstChild(data.AnimationType)
            if folder then
                return folder
            end
        end
    end
    return collection:FindFirstChild("Default")
end

function System.animation.stop_tracks_with_attrs(animator, attributes)
    if not animator then
        return
    end
    local tracks
    local ok = pcall(function()
        tracks = animator:GetPlayingAnimationTracks()
    end)
    if not ok or type(tracks) ~= "table" then
        return
    end
    for _, track in ipairs(tracks) do
        for _, attribute in ipairs(attributes) do
            local has = false
            pcall(function()
                has = track:GetAttribute(attribute) ~= nil
            end)
            if has then
                pcall(function()
                    track:Stop(track:GetAttribute("StopFadeTime"))
                end)
                break
            end
        end
    end
end

function System.animation.stop_grab()
    local track = System.animation.__grab_track
    if track then
        pcall(function()
            track:Stop(track:GetAttribute("StopFadeTime"))
        end)
    end
    System.animation.__grab_track = nil
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    System.animation.stop_tracks_with_attrs(animator, { "GrabParry", "Parry" })
end

function System.animation.play_grab_parry()
    local character = LocalPlayer.Character
    if not character or character:GetAttribute("InOverdriveMech") then
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        return
    end
    System.animation.stop_tracks_with_attrs(animator, { "SuccessParry", "Parry", "GrabParry" })
    local folder = System.animation.get_anim_folder()
    if not folder then
        return
    end
    local animation = folder:FindFirstChild("GrabParry") or folder:FindFirstChild("Grab") or folder:FindFirstChild("Parry")
    if not animation then
        return
    end
    local ok, track = pcall(function()
        return animator:LoadAnimation(animation)
    end)
    if not ok or not track then
        return
    end
    pcall(function()
        track.Priority = Enum.AnimationPriority.Action4
        track:Play(track:GetAttribute("PlayFadeTime"), track:GetAttribute("PlayWeight"), track:GetAttribute("PlaySpeed"))
        local speed = track:GetAttribute("PlaySpeed") or 1
        local length = track.Length == 0 and 1 or (track.Length - track.TimePosition) * speed
        character:SetAttribute("ParryTime", math.max(character:GetAttribute("ParryTime") or 0, length))
    end)
    System.animation.__grab_track = track
end

local function get_network_ping()
    local ping = 0
    pcall(function()
        if LocalPlayer and LocalPlayer.GetNetworkPing then
            ping = LocalPlayer:GetNetworkPing() * 1000
        end
    end)
    if ping <= 0 then
        pcall(function()
            local network = Stats:FindFirstChild("Network")
            local server = network and network:FindFirstChild("ServerStatsItem")
            local data = server and server:FindFirstChild("Data Ping")
            if data then
                if data.GetValue then
                    ping = data:GetValue()
                elseif data.GetValueString then
                    ping = tonumber(tostring(data:GetValueString()):match("[%d%.]+")) or 0
                end
            end
        end)
    end
    return ping
end

local function update_divisor()
    local accuracy = math.clamp(System.__properties.__accuracy or 75, 1, 100)
    System.__properties.__divisor_multiplier = 0.5 + (accuracy - 1) * 0.010101010101010102
end

local function get_premium_parry_distance(speed, accuracy)
    local ping = get_data_ping()
    if ping <= 0 then
        ping = 50
    end
    local divisor = (2.4 + math.min(math.max(speed - 9.5, 0), 650) * 0.002) * (function()
        local acc = math.clamp(accuracy or System.__properties.__accuracy or 75, 1, 100)
        return 0.5 + (acc - 1) * 0.010101010101010102
    end)()
    local base = math.clamp(ping / 100, 5, 17) + math.max(speed / divisor, 9.5)
    return base
end
pcall(update_divisor)

local function update_randomized_accuracy()
    if not System.__properties.__randomized_accuracy_enabled then return end
    local ping = get_data_ping()
    if ping <= 0 then
        ping = get_network_ping()
    end
    local new_accuracy
    if ping >= 90 then
        new_accuracy = 4
    elseif ping <= 50 then
        new_accuracy = math.random(70, 100)
    else
        new_accuracy = System.__properties.__accuracy
    end
    if new_accuracy then
        System.__properties.__accuracy = new_accuracy
        update_divisor()
    end
end

task.spawn(function()
    while getgenv()._VanishAlive ~= false do
        task.wait(1)
        if System.__properties.__randomized_accuracy_enabled then
            pcall(update_randomized_accuracy)
        end
    end
end)

System.ball = {}

function System.ball.get_all()
    local out = {}
    for _, folder_name in ipairs({ "Balls", "TrainingBalls" }) do
        local folder = workspace:FindFirstChild(folder_name)
        if not folder then continue end
        for _, child in ipairs(folder:GetChildren()) do
            if child:GetAttribute("realBall") then
                table.insert(out, { part = child, model = nil })
                continue
            end
            if child:IsA("Model") then
                local part = child:FindFirstChild("Corpo") or child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                if part then
                    table.insert(out, { part = part, model = child })
                end
            end
        end
    end
    return out
end

function System.ball.get_entries()
    return System.ball.get_all()
end

function System.ball.get()
    local balls = workspace:FindFirstChild("Balls")
    if balls then
        for _, ball in pairs(balls:GetChildren()) do
            if ball:GetAttribute("realBall") then
                pcall(function()
                    ball.CanCollide = false
                end)
                return ball
            end
        end
    end
    local entries = System.ball.get_all()
    local first = entries[1]
    return first and first.part or nil
end

function System.ball.get_all_real()
    local balls_table = {}
    local balls = workspace:FindFirstChild("Balls")
    if balls then
        for _, ball in pairs(balls:GetChildren()) do
            if ball:GetAttribute("realBall") then
                pcall(function()
                    ball.CanCollide = false
                end)
                table.insert(balls_table, ball)
            end
        end
    end
    return balls_table
end

function System.ball.is_model_targeting_me(model)
    if not model then return false end
    local wl = model:FindFirstChild("CollisionWhitelist")
    if not wl then return false end
    return wl.Value == LocalPlayer.Character
end

function System.ball.is_named_target(target)
    if target == nil or target == "" then
        return false
    end
    if typeof(target) == "Instance" then
        if target:IsA("Player") then
            return target == LocalPlayer
        end
        if LocalPlayer.Character and target == LocalPlayer.Character then
            return true
        end
    end
    if target == LocalPlayer or target == LocalPlayer.Name or target == LocalPlayer.DisplayName then
        return true
    end
    if target == LocalPlayer.UserId or tostring(target) == tostring(LocalPlayer.UserId) then
        return true
    end
    local label = tostring(target)
    if label == LocalPlayer.Name or label == LocalPlayer.DisplayName or label == tostring(LocalPlayer) then
        return true
    end
    local team = LocalPlayer.Team
    if team and team.Name == "Blue" and target == "Goal1" then
        return true
    end
    if team and team.Name == "Red" and target == "Goal2" then
        return true
    end
    return false
end

function System.ball.is_targeting_me(entry)
    if not entry or not entry.part then return false end
    if entry.model then
        if System.ball.is_model_targeting_me(entry.model) then
            return true
        end
        if System.ball.is_named_target(entry.model:GetAttribute("target")) then
            return true
        end
    end
    return System.ball.is_named_target(entry.part:GetAttribute("target"))
end

function System.ball.in_round()
    local char = LocalPlayer.Character
    if not char then
        return false
    end
    local alive = Alive or workspace:FindFirstChild("Alive")
    if alive and (char.Parent == alive or alive:FindFirstChild(LocalPlayer.Name)) then
        return true
    end
    local training = workspace:FindFirstChild("TrainingBalls")
    return training ~= nil and #training:GetChildren() > 0
end

function System.ball.get_targeted()
    local out = {}
    for _, entry in ipairs(System.ball.get_all()) do
        if System.ball.is_targeting_me(entry) then
            table.insert(out, entry)
        end
    end
    return out
end

function System.ball.get_velocity(part, model)
    if model then
        local attr = model:GetAttribute("Velocity")
        if typeof(attr) == "Vector3" then
            return attr
        end
    end
    if not part then
        return Vector3.zero
    end
    local zoomies = part:FindFirstChild("zoomies")
    if zoomies then
        return zoomies.VectorVelocity
    end
    return part.AssemblyLinearVelocity
end

function System.ball.update_tracking(part, model)
    if not part then return end
    local key = tostring(part)
    local track = System.__properties.__ball_tracking
    if not track then
        track = {}
        System.__properties.__ball_tracking = track
    end
    if not track[key] then
        track[key] = { samples = {} }
    end
    local velocity = System.ball.get_velocity(part, model)
    local samples = track[key].samples
    table.insert(samples, { vel = velocity, t = tick() })
    if #samples > 20 then
        table.remove(samples, 1)
    end
end

function System.ball.check_tornado(part)
    if part and part:FindFirstChild("AeroDynamicSlashVFX") then
        pcall(function()
            Debris:AddItem(part.AeroDynamicSlashVFX, 0)
        end)
        AbilityDetect.mark_tornado()
    end
    return AbilityDetect.is_tornado_active()
end

System.player = {}

local Closest_Entity = nil

function System.player.get_closest()
    local max_distance = math.huge
    local closest_entity = nil
    local alive = Alive or workspace:FindFirstChild("Alive")
    if not alive then
        Closest_Entity = nil
        return nil
    end
    local character = LocalPlayer.Character
    for _, entity in pairs(alive:GetChildren()) do
        if entity ~= character and entity.PrimaryPart then
            local distance = LocalPlayer:DistanceFromCharacter(entity.PrimaryPart.Position)
            if distance < max_distance then
                max_distance = distance
                closest_entity = entity
            end
        end
    end
    Closest_Entity = closest_entity
    return closest_entity
end

function System.player.get_closest_to_cursor()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
        return nil
    end
    local closest_player = nil
    local minimal_dot = -math.huge
    local camera = workspace.CurrentCamera
    if not Alive then return nil end
    local success, mouse_location = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    if not success then return nil end
    local ray = camera:ScreenPointToRay(mouse_location.X, mouse_location.Y)
    local pointer = CFrame.lookAt(ray.Origin, ray.Origin + ray.Direction)
    for _, player in pairs(Alive:GetChildren()) do
        if player == LocalPlayer.Character then continue end
        if not player:FindFirstChild('HumanoidRootPart') then continue end
        local direction = (player.HumanoidRootPart.Position - camera.CFrame.Position).Unit
        local dot = pointer.LookVector:Dot(direction)
        if dot > minimal_dot then
            minimal_dot = dot
            closest_player = player
        end
    end
    return closest_player
end

System.curve = {}

function System.curve.get_cframe()
    local camera = workspace.CurrentCamera
    if not camera then return CFrame.new() end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    if not root then return camera.CFrame end

    local names = System.__config and System.__config.__curve_names
    local idx = System.__properties.__curve_mode or 1
    local modeName = (type(names) == "table" and names[idx]) or "Camera"
    modeName = tostring(modeName or "Camera")

    local pos = camera.CFrame.Position
    if modeName == "Camera" or modeName == "Dot" then
        return camera.CFrame
    elseif modeName == "High" or modeName == "Up" then
        return CFrame.lookAt(pos, pos + camera.CFrame.UpVector * 1e6)
    elseif modeName == "Left" then
        return CFrame.lookAt(pos, pos - camera.CFrame.RightVector * 1e6)
    elseif modeName == "Right" then
        return CFrame.lookAt(pos, pos + camera.CFrame.RightVector * 1e6)
    elseif modeName == "Delay" then
        local dir = root.Position - pos
        if dir.Magnitude < 0.01 then
            dir = camera.CFrame.LookVector
        else
            dir = dir.Unit
        end
        return CFrame.lookAt(pos, pos - dir * 1e6 + Vector3.new(1000, 1000, 1000))
    elseif modeName == "Random" then
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        local aim = root.Position + camera.CFrame.LookVector * 120
        local look = (root.Position - aim)
        if look.Magnitude < 0.01 then
            look = -camera.CFrame.LookVector
        else
            look = look.Unit
        end
        local side = (math.random(0, 1) == 0) and -1 or 1
        local offsets = {
            look * math.random(7000, 12000) + right * (side * math.random(2000, 5000)) + up * math.random(3000, 6000),
            look * math.random(8000, 15000) + right * (side * math.random(1500, 4000)) + up * math.random(2000, 5000),
            right * (side * math.random(8000, 15000)) + look * math.random(2000, 5000) + up * math.random(2000, 5000),
            right * (side * math.random(10000, 18000)) + look * math.random(1000, 3000) + up * math.random(1500, 4000),
            look * math.random(10000, 18000) + right * (side * math.random(3000, 6000)) + up * math.random(2500, 5500),
            up * math.random(6000, 12000) + look * math.random(4000, 8000) + right * (side * math.random(2000, 5000)),
        }
        return CFrame.new(root.Position, aim + offsets[math.random(1, #offsets)])
    end

    local targetPart
    local closest = System.player.get_closest_to_cursor()
    if closest and closest:FindFirstChild('HumanoidRootPart') then
        targetPart = closest.HumanoidRootPart
    end
    local target_pos = targetPart and targetPart.Position or (root.Position + camera.CFrame.LookVector * 100)

    if modeName == "Accelerated" then
        return CFrame.new(root.Position, target_pos + Vector3.new(0, 5, 0))
    elseif modeName == "Backwards" or modeName == "Back" then
        local direction = (root.Position - target_pos).Unit
        local backwards_pos = root.Position + direction * 10000 + Vector3.new(0, 1000, 0)
        return CFrame.new(camera.CFrame.Position, backwards_pos)
    elseif modeName == "Slow" or modeName == "Down" then
        return CFrame.new(root.Position, target_pos + Vector3.new(0, -9e18, 0))
    elseif modeName == "RandomTarget" then
        local candidates = {}
        if Alive then
            for _, pl in pairs(Alive:GetChildren()) do
                if pl ~= LocalPlayer.Character and pl.PrimaryPart then
                    table.insert(candidates, pl)
                end
            end
        end
        if #candidates > 0 then
            local choice = candidates[math.random(1, #candidates)]
            return CFrame.new(root.Position, choice.PrimaryPart.Position)
        end
        return camera.CFrame
    end

    return camera.CFrame
end

System.parry = {}

local function bump_parry_counter()
    if (System.__properties.__parries or 0) > 10000 then
        return
    end
    System.__properties.__parries = (System.__properties.__parries or 0) + 1
    task.delay(0.5, function()
        if System.__properties.__parries and System.__properties.__parries > 0 then
            System.__properties.__parries = System.__properties.__parries - 1
        end
    end)
end

local last_block_at = 0

local function fire_block_connections()
    local now = os.clock()
    if now - last_block_at < 0.35 then
        return false
    end
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    local hotbar = gui and gui:FindFirstChild("Hotbar")
    local block = hotbar and hotbar:FindFirstChild("Block")
    if not block or not block.Activated or type(getconnections) ~= "function" then
        return false
    end
    local ok, conns = pcall(getconnections, block.Activated)
    if not ok or type(conns) ~= "table" then
        return false
    end
    last_block_at = now
    local fired_any = false
    for _, connection in pairs(conns) do
        local ok = pcall(function()
            connection:Fire()
        end)
        if ok then
            fired_any = true
        end
    end
    return fired_any
end

local path_health = { fails = 0, last_ok = 0, armed = false }

local function confirm_parry_path()
    path_health.fails = 0
    path_health.last_ok = tick()
end

local function rebuild_pry_signal()
    pcall(function()
        ensure_pry_signal(pry_bound_controller ~= nil and pry_bound_controller.Parent == nil)
    end)
end

local function watch_parry_path()
end

pcall(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 30)
    local ev = remotes and remotes:FindFirstChild("ParrySuccess")
    if ev then
        ev.OnClientEvent:Connect(function()
            confirm_parry_path()
        end)
    end
end)

local function og_remote_parry(is_spam)
    if (System.__properties.__parries or 0) > 10000 or not LocalPlayer.Character then
        return false
    end
    if captured.remote and not captured.remote.Parent then
        captured.remote = nil
    end
    if not signal_still_bound() then
        ensure_pry_signal(false)
    end
    local curve = nil
    pcall(function()
        curve = System.curve.get_cframe()
    end)
    if typeof(curve) ~= "CFrame" then
        curve = CFrame.new()
    end
    local data = nil
    pcall(function()
        data = og_get_event_data()
    end)
    if type(data) ~= "table" then
        data = {}
    end
    local aim = nil
    pcall(function()
        aim = og_get_mouse_vec()
    end)
    if type(aim) ~= "table" then
        aim = { 0, 0 }
    end
    local sent = fire_allusive_remote(curve, data, aim) == true
    if not sent then
        rebuild_pry_signal()
        sent = fire_allusive_remote(curve, data, aim) == true
    end
    if not sent and captured.remote and captured.remote.Parent and captured.sessionKey ~= nil and key ~= nil then
        local ok, result = pcall(fireParry_wh)
        sent = ok and result == true
    end
    if not sent then
        sent = fire_reverted_remotes(curve, data, aim) == true
    end
    if not sent then
        if fire_block_connections() then
            System.__properties.__first_parry_done = true
            sent = true
        end
    end
    if sent then
        if (System.__properties.__parries or 0) <= 10000 then
            bump_parry_counter()
        end
    end
    return sent
end

function System.parry.execute()
    return og_remote_parry(false)
end

function System.parry.execute_fast(_mode)
    return og_remote_parry(true)
end

function System.parry.execute_action()
    return System.parry.execute()
end

local function linear_predict(a, b, time_volume)
    return a + (b - a) * time_volume
end

System.detection = {
    __ball_properties = {
        __aerodynamic_time = tick(),
        __last_warping = tick(),
        __lerp_radians = 0,
        __curving = tick(),
        __curve_time = 0,
    },
}

System.detection.__per_ball = {}

function System.detection.is_curved()
    local ball_properties = System.detection.__ball_properties
    local ball = System.ball.get()
    if not ball then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local zoomies = ball:FindFirstChild("zoomies")
    if not zoomies then return false end
    local velocity = zoomies.VectorVelocity or Vector3.new()
    local speed = velocity.Magnitude
    if speed == 0 then return false end
    local ball_direction = velocity.Unit
    local direction_vector = LocalPlayer.Character.PrimaryPart.Position - ball.Position
    if direction_vector.Magnitude == 0 then return false end
    local direction = direction_vector.Unit
    local dot = direction:Dot(ball_direction)
    local speed_threshold = math.min(speed / 100, 40)
    local direction_difference = ball_direction - velocity
    local direction_similarity = 0
    if direction_difference.Magnitude > 0 then
        direction_similarity = direction:Dot(direction_difference.Unit)
    end
    local dot_difference = dot - direction_similarity
    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local ping = 50
    pcall(function()
        ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if type(ping) ~= "number" or ping <= 0 then
        ping = 50
    end
    local dot_threshold = 0.5 - (ping / 1000)
    local reach_time = distance / speed - (ping / 1000)
    local ball_distance_threshold = 15 - math.min(distance / 1000, 15) + speed_threshold
    local clamped_dot = math.clamp(dot, -1, 1)
    local radians = math.rad(math.asin(clamped_dot))
    ball_properties.__lerp_radians = linear_predict(ball_properties.__lerp_radians or 0, radians, 0.8)
    if speed > 0 and reach_time > ping / 10 then
        ball_distance_threshold = math.max(ball_distance_threshold - 15, 15)
    end
    if distance < ball_distance_threshold then return false end
    if dot_difference < dot_threshold then return true end
    if ball_properties.__lerp_radians < 0.018 then
        ball_properties.__last_warping = tick()
    end
    if (tick() - (ball_properties.__last_warping or 0)) < (reach_time / 1.5) then
        return true
    end
    if (tick() - (ball_properties.__curving or 0)) < (reach_time / 1.5) then
        return true
    end
    return dot < dot_threshold
end

System.ball.is_curved = System.detection.is_curved

pcall(function()
    ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
        pcall(System.animation.stop_grab)
    end)
end)

pcall(function()
    ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
        local character = LocalPlayer.Character
        local primary = character and character.PrimaryPart
        if not primary then
            return
        end
        local balls = workspace:FindFirstChild("Balls")
        if not balls then
            return
        end
        for _, ball in ipairs(balls:GetChildren()) do
            if not ball:IsA("BasePart") then
                continue
            end
            local zoomies = ball:FindFirstChild("zoomies")
            if not zoomies then
                continue
            end
            local speed = zoomies.VectorVelocity.Magnitude
            local distance = (primary.Position - ball.Position).Magnitude
            local ping = get_data_ping()
            local time_to = distance / math.max(speed, 1) - ping / 1000
            local gate = 15 - math.min(distance / 1000, 15) + math.min(speed / 100, 40)
            if speed > 1 and ping / 10 < time_to then
                gate = math.max(gate - 15, 15)
            end
            if root == primary then
                break
            end
            if not (gate < distance) then
                break
            end
            System.detection.__ball_properties.__curve_time = tick()
            System.detection.__ball_properties.__curving = tick()
            break
        end
    end)
end)

getgenv().CooldownProtection = getgenv().CooldownProtection or false
getgenv().AutoAbility = getgenv().AutoAbility or false
getgenv().ManualSpamAnimationFix = getgenv().ManualSpamAnimationFix or false
getgenv().AutoSpamAnimationFix = getgenv().AutoSpamAnimationFix or false
getgenv().DetectionsEnabled = getgenv().DetectionsEnabled == true
getgenv().InfinityDetection = getgenv().InfinityDetection == true
getgenv().DeathSlashDetection = getgenv().DeathSlashDetection == true
getgenv().SlashOfFuryDetection = getgenv().SlashOfFuryDetection == true
getgenv().TimeHoleDetection = getgenv().TimeHoleDetection == true
getgenv().SingularityDetection = getgenv().SingularityDetection == true
getgenv().PulsedDetection = getgenv().PulsedDetection == true
getgenv().ForcefieldDetection = getgenv().ForcefieldDetection == true
getgenv().DualityDetection = getgenv().DualityDetection == true

local function fire_combat_parry()
    return System.parry.execute() == true
end

System.manual_spam = {}

local manualSpamThread = nil
local macroSpamActive = false

function System.manual_spam.start()
    System.manual_spam.stop()
    System.__properties.__manual_spam_enabled = true
    macroSpamActive = true
    pcall(function()
        ensure_pry_signal(false)
    end)
    local parry_execute = System.parry.execute
    local play_animation = System.animation.play_grab_parry
    local threshold = 0.015
    manualSpamThread = coroutine.create(function()
        local last_spam = 0
        while System.__properties.__manual_spam_enabled do
            local now = os.clock()
            if now - last_spam >= threshold then
                last_spam = now
                parry_execute()
                if getgenv().ManualSpamAnimationFix then
                    play_animation()
                end
            end
            coroutine.yield()
        end
    end)
    task.spawn(function()
        while System.__properties.__manual_spam_enabled and manualSpamThread and coroutine.status(manualSpamThread) ~= "dead" do
            coroutine.resume(manualSpamThread)
            task.wait()
        end
    end)
end

function System.manual_spam.stop()
    System.__properties.__manual_spam_enabled = false
    macroSpamActive = false
    manualSpamThread = nil
end

RunService.Heartbeat:Connect(function()
    if not macroSpamActive then
        return
    end
    pcall(function()
        System.parry.execute()
    end)
    if getgenv().ManualSpamAnimationFix then
        pcall(System.animation.play_grab_parry)
    end
end)

System.auto_spam = {}

function System.auto_spam.reach(speed)
    local sens = math.max(System.__properties.__spam_sensitivity or System.__properties.__auto_spam_distance_multiplier or 1, 0.1)
    return get_premium_parry_distance(speed) * sens
end

function System.auto_spam:get_entity_properties()
    System.player.get_closest()
    if not Closest_Entity or not Closest_Entity.PrimaryPart then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local entity_velocity = Closest_Entity.PrimaryPart.Velocity
    local entity_direction = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
    local entity_distance = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    return {
        Velocity = entity_velocity,
        Direction = entity_direction,
        Distance = entity_distance
    }
end

function System.auto_spam:get_ball_properties()
    local ball = System.ball.get()
    if not ball then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local ball_velocity = ball.AssemblyLinearVelocity or Vector3.new()
    local ball_origin = ball
    local ball_direction_vector = LocalPlayer.Character.PrimaryPart.Position - ball_origin.Position
    local ball_distance = ball_direction_vector.Magnitude
    local ball_direction = Vector3.new()
    local ball_dot = 0
    if ball_distance > 0 then
        ball_direction = ball_direction_vector.Unit
        if ball_velocity.Magnitude > 0 then
            ball_dot = ball_direction:Dot(ball_velocity.Unit)
        end
    end
    return {
        Velocity = ball_velocity,
        Direction = ball_direction,
        Distance = ball_distance,
        Dot = ball_dot
    }
end

function System.auto_spam.spam_service(self)
    local ball = System.ball.get()
    local entity = System.player.get_closest()
    if not ball or not entity or not entity.PrimaryPart then
        return false
    end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return false
    end

    local D = 5
    local velocity = ball.AssemblyLinearVelocity or Vector3.new()
    local n = velocity.Magnitude
    if n == 0 then
        return D
    end

    local to_ball = (LocalPlayer.Character.PrimaryPart.Position - ball.Position)
    if to_ball.Magnitude == 0 then
        return D
    end

    local r = to_ball.Unit
    local t = 0
    if n > 0 and velocity.Magnitude > 0 then
        t = r:Dot(velocity.Unit)
    end

    local target_pos = entity.PrimaryPart.Position
    local X = LocalPlayer:DistanceFromCharacter(target_pos)

    local E = 1
    local Fmove = Vector3.new()
    local success, humanoid = pcall(function()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end)
    if success and humanoid and humanoid.MoveDirection then
        Fmove = humanoid.MoveDirection
    end

    local N = (target_pos - LocalPlayer.Character.PrimaryPart.Position)
    if N.Magnitude > 0 then N = N.Unit else N = Vector3.new() end
    local lmove = Vector3.new()
    if entity then
        local ehum = entity:FindFirstChildOfClass("Humanoid")
        if ehum and ehum.MoveDirection then lmove = ehum.MoveDirection end
    end

    _G.Last_Close_Contact = _G.Last_Close_Contact or 0
    _G.In_Close_Contact = _G.In_Close_Contact or false
    local now = tick()
    if X <= 3 then
        _G.In_Close_Contact = true
    end
    if _G.In_Close_Contact and X > 3.3 then
        _G.In_Close_Contact = false
        _G.Last_Close_Contact = now
    end
    local u = (not _G.In_Close_Contact) and (now - (_G.Last_Close_Contact or 0) >= 1.5)
    if u and (Fmove.Magnitude > 0.2 and Fmove:Dot(N) < -0.4) then
        E = 10
    end
    if u and (lmove.Magnitude > 0.2 and lmove:Dot(-N) < -0.4) then
        E = 10
    end

    local B = (self.Ping or 50) * 0.7 + math.min(n / (E * 1.2), 80)
    if (self.Entity_Properties and self.Entity_Properties.Distance or math.huge) > B then
        return D
    end
    if (self.Ball_Properties and self.Ball_Properties.Distance or math.huge) > B then
        return D
    end
    if X > B then
        return D
    end

    local U = math.clamp(-t, 0, 1)
    local q = math.clamp(U * (n / 40), 0, 4)
    D = B - q
    return D
end

local function combined_parry_reach(speed, raw_ping)
    speed = speed or 0
    local ping = raw_ping
    if type(ping) ~= "number" or ping <= 0 then
        ping = 50
    end
    local accuracy = math.clamp(System.__properties.__accuracy or 75, 1, 100)
    local capped = math.min(math.max(speed - 9.5, 0), 650)
    local og_div = (2.4 + capped * 0.002) * (0.7 + (accuracy - 1) * 0.0035353535353535)
    if og_div == 0 then
        og_div = 0.001
    end
    local og_ping = math.clamp((ping / 10) / 10, 5, 17)
    local og_reach = og_ping + math.max(speed / og_div, 9.5)
    local allusive_div = (2.4 + capped * 0.002) * (0.5 + (accuracy - 1) * 0.010101010101010102)
    if allusive_div == 0 then
        allusive_div = 0.001
    end
    local allusive_reach = math.clamp(ping / 100, 5, 17) + math.max(speed / allusive_div, 9.5)
    local reach = math.max(og_reach, allusive_reach)
    if speed >= 800 then
        reach = reach + math.min(speed / 80, 35)
    end
    return reach
end

local function close_spam_reach(speed)
    speed = speed or 0
    local reach = 17 + (speed / 250) * 7
    if speed >= 800 then
        reach = reach + math.min(speed / 60, 45)
    end
    return reach
end

function System.auto_spam.frame()
    if not System.__properties.__auto_spam_enabled then
        return
    end
    if System.__properties.__manual_spam_enabled then
        return
    end
    local ball = System.ball.get()
    if not ball then
        return
    end
    local zoomies = ball:FindFirstChild("zoomies")
    if not zoomies then
        return
    end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return
    end
    System.player.get_closest()
    local ping = 50
    pcall(function()
        ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if type(ping) ~= "number" or ping <= 0 then
        ping = 50
    end
    local ping_threshold = math.clamp(ping / 10, 1, 16)
    local ball_target = ball:GetAttribute("target")
    local ball_properties = System.auto_spam:get_ball_properties()
    local entity_properties = System.auto_spam:get_entity_properties()
    if not ball_properties or not entity_properties then
        return
    end
    local spam_accuracy = System.auto_spam.spam_service({
        Ball_Properties = ball_properties,
        Entity_Properties = entity_properties,
        Ping = ping_threshold
    })
    if zoomies.VectorVelocity.Magnitude == 0 then
        return
    end
    if AbilityDetect.ability_hold and AbilityDetect.ability_hold() then
        return
    end
    if AbilityDetect.dragon_hold and AbilityDetect.dragon_hold(ball) then
        return
    end
    local distance = LocalPlayer:DistanceFromCharacter(ball.Position)
    if not ball_target then
        return
    end
    if LocalPlayer.Character:GetAttribute("Pulsed") then
        return
    end
    local target_distance = math.huge
    if Closest_Entity and Closest_Entity.PrimaryPart then
        target_distance = LocalPlayer:DistanceFromCharacter(Closest_Entity.PrimaryPart.Position)
    end
    if type(spam_accuracy) ~= "number" then
        spam_accuracy = 5
    end
    local aimed = ball_target == LocalPlayer.Name or System.ball.is_named_target(ball_target)
    local speed = zoomies.VectorVelocity.Magnitude
    if aimed and target_distance > 30 and distance > 30 and distance > close_spam_reach(speed) then
        return
    end
    local root = LocalPlayer.Character.PrimaryPart
    local incoming = true
    if root and speed > 1 then
        local offset = root.Position - ball.Position
        if offset.Magnitude > 1 then
            incoming = zoomies.VectorVelocity:Dot(offset) > 0
        end
    end
    local close_hit = aimed and incoming and distance <= close_spam_reach(speed)
    local og_hit = distance <= spam_accuracy and target_distance <= spam_accuracy
    if (og_hit or close_hit) and System.__properties.__parries > System.__properties.__spam_threshold then
        System.parry.execute_action()
        if getgenv().AutoSpamAnimationFix then
            task.spawn(function()
                pcall(System.animation.play_grab_parry)
            end)
        end
    end
end

local function autospam_ensure_loop()
    local conns = System.__properties.__connections
    if not System.__properties.__auto_spam_enabled then
        return
    end
    local ps = conns.__auto_spam
    local hb = conns.__auto_spam_hb
    if hb then
        pcall(function()
            hb:Disconnect()
        end)
        conns.__auto_spam_hb = nil
    end
    local need_ps = not (ps and typeof(ps) == "RBXScriptConnection" and ps.Connected)
    if need_ps then
        if ps then
            pcall(function()
                ps:Disconnect()
            end)
        end
        conns.__auto_spam = RunService.PreSimulation:Connect(function()
            pcall(System.auto_spam.frame)
        end)
    end
end

function System.auto_spam.start()
    if System.__properties.__connections.__auto_spam then
        pcall(function()
            System.__properties.__connections.__auto_spam:Disconnect()
        end)
        System.__properties.__connections.__auto_spam = nil
    end
    if System.__properties.__connections.__auto_spam_hb then
        pcall(function()
            System.__properties.__connections.__auto_spam_hb:Disconnect()
        end)
        System.__properties.__connections.__auto_spam_hb = nil
    end
    System.__properties.__auto_spam_enabled = true
    System.__properties.__parries = 0
    System.__properties.__spam_auto_decay_at = {}
    System.__properties.__spam_latched = false
    System.__properties.__spam_latch_lost_at = 0
    pcall(function()
        ensure_pry_signal(false)
    end)
    autospam_ensure_loop()
end

function System.auto_spam.stop()
    System.__properties.__auto_spam_enabled = false
    System.__properties.__spam_auto_decay_at = {}
    System.__properties.__spam_latched = false
    if System.__properties.__connections.__auto_spam then
        System.__properties.__connections.__auto_spam:Disconnect()
        System.__properties.__connections.__auto_spam = nil
    end
    if System.__properties.__connections.__auto_spam_hb then
        System.__properties.__connections.__auto_spam_hb:Disconnect()
        System.__properties.__connections.__auto_spam_hb = nil
    end
end

System.autoparry = {}

local parry_fail = { at = 0, last = nil, conn = nil, pending = 0, saw = false, window = 0.4 }

local function hook_parry_cooldown(char)
    if parry_fail.conn then
        pcall(function()
            parry_fail.conn:Disconnect()
        end)
        parry_fail.conn = nil
    end
    parry_fail.pending = (parry_fail.pending or 0) + 1
    parry_fail.saw = false
    if not char then
        return
    end
    parry_fail.last = char:GetAttribute("Parrying")
    parry_fail.at = 0
    parry_fail.conn = char:GetAttributeChangedSignal("Parrying"):Connect(function()
        local now = char:GetAttribute("Parrying")
        if now == true then
            parry_fail.saw = true
        end
        if parry_fail.last == true and now == false then
            parry_fail.at = tick()
        elseif now == nil or now == true then
            parry_fail.at = 0
        end
        parry_fail.last = now
    end)
end

if LocalPlayer.Character then
    hook_parry_cooldown(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(hook_parry_cooldown)

local function try_cooldown_protection()
    if not getgenv().CooldownProtection then
        return false
    end
    if parry_fail.at == 0 then
        return false
    end
    if tick() - parry_fail.at >= 2 then
        parry_fail.at = 0
        return false
    end
    local ok = pcall(function()
        ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
    end)
    parry_fail.at = 0
    return ok
end

local function mark_parry_attempt()
    parry_fail.pending = (parry_fail.pending or 0) + 1
    local id = parry_fail.pending
    parry_fail.saw = false
    task.delay(parry_fail.window or 0.4, function()
        if parry_fail.pending ~= id or parry_fail.saw then
            return
        end
        local live = LocalPlayer.Character
        if live and live:GetAttribute("Parrying") == true then
            return
        end
        parry_fail.at = tick()
    end)
end

function System.autoparry.frame()
    if not System.__properties.__autoparry_enabled or not LocalPlayer.Character or
        not LocalPlayer.Character.PrimaryPart then
        return
    end
    local balls = {}
    local seen = {}
    local function add_ball(ball)
        if typeof(ball) == "Instance" and not seen[ball] then
            seen[ball] = true
            table.insert(balls, ball)
        end
    end
    for _, ball in ipairs(System.ball.get_all_real()) do
        add_ball(ball)
    end
    for _, entry in ipairs(System.ball.get_all()) do
        if type(entry) == "table" then
            add_ball(entry.part)
        else
            add_ball(entry)
        end
    end
    local one_ball = System.ball.get()
    local training_ball = nil
    if workspace:FindFirstChild("TrainingBalls") then
        for _, inst in pairs(workspace.TrainingBalls:GetChildren()) do
            if inst:GetAttribute("realBall") then
                training_ball = inst
                break
            end
        end
    end
    for _, ball in pairs(balls) do
        if getgenv().BallVelocityAbove800 then
            return
        end
        if not ball then
            continue
        end
        local zoomies = ball:FindFirstChild("zoomies")
        if not zoomies then
            continue
        end
        ball:GetAttributeChangedSignal("target"):Once(function()
            System.__properties.__parried = false
        end)
        if System.__properties.__parried then
            continue
        end
        local ball_target = ball:GetAttribute("target")
        local velocity = zoomies.VectorVelocity
        local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
        local ping = 50
        pcall(function()
            ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
        end)
        local ping_threshold = math.clamp(ping / 10, 5, 17)
        local speed = velocity.Magnitude
        local capped_speed_diff = math.min(math.max(speed - 9.5, 0), 650)
        local speed_divisor = (2.4 + capped_speed_diff * 0.002) * System.__properties.__divisor_multiplier
        local parry_accuracy = ping_threshold + math.max(speed / speed_divisor, 9.5)
        local curved = System.detection.is_curved()
        if ball:FindFirstChild("AeroDynamicSlashVFX") then
            ball.AeroDynamicSlashVFX:Destroy()
            System.__properties.__tornado_time = tick()
        end
        local runtime = Runtime or workspace:FindFirstChild("Runtime")
        if runtime and runtime:FindFirstChild("Tornado") then
            if (tick() - System.__properties.__tornado_time) <
                (runtime.Tornado:GetAttribute("TornadoTime") or 1) + 0.314159 then
                continue
            end
        end
        if one_ball and one_ball:GetAttribute("target") == LocalPlayer.Name and curved then
            continue
        end
        if ball:FindFirstChild("ComboCounter") then
            continue
        end
        if LocalPlayer.Character.PrimaryPart:FindFirstChild("SingularityCape") then
            continue
        end
        if ball_target == LocalPlayer.Name and distance <= parry_accuracy then
            if getgenv().CooldownProtection then
                local ok_cd, ParryCD = pcall(function()
                    return LocalPlayer.PlayerGui.Hotbar.Block.UIGradient
                end)
                if ok_cd and ParryCD and ParryCD.Offset.Y < 0.4 then
                    pcall(function()
                        ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                    end)
                    continue
                end
            end
            if getgenv().AutoAbility then
                local ok_ab, AbilityCD = pcall(function()
                    return LocalPlayer.PlayerGui.Hotbar.Ability.UIGradient
                end)
                if ok_ab and AbilityCD and AbilityCD.Offset.Y == 0.5 then
                    local abilities = LocalPlayer.Character:FindFirstChild("Abilities")
                    if abilities and (
                        (abilities:FindFirstChild("Raging Deflection") and abilities["Raging Deflection"].Enabled)
                        or (abilities:FindFirstChild("Rapture") and abilities.Rapture.Enabled)
                        or (abilities:FindFirstChild("Calming Deflection") and abilities["Calming Deflection"].Enabled)
                        or (abilities:FindFirstChild("Aerodynamic Slash") and abilities["Aerodynamic Slash"].Enabled)
                        or (abilities:FindFirstChild("Fracture") and abilities.Fracture.Enabled)
                        or (abilities:FindFirstChild("Death Slash") and abilities["Death Slash"].Enabled)
                    ) then
                        System.__properties.__parried = true
                        pcall(function()
                            ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                        end)
                        task.spawn(function()
                            task.wait(2.432)
                            pcall(function()
                                ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
                            end)
                        end)
                        continue
                    end
                end
            end
        end
        if ball_target == LocalPlayer.Name and distance <= parry_accuracy then
            System.parry.execute_action()
            System.__properties.__parried = true
        end
        local last_parrys = tick()
        repeat
            RunService.Stepped:Wait()
        until (tick() - last_parrys) >= 1 or not System.__properties.__parried
        System.__properties.__parried = false
    end
    if training_ball then
        local zoomies = training_ball:FindFirstChild("zoomies")
        if zoomies then
            training_ball:GetAttributeChangedSignal("target"):Once(function()
                System.__properties.__training_parried = false
            end)
            if not System.__properties.__training_parried then
                local ball_target = training_ball:GetAttribute("target")
                local velocity = zoomies.VectorVelocity
                local distance = LocalPlayer:DistanceFromCharacter(training_ball.Position)
                local speed = velocity.Magnitude
                local ping = 50
                pcall(function()
                    ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
                end)
                local ping_threshold = math.clamp(ping / 10, 5, 17)
                local capped_speed_diff = math.min(math.max(speed - 9.5, 0), 650)
                local speed_divisor = (2.4 + capped_speed_diff * 0.002) * System.__properties.__divisor_multiplier
                local parry_accuracy = ping_threshold + math.max(speed / speed_divisor, 9.5)
                if ball_target == LocalPlayer.Name and distance <= parry_accuracy then
                    System.parry.execute_action()
                    System.__properties.__training_parried = true
                    local last_parrys = tick()
                    repeat
                        RunService.Stepped:Wait()
                    until (tick() - last_parrys) >= 1 or not System.__properties.__training_parried
                    System.__properties.__training_parried = false
                end
            end
        end
    end
end

local function autoparry_ensure_loop()
    local conns = System.__properties.__connections
    local conn = conns.__autoparry
    if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
        return
    end
    if conn then
        pcall(function()
            conn:Disconnect()
        end)
    end
    if conns.__autoparry_hb then
        pcall(function()
            conns.__autoparry_hb:Disconnect()
        end)
        conns.__autoparry_hb = nil
    end
    conns.__autoparry = RunService.PreSimulation:Connect(function()
        pcall(System.autoparry.frame)
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if System and System.__properties and System.__properties.__autoparry_enabled then
            local conn = System.__properties.__connections.__autoparry
            if not conn or typeof(conn) ~= "RBXScriptConnection" or not conn.Connected then
                pcall(autoparry_ensure_loop)
            end
        end
    end
end)

function System.autoparry.start()
    System.__properties.__autoparry_enabled = true
    System.__properties.__parried = false
    System.__properties.__parried_at = 0
    System.__properties.__parried_until = 0
    System.__properties.__training_parried = false
    System.__properties.__parry_watch = {}
    if System.__properties.__connections.__autoparry then
        pcall(function()
            System.__properties.__connections.__autoparry:Disconnect()
        end)
        System.__properties.__connections.__autoparry = nil
    end
    if System.__properties.__connections.__autoparry_hb then
        pcall(function()
            System.__properties.__connections.__autoparry_hb:Disconnect()
        end)
        System.__properties.__connections.__autoparry_hb = nil
    end
    pcall(function()
        ensure_pry_signal(false)
    end)
    autoparry_ensure_loop()
end

function System.autoparry.stop()
    System.__properties.__autoparry_enabled = false
    System.__properties.__parried = false
    System.__properties.__parried_at = 0
    System.__properties.__parried_until = 0
    System.__properties.__training_parried = false
    local watch = System.__properties.__parry_watch
    if type(watch) == "table" then
        for ball, conn in pairs(watch) do
            pcall(function()
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                end
            end)
            watch[ball] = nil
        end
    end
    System.__properties.__parry_watch = {}
end

pcall(autoparry_ensure_loop)
task.spawn(function()
    while getgenv()._VanishAlive ~= false do
        pcall(autoparry_ensure_loop)
        if System.__properties.__auto_spam_enabled then
            pcall(autospam_ensure_loop)
        end
        task.wait(2)
    end
end)

local function create_mobile_button(name, position_y, color)
    local gui = Instance.new('ScreenGui')
    gui.Name = 'Sigma' .. name .. 'Mobile'
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local button = Instance.new('TextButton')
    button.Size = UDim2.new(0, 140, 0, 50)
    button.Position = UDim2.new(0.5, -70, position_y, 0)
    button.BackgroundTransparency = 1
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Draggable = true
    button.AutoButtonColor = false
    button.ZIndex = 2

    local bg = Instance.new('Frame')
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bg.Parent = button

    local corner = Instance.new('UICorner')
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = bg

    local stroke = Instance.new('UIStroke')
    stroke.Color = color
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = bg

    local text = Instance.new('TextLabel')
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.Font = Enum.Font.GothamBold
    text.TextSize = 16
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.ZIndex = 3
    text.Parent = button

    button.Parent = gui
    gui.Parent = CoreGui

    return {gui = gui, button = button, text = text, bg = bg}
end

local function destroy_mobile_gui(gui_data)
    if gui_data and gui_data.gui then
        gui_data.gui:Destroy()
    end
end

local autoparry_module = CombatTab:create_module({
    title = "Auto Parry",
    description = "Automatically parries incoming balls",
    flag = "AutoParryModule",
    section = "left",
    callback = function(state)
        state = toggle_state(state)
        if System then
            System.__properties.__autoparry_enabled = state
            if state then
                if System.autoparry and System.autoparry.start then pcall(System.autoparry.start)
                end
                if System.__properties.__is_mobile and not System.__properties.__mobile_guis.autoparry then
                    local success, autoparry_mobile = pcall(function()
                        return create_mobile_button('AutoParry', 0.6, Color3.fromRGB(100, 180, 255))
                    end)
                    if success and autoparry_mobile then
                        System.__properties.__mobile_guis.autoparry = autoparry_mobile

                        local touch_start = 0
                        local was_dragged = false

                        autoparry_mobile.button.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch then
                                touch_start = tick()
                                was_dragged = false
                            end
                        end)

                        autoparry_mobile.button.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch then
                                if (tick() - touch_start) > 0.1 then
                                    was_dragged = true
                                end
                            end
                        end)

                        autoparry_mobile.button.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch and not was_dragged then
                                if System then
                                    System.__properties.__autoparry_enabled = not System.__properties.__autoparry_enabled
                                    if System.autoparry and System.autoparry.start and System.autoparry.stop then
                                        if System.__properties.__autoparry_enabled then
                                            pcall(System.autoparry.start)
                                        else
                                            pcall(System.autoparry.stop)
                                        end
                                    end
                                end

                                if System and System.__properties and System.__properties.__autoparry_enabled then
                                    autoparry_mobile.text.Text = "ON"
                                    autoparry_mobile.text.TextColor3 = Color3.fromRGB(100, 180, 255)
                                else
                                    autoparry_mobile.text.Text = "AutoParry"
                                    autoparry_mobile.text.TextColor3 = Color3.fromRGB(255, 255, 255)
                                end

                                if section_notify_on("AutoParryModule") then
                                    Notify({ title = "Auto Parry", text = System and System.__properties and System.__properties.__autoparry_enabled and "ON" or "OFF", duration = 2 })
                                end
                            end
                        end)
                    end
                end
            else
                if System.autoparry and System.autoparry.stop then pcall(System.autoparry.stop)
                end
                if System.__properties.__mobile_guis.autoparry then
                    destroy_mobile_gui(System.__properties.__mobile_guis.autoparry)
                    System.__properties.__mobile_guis.autoparry = nil
                end
            end
        end
    end
})

local mode_curve_dropdown = nil
local CurveOverlayState = {
    gui = nil,
    frame = nil,
    drag = nil,
    release = nil,
}

local function current_curve_name()
    local names = System and System.__config and System.__config.__curve_names
    local idx = System and System.__properties and System.__properties.__curve_mode
    if type(names) == "table" and type(idx) == "number" and names[idx] then
        return names[idx]
    end
    return "Camera"
end

local function apply_curve_type(value)
    value = dropdown_value(value) or value
    local names = System and System.__config and System.__config.__curve_names
    if type(names) ~= "table" then
        return
    end
    if type(value) == "number" and value >= 1 and value <= #names then
        System.__properties.__curve_mode = value
    elseif type(value) == "string" then
        local aliases = {
            Dot = "Camera",
            Back = "Backwards",
            Up = "High",
            Down = "Slow",
        }
        value = aliases[value] or value
        for i, name in ipairs(names) do
            if name == value then
                System.__properties.__curve_mode = i
                break
            end
        end
    end
    getgenv().ParryCurveMode = current_curve_name()
    if CurveOverlayState.frame then
        local pill = CurveOverlayState.frame:FindFirstChild("PillLabel")
        if pill then
            pill.Text = current_curve_name()
        end
    end
end

pcall(function()
    local old = CoreGui:FindFirstChild("VanishCurveOverlay")
    if old then old:Destroy() end
end)

mode_curve_dropdown = autoparry_module:create_dropdown({
    title = "Curve Type",
    flag = "ModeCurve",
    options = (System and System.__config and System.__config.__curve_names) or {"Camera", "Random", "Accelerated", "Backwards", "Slow", "High", "RandomTarget", "Left", "Right", "Delay"},
    option_keybinds = true,
    maximum_options = 10,
    callback = function(value)
        apply_curve_type(value)
    end
})

autoparry_module:create_slider({
    title = "Parry Accuracy",
    flag = "ParryAccuracy",
    maximum_value = 100,
    minimum_value = 1,
    value = 75,
    round_number = true,
    callback = function(value)
        if System then
            System.__properties.__accuracy = value
            if update_divisor then pcall(update_divisor) end
        end
    end
})

autoparry_module:create_checkbox({
    title = "Randomize Accuracy",
    flag = "RandomizeAccuracy",
    callback = function(value)
        if System then
            System.__properties.__randomized_accuracy_enabled = toggle_state(value)
            if System.__properties.__randomized_accuracy_enabled and update_randomized_accuracy then pcall(update_randomized_accuracy) end
        end
    end
})

autoparry_module:create_checkbox({
    title = "Cooldown Protection",
    flag = "CooldownProtection",
    callback = function(value)
        getgenv().CooldownProtection = toggle_state(value)
    end
})

autoparry_module:create_checkbox({
    title = "Auto Ability",
    flag = "AutoAbility",
    callback = function(value)
        getgenv().AutoAbility = toggle_state(value)
    end
})


local function destroy_curve_overlay()
    if CurveOverlayState.drag then
        CurveOverlayState.drag:Disconnect()
        CurveOverlayState.drag = nil
    end
    if CurveOverlayState.release then
        CurveOverlayState.release:Disconnect()
        CurveOverlayState.release = nil
    end
    if CurveOverlayState.gui then
        pcall(function() CurveOverlayState.gui:Destroy() end)
    end
    CurveOverlayState.gui = nil
    CurveOverlayState.frame = nil
end

local function create_curve_overlay()
    if CurveOverlayState.gui then
        return
    end

    local curveNames = (System and System.__config and System.__config.__curve_names) or {"Camera", "Random", "Accelerated", "Backwards", "Slow", "High", "RandomTarget", "Left", "Right", "Delay"}

    local OverlayGui = Instance.new("ScreenGui")
    OverlayGui.Name = "VanishCurveOverlay"
    OverlayGui.ResetOnSpawn = false
    OverlayGui.IgnoreGuiInset = true
    OverlayGui.DisplayOrder = 100
    OverlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        local protect = protect_gui or protectgui or (syn and syn.protect_gui)
        if protect then
            protect(OverlayGui)
        end
    end)
    pcall(function()
        if typeof(gethui) == "function" then
            OverlayGui.Parent = gethui()
        end
    end)
    if not OverlayGui.Parent then
        pcall(function() OverlayGui.Parent = CoreGui end)
    end
    if getgenv()._VanishGuis then
        table.insert(getgenv()._VanishGuis, OverlayGui)
    end

    local Pill = Instance.new("Frame")
    Pill.Name = "CurvePill"
    Pill.Size = UDim2.new(0, 132, 0, 36)
    Pill.AnchorPoint = Vector2.new(0.5, 1)
    Pill.Position = UDim2.new(0.5, 0, 1, -18)
    Pill.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Pill.BorderSizePixel = 0
    Pill.ClipsDescendants = false
    Pill.Active = true
    Pill.ZIndex = 40
    Pill.Parent = OverlayGui

    local PillCorner = Instance.new("UICorner")
    PillCorner.CornerRadius = UDim.new(0, 8)
    PillCorner.Parent = Pill

    local PillStroke = Instance.new("UIStroke")
    PillStroke.Color = Color3.fromRGB(255, 255, 255)
    PillStroke.Transparency = 0.55
    PillStroke.Thickness = 1
    PillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    PillStroke.Parent = Pill

    local PillLabel = Instance.new("TextLabel")
    PillLabel.Name = "PillLabel"
    PillLabel.Size = UDim2.new(1, -10, 1, 0)
    PillLabel.Position = UDim2.new(0, 5, 0, 0)
    PillLabel.BackgroundTransparency = 1
    PillLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    PillLabel.Text = current_curve_name()
    PillLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PillLabel.TextSize = 12
    PillLabel.TextXAlignment = Enum.TextXAlignment.Center
    PillLabel.ZIndex = 42
    PillLabel.Parent = Pill

    local OPTION_H = 32
    local POPUP_FULL_H = #curveNames * OPTION_H + 8

    local Popup = Instance.new("Frame")
    Popup.Name = "CurvePopup"
    Popup.Size = UDim2.new(0, 132, 0, POPUP_FULL_H)
    Popup.AnchorPoint = Vector2.new(0.5, 1)
    Popup.Position = UDim2.new(0.5, 0, 0, -6)
    Popup.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Popup.BackgroundTransparency = 1
    Popup.BorderSizePixel = 0
    Popup.ZIndex = 50
    Popup.Visible = false
    Popup.Parent = Pill

    local PopupCorner = Instance.new("UICorner")
    PopupCorner.CornerRadius = UDim.new(0, 8)
    PopupCorner.Parent = Popup

    local PopupStroke = Instance.new("UIStroke")
    PopupStroke.Color = Color3.fromRGB(255, 255, 255)
    PopupStroke.Transparency = 1
    PopupStroke.Thickness = 1
    PopupStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    PopupStroke.Parent = Popup

    local PopupPad = Instance.new("UIPadding")
    PopupPad.PaddingTop = UDim.new(0, 4)
    PopupPad.PaddingBottom = UDim.new(0, 4)
    PopupPad.Parent = Popup

    local PopupList = Instance.new("UIListLayout")
    PopupList.SortOrder = Enum.SortOrder.LayoutOrder
    PopupList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PopupList.Padding = UDim.new(0, 0)
    PopupList.Parent = Popup

    local popupOpen = false
    local tweening = false

    local function tweenPopupText(alpha, info)
        for _, d in ipairs(Popup:GetDescendants()) do
            if d:IsA("TextLabel") then
                TweenService:Create(d, info, { TextTransparency = alpha }):Play()
            end
        end
    end

    local function openPopup()
        if tweening then return end
        popupOpen = true
        tweening = true
        Popup.BackgroundTransparency = 1
        PopupStroke.Transparency = 1
        Popup.Position = UDim2.new(0.5, 0, 0, 6)
        Popup.Visible = true
        for _, d in ipairs(Popup:GetDescendants()) do
            if d:IsA("TextLabel") then
                d.TextTransparency = 1
            end
        end
        local t = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        TweenService:Create(Popup, t, { BackgroundTransparency = 0, Position = UDim2.new(0.5, 0, 0, -6) }):Play()
        TweenService:Create(PopupStroke, t, { Transparency = 0.55 }):Play()
        tweenPopupText(0, t)
        task.delay(0.22, function() tweening = false end)
    end

    local function closePopup()
        if not popupOpen or tweening then return end
        popupOpen = false
        tweening = true
        local t = TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        TweenService:Create(Popup, t, { BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0, 6) }):Play()
        TweenService:Create(PopupStroke, t, { Transparency = 1 }):Play()
        tweenPopupText(1, t)
        task.delay(0.18, function()
            Popup.Visible = false
            Popup.Position = UDim2.new(0.5, 0, 0, -6)
            tweening = false
        end)
    end

    for i, label in ipairs(curveNames) do
        local Opt = Instance.new("TextButton")
        Opt.Name = "CurveOpt"
        Opt.Size = UDim2.new(1, 0, 0, OPTION_H)
        Opt.BackgroundTransparency = 1
        Opt.BorderSizePixel = 0
        Opt.AutoButtonColor = false
        Opt.Text = ""
        Opt.LayoutOrder = i
        Opt.ZIndex = 46
        Opt.Parent = Popup

        local OptLabel = Instance.new("TextLabel")
        OptLabel.Name = "TextLabel"
        OptLabel.Size = UDim2.new(1, 0, 1, 0)
        OptLabel.BackgroundTransparency = 1
        OptLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        OptLabel.Text = label
        OptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptLabel.TextSize = 12
        OptLabel.TextXAlignment = Enum.TextXAlignment.Center
        OptLabel.ZIndex = 47
        OptLabel.Parent = Opt

        if i < #curveNames then
            local Sep = Instance.new("Frame")
            Sep.Size = UDim2.new(1, -24, 0, 1)
            Sep.Position = UDim2.new(0, 12, 1, -1)
            Sep.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Sep.BackgroundTransparency = 0.92
            Sep.BorderSizePixel = 0
            Sep.ZIndex = 46
            Sep.Parent = Opt
        end

        Opt.Activated:Connect(function()
            apply_curve_type(label)
            if mode_curve_dropdown and mode_curve_dropdown.update then
                pcall(function() mode_curve_dropdown:update(label) end)
            end
            PillLabel.Text = label
            closePopup()
        end)
    end

    local dragMoved = false
    local dragStart = nil
    local pillStartPos = nil

    local PillHit = Instance.new("TextButton")
    PillHit.Name = "PillHit"
    PillHit.Size = UDim2.new(1, 0, 1, 0)
    PillHit.BackgroundTransparency = 1
    PillHit.Text = ""
    PillHit.AutoButtonColor = false
    PillHit.ZIndex = 43
    PillHit.Parent = Pill

    PillHit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragMoved = false
            dragStart = input.Position
            pillStartPos = Pill.Position
        end
    end)

    CurveOverlayState.drag = UserInputService.InputChanged:Connect(function(input)
        if not dragStart then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local delta = input.Position - dragStart
        if not dragMoved and (math.abs(delta.X) > 6 or math.abs(delta.Y) > 6) then
            dragMoved = true
            if popupOpen then closePopup() end
        end
        if dragMoved and pillStartPos then
            Pill.Position = UDim2.new(pillStartPos.X.Scale, pillStartPos.X.Offset + delta.X, pillStartPos.Y.Scale, pillStartPos.Y.Offset + delta.Y)
        end
    end)

    CurveOverlayState.release = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if not dragStart then
            return
        end
        if not dragMoved then
            if popupOpen then
                closePopup()
            else
                openPopup()
            end
        end
        dragStart = nil
        dragMoved = false
    end)

    CurveOverlayState.gui = OverlayGui
    CurveOverlayState.frame = Pill
end

autoparry_module:create_checkbox({
    title = "Mobile Curve",
    flag = "MobileCurve",
    callback = function(value)
        getgenv().MobileCurve = toggle_state(value)
        if getgenv().MobileCurve then
            create_curve_overlay()
            if CurveOverlayState.frame then
                CurveOverlayState.frame.Visible = true
            end
        else
            destroy_curve_overlay()
        end
    end
})


do
    local triggerbot = {
        enabled = false,
        is_parrying = false,
        connection = nil,
        mobile = nil,
    }
    getgenv()._VanishTriggerbot = triggerbot

    local function triggerbot_process()
        if not triggerbot.enabled then
            return
        end
        if AbilityDetect.has_singularity_cape and AbilityDetect.has_singularity_cape() then
            return
        end
        if triggerbot.is_parrying then
            return
        end
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then
            return
        end
        local entries = System.ball.get_targeted()
        if not entries or #entries == 0 then
            return
        end
        local root_pos = root.Position
        table.sort(entries, function(a, b)
            local pa = a and a.part
            local pb = b and b.part
            if not pa then
                return false
            end
            if not pb then
                return true
            end
            return (pa.Position - root_pos).Magnitude < (pb.Position - root_pos).Magnitude
        end)
        for _, entry in ipairs(entries) do
            local part = entry and entry.part
            if not part then
                continue
            end
            local velocity = System.ball.get_velocity(part, entry.model)
            local speed = velocity.Magnitude
            local distance = (part.Position - root_pos).Magnitude
            if distance > get_premium_parry_distance(speed, System.__properties.__accuracy) then
                continue
            end
            triggerbot.is_parrying = true
            if System.animation and System.animation.play_grab_parry then
                task.spawn(function()
                    pcall(System.animation.play_grab_parry)
                end)
            end
            fire_combat_parry(nil, false)
            local watch = entry.model or part
            local conn
            conn = watch:GetAttributeChangedSignal("target"):Connect(function()
                if not System.ball.is_targeting_me(entry) then
                    triggerbot.is_parrying = false
                    if conn then
                        conn:Disconnect()
                        conn = nil
                    end
                end
            end)
            local started = tick()
            task.spawn(function()
                repeat
                    RunService.Heartbeat:Wait()
                until (tick() - started) >= 1 or not triggerbot.is_parrying
                triggerbot.is_parrying = false
                if conn then
                    pcall(function()
                        conn:Disconnect()
                    end)
                    conn = nil
                end
            end)
            break
        end
    end

    local function triggerbot_set(state)
        triggerbot.enabled = state == true
        getgenv()._VanishTriggerbotEnabled = triggerbot.enabled
        if triggerbot.enabled then
            if not triggerbot.connection then
                triggerbot.connection = RunService.Heartbeat:Connect(triggerbot_process)
            end
        else
            if triggerbot.connection then
                pcall(function()
                    triggerbot.connection:Disconnect()
                end)
                triggerbot.connection = nil
            end
            triggerbot.is_parrying = false
        end
    end

    getgenv()._VanishTriggerbotSet = triggerbot_set
    getgenv()._VanishTriggerbotStop = function()
        triggerbot_set(false)
        if triggerbot.mobile and triggerbot.mobile.gui then
            pcall(function()
                triggerbot.mobile.gui:Destroy()
            end)
            triggerbot.mobile = nil
        end
    end

    CombatTab:create_module({
        title = "Triggerbot",
        description = "fires when ball targets you",
        flag = "TriggerbotModule",
        section = "left",
        callback = function(state)
            state = toggle_state(state)
            local is_mobile = System and System.__properties and System.__properties.__is_mobile
            if is_mobile then
                if state then
                    if not triggerbot.mobile then
                        local gui_data = create_mobile_button("Trigger", 0.7, Color3.fromRGB(255, 100, 0))
                        triggerbot.mobile = gui_data
                        local touch_t = 0
                        local dragged = false
                        gui_data.button.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch then
                                touch_t = tick()
                                dragged = false
                            end
                        end)
                        gui_data.button.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch and tick() - touch_t > 0.15 then
                                dragged = true
                            end
                        end)
                        gui_data.button.InputEnded:Connect(function(input)
                            if input.UserInputType ~= Enum.UserInputType.Touch or dragged then
                                return
                            end
                            local on = not triggerbot.enabled
                            triggerbot_set(on)
                            gui_data.text.Text = on and "ON" or "Trigger"
                            gui_data.text.TextColor3 = on and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(235, 235, 245)
                        end)
                    end
                else
                    triggerbot_set(false)
                    if triggerbot.mobile and triggerbot.mobile.gui then
                        pcall(function()
                            triggerbot.mobile.gui:Destroy()
                        end)
                        triggerbot.mobile = nil
                    end
                end
            else
                triggerbot_set(state)
            end
        end
    })
end

local auto_spam_module = CombatTab:create_module({
    title = "Auto Spam",
    description = "Automatically spams parries",
    flag = "AutoSpamModule",
    section = "right",
    callback = function(state)
        state = toggle_state(state)
        if System and System.auto_spam then
            System.__properties.__auto_spam_enabled = state
            if state then
                if System.auto_spam and System.auto_spam.start then pcall(System.auto_spam.start) end
                if System.__properties.__is_mobile and not System.__properties.__mobile_guis.autospam then
                    local success, autospam_mobile = pcall(function()
                        return create_mobile_button('AutoSpam', 0.78, Color3.fromRGB(150, 255, 150))
                    end)
                    if success and autospam_mobile then
                        System.__properties.__mobile_guis.autospam = autospam_mobile

                        local touch_start = 0
                        local was_dragged = false

                        autospam_mobile.button.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch then
                                touch_start = tick()
                                was_dragged = false
                            end
                        end)

                        autospam_mobile.button.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch then
                                if (tick() - touch_start) > 0.1 then
                                    was_dragged = true
                                end
                            end
                        end)

                        autospam_mobile.button.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Touch and not was_dragged then
                                if System then
                                    System.__properties.__auto_spam_enabled = not System.__properties.__auto_spam_enabled
                                    if System.auto_spam and System.auto_spam.start and System.auto_spam.stop then
                                        if System.__properties.__auto_spam_enabled then
                                            pcall(System.auto_spam.start)
                                        else
                                            pcall(System.auto_spam.stop)
                                        end
                                    end
                                end

                                if System and System.__properties and System.__properties.__auto_spam_enabled then
                                    autospam_mobile.text.Text = "ON"
                                    autospam_mobile.text.TextColor3 = Color3.fromRGB(150, 255, 150)
                                else
                                    autospam_mobile.text.Text = "AutoSpam"
                                    autospam_mobile.text.TextColor3 = Color3.fromRGB(255, 255, 255)
                                end
                            end
                        end)
                    end
                end
            else
                if System.auto_spam and System.auto_spam.stop then pcall(System.auto_spam.stop) end
                if System.__properties.__mobile_guis.autospam then
                    destroy_mobile_gui(System.__properties.__mobile_guis.autospam)
                    System.__properties.__mobile_guis.autospam = nil
                end
            end
        end
    end
})

auto_spam_module:create_checkbox({
    title = "Animation Fix",
    flag = "AutoSpamAnimationFix",
    callback = function(value)
        getgenv().AutoSpamAnimationFix = toggle_state(value)
    end
})

auto_spam_module:create_slider({
    title = "Spam Threshold",
    flag = "ParryThreshold",
    maximum_value = 10,
    minimum_value = 0,
    value = 1.5,
    round_number = false,
    callback = function(value)
        if System then System.__properties.__spam_threshold = value end
    end
})

auto_spam_module:create_slider({
    title = "Distance Multiplier",
    flag = "DistanceMultiplier",
    maximum_value = 3,
    minimum_value = 0.3,
    value = 1,
    round_number = false,
    callback = function(value)
        if System then
            System.__properties.__auto_spam_distance_multiplier = value
            System.__properties.__spam_sensitivity = value
        end
    end
})


local function sync_manual_spam_button(active)
    local ui = System.__properties.__manual_spam_ui
    if not ui then return end
    if ui.button then
        ui.button.Text = active and "ON" or "OFF"
    end
    if ui.update_colors then
        ui.update_colors(active)
    end
    ui.active = active == true
end

local function set_manual_spam_running(active)
    if active then
        if System.manual_spam and System.manual_spam.start then pcall(System.manual_spam.start) end
    else
        if System.manual_spam and System.manual_spam.stop then pcall(System.manual_spam.stop) end
    end
    sync_manual_spam_button(active)
end

local manual_spam_module = CombatTab:create_module({
    title = "Manual Spam",
    description = "Manually spam parries",
    flag = "ManualSpamModule",
    section = "right",
    callback = function(state)
        if not System or not System.manual_spam then return end
        state = toggle_state(state)
        getgenv().ManualSpamModuleEnabled = state
        if state then
            if not System.__properties.__manual_spam_ui_created then
                    local ScreenGui = Instance.new("ScreenGui")
                    ScreenGui.Name = "ManualSpamPanel"
                    ScreenGui.ResetOnSpawn = false
                    ScreenGui.IgnoreGuiInset = true
                    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    ScreenGui.DisplayOrder = 10
                    pcall(function()
                        local protect = protect_gui or protectgui or (syn and syn.protect_gui)
                        if protect then protect(ScreenGui) end
                    end)
                    pcall(function()
                        if typeof(gethui) == "function" then
                            ScreenGui.Parent = gethui()
                        end
                    end)
                    if not ScreenGui.Parent then
                        pcall(function() ScreenGui.Parent = CoreGui end)
                    end
                    if getgenv()._VanishGuis then
                        table.insert(getgenv()._VanishGuis, ScreenGui)
                    end

                    local SpamFrame = Instance.new("Frame", ScreenGui)
                    SpamFrame.Size = UDim2.new(0, 150, 0, 80)
                    SpamFrame.Position = UDim2.new(1, -170, 1, -120)
                    SpamFrame.Active = true
                    SpamFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    SpamFrame.BackgroundTransparency = 0
                    SpamFrame.Visible = true
                    SpamFrame.Name = "SpamFrame"

                    Instance.new("UICorner", SpamFrame).CornerRadius = UDim.new(0, 12)
                    local SpamStroke = Instance.new("UIStroke", SpamFrame)
                    SpamStroke.Color = Color3.new(1, 1, 1)
                    SpamStroke.Thickness = 2

                    local SpamTitleLbl = Instance.new("TextLabel", SpamFrame)
                    SpamTitleLbl.Size = UDim2.new(1, 0, 0, 25)
                    SpamTitleLbl.Text = "Manual Spam"
                    SpamTitleLbl.TextColor3 = Color3.new(1, 1, 1)
                    SpamTitleLbl.BackgroundTransparency = 1
                    SpamTitleLbl.Font = Enum.Font.GothamBold
                    SpamTitleLbl.TextSize = 12

                    local SpamToggleBtn = Instance.new("TextButton", SpamFrame)
                    SpamToggleBtn.Size = UDim2.new(0.85, 0, 0, 35)
                    SpamToggleBtn.Position = UDim2.new(0.075, 0, 0, 35)
                    SpamToggleBtn.Text = "OFF"
                    SpamToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    SpamToggleBtn.TextColor3 = Color3.new(1, 1, 1)
                    SpamToggleBtn.Font = Enum.Font.GothamBold
                    SpamToggleBtn.TextSize = 13
                    Instance.new("UICorner", SpamToggleBtn).CornerRadius = UDim.new(0, 8)

                    local dragging = false
                    local dragInput = nil
                    local dragStart = nil
                    local startPos = nil

                    local function update(input)
                        local delta = input.Position - dragStart
                        SpamFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    end

                    SpamTitleLbl.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            dragStart = input.Position
                            startPos = SpamFrame.Position

                            input.Changed:Connect(function()
                                if input.UserInputState == Enum.UserInputState.End then
                                    dragging = false
                                end
                            end)
                        end
                    end)

                    SpamTitleLbl.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            dragInput = input
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if input == dragInput and dragging then
                            update(input)
                        end
                    end)

                    local function UpdateSpamColors(active)
                        if active then
                            SpamFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                            SpamFrame.BackgroundTransparency = 0
                            SpamStroke.Color = Color3.new(1, 1, 1)
                            SpamTitleLbl.TextColor3 = Color3.new(1, 1, 1)
                            SpamToggleBtn.TextColor3 = Color3.new(0, 0, 0)
                            SpamToggleBtn.BackgroundColor3 = Color3.new(1, 1, 1)
                        else
                            SpamFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            SpamFrame.BackgroundTransparency = 0
                            SpamStroke.Color = Color3.new(1, 1, 1)
                            SpamTitleLbl.TextColor3 = Color3.new(1, 1, 1)
                            SpamToggleBtn.TextColor3 = Color3.new(1, 1, 1)
                            SpamToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        end
                    end

                    SpamToggleBtn.MouseButton1Click:Connect(function()
                        local running = not (System.__properties.__manual_spam_enabled == true)
                        set_manual_spam_running(running)
                        if section_notify_on("ManualSpamModule") then
                            Notify({ title = "Manual Spam", text = running and "ON" or "OFF", duration = 2 })
                        end
                    end)

                    System.__properties.__manual_spam_ui = {
                        gui = ScreenGui,
                        frame = SpamFrame,
                        button = SpamToggleBtn,
                        title = SpamTitleLbl,
                        update_colors = UpdateSpamColors,
                        active = false
                    }
                    System.__properties.__manual_spam_ui_created = true
                    UpdateSpamColors(false)
                end
            else
                set_manual_spam_running(false)
                if System.__properties.__manual_spam_ui and System.__properties.__manual_spam_ui.gui then
                    pcall(function() System.__properties.__manual_spam_ui.gui:Destroy() end)
                    System.__properties.__manual_spam_ui = nil
                    System.__properties.__manual_spam_ui_created = false
                end
            end
    end
})

manual_spam_module:create_checkbox({
    title = "Animation Fix",
    flag = "ManualSpamAnimationFix",
    callback = function(value)
        getgenv().ManualSpamAnimationFix = toggle_state(value)
    end
})


local detections_module = CombatTab:create_module({
    title = "Ability Detection",
    description = "Skips auto parry while active",
    flag = "DetectionsModule",
    section = "left",
    callback = function(state)
        getgenv().DetectionsEnabled = toggle_state(state)
    end
})

detections_module:create_checkbox({
    title = "Infinity",
    flag = "InfinityDetection",
    callback = function(value)
        getgenv().InfinityDetection = toggle_state(value)
    end
})

detections_module:create_checkbox({
    title = "Death Slash",
    flag = "DeathSlashDetection",
    callback = function(value)
        getgenv().DeathSlashDetection = toggle_state(value)
    end
})

detections_module:create_checkbox({
    title = "Forcefield",
    flag = "ForcefieldDetection",
    callback = function(value)
        getgenv().ForcefieldDetection = toggle_state(value)
    end
})

detections_module:create_checkbox({
    title = "Singularity",
    flag = "SingularityDetection",
    callback = function(value)
        getgenv().SingularityDetection = toggle_state(value)
    end
})

detections_module:create_checkbox({
    title = "Slash of Fury",
    flag = "SlashOfFuryDetection",
    callback = function(value)
        getgenv().SlashOfFuryDetection = toggle_state(value)
    end
})

detections_module:create_checkbox({
    title = "Time Hole",
    flag = "TimeHoleDetection",
    callback = function(value)
        getgenv().TimeHoleDetection = toggle_state(value)
    end
})

detections_module:create_checkbox({
    title = "Pulse",
    flag = "PulsedDetection",
    callback = function(value)
        getgenv().PulsedDetection = toggle_state(value)
    end
})

detections_module:create_checkbox({
    title = "Slash of Duality",
    flag = "DualityDetection",
    callback = function(value)
        getgenv().DualityDetection = toggle_state(value)
    end
})


getgenv().ShowPlatformESP = getgenv().ShowPlatformESP or false
getgenv().AbilityVisualizer = getgenv().AbilityVisualizer or false
getgenv().AbilityESPShowCooldown = getgenv().AbilityESPShowCooldown or false

local ability_esp
do
    ability_esp = {
        active = false,
        labels = {},
        conns = {},
        nameTagState = {},
        cdWatch = {},
        abilityData = {},
    }
    local PINK_A = Color3.fromRGB(255, 210, 230)
    local PINK_B = Color3.fromRGB(255, 105, 180)
    local DARK_BLUE_A = Color3.fromRGB(90, 150, 230)
    local DARK_BLUE_B = Color3.fromRGB(20, 55, 130)
    local GRAY_A = Color3.fromRGB(200, 200, 200)
    local GRAY_B = Color3.fromRGB(130, 130, 130)

    local OS_PLATFORM_MAP = {
        [0] = "PC",
        [1] = "PC",
        [2] = "Mobile",
        [3] = "Mobile",
        [4] = "Console",
        [5] = "Console",
        [6] = "PC",
        [7] = "Mobile",
        [8] = "PC",
        [9] = "Console",
        [10] = "Console",
        [11] = "Mobile",
        [12] = "Console",
    }

    local function readPlayerProp(player, name)
        local value
        if gethiddenproperty then
            pcall(function() value = gethiddenproperty(player, name) end)
        end
        if value == nil then
            pcall(function() value = player[name] end)
        end
        if value == nil then
            pcall(function() value = player:GetAttribute(name) end)
        end
        return value
    end

    local function platformFromValue(value)
        if value == nil then return nil end
        if typeof(value) == "EnumItem" then
            value = value.Name
        end
        if type(value) == "number" then
            return OS_PLATFORM_MAP[value]
        end
        local str = tostring(value):lower()
        str = str:gsub("^enum%.platform%.", "")
        str = str:gsub("^platform%.", "")
        local asNumber = tonumber(str)
        if asNumber ~= nil and OS_PLATFORM_MAP[asNumber] then
            return OS_PLATFORM_MAP[asNumber]
        end
        if str:find("android", 1, true) or str:find("ios", 1, true) or str:find("iphone", 1, true) or str:find("ipad", 1, true) or str:find("chromeos", 1, true) or str:find("mobile", 1, true) or str:find("touch", 1, true) then
            return "Mobile"
        end
        if str:find("xbox", 1, true) or str:find("durango", 1, true) or str:find("scarlett", 1, true) or str:find("ps4", 1, true) or str:find("ps5", 1, true) or str:find("playstation", 1, true) or str:find("orbis", 1, true) or str:find("prospero", 1, true) or str:find("console", 1, true) or str:find("gamepad", 1, true) then
            return "Console"
        end
        if str:find("windows", 1, true) or str:find("osx", 1, true) or str:find("mac", 1, true) or str:find("linux", 1, true) or str:find("uwp", 1, true) or str:find("win32", 1, true) or str:find("pc", 1, true) or str:find("desktop", 1, true) or str:find("keyboard", 1, true) then
            return "PC"
        end
        return nil
    end

    local platformCache = {}
    local abilityIconCache = {}
    local abilityModuleIndex = nil
    local abilitiesFolderRef = nil

    local function toAbilityAsset(id)
        if type(id) == "number" and id > 0 then
            return "rbxassetid://" .. tostring(id)
        end
        if type(id) ~= "string" or id == "" then
            return ""
        end
        if string.find(id, "rbxasset", 1, true) or string.find(id, "http", 1, true) then
            return id
        end
        local num = tonumber(id)
        if num and num > 0 then
            return "rbxassetid://" .. tostring(num)
        end
        return ""
    end

    local function extractAbilityIcon(data, inst)
        if type(data) == "table" then
            local keys = {
                "iconId", "IconId", "icon", "Icon", "imageId", "ImageId", "Image",
                "abilityIcon", "AbilityIcon", "IconImage", "iconImage", "ImageIdString"
            }
            for i = 1, #keys do
                local asset = toAbilityAsset(data[keys[i]])
                if asset ~= "" then
                    return asset
                end
            end
        end
        if inst then
            local props = { "iconId", "IconId", "Image", "Texture", "TextureId" }
            for i = 1, #props do
                local value
                pcall(function() value = inst:GetAttribute(props[i]) end)
                local asset = toAbilityAsset(value)
                if asset ~= "" then
                    return asset
                end
            end
            local img = inst:FindFirstChildWhichIsA("ImageLabel", true) or inst:FindFirstChildWhichIsA("ImageButton", true)
            if img and type(img.Image) == "string" and img.Image ~= "" then
                return img.Image
            end
        end
        return ""
    end

    local function getAbilitiesFolder()
        if abilitiesFolderRef and abilitiesFolderRef.Parent then
            return abilitiesFolderRef
        end
        local shared = ReplicatedStorage:FindFirstChild("Shared")
        abilitiesFolderRef = (shared and (shared:FindFirstChild("Abilities") or shared:FindFirstChild("Ability")))
            or ReplicatedStorage:FindFirstChild("Abilities")
            or ReplicatedStorage:FindFirstChild("AbilityModules")
        return abilitiesFolderRef
    end

    local function indexAbilityModules()
        if abilityModuleIndex then
            return abilityModuleIndex
        end
        abilityModuleIndex = {}
        local folder = getAbilitiesFolder()
        if not folder then
            return abilityModuleIndex
        end
        local function addModule(child)
            if not child then return end
            abilityModuleIndex[child.Name] = child
            abilityModuleIndex[string.lower(child.Name)] = child
            abilityModuleIndex[string.lower((child.Name:gsub("%s+", "")))] = child
        end
        for _, child in ipairs(folder:GetChildren()) do
            addModule(child)
        end
        folder.ChildAdded:Connect(function(child)
            addModule(child)
            abilityIconCache[child.Name] = nil
        end)
        return abilityModuleIndex
    end

    local function findAbilityModule(abilityName)
        local index = indexAbilityModules()
        if index[abilityName] then
            return index[abilityName]
        end
        local lower = string.lower(abilityName)
        if index[lower] then
            return index[lower]
        end
        local compact = string.lower((abilityName:gsub("%s+", "")))
        if index[compact] then
            return index[compact]
        end
        for name, module in pairs(index) do
            if type(name) == "string" and string.find(string.lower(name), compact, 1, true) then
                return module
            end
        end
        return nil
    end

    local function getAbilityIcon(abilityName)
        if type(abilityName) ~= "string" or abilityName == "" then
            return ""
        end
        if abilityIconCache[abilityName] then
            return abilityIconCache[abilityName]
        end
        local icon = ""
        pcall(function()
            local module = findAbilityModule(abilityName)
            if module then
                icon = extractAbilityIcon(nil, module)
                if icon == "" and (module:IsA("ModuleScript") or module.ClassName == "ModuleScript") then
                    local ok, data = pcall(require, module)
                    if ok then
                        icon = extractAbilityIcon(data, module)
                    end
                end
            end
            if icon == "" then
                local folder = getAbilitiesFolder()
                if folder then
                    for _, child in ipairs(folder:GetChildren()) do
                        if string.lower(child.Name) == string.lower(abilityName) then
                            if child:IsA("ModuleScript") then
                                local ok, data = pcall(require, child)
                                if ok then
                                    icon = extractAbilityIcon(data, child)
                                end
                            end
                            if icon == "" then
                                icon = extractAbilityIcon(nil, child)
                            end
                            break
                        end
                    end
                end
            end
        end)
        if icon ~= "" then
            abilityIconCache[abilityName] = icon
        end
        return icon
    end

    local function getAbilityModuleData(abilityName)
        if type(abilityName) ~= "string" or abilityName == "" then
            return nil
        end
        local cached = ability_esp.abilityData[abilityName]
        if cached ~= nil then
            return cached or nil
        end
        local data = nil
        pcall(function()
            local module = findAbilityModule(abilityName)
            if module and module:IsA("ModuleScript") then
                local ok, result = pcall(require, module)
                if ok and type(result) == "table" then
                    data = result
                end
            end
        end)
        ability_esp.abilityData[abilityName] = data or false
        return data
    end

    local function getUpgradeLevel(player, abilityName)
        local level = 0
        pcall(function()
            local upgrades = player:FindFirstChild("Upgrades")
            local value = upgrades and upgrades:FindFirstChild(abilityName)
            if value and type(value.Value) == "number" then
                level = value.Value
            end
        end)
        return level
    end

    local function abilityCooldownLength(player, abilityName)
        local info = getAbilityModuleData(abilityName)
        if not info or type(info.cooldown) ~= "number" then
            return 0
        end
        local level = getUpgradeLevel(player, abilityName)
        return math.max(0, info.cooldown - (info.cooldownReductionPerUpgrade or 0) * level)
    end

    local function clearCdWatch(player)
        local list = ability_esp.cdWatch[player]
        if not list then
            return
        end
        for _, conn in ipairs(list) do
            pcall(function()
                conn:Disconnect()
            end)
        end
        ability_esp.cdWatch[player] = nil
    end

    local function beginAbilityCooldown(player, data, abilityName)
        if not data then
            return
        end
        local length = abilityCooldownLength(player, abilityName)
        if length > 0 then
            data.cdStart = tick()
            data.cdLen = length
        else
            data.cdStart = nil
            data.cdLen = nil
        end
    end

    local EQUIP_ATTRS = {
        "CurrentlyEquippedAbility",
        "EquippedAbility",
        "Ability",
        "CurrentAbility",
        "SelectedAbility",
        "AbilityName",
        "EquippedAbilityName"
    }

    local function getEquippedAbility(player)
        for i = 1, #EQUIP_ATTRS do
            local ab = player:GetAttribute(EQUIP_ATTRS[i])
            if type(ab) == "string" and ab ~= "" and ab ~= "None" then
                return ab
            end
        end
        local char = player.Character
        if char then
            for i = 1, #EQUIP_ATTRS do
                local ab = char:GetAttribute(EQUIP_ATTRS[i])
                if type(ab) == "string" and ab ~= "" and ab ~= "None" then
                    return ab
                end
            end
            local abilities = char:FindFirstChild("Abilities")
            if abilities then
                local enabledName
                for _, child in ipairs(abilities:GetChildren()) do
                    local on = false
                    pcall(function()
                        on = child.Enabled == true
                    end)
                    if not on then
                        pcall(function()
                            on = child:GetAttribute("Enabled") == true or child:GetAttribute("Equipped") == true
                        end)
                    end
                    if on then
                        enabledName = child.Name
                        break
                    end
                end
                if enabledName and enabledName ~= "" then
                    return enabledName
                end
            end
        end
        return ""
    end

    local function watchAbilityCooldown(player, data)
        clearCdWatch(player)
        local list = {}
        ability_esp.cdWatch[player] = list
        local char = player.Character
        if char then
            table.insert(list, char.AttributeChanged:Connect(function(attr)
                local live = ability_esp.labels[player]
                if not live then
                    return
                end
                local equipped = getEquippedAbility(player)
                if attr == "AbilityUpgrade" and char:GetAttribute("AbilityUpgrade") ~= nil and equipped ~= "" and equipped ~= "Dribble" then
                    beginAbilityCooldown(player, live, equipped)
                elseif attr == "DribbleDebounce" and char:GetAttribute("DribbleDebounce") == true and equipped == "Dribble" then
                    beginAbilityCooldown(player, live, "Dribble")
                end
            end))
        end
        table.insert(list, player.AttributeChanged:Connect(function(attr)
            if attr ~= "CurrentlyEquippedAbility" and attr ~= "EquippedAbility" then
                return
            end
            local live = ability_esp.labels[player]
            if not live then
                return
            end
            live.cdStart = nil
            live.cdLen = nil
        end))
    end

    local function getPlayerPlatform(p)
        if not p then return "PC" end
        local cached = platformCache[p]
        if cached and (tick() - cached.time) < 8 then
            return cached.label
        end

        local label
        if p == LocalPlayer then
            local gamepad = UserInputService.GamepadEnabled
            local keyboard = UserInputService.KeyboardEnabled
            local mouse = UserInputService.MouseEnabled
            local touch = UserInputService.TouchEnabled
            if gamepad and not keyboard and not mouse then
                label = "Console"
            elseif touch and not keyboard and not mouse then
                label = "Mobile"
            else
                label = platformFromValue(readPlayerProp(p, "OsPlatform")) or "PC"
            end
        end

        if not label then
            local props = { "OsPlatform", "DevicePlatform", "Platform", "ClientOsPlatform" }
            for i = 1, #props do
                label = platformFromValue(readPlayerProp(p, props[i]))
                if label then break end
            end
        end

        if not label then
            local attrs = { "OsPlatform", "DevicePlatform", "Platform", "Device", "DeviceType", "InputType", "LastInputType" }
            for i = 1, #attrs do
                label = platformFromValue(p:GetAttribute(attrs[i]))
                if label then break end
            end
        end

        if not label then
            local pg = p:FindFirstChild("PlayerGui")
            if pg and (pg:FindFirstChild("TouchGui") or pg:FindFirstChild("MobileControls") or pg:FindFirstChild("ControlGui")) then
                label = "Mobile"
            end
        end

        label = label or "PC"
        platformCache[p] = { label = label, time = tick() }
        return label
    end

    local function hideDefaultNameTag(player, char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if ability_esp.nameTagState[player] == nil then ability_esp.nameTagState[player] = hum.DisplayDistanceType end
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        hum.NameDisplayDistance = 0
        hum.HealthDisplayDistance = 0
    end

    local function restoreDefaultNameTag(player, char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local original = ability_esp.nameTagState[player]
        if hum and original ~= nil then hum.DisplayDistanceType = original end
        ability_esp.nameTagState[player] = nil
    end

    local function restoreAllDefaultNameTags()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                restoreDefaultNameTag(player, player.Character)
            end
        end
        ability_esp.nameTagState = {}
    end

    local function addTextGradient(label, c1, c2)
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2) })
        g.Rotation = 0
        g.Parent = label
        return g
    end

    local function makeEsp(player)
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        if not head then return end
        hideDefaultNameTag(player, char)
        local old = head:FindFirstChild("AbilityESPGui")
        if old then old:Destroy() end
        local bg = Instance.new("BillboardGui")
        bg.Name = "AbilityESPGui"
        bg.Size = UDim2.new(0, 260, 0, 28)
        bg.StudsOffset = Vector3.new(0, 3, 0)
        bg.AlwaysOnTop = true
        bg.Adornee = head
        bg.Parent = head

        local stack = Instance.new("Frame")
        stack.Size = UDim2.fromScale(1, 1)
        stack.BackgroundTransparency = 1
        stack.Parent = bg
        local stackLayout = Instance.new("UIListLayout")
        stackLayout.FillDirection = Enum.FillDirection.Vertical
        stackLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        stackLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        stackLayout.SortOrder = Enum.SortOrder.LayoutOrder
        stackLayout.Padding = UDim.new(0, 2)
        stackLayout.Parent = stack

        local abIcon = Instance.new("ImageLabel")
        abIcon.Name = "AbilityIcon"
        abIcon.Size = UDim2.fromOffset(32, 32)
        abIcon.BackgroundTransparency = 1
        abIcon.BorderSizePixel = 0
        abIcon.ScaleType = Enum.ScaleType.Fit
        abIcon.Visible = false
        abIcon.LayoutOrder = 0
        abIcon.Parent = stack

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1
        row.LayoutOrder = 1
        row.Parent = stack
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 2)
        layout.Parent = row

        local function makeAbPart(text, order, c1, c2, prnt)
            local lbl = Instance.new("TextLabel")
            lbl.AutomaticSize = Enum.AutomaticSize.X
            lbl.Size = UDim2.new(0, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 14
            lbl.TextColor3 = Color3.new(1, 1, 1)
            lbl.TextStrokeTransparency = 0.45
            lbl.Text = text
            lbl.LayoutOrder = order
            lbl.Parent = prnt
            if c1 and c2 then addTextGradient(lbl, c1, c2) end
            return lbl
        end

        local platformWrap = Instance.new("Frame")
        platformWrap.Name = "Platform"
        platformWrap.AutomaticSize = Enum.AutomaticSize.X
        platformWrap.Size = UDim2.new(0, 0, 1, 0)
        platformWrap.BackgroundTransparency = 1
        platformWrap.LayoutOrder = 0
        platformWrap.Visible = false
        platformWrap.Parent = row
        local platLayout = Instance.new("UIListLayout")
        platLayout.FillDirection = Enum.FillDirection.Horizontal
        platLayout.SortOrder = Enum.SortOrder.LayoutOrder
        platLayout.Parent = platformWrap

        makeAbPart("[", 1, GRAY_A, GRAY_B, platformWrap)
        local platName = makeAbPart(getPlayerPlatform(player), 2, GRAY_A, GRAY_B, platformWrap)
        makeAbPart("] ", 3, GRAY_A, GRAY_B, platformWrap)

        local nameLbl = makeAbPart(player.DisplayName, 1, PINK_A, PINK_B, row)

        local abWrap = Instance.new("Frame")
        abWrap.Name = "Ability"
        abWrap.AutomaticSize = Enum.AutomaticSize.X
        abWrap.Size = UDim2.new(0, 0, 1, 0)
        abWrap.BackgroundTransparency = 1
        abWrap.LayoutOrder = 2
        abWrap.Visible = false
        abWrap.Parent = row
        local abLayout = Instance.new("UIListLayout")
        abLayout.FillDirection = Enum.FillDirection.Horizontal
        abLayout.SortOrder = Enum.SortOrder.LayoutOrder
        abLayout.Parent = abWrap

        makeAbPart(" [", 1, PINK_A, PINK_B, abWrap)
        local abName = makeAbPart("", 2, DARK_BLUE_A, DARK_BLUE_B, abWrap)
        makeAbPart("]", 3, PINK_A, PINK_B, abWrap)

        local cdLbl = Instance.new("TextLabel")
        cdLbl.Name = "Cooldown"
        cdLbl.AutomaticSize = Enum.AutomaticSize.X
        cdLbl.Size = UDim2.new(0, 0, 0, 14)
        cdLbl.BackgroundTransparency = 1
        cdLbl.Font = Enum.Font.GothamBold
        cdLbl.TextSize = 13
        cdLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
        cdLbl.TextStrokeTransparency = 0.45
        cdLbl.Text = "Ready"
        cdLbl.Visible = false
        cdLbl.LayoutOrder = 2
        cdLbl.Parent = stack

        ability_esp.labels[player] = {
            gui = bg,
            icon = abIcon,
            name = nameLbl,
            abilityWrap = abWrap,
            abilityName = abName,
            cooldown = cdLbl,
            platformWrap = platformWrap,
            platName = platName,
            player = player,
            cdStart = nil,
            cdLen = nil,
        }
        watchAbilityCooldown(player, ability_esp.labels[player])
    end

    local function refreshEsp()
        for player, data in pairs(ability_esp.labels) do
            local char = player.Character
            if player.Parent and char then hideDefaultNameTag(player, char) end
            if player.Parent and data and data.name and data.name.Parent then
                data.name.Text = player.DisplayName
                if data.platName and data.platName.Parent then
                    data.platName.Text = getPlayerPlatform(player)
                end
                local ab = getEquippedAbility(player)
                local showIconMode = getgenv().AbilityVisualizer == true
                if ab ~= "" and not showIconMode then
                    data.abilityName.Text = ab
                    data.abilityWrap.Visible = true
                else
                    data.abilityName.Text = ""
                    data.abilityWrap.Visible = false
                end
                data.platformWrap.Visible = getgenv().ShowPlatformESP and true or false
                local showIcon = false
                if data.icon then
                    showIcon = getgenv().AbilityVisualizer == true and ab ~= ""
                    if showIcon then
                        data.icon.Image = getAbilityIcon(ab)
                        data.icon.Visible = data.icon.Image ~= ""
                    else
                        data.icon.Visible = false
                    end
                end
                local showCd = getgenv().AbilityESPShowCooldown == true and ab ~= ""
                if data.cooldown then
                    data.cooldown.Visible = showCd
                    if showCd then
                        local remain = 0
                        if data.cdStart and data.cdLen then
                            remain = math.max(0, data.cdLen - (tick() - data.cdStart))
                            if remain <= 0 then
                                data.cdStart = nil
                                data.cdLen = nil
                                remain = 0
                            end
                        end
                        if remain > 0 then
                            data.cooldown.Text = string.format("cd  %.1fs", remain)
                            data.cooldown.TextColor3 = Color3.fromRGB(180, 180, 180)
                        else
                            data.cooldown.Text = "Ready"
                            data.cooldown.TextColor3 = Color3.fromRGB(100, 255, 150)
                        end
                    end
                end
                if data.gui then
                    local height = 28
                    if showIcon then
                        height = height + 34
                    end
                    if showCd then
                        height = height + 16
                    end
                    data.gui.Size = UDim2.new(0, 260, 0, height)
                    data.gui.StudsOffset = Vector3.new(0, (showIcon or showCd) and 3.2 or 3, 0)
                end
            end
        end
    end

    function ability_esp.start()
        if ability_esp.active then return end
        ability_esp.active = true
        getgenv().AbilityESP = true
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                ability_esp.conns[p] = p.CharacterAdded:Connect(function()
                    task.wait(0.2)
                    if ability_esp.active then makeEsp(p) end
                end)
                if p.Character then makeEsp(p) end
            end
        end
        ability_esp.added = Players.PlayerAdded:Connect(function(p)
            if p == LocalPlayer or not ability_esp.active then return end
            ability_esp.conns[p] = p.CharacterAdded:Connect(function()
                task.wait(0.2)
                if ability_esp.active then makeEsp(p) end
            end)
            if p.Character then makeEsp(p) end
        end)
        task.spawn(function()
            while ability_esp.active and getgenv()._VanishAlive ~= false do
                refreshEsp()
                if getgenv().AbilityESPShowCooldown == true then
                    task.wait(0.1)
                else
                    task.wait(UserInputService.TouchEnabled and 1 or 0.6)
                end
            end
        end)
    end

    function ability_esp.stop()
        ability_esp.active = false
        getgenv().AbilityESP = false
        if ability_esp.added then
            ability_esp.added:Disconnect()
            ability_esp.added = nil
        end
        for p, c in pairs(ability_esp.conns) do c:Disconnect(); ability_esp.conns[p] = nil end
        for p, data in pairs(ability_esp.labels) do
            clearCdWatch(p)
            if data and data.gui then data.gui:Destroy() end
            ability_esp.labels[p] = nil
        end
        platformCache = {}
        abilityIconCache = {}
        restoreAllDefaultNameTags()
    end
end

local Byte_Library = {}
function Byte_Library.Korblox(char)
    if not char then return end
    local leg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
    if not leg then return end
    if not leg:FindFirstChild("KorbloxMesh") then
        for _, v in leg:GetChildren() do if v:IsA("SpecialMesh") then v:Destroy() end end
        local m = Instance.new("SpecialMesh")
        m.Name = "KorbloxMesh"
        m.MeshId = "rbxassetid://902942096"
        m.TextureId = "rbxassetid://902843398"
        m.Offset = Vector3.new(0, 0.7, 0)
        m.Parent = leg
    end
end
function Byte_Library.Restore_Leg(char)
    if not char then return end
    local leg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
    if not leg then return end
    for _, v in leg:GetChildren() do if v:IsA("SpecialMesh") then v:Destroy() end end
end
function Byte_Library.Headless(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    head.Transparency = 1
    for _, child in head:GetChildren() do
        if child:IsA("Decal") or child.Name == "face" then
            child.Transparency = 1
        elseif child:IsA("SpecialMesh") or child:IsA("DataModelMesh") then
            if not child:GetAttribute("OriginalScale") then
                child:SetAttribute("OriginalScale", child.Scale)
                child.Scale = Vector3.new(0, 0, 0)
            end
        end
    end
end
function Byte_Library.Restore_Head(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    head.Transparency = 0
    for _, child in head:GetChildren() do
        if child:IsA("Decal") or child.Name == "face" then
            child.Transparency = 0
        elseif child:IsA("SpecialMesh") or child:IsA("DataModelMesh") then
            local orig = child:GetAttribute("OriginalScale")
            if orig then
                child.Scale = orig
                child:SetAttribute("OriginalScale", nil)
            end
        end
    end
end

local function headlessKorblox_forgetConn()
    local conn = getgenv()._Vanish_HeadlessConn
    getgenv()._Vanish_HeadlessConn = nil
    pcall(function()
        if conn then conn:Disconnect() end
    end)
    pcall(function()
        local list = getgenv()._VanishConns
        if type(list) == "table" and conn then
            for i, c in ipairs(list) do
                if c == conn then
                    table.remove(list, i)
                    break
                end
            end
        end
    end)
end

local function headlessKorblox_onRespawn(char)
    if getgenv()._VanishAlive == false then return end
    if not getgenv().HeadlessKorbloxEnabled then
        task.defer(function()
            pcall(function()
                Byte_Library.Restore_Head(char)
                Byte_Library.Restore_Leg(char)
            end)
        end)
        return
    end
    task.spawn(function()
        char:WaitForChild("Head", 5)
        task.wait(0.5)
        if getgenv()._VanishAlive == false then return end
        if not LocalPlayer.Character or LocalPlayer.Character ~= char then return end
        if not getgenv().HeadlessKorbloxEnabled then
            pcall(function()
                Byte_Library.Restore_Head(char)
                Byte_Library.Restore_Leg(char)
            end)
            return
        end
        pcall(function()
            Byte_Library.Headless(char)
            Byte_Library.Korblox(char)
        end)
        task.wait(1.5)
        if getgenv()._VanishAlive == false then return end
        if not getgenv().HeadlessKorbloxEnabled then return end
        if not LocalPlayer.Character or LocalPlayer.Character ~= char then return end
        local head = char:FindFirstChild("Head")
        if head and head.Transparency ~= 1 then
            pcall(function()
                Byte_Library.Headless(char)
                Byte_Library.Korblox(char)
            end)
        end
    end)
end

local function headlessKorblox_updateConn()
    if getgenv().HeadlessKorbloxEnabled == true then
        local conn = getgenv()._Vanish_HeadlessConn
        if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
            return
        end
        headlessKorblox_forgetConn()
        local ok, newConn = pcall(function()
            return LocalPlayer.CharacterAdded:Connect(headlessKorblox_onRespawn)
        end)
        if ok and newConn then
            getgenv()._Vanish_HeadlessConn = newConn
            pcall(function()
                if type(getgenv()._VanishConns) == "table" then
                    table.insert(getgenv()._VanishConns, newConn)
                end
            end)
        end
    else
        headlessKorblox_forgetConn()
    end
end

headlessKorblox_forgetConn()
headlessKorblox_updateConn()


local swordInstances2

local function getSwordInstances()
    if swordInstances2 then return swordInstances2 end
    local shared = ReplicatedStorage:FindFirstChild("Shared")
    if not shared then return nil end
    local rep = shared:FindFirstChild("ReplicatedInstances")
    if not rep then return nil end
    local swords = rep:FindFirstChild("Swords")
    if not swords then return nil end
    local ok, mod = pcall(require, swords)
    if ok then swordInstances2 = mod end
    return swordInstances2
end

task.spawn(function()
    while getgenv()._VanishAlive ~= false do
        task.wait(2)
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if not hum then return end
            local animator = hum:FindFirstChildWhichIsA("Animator")
            if not animator then return end
            local tracks = animator:GetPlayingAnimationTracks()
            if #tracks > 32 then
                for _, track in ipairs(tracks) do
                    if track.Weight < 0.01 then
                        track:Stop()
                        pcall(function() track:Destroy() end)
                    end
                end
            end
        end)
    end
end)

getgenv().UnlockAllSwords = false -- kept false for compat, Unlock All removed

local function rememberStartupSword()
    if type(getgenv()._usStartupSword) == "string" and getgenv()._usStartupSword ~= "" then
        return
    end
    local name = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
    local char = LocalPlayer.Character
    if (type(name) ~= "string" or name == "") and char then
        name = char:GetAttribute("CurrentlyEquippedSword")
    end
    if type(name) == "string" and name ~= "" then
        getgenv()._usStartupSword = name
    end
end
rememberStartupSword()
task.defer(rememberStartupSword)
pcall(function()
    LocalPlayer:GetAttributeChangedSignal("CurrentlyEquippedSword"):Once(rememberStartupSword)
end)
if LocalPlayer.Character then
    pcall(function()
        LocalPlayer.Character:GetAttributeChangedSignal("CurrentlyEquippedSword"):Once(rememberStartupSword)
    end)
end

local function installUnlockSuite()
    do return end -- Unlock All removed
repeat task.wait() until game:IsLoaded()

local getgenv = getgenv
local task = task
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local function getExecutorGlobal(name)
    if getgenv and getgenv()[name] ~= nil then return getgenv()[name] end
    if _G and _G[name] ~= nil then return _G[name] end
    if shared and shared[name] ~= nil then return shared[name] end
    if getrenv and getrenv()[name] ~= nil then return getrenv()[name] end

    local value = nil
    pcall(function()
        if gethui then
            local hui = gethui()
            if hui and hui[name] ~= nil then value = hui[name] end
        end
    end)
    if value ~= nil then return value end

    pcall(function()
        if getfenv then
            local environment = getfenv(0)
            if environment and environment[name] ~= nil then value = environment[name] end
        end
    end)
    if value ~= nil then return value end

    return nil
end

    local SKIN_LAST_EQUIPPED_CONFIG_KEY = "Skin.LastEquippedSword"
    local EXPLOSION_LAST_EQUIPPED_CONFIG_KEY = "Skin.LastEquippedExplosion"
    local AUTO_CONFIG_FILE = "UnlockSuite/auto_config.json"

    local function readUnlockSuiteAutoConfig()
        local data = {}
        pcall(function()
            if isfile and isfile(AUTO_CONFIG_FILE) then
                local decoded = HttpService:JSONDecode(readfile(AUTO_CONFIG_FILE))
                if type(decoded) == "table" then
                    data = decoded
                end
            end
        end)
        return data
    end

    local function writeUnlockSuiteAutoConfig(data)
        pcall(function()
            if isfolder and makefolder and not isfolder("UnlockSuite") then
                makefolder("UnlockSuite")
            end
            if writefile then
                writefile(AUTO_CONFIG_FILE, HttpService:JSONEncode(data or {}))
            end
        end)
    end

    local function loadLastEquippedSword()
        local data = readUnlockSuiteAutoConfig()
        local saved = data[SKIN_LAST_EQUIPPED_CONFIG_KEY]
        return type(saved) == "string" and saved or ""
    end

    local function loadLastEquippedExplosion()
        local data = readUnlockSuiteAutoConfig()
        local saved = data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY]
        return type(saved) == "string" and saved or ""
    end

    getgenv().saveLastEquippedSword = function(swordName)
        if type(swordName) ~= "string" or swordName == "" then return end

        local autoConfig = getgenv()._usAutoConfig
        local data = autoConfig and autoConfig.Data
        if type(data) ~= "table" then
            data = readUnlockSuiteAutoConfig()
        end

        data[SKIN_LAST_EQUIPPED_CONFIG_KEY] = swordName
        if autoConfig and type(autoConfig.Data) == "table" then
            autoConfig.Data[SKIN_LAST_EQUIPPED_CONFIG_KEY] = swordName
        end
        writeUnlockSuiteAutoConfig(data)
    end

    getgenv().saveLastEquippedExplosion = function(explosionName)
        if type(explosionName) ~= "string" or explosionName == "" then return end

        local autoConfig = getgenv()._usAutoConfig
        local data = autoConfig and autoConfig.Data
        if type(data) ~= "table" then
            data = readUnlockSuiteAutoConfig()
        end

        data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY] = explosionName
        if autoConfig and type(autoConfig.Data) == "table" then
            autoConfig.Data[EXPLOSION_LAST_EQUIPPED_CONFIG_KEY] = explosionName
        end
        writeUnlockSuiteAutoConfig(data)
    end

    do
        local savedLastSword = loadLastEquippedSword()
        local savedLastExplosion = loadLastEquippedExplosion()
        getgenv().skinChanger = getgenv().skinChanger or savedLastSword ~= ""
        getgenv().swordModel = type(getgenv().swordModel) == "string" and getgenv().swordModel ~= "" and getgenv().swordModel or savedLastSword
        getgenv().swordAnimations = type(getgenv().swordAnimations) == "string" and getgenv().swordAnimations ~= "" and getgenv().swordAnimations or savedLastSword
        getgenv().swordFX = type(getgenv().swordFX) == "string" and getgenv().swordFX ~= "" and getgenv().swordFX or savedLastSword
        getgenv().swordSound = type(getgenv().swordSound) == "string" and getgenv().swordSound ~= "" and getgenv().swordSound or savedLastSword
        if getgenv().changeSwordModel == nil then getgenv().changeSwordModel = true end
        if getgenv().changeSwordAnimation == nil then getgenv().changeSwordAnimation = true end
        if getgenv().changeSwordFX == nil then getgenv().changeSwordFX = true end
        getgenv().explosionChanger = getgenv().explosionChanger or savedLastExplosion ~= ""
        getgenv().explosionFX = type(getgenv().explosionFX) == "string" and getgenv().explosionFX ~= "" and getgenv().explosionFX or savedLastExplosion
    end

    task.spawn(function()
        local rs = game:GetService("ReplicatedStorage")
        local swordInstancesInstance = rs:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9)
        local swordInstances = (require :: any)(swordInstancesInstance)

        local swordsController
        local function controller_shaped(t)
            if type(t) ~= "table" then
                return false
            end
            local ok, hit = pcall(function()
                return t.SetSword ~= nil or t.setSword ~= nil or t.currentSword ~= nil or t.SwordFX ~= nil
            end)
            return ok and hit == true
        end
        task.spawn(function()
            while task.wait(0.25) and not swordsController do
                local ok, conns = pcall(getconnections, rs.Remotes.FireSwordInfo.OnClientEvent)
                if ok and conns then
                    for _, v in ipairs(conns) do
                        local fn = v.Function
                        if type(fn) == "function" then
                            local ok2, up = pcall(getupvalues, fn)
                            if ok2 and type(up) == "table" then
                                if #up == 1 and type(up[1]) == "table" then
                                    swordsController = up[1]
                                    break
                                end
                                for i = 1, #up do
                                    if controller_shaped(up[i]) then
                                        swordsController = up[i]
                                        break
                                    end
                                end
                                if swordsController then
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if swordsController and type(getgenv().updateSword) == "function" then
                task.wait(0.5)
                pcall(getgenv().updateSword)
            end
        end)

        local function getSlashName(swordName)
            local ok, sln = pcall(function() return swordInstances:GetSword(swordName) end)
            return (ok and sln and sln.SlashName) or "SlashEffect"
        end

        local function refreshSlashName()
            local fxName = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
            if fxName ~= "" then
                getgenv().slashName = getSlashName(fxName)
            else
                getgenv().slashName = "SlashEffect"
            end
        end
        refreshSlashName()

        local function setSword()
            if not getgenv().skinChanger then return end
            if not LocalPlayer.Character then return end
            pcall(function()
                local f = rawget(swordInstances, "EquipSwordTo")
                if type(f) == "function" then
                    local ups = getupvalues(f)
                    for i = 1, #ups do
                        if type(ups[i]) == "boolean" then
                            setupvalue(f, i, false)
                            break
                        end
                    end
                end
            end)
            pcall(function()
                if getgenv().changeSwordModel ~= false and getgenv().swordModel ~= "" then
                    swordInstances:EquipSwordTo(LocalPlayer.Character, getgenv().swordModel)
                end
            end)
            task.spawn(function()
                local attempts = 0
                while not swordsController and attempts < 20 do
                    task.wait(0.5); attempts = attempts + 1
                end
                if not swordsController then return end
                local do_anims = getgenv().changeSwordAnimation ~= false
                local do_fx = getgenv().changeSwordFX ~= false
                if not do_anims and not do_fx then return end
                if do_anims then
                pcall(function()
                    local animSword = getgenv().swordAnimations ~= "" and getgenv().swordAnimations or getgenv().swordModel
                    if type(swordsController.SetSword) == "function" then
                        swordsController:SetSword(animSword)
                    elseif type(swordsController.setSword) == "function" then
                        swordsController:setSword(animSword)
                    end
                end)
                end
                if do_fx then
                pcall(function()
                    local targetSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                    local cur = nil
                    pcall(function() cur = LocalPlayer:GetAttribute("CurrentlyEquippedSword") end)
                    for k, v in pairs(swordsController) do
                        if type(v) == "string" and targetSword ~= "" and v ~= targetSword and (v == cur or v == getgenv().swordModel) then
                            pcall(function() swordsController[k] = targetSword end)
                        end
                    end
                    if swordsController.currentSword ~= nil then
                        pcall(function() swordsController.currentSword = targetSword end)
                    end
                    if swordsController.SwordFX ~= nil then
                        pcall(function() swordsController.SwordFX = targetSword end)
                    end
                end)
                end
            end)
        end

        local hookedFuncs = {}
        task.spawn(function()
            local remotesToHook = {"PlaySound", "PlayVisuals"}
            while task.wait(1) do
                for _, remoteName in ipairs(remotesToHook) do
                    local remote = rs.Remotes:FindFirstChild(remoteName)
                    if remote and remote:IsA("RemoteEvent") then
                        local ok, conns = pcall(getconnections, remote.OnClientEvent)
                        if ok and type(conns) == "table" then
                            for _, v in ipairs(conns) do
                                local func = v.Function
                                if func and not hookedFuncs[func] then
                                    hookedFuncs[func] = true
                                    v:Disable()
                                    local targetFunc = func
                                    local isSoundRemote = (remoteName == "PlaySound")
                                    local ourFunc
                                    ourFunc = function(...)
                                        local args = { ... }
                                        local isLocal = false
                                        for _, arg in ipairs(args) do
                                            if tostring(arg) == LocalPlayer.Name or (typeof(arg) == "Instance" and (arg == LocalPlayer.Character or arg == LocalPlayer)) then
                                                isLocal = true
                                                break
                                            end
                                        end
                                        if isLocal and getgenv().skinChanger and getgenv().changeSwordFX ~= false then
                                            local fxSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                                            local soundSword = (type(getgenv().swordSound) == "string" and getgenv().swordSound ~= "" and getgenv().swordSound) or fxSword
                                            refreshSlashName()
                                            local swordFound = false
                                            local slashFound = false
                                            for i, arg in ipairs(args) do
                                                if type(arg) == "string" then
                                                    if not isSoundRemote and fxSword ~= "" and not slashFound and (arg:match("Slash") or arg == "Default" or arg:match("Effect")) then
                                                        args[i] = getgenv().slashName
                                                        slashFound = true
                                                    elseif fxSword ~= "" and not swordFound then
                                                        local isSword = false
                                                        pcall(function()
                                                            if rs.Shared.ReplicatedInstances.Swords:FindFirstChild(arg) then
                                                                isSword = true
                                                            end
                                                        end)
                                                        if isSword or arg == LocalPlayer:GetAttribute("CurrentlyEquippedSword") then
                                                            args[i] = isSoundRemote and soundSword or fxSword
                                                            swordFound = true
                                                        end
                                                    end
                                                end
                                            end
                                            if not isSoundRemote and fxSword ~= "" and not slashFound and type(args[1]) == "string" then
                                                args[1] = getgenv().slashName
                                            end
                                            if fxSword ~= "" and not swordFound and type(args[3]) == "string" then
                                                args[3] = isSoundRemote and soundSword or fxSword
                                            end
                                        end
                                        if setthreadidentity then pcall(setthreadidentity, 2) end
                                        pcall(targetFunc, unpack(args))
                                    end
                                    hookedFuncs[ourFunc] = true
                                    remote.OnClientEvent:Connect(ourFunc)
                                end
                            end
                        end
                    end
                end
            end
        end)

        getgenv().updateSword = function()
            refreshSlashName()
            if getgenv().skinChanger and getgenv().swordModel ~= "" and getgenv().saveLastEquippedSword then
                getgenv().saveLastEquippedSword(getgenv().swordModel)
            end
            setSword()
        end

        task.spawn(function()
            while task.wait(1) do
                if getgenv().skinChanger and getgenv().swordModel ~= "" then
                    local char = LocalPlayer.Character
                    if char then
                        local cur_sword = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
                        if cur_sword ~= getgenv().swordModel then
                            if cur_sword ~= char:GetAttribute("LastOverwrittenSword") then
                                pcall(function()
                                    char:SetAttribute("LastOverwrittenSword", cur_sword)
                                end)
                            end
                            setSword()
                        end
                        if not char:FindFirstChild(getgenv().swordModel) then
                            setSword()
                        end
                        for _, v in pairs(char:GetChildren()) do
                            if v:IsA("Model") and v.Name ~= getgenv().swordModel and v:FindFirstChild("Handle") then
                                v:Destroy()
                            end
                            task.wait()
                        end
                    end
                end
            end
        end)

        LocalPlayer.CharacterAdded:Connect(function()
            if getgenv().skinChanger then
                getgenv().skinChanger = false
                if getgenv().setSkinChangerToggleUI then getgenv().setSkinChangerToggleUI(false) end
                task.wait(2)
                getgenv().skinChanger = true
                if getgenv().setSkinChangerToggleUI then getgenv().setSkinChangerToggleUI(true) end
                task.wait(0.5)
                pcall(function() getgenv().updateSword() end)
            end
        end)
    end)

    task.spawn(function()
        local rs = game:GetService("ReplicatedStorage")
        local explosionHookedFuncs = {}
        local explosionDirectHooked = {}
        local deadFolderHooked = false
        local explosionModule = nil
        local bindableInvokeHooked = false
        local nativeExplosionSuppressorHooked = {}
        local pendingKillExplosionPosition = nil
        local pendingKillExplosionAt = 0
        local lastLocalKillAt = 0
        local lastLocalKillStatTotal = nil
        local killStatWatcherStarted = false
        local lastLocalExplosionPlayedAt = 0
        local lastLocalExplosionPlayedPosition = nil

        local function normalizeExplosionName(value)
            return tostring(value or ""):lower():gsub("[^%w]", "")
        end

        local function getNetFolder()
            local packages = rs:FindFirstChild("Packages")
            local index = packages and packages:FindFirstChild("_Index")
            local sleitnick = index and index:FindFirstChild("sleitnick_net@0.1.0")
            return sleitnick and sleitnick:FindFirstChild("net")
        end

        local function getExplosionInstances()
            local shared = rs:FindFirstChild("Shared")
            local replicatedInstances = shared and shared:FindFirstChild("ReplicatedInstances")
            return replicatedInstances and replicatedInstances:FindFirstChild("Explosions")
        end

        local function getExplosionDataFolder()
            local misc = rs:FindFirstChild("Misc")
            return misc and misc:FindFirstChild("DataExplosions")
        end

        local function getExplosionEffectsFolder()
            return rs:FindFirstChild("ExplosionEffects")
        end

        local function getExplosionModule()
            if explosionModule ~= nil then return explosionModule end
            local instance = getExplosionInstances()
            if instance and instance:IsA("ModuleScript") then
                local ok, result = pcall(function()
                    return require(instance)
                end)
                explosionModule = ok and result or false
            end
            return explosionModule
        end

        local function findExplosionInstanceByName(value)
            if type(value) ~= "string" or value == "" then return nil end
            local wanted = normalizeExplosionName(value)
            for _, root in ipairs({getExplosionDataFolder(), getExplosionEffectsFolder(), getExplosionInstances()}) do
                if root then
                    local exact = root:FindFirstChild(value, true)
                    if exact then return exact end
                    for _, child in ipairs(root:GetDescendants()) do
                        if normalizeExplosionName(child.Name) == wanted then
                            return child
                        end
                    end
                end
            end
            return nil
        end

        local function findExplosionDataConfig(value)
            if type(value) ~= "string" or value == "" then return nil end
            local dataFolder = getExplosionDataFolder()
            if not dataFolder then return nil end
            local wanted = normalizeExplosionName(value)
            local exact = dataFolder:FindFirstChild(value, true)
            if exact then return exact end
            for _, child in ipairs(dataFolder:GetDescendants()) do
                if normalizeExplosionName(child.Name) == wanted then
                    return child
                end
                for _, attributeValue in pairs(child:GetAttributes()) do
                    if type(attributeValue) == "string" and normalizeExplosionName(attributeValue) == wanted then
                        return child
                    end
                end
            end
            return nil
        end

        local function getExplosionAliases(value)
            local aliases = {}
            local seen = {}
            local function add(alias)
                if type(alias) ~= "string" or alias == "" then return end
                local key = normalizeExplosionName(alias)
                if key == "" or seen[key] then return end
                seen[key] = true
                aliases[#aliases + 1] = alias
            end
            add(value)
            local config = findExplosionDataConfig(value)
            if config then
                add(config.Name)
                for _, attributeName in ipairs({
                    "Title", "TitleText", "DisplayName", "ExplosionName", "EffectName", "FXName", "VFXName", "ItemName",
                }) do
                    local ok, attributeValue = pcall(function()
                        return config:GetAttribute(attributeName)
                    end)
                    if ok then add(attributeValue) end
                end
                local scanned = 0
                for _, object in ipairs(config:GetDescendants()) do
                    if object:IsA("StringValue") then
                        add(object.Value)
                        scanned = scanned + 1
                        if scanned >= 20 then break end
                    end
                end
            end
            return aliases
        end

        local function isPlayableExplosionTemplate(instance)
            if typeof(instance) ~= "Instance" then return false end
            if instance:IsA("Configuration")
                or instance:IsA("ModuleScript")
                or instance:IsA("Script")
                or instance:IsA("LocalScript")
                or instance:IsA("BindableFunction")
                or instance:IsA("BindableEvent")
                or instance:IsA("ObjectValue") then
                return false
            end
            return instance:IsA("Folder")
                or instance:IsA("Model")
                or instance:IsA("BasePart")
                or instance:IsA("Attachment")
                or instance:IsA("Accessory")
                or instance:IsA("Tool")
                or instance:FindFirstChildWhichIsA("BasePart", true) ~= nil
                or instance:FindFirstChildWhichIsA("ParticleEmitter", true) ~= nil
                or instance:FindFirstChildWhichIsA("Beam", true) ~= nil
                or instance:FindFirstChildWhichIsA("Trail", true) ~= nil
        end

        local function firstPlayableExplosionValue(value, depth, seen)
            if value == nil or depth > 4 then return nil end
            if typeof(value) == "Instance" then
                return isPlayableExplosionTemplate(value) and value or nil
            end
            if type(value) ~= "table" then return nil end
            seen = seen or {}
            if seen[value] then return nil end
            seen[value] = true
            for _, key in ipairs({"VFX", "Effect", "Effects", "Instance", "Model", "Folder", "Explosion", "Object", "Template"}) do
                local candidate = firstPlayableExplosionValue(value[key], depth + 1, seen)
                if candidate then return candidate end
            end
            for _, child in pairs(value) do
                local candidate = firstPlayableExplosionValue(child, depth + 1, seen)
                if candidate then return candidate end
            end
            return nil
        end

        local function getReplicatedExplosionTemplate(value)
            local instances = getExplosionInstances()
            if not instances then return nil end
            for _, alias in ipairs(getExplosionAliases(value)) do
                local direct = instances:FindFirstChild(alias, true)
                if isPlayableExplosionTemplate(direct) then
                    getgenv().lastExplosionTemplateSource = "ReplicatedInstances"
                    return direct
                end
            end
            local bindable = instances:FindFirstChild("GetInstance")
            if bindable and bindable:IsA("BindableFunction") then
                for _, alias in ipairs(getExplosionAliases(value)) do
                    local ok, result = pcall(function()
                        return bindable:Invoke(alias)
                    end)
                    local template = ok and firstPlayableExplosionValue(result, 0, {}) or nil
                    if template then
                        getgenv().lastExplosionTemplateSource = "ReplicatedInstances.GetInstance"
                        return template
                    end
                end
            end
            local module = getExplosionModule()
            if type(module) == "table" then
                for _, alias in ipairs(getExplosionAliases(value)) do
                    local directValue = module[alias] or module[normalizeExplosionName(alias)]
                    local directTemplate = firstPlayableExplosionValue(directValue, 0, {})
                    if directTemplate then
                        getgenv().lastExplosionTemplateSource = "ReplicatedInstances.Module"
                        return directTemplate
                    end
                    for _, methodName in ipairs({"GetInstance", "GetExplosion", "GetExplosionVFX", "GetEffect", "Get"}) do
                        local method = module[methodName]
                        if type(method) == "function" then
                            for _, callWithSelf in ipairs({true, false}) do
                                local ok, result = pcall(function()
                                    if callWithSelf then
                                        return method(module, alias)
                                    end
                                    return method(alias)
                                end)
                                local template = ok and firstPlayableExplosionValue(result, 0, {}) or nil
                                if template then
                                    getgenv().lastExplosionTemplateSource = "ReplicatedInstances." .. methodName
                                    return template
                                end
                            end
                        end
                    end
                end
            end
            return nil
        end

        local function findExplosionEffectTemplate(value)
            if type(value) ~= "string" or value == "" then return nil end
            local replicatedTemplate = getReplicatedExplosionTemplate(value)
            if replicatedTemplate then return replicatedTemplate end
            local effectsFolder = getExplosionEffectsFolder()
            if not effectsFolder then return nil end
            for _, alias in ipairs(getExplosionAliases(value)) do
                local exact = effectsFolder:FindFirstChild(alias, true)
                if exact and isPlayableExplosionTemplate(exact) then
                    getgenv().lastExplosionTemplateSource = "ExplosionEffects"
                    return exact
                end
            end
            for _, alias in ipairs(getExplosionAliases(value)) do
                local wanted = normalizeExplosionName(alias)
                for _, child in ipairs(effectsFolder:GetDescendants()) do
                    if isPlayableExplosionTemplate(child) and normalizeExplosionName(child.Name) == wanted then
                        getgenv().lastExplosionTemplateSource = "ExplosionEffects"
                        return child
                    end
                end
            end
            local best = nil
            local bestScore = 0
            for _, child in ipairs(effectsFolder:GetDescendants()) do
                if isPlayableExplosionTemplate(child) then
                    local key = normalizeExplosionName(child.Name)
                    local score = 0
                    for _, alias in ipairs(getExplosionAliases(value)) do
                        local wanted = normalizeExplosionName(alias)
                        if wanted:find(key, 1, true) or key:find(wanted, 1, true) then
                            score = math.max(score, math.min(#key, #wanted))
                        else
                            for word in tostring(alias):gmatch("[%w]+") do
                                local wordKey = normalizeExplosionName(word)
                                if #wordKey >= 4 and key:find(wordKey, 1, true) then
                                    score = score + #wordKey
                                end
                            end
                        end
                    end
                    if score > bestScore then
                        best = child
                        bestScore = score
                    end
                end
            end
            if best then
                getgenv().lastExplosionTemplateSource = "ExplosionEffects.Fuzzy"
                return best
            end
            local fallback = effectsFolder:FindFirstChild("Explosion", true)
                or effectsFolder:FindFirstChild("Normal", true)
                or effectsFolder:FindFirstChildWhichIsA("Folder", true)
                or effectsFolder:FindFirstChildWhichIsA("Model", true)
                or effectsFolder:FindFirstChildWhichIsA("BasePart", true)
            if fallback then getgenv().lastExplosionTemplateSource = "ExplosionEffects.Fallback" end
            return fallback
        end

        local function getSelectedExplosionName()
            local selected = getgenv().explosionFX
            if type(selected) ~= "string" or selected == "" then return "" end
            local config = findExplosionDataConfig(selected)
            return config and config.Name or selected
        end

        local function isPlayerString(value)
            if type(value) ~= "string" then return false end
            for _, player in ipairs(Players:GetPlayers()) do
                if value == player.Name or value == player.DisplayName then
                    return true
                end
            end
            return false
        end

        local function isKnownExplosionName(value)
            if type(value) ~= "string" or value == "" then return false end
            if findExplosionInstanceByName(value) then return true end
            local instances = getExplosionInstances()
            if instances then
                local bindable = instances:FindFirstChild("GetInstance")
                if bindable and bindable:IsA("BindableFunction") then
                    local ok, result = pcall(function()
                        return bindable:Invoke(value)
                    end)
                    if ok and result then return true end
                end
                if instances:FindFirstChild(value, true) then return true end
            end
            local module = getExplosionModule()
            if type(module) == "table" then
                if module[value] ~= nil then return true end
                for _, methodName in ipairs({"GetExplosion", "GetInstance", "Get"}) do
                    if type(module[methodName]) == "function" then
                        local ok, result = pcall(function()
                            return module[methodName](module, value)
                        end)
                        if ok and result then return true end
                    end
                end
            end
            return false
        end

        local function argsMentionLocal(args)
            for _, arg in ipairs(args) do
                if arg == LocalPlayer or arg == LocalPlayer.Character or arg == LocalPlayer.Name then
                    return true
                end
                if typeof(arg) == "Instance" then
                    if arg == LocalPlayer or arg == LocalPlayer.Character then return true end
                    if LocalPlayer.Character and arg:IsDescendantOf(LocalPlayer.Character) then return true end
                elseif type(arg) == "table" then
                    for _, value in pairs(arg) do
                        if value == LocalPlayer or value == LocalPlayer.Character or value == LocalPlayer.Name then
                            return true
                        end
                    end
                end
            end
            return false
        end

        local function valueMentionsLocal(value, depth)
            if depth > 4 or value == nil then return false end
            if value == LocalPlayer or value == LocalPlayer.Character or value == LocalPlayer.Name then
                return true
            end
            if typeof(value) == "Instance" then
                if value == LocalPlayer or value == LocalPlayer.Character then return true end
                if value:IsA("Player") then
                    return value == LocalPlayer or value.Name == LocalPlayer.Name or value.DisplayName == LocalPlayer.DisplayName
                end
                return LocalPlayer.Character and value:IsDescendantOf(LocalPlayer.Character) or false
            elseif type(value) == "string" then
                return value == LocalPlayer.Name or value == LocalPlayer.DisplayName
            elseif type(value) == "table" then
                for _, child in pairs(value) do
                    if valueMentionsLocal(child, depth + 1) then return true end
                end
            end
            return false
        end

        local function tableIndicatesLocalKill(tbl, depth)
            if type(tbl) ~= "table" or depth > 4 then return false end
            for key, value in pairs(tbl) do
                local keyText = tostring(key):lower()
                local killerKey = keyText:find("killer", 1, true) or keyText:find("attacker", 1, true) or keyText:find("creator", 1, true) or keyText:find("source", 1, true) or keyText:find("from", 1, true) or keyText:find("dealer", 1, true) or keyText:find("owner", 1, true)
                local victimKey = keyText:find("victim", 1, true) or keyText:find("dead", 1, true) or keyText:find("killed", 1, true) or keyText:find("target", 1, true)
                if killerKey and valueMentionsLocal(value, 0) then return true end
                if victimKey and valueMentionsLocal(value, 0) then return false end
            end
            for _, value in pairs(tbl) do
                if tableIndicatesLocalKill(value, depth + 1) then return true end
            end
            return false
        end

        local function tableIndicatesLocalDeath(tbl, depth)
            if type(tbl) ~= "table" or depth > 4 then return false end
            for key, value in pairs(tbl) do
                local keyText = tostring(key):lower()
                local victimKey = keyText:find("victim", 1, true) or keyText:find("dead", 1, true) or keyText:find("killed", 1, true) or keyText:find("target", 1, true)
                if victimKey and valueMentionsLocal(value, 0) then return true end
            end
            for _, value in pairs(tbl) do
                if tableIndicatesLocalDeath(value, depth + 1) then return true end
            end
            return false
        end

        local function argsIndicateLocalDeath(args)
            for _, arg in ipairs(args) do
                if tableIndicatesLocalDeath(arg, 0) then return true end
            end
            return false
        end

        local function argsIndicateLocalKill(args, remoteName)
            for _, arg in ipairs(args) do
                if tableIndicatesLocalKill(arg, 0) then return true end
            end
            local first = args[1]
            local second = args[2]
            local third = args[3]
            if valueMentionsLocal(second, 0) and not valueMentionsLocal(first, 0) then return true end
            if valueMentionsLocal(third, 0) and not valueMentionsLocal(first, 0) then return true end
            if valueMentionsLocal(first, 0) and not valueMentionsLocal(second, 0) then return true end
            local remoteKey = tostring(remoteName or ""):lower()
            local killRemote = remoteKey:find("kill", 1, true) or remoteKey:find("death", 1, true) or remoteKey:find("dead", 1, true)
            return killRemote and argsMentionLocal(args) and not argsIndicateLocalDeath(args)
        end

        local function getPositionFromExplosionValue(value, depth)
            if depth > 3 or value == nil then return nil end
            if typeof(value) == "Vector3" then return value end
            if typeof(value) == "CFrame" then return value.Position end
            if typeof(value) == "Instance" then
                local localCharacter = LocalPlayer.Character
                if value == LocalPlayer or value == localCharacter then return nil end
                if localCharacter and value:IsDescendantOf(localCharacter) then return nil end
                if value:IsA("BasePart") then return value.Position end
                if value:IsA("Player") then
                    local character = value.Character
                    local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                    return root and root.Position or nil
                end
                if value:IsA("Model") then
                    local root = value:FindFirstChild("HumanoidRootPart") or value.PrimaryPart
                    if root then return root.Position end
                    local ok, pivot = pcall(function() return value:GetPivot() end)
                    if ok and pivot then return pivot.Position end
                end
            elseif type(value) == "table" then
                for _, child in pairs(value) do
                    local position = getPositionFromExplosionValue(child, depth + 1)
                    if position then return position end
                end
            end
            return nil
        end

        local function isLocalExplosionPosition(position)
            if typeof(position) ~= "Vector3" then return false end
            local character = LocalPlayer.Character
            local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
            return root and (position - root.Position).Magnitude <= 4 or false
        end

        local function getExplosionPositionFromArgs(args)
            for _, arg in ipairs(args) do
                local position = getPositionFromExplosionValue(arg, 0)
                if position and not isLocalExplosionPosition(position) then return position end
            end
            return nil
        end

        local function parseVector3Attribute(value)
            if typeof(value) == "Vector3" then return value end
            if type(value) ~= "string" then return nil end
            local numbers = {}
            for numberText in value:gmatch("[-+]?%d+%.?%d*") do
                numbers[#numbers + 1] = tonumber(numberText)
                if #numbers >= 3 then break end
            end
            if #numbers >= 3 then
                return Vector3.new(numbers[1], numbers[2], numbers[3])
            end
            return nil
        end

        local function getNumberAttribute(object, names)
            for _, name in ipairs(names) do
                local value = tonumber(object:GetAttribute(name))
                if value then return value end
            end
            return nil
        end

        local function delayedTween(object, delayTime, duration, properties)
            if not next(properties) then return end
            task.delay(delayTime or 0, function()
                if object and object.Parent then
                    pcall(function()
                        TweenService:Create(object, TweenInfo.new(math.max(duration or 0.05, 0.05), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties):Play()
                    end)
                end
            end)
        end

        local function activateLocalExplosionObject(root)
            local objects = {root}
            for _, object in ipairs(root:GetDescendants()) do
                objects[#objects + 1] = object
            end
            for _, object in ipairs(objects) do
                local emitDelay = tonumber(object:GetAttribute("EmitDelay")) or tonumber(object:GetAttribute("Delay")) or 0
                local duration = tonumber(object:GetAttribute("Duration")) or tonumber(object:GetAttribute("Time")) or 0.35
                if object:IsA("BasePart") then
                    object.Anchored = true
                    object.CanCollide = false
                    object.CanTouch = false
                    object.CanQuery = false
                    local properties = {}
                    local sizeTarget = parseVector3Attribute(object:GetAttribute("Size_Target")) or parseVector3Attribute(object:GetAttribute("Size"))
                    local transparencyTarget = tonumber(object:GetAttribute("Transparency_Target")) or tonumber(object:GetAttribute("Transparency"))
                    if sizeTarget then properties.Size = sizeTarget end
                    if transparencyTarget then properties.Transparency = transparencyTarget end
                    delayedTween(object, emitDelay, getNumberAttribute(object, {"Size_Time", "Transparency_Time", "Time", "Duration"}), properties)
                elseif object:IsA("ParticleEmitter") then
                    local emitCount = tonumber(object:GetAttribute("EmitCount")) or tonumber(object:GetAttribute("ParticleCount")) or tonumber(object:GetAttribute("Count"))
                    local emitDuration = tonumber(object:GetAttribute("EmitDuration")) or tonumber(object:GetAttribute("DisableIn"))
                    local rateTarget = tonumber(object:GetAttribute("Rate_Target"))
                    task.delay(emitDelay, function()
                        if object and object.Parent then
                            if emitCount and emitCount > 0 then
                                pcall(function() object:Emit(emitCount) end)
                            else
                                pcall(function() object.Enabled = true end)
                                if emitDuration and emitDuration > 0 then
                                    task.delay(emitDuration, function()
                                        if object and object.Parent then object.Enabled = false end
                                    end)
                                end
                            end
                            if rateTarget then
                                delayedTween(object, 0, duration, {Rate = rateTarget})
                            end
                        end
                    end)
                elseif object:IsA("Beam") or object:IsA("Trail") or object:IsA("Light") then
                    task.delay(emitDelay, function()
                        if object and object.Parent then object.Enabled = true end
                    end)
                elseif object:IsA("Sound") then
                    task.delay(tonumber(object:GetAttribute("Delay")) or emitDelay, function()
                        if object and object.Parent then
                            pcall(function() object:Play() end)
                        end
                    end)
                end
            end
        end

        local function playSyntheticExplosion(position)
            getgenv().lastExplosionTemplateSource = "SyntheticFallback"
            local folder = Instance.new("Folder")
            folder.Name = "UnlockSuiteExplosion_LocalFallback"
            folder.Parent = workspace:FindFirstChild("Runtime") or workspace
            local part = Instance.new("Part")
            part.Name = "Burst"
            part.Anchored = true
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.Material = Enum.Material.Neon
            part.Shape = Enum.PartType.Ball
            part.Size = Vector3.new(1, 1, 1)
            part.Color = Color3.fromRGB(120, 180, 255)
            part.Transparency = 1
            pcall(function() part.LocalTransparencyModifier = 1 end)
            part.CFrame = CFrame.new(position or Vector3.zero)
            part.Parent = folder
            local attachment = Instance.new("Attachment")
            attachment.Parent = part
            local emitter = Instance.new("ParticleEmitter")
            emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            emitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(90, 130, 255))
            emitter.LightEmission = 1
            emitter.Lifetime = NumberRange.new(0.35, 0.9)
            emitter.Speed = NumberRange.new(28, 58)
            emitter.SpreadAngle = Vector2.new(180, 180)
            emitter.Drag = 4
            emitter.Rate = 0
            emitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.8),
                NumberSequenceKeypoint.new(1, 0),
            })
            emitter.Parent = attachment
            emitter:Emit(90)
            local light = Instance.new("PointLight")
            light.Color = part.Color
            light.Brightness = 5
            light.Range = 18
            light.Parent = part
            TweenService:Create(part, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(9, 9, 9), Transparency = 1}):Play()
            TweenService:Create(light, TweenInfo.new(0.45), {Brightness = 0, Range = 0}):Play()
            task.delay(2, function()
                if folder and folder.Parent then folder:Destroy() end
            end)
            return true
        end

        local function playLocalExplosion(position)
            if not getgenv().explosionChanger then return false end
            local selectedExplosion = getSelectedExplosionName()
            if selectedExplosion == "" then return false end
            local template = findExplosionEffectTemplate(selectedExplosion)
            if not template then return playSyntheticExplosion(position) end
            local clone = template:Clone()
            clone.Name = "UnlockSuiteExplosion_" .. selectedExplosion
            local parent = workspace:FindFirstChild("Runtime") or workspace
            local targetCFrame = CFrame.new(position or Vector3.zero)
            if clone:IsA("Attachment") then
                local folder = Instance.new("Folder")
                folder.Name = "UnlockSuiteExplosion_" .. selectedExplosion
                folder.Parent = parent
                local anchor = Instance.new("Part")
                anchor.Name = "UnlockSuiteExplosionAnchor"
                anchor.Anchored = true
                anchor.CanCollide = false
                anchor.CanTouch = false
                anchor.CanQuery = false
                anchor.Transparency = 1
                anchor.Size = Vector3.new(1, 1, 1)
                anchor.CFrame = targetCFrame
                anchor.Parent = folder
                clone.Parent = anchor
                clone = folder
            else
                clone.Parent = parent
            end
            if clone:IsA("Model") then
                pcall(function() clone:PivotTo(targetCFrame) end)
            elseif clone:IsA("BasePart") then
                clone.CFrame = targetCFrame
            elseif clone:IsA("Folder") then
                local base = clone:FindFirstChildWhichIsA("BasePart", true)
                if base then
                    local offset = targetCFrame.Position - base.Position
                    for _, part in ipairs(clone:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CFrame = part.CFrame + offset
                        end
                    end
                end
            end
            activateLocalExplosionObject(clone)
            task.delay(8, function()
                if clone and clone.Parent then clone:Destroy() end
            end)
            return true
        end

        local function isUnlockSuiteExplosionObject(object)
            local current = object
            while current and current ~= workspace do
                if type(current.Name) == "string" and current.Name:find("UnlockSuiteExplosion", 1, true) then
                    return true
                end
                current = current.Parent
            end
            return false
        end

        local function hideNativeExplosionVisual(object)
            if not object or isUnlockSuiteExplosionObject(object) then return end
            local objects = { object }
            for _, descendant in ipairs(object:GetDescendants()) do
                objects[#objects + 1] = descendant
            end
            for _, item in ipairs(objects) do
                pcall(function()
                    if item:IsA("BasePart") then
                        item.Transparency = 1
                        item.LocalTransparencyModifier = 1
                        item.CanCollide = false
                        item.CanTouch = false
                        item.CanQuery = false
                    elseif item:IsA("ParticleEmitter") then
                        item.Enabled = false
                        item.Rate = 0
                        pcall(function() item:Clear() end)
                    elseif item:IsA("Beam") or item:IsA("Trail") or item:IsA("Light") then
                        item.Enabled = false
                    elseif item:IsA("Sound") then
                        item.Volume = 0
                        pcall(function() item:Stop() end)
                    end
                end)
            end
        end

        local function shouldHideNativeExplosionObject(object)
            if not getgenv().explosionChanger then return false end
            if (getgenv()._usExplosionLocalKillUntil or 0) <= os.clock() then return false end
            if isUnlockSuiteExplosionObject(object) then return false end
            local key = normalizeExplosionName(object and object.Name or "")
            if key:find("explosion", 1, true) or key:find("explode", 1, true) or key:find("effect", 1, true) or key:find("vfx", 1, true) or key:find("burst", 1, true) or key:find("kill", 1, true) then
                return true
            end
            local parent = object and object.Parent
            local parentKey = normalizeExplosionName(parent and parent.Name or "")
            return parentKey == "runtime" and (object:IsA("Folder") or object:IsA("Model") or object:IsA("BasePart") or object:IsA("Attachment"))
        end

        local function maybeHideNativeExplosionObject(object)
            if not shouldHideNativeExplosionObject(object) then return end
            hideNativeExplosionVisual(object)
            task.delay(0.03, function() hideNativeExplosionVisual(object) end)
            task.delay(0.12, function() hideNativeExplosionVisual(object) end)
            task.delay(0.3, function() hideNativeExplosionVisual(object) end)
        end

        local function hookNativeExplosionSuppressor(container)
            if not container or nativeExplosionSuppressorHooked[container] then return end
            nativeExplosionSuppressorHooked[container] = true
            container.ChildAdded:Connect(maybeHideNativeExplosionObject)
        end

        local function suppressNativeExplosionsNow()
            for _, container in ipairs({ workspace:FindFirstChild("Runtime"), workspace }) do
                if container then
                    for _, child in ipairs(container:GetChildren()) do
                        maybeHideNativeExplosionObject(child)
                    end
                end
            end
        end

        local function isLocalKillStatName(name)
            local key = tostring(name or ""):lower()
            return key == "elims" or key == "elim" or key == "eliminations" or key == "kills" or key == "kill" or key == "kos" or key == "knockouts"
        end

        local function numericStatValue(value)
            if type(value) == "number" then return value end
            if type(value) == "string" then return tonumber(value) end
            if typeof(value) == "Instance" and (value:IsA("IntValue") or value:IsA("NumberValue") or value:IsA("StringValue")) then
                return tonumber((value :: any).Value)
            end
            return nil
        end

        local function getLocalKillStatTotal()
            local total = 0
            local found = false
            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            if leaderstats then
                for _, stat in ipairs(leaderstats:GetChildren()) do
                    if isLocalKillStatName(stat.Name) then
                        local value = numericStatValue(stat)
                        if value then
                            total = total + value
                            found = true
                        end
                    end
                end
            end
            for _, attributeName in ipairs({"PlayerElims", "Elims", "Eliminations", "Kills", "KillCount", "Knockouts"}) do
                local value = numericStatValue(LocalPlayer:GetAttribute(attributeName))
                if value then
                    total = total + value
                    found = true
                end
            end
            return found and total or nil
        end

        local function playPendingKillExplosion()
            if not getgenv().explosionChanger and (not getgenv().finisherModel or getgenv().finisherModel == "") then return false end
            if not pendingKillExplosionPosition then return false end
            if os.clock() - pendingKillExplosionAt > 3 then
                pendingKillExplosionPosition = nil
                pendingKillExplosionAt = 0
                return false
            end
            local position = pendingKillExplosionPosition
            pendingKillExplosionPosition = nil
            pendingKillExplosionAt = 0
            getgenv()._usExplosionLocalKillUntil = os.clock() + 1.25
            if lastLocalExplosionPlayedPosition and os.clock() - lastLocalExplosionPlayedAt < 0.25 and (lastLocalExplosionPlayedPosition - position).Magnitude < 8 then
                return false
            end
            lastLocalExplosionPlayedAt = os.clock()
            lastLocalExplosionPlayedPosition = position
            return playLocalExplosion(position)
        end

        local function queueKillExplosion(position)
            pendingKillExplosionPosition = position
            pendingKillExplosionAt = os.clock()
            if os.clock() - lastLocalKillAt <= 2.5 then
                playPendingKillExplosion()
            end
        end

        local function markLocalKill(position)
            lastLocalKillAt = os.clock()
            getgenv()._usExplosionLocalKillUntil = os.clock() + 1.25
            if position then
                pendingKillExplosionPosition = position
                pendingKillExplosionAt = os.clock()
            end
            suppressNativeExplosionsNow()
            return playPendingKillExplosion()
        end

        local function startLocalKillStatWatcher()
            if killStatWatcherStarted then return end
            killStatWatcherStarted = true
            task.spawn(function()
                while task.wait(0.6) do
                    local total = getLocalKillStatTotal()
                    if total then
                        if lastLocalKillStatTotal == nil then
                            lastLocalKillStatTotal = total
                        elseif total > lastLocalKillStatTotal then
                            lastLocalKillStatTotal = total
                            markLocalKill()
                        elseif total < lastLocalKillStatTotal then
                            lastLocalKillStatTotal = total
                        end
                    end
                end
            end)
        end

        local function patchExplosionTable(tbl, remoteKey, selectedExplosion, depth)
            if type(tbl) ~= "table" or depth > 2 then return false end
            local changed = false
            for key, value in pairs(tbl) do
                local keyText = tostring(key):lower()
                if type(value) == "string" then
                    local keyLooksRight = keyText:find("explosion", 1, true) or keyText:find("effect", 1, true) or keyText:find("fx", 1, true)
                    if keyLooksRight or isKnownExplosionName(value) then
                        tbl[key] = selectedExplosion
                        changed = true
                    end
                elseif type(value) == "table" then
                    changed = patchExplosionTable(value, remoteKey, selectedExplosion, depth + 1) or changed
                end
            end
            return changed
        end

        local function patchExplosionArgs(remoteName, args, isOurKill)
            if not getgenv().explosionChanger then return args end
            local selectedExplosion = getSelectedExplosionName()
            if type(selectedExplosion) ~= "string" or selectedExplosion == "" then return args end
            if not isOurKill then return args end
            local remoteKey = tostring(remoteName):lower()
            local isExplosionRemote = remoteKey:find("explosion", 1, true) ~= nil
            local localRelated = argsMentionLocal(args)
            local changed = false
            for index, arg in ipairs(args) do
                if type(arg) == "string" and not isPlayerString(arg) then
                    local valueKey = arg:lower()
                    local shouldPatch = isKnownExplosionName(arg) or isExplosionRemote or (localRelated and (valueKey:find("explosion", 1, true) or valueKey:find("effect", 1, true) or valueKey:find("fx", 1, true)))
                    if shouldPatch then
                        args[index] = selectedExplosion
                        changed = true
                    end
                elseif type(arg) == "table" then
                    changed = patchExplosionTable(arg, remoteKey, selectedExplosion, 0) or changed
                end
            end
            if isExplosionRemote and not changed then
                for index, arg in ipairs(args) do
                    if type(arg) == "string" and not isPlayerString(arg) then
                        args[index] = selectedExplosion
                        break
                    end
                end
            end
            return args
        end

        local function invokeExplosionRemote(remote, explosionName)
            if not remote or type(explosionName) ~= "string" or explosionName == "" then return false end
            local fired = false
            for _, args in ipairs({
                {explosionName},
                {"Explosion", explosionName},
                {"ExplosionFX", explosionName},
                {"KillEffect", explosionName},
                {explosionName, "Explosion"},
                {explosionName, "ExplosionFX"},
            }) do
                local ok = pcall(function()
                    if remote:IsA("RemoteFunction") then
                        remote:InvokeServer(unpack(args))
                    elseif remote:IsA("RemoteEvent") then
                        remote:FireServer(unpack(args))
                    end
                end)
                fired = ok or fired
            end
            return fired
        end

        local function isExplosionBindable(instance)
            if typeof(instance) ~= "Instance" or not instance:IsA("BindableFunction") then return false end
            local nameKey = normalizeExplosionName(instance.Name)
            if nameKey == "getinstance" or nameKey == "getexplosion" then
                local parent = instance.Parent
                while parent and parent ~= rs do
                    if normalizeExplosionName(parent.Name):find("explosion", 1, true) then
                        return true
                    end
                    parent = parent.Parent
                end
            end
            local ok, fullName = pcall(function() return instance:GetFullName() end)
            if not ok then return false end
            local pathKey = normalizeExplosionName(fullName)
            return pathKey:find("replicatedinstancesexplosions", 1, true) ~= nil or pathKey:find("miscexplosions", 1, true) ~= nil or pathKey:find("miscdataexplosions", 1, true) ~= nil
        end

        local function installExplosionBindableHook()
            if bindableInvokeHooked then return end
            local hookFunction = getExecutorGlobal("hookfunction") or getExecutorGlobal("hookfunc")
            local makeClosure = getExecutorGlobal("newcclosure") or function(callback) return callback end
            if type(hookFunction) ~= "function" then return end
            local dummyBindable = Instance.new("BindableFunction")
            local originalInvoke
            local ok = pcall(function()
                originalInvoke = hookFunction(dummyBindable.Invoke, makeClosure(function(self, ...)
                    local args = { ... }
                    local localKillWindow = (getgenv()._usExplosionLocalKillUntil or 0) > os.clock()
                    if getgenv().explosionChanger and localKillWindow and isExplosionBindable(self) then
                        local selectedExplosion = getSelectedExplosionName()
                        if selectedExplosion ~= "" then
                            for index, value in ipairs(args) do
                                if type(value) == "string" and not isPlayerString(value) then
                                    args[index] = selectedExplosion
                                    break
                                end
                            end
                            if #args == 0 then
                                args[1] = selectedExplosion
                            end
                        end
                    end
                    return originalInvoke(self, unpack(args))
                end))
            end)
            dummyBindable:Destroy()
            bindableInvokeHooked = ok == true
        end

        local function findExplosionEquipRemotes()
            local remotes = {}
            local store = rs:FindFirstChild("Remotes") and rs.Remotes:FindFirstChild("Store")
            local net = getNetFolder()
            local function addRemote(remote)
                if not remote then return end
                for _, existing in ipairs(remotes) do
                    if existing == remote then return end
                end
                table.insert(remotes, remote)
            end
            if store then
                for _, remoteName in ipairs({
                    "RequestEquipExplosionFX",
                    "RequestEquipExplosion",
                    "RequestEquipExplosionEffect",
                    "RequestEquipExplosionSkin",
                    "RequestEquipKillEffect",
                    "RequestEquipKillExplosion",
                }) do
                    addRemote(store:FindFirstChild(remoteName))
                end
            end
            local netRemote = net and (net:FindFirstChild("RF/RequestEquipExplosion") or net:FindFirstChild("RE/RequestEquipExplosion") or net:FindFirstChild("RF/RequestEquipExplosionFX") or net:FindFirstChild("RE/RequestEquipExplosionFX"))
            addRemote(netRemote)
            if #remotes == 0 then
                for _, obj in ipairs(rs:GetDescendants()) do
                    if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") then
                        local key = obj.Name:lower()
                        if key:find("requestequip", 1, true) and key:find("explosion", 1, true) then
                            addRemote(obj)
                        end
                    end
                end
            end
            return remotes
        end

        local function setExplosionAttributes(explosionName)
            local names = {
                "CurrentlyEquippedExplosion",
                "CurrentlyEquippedExplosionFX",
                "EquippedExplosion",
                "EquippedExplosionFX",
                "SelectedExplosion",
                "SelectedExplosionFX",
                "CurrentExplosion",
                "CurrentExplosionFX",
                "KillEffect",
                "EquippedKillEffect",
            }
            for _, attributeName in ipairs(names) do
                pcall(function() LocalPlayer:SetAttribute(attributeName, explosionName) end)
                if LocalPlayer.Character then
                    pcall(function() LocalPlayer.Character:SetAttribute(attributeName, explosionName) end)
                end
            end
        end

        getgenv().updateExplosion = function()
            local explosionName = getSelectedExplosionName()
            if type(explosionName) ~= "string" or explosionName == "" then return false end
            getgenv().explosionFX = explosionName
            setExplosionAttributes(explosionName)
            if getgenv().saveLastEquippedExplosion then
                getgenv().saveLastEquippedExplosion(explosionName)
            end
            installExplosionBindableHook()
            local fired = false
            for _, remote in ipairs(findExplosionEquipRemotes()) do
                fired = invokeExplosionRemote(remote, explosionName) or fired
            end
            return fired
        end

        getgenv().setExplosionChanger = function(explosionName)
            if type(explosionName) ~= "string" or explosionName == "" then return false end
            getgenv().explosionFX = explosionName
            getgenv().explosionChanger = true
            if getgenv().setExplosionChangerToggleUI then getgenv().setExplosionChangerToggleUI(true) end
            if getgenv().setExplosionInputUI then getgenv().setExplosionInputUI(explosionName) end
            return getgenv().updateExplosion()
        end

        getgenv().testExplosion = function()
            local character = LocalPlayer.Character
            local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
            local camera = workspace.CurrentCamera
            local position = root and (root.Position + root.CFrame.LookVector * 7) or camera and (camera.CFrame.Position + camera.CFrame.LookVector * 12) or Vector3.zero
            return playLocalExplosion(position)
        end

        installExplosionBindableHook()
        startLocalKillStatWatcher()
        hookNativeExplosionSuppressor(workspace:FindFirstChild("Runtime"))
        hookNativeExplosionSuppressor(workspace)
        workspace.ChildAdded:Connect(function(child)
            if child.Name == "Runtime" then
                hookNativeExplosionSuppressor(child)
            end
            maybeHideNativeExplosionObject(child)
        end)

        local function hookDeadFolder()
            if deadFolderHooked then return end
            local deadFolder = workspace:FindFirstChild("Dead")
            if not deadFolder then return end
            deadFolderHooked = true
            deadFolder.ChildAdded:Connect(function(character)
                if not getgenv().explosionChanger and (not getgenv().finisherModel or getgenv().finisherModel == "") then return end
                task.wait(0.05)
                if character == LocalPlayer.Character then return end
                local root = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart)
                if root then
                    local creator = character:FindFirstChild("creator", true) or character:FindFirstChild("Creator", true)
                    local characterPlayer = Players:GetPlayerFromCharacter(character) or Players:FindFirstChild(tostring(character and character.Name or ""))
                    if creator and (creator.Value == LocalPlayer or creator.Value == LocalPlayer.Name) then
                        markLocalKill(root.Position)
                    elseif not characterPlayer then
                        markLocalKill(root.Position)
                    else
                        queueKillExplosion(root.Position)
                    end
                end
            end)
        end

        hookDeadFolder()
        workspace.ChildAdded:Connect(function(child)
            if child.Name == "Dead" then
                deadFolderHooked = false
                task.defer(hookDeadFolder)
            end
        end)

        LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.75)
            if getgenv().explosionChanger and getgenv().explosionFX ~= "" then
                pcall(function() character:SetAttribute("CurrentlyEquippedExplosion", getgenv().explosionFX) end)
                pcall(getgenv().updateExplosion)
            end
        end)

        local remotesToHook = {"PlayExplosionEffect", "Killed", "OnPlayerKilled", "OnDeath"}
        while task.wait(1) do
            if not getgenv().UnlockAllSwords and not getgenv().explosionChanger then
                continue
            end
            local remotesFolder = rs:FindFirstChild("Remotes")
            if remotesFolder then
                for _, remoteName in ipairs(remotesToHook) do
                    local remote = remotesFolder:FindFirstChild(remoteName)
                    if remote and remote:IsA("RemoteEvent") then
                        if not explosionDirectHooked[remote] then
                            explosionDirectHooked[remote] = true
                            remote.OnClientEvent:Connect(function(...)
                                if not getgenv().explosionChanger then return end
                                local rawArgs = { ... }
                                local position = getExplosionPositionFromArgs(rawArgs)
                                local isOurKill = argsIndicateLocalKill(rawArgs, remoteName)
                                if isOurKill then
                                    markLocalKill(position)
                                elseif remoteName ~= "PlayExplosionEffect" then
                                    queueKillExplosion(position)
                                end
                            end)
                        end
                        local ok, connections = pcall(getconnections, remote.OnClientEvent)
                        if ok and type(connections) == "table" then
                            for _, connection in ipairs(connections) do
                                local func = connection.Function
                                if func and not explosionHookedFuncs[func] then
                                    if isourclosure and isourclosure(func) then
                                        explosionHookedFuncs[func] = true
                                        continue
                                    end
                                    explosionHookedFuncs[func] = true
                                    connection:Disable()
                                    local targetFunc = func
                                    local ourFunc
                                    ourFunc = function(...)
                                        local rawArgs = { ... }
                                        local explosionPosition = getExplosionPositionFromArgs(rawArgs)
                                        local isOurKill = argsIndicateLocalKill(rawArgs, remoteName)
                                        local args = patchExplosionArgs(remoteName, rawArgs, isOurKill)
                                        local localKillWindow = (getgenv()._usExplosionLocalKillUntil or 0) > os.clock()
                                        if getgenv().explosionChanger then
                                            if isOurKill then
                                                markLocalKill(explosionPosition)
                                            elseif remoteName ~= "PlayExplosionEffect" then
                                                queueKillExplosion(explosionPosition)
                                            end
                                            if remoteName == "PlayExplosionEffect" and (isOurKill or localKillWindow) then
                                                return
                                            end
                                        end
                                        if setthreadidentity then pcall(setthreadidentity, 2) end
                                        pcall(targetFunc, unpack(args))
                                    end
                                    explosionHookedFuncs[ourFunc] = true
                                    remote.OnClientEvent:Connect(ourFunc)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    getgenv().selectedEmote = getgenv().selectedEmote or ""
    getgenv().emoteVFXEnabled = false
    getgenv().emoteLooped = false

    local emoteState = {
        catalog = {},
        byName = {},
        activeTrack = nil,
        activeSounds = {},
        activeVFX = {},
        playToken = 0,
        destroyed = false,
        emoteWheelEnabled = false,
    }

    local function normalizeEmote(value)
        return tostring(value or ""):lower():gsub("[^%w]", "")
    end

    local function emoteFolders()
        local folders = {}
        local misc = ReplicatedStorage:FindFirstChild("Misc")
        local emotes = misc and misc:FindFirstChild("Emotes")
        if emotes then table.insert(folders, emotes) end
        local shared = ReplicatedStorage:FindFirstChild("Shared")
        local replicatedInstances = ReplicatedStorage:FindFirstChild("ReplicatedInstances") or (shared and shared:FindFirstChild("ReplicatedInstances"))
        if replicatedInstances then
            emotes = replicatedInstances:FindFirstChild("Emotes")
            if emotes and not table.find(folders, emotes) then
                table.insert(folders, emotes)
            end
        end
        return folders
    end

    local function refreshCatalog()
        table.clear(emoteState.catalog)
        table.clear(emoteState.byName)
        for _, folder in ipairs(emoteFolders()) do
            for _, object in ipairs(folder:GetDescendants()) do
                if object:IsA("Animation") then
                    local name = object:GetAttribute("EmoteName") or object.Name
                    if type(name) == "string" and name ~= "" and not emoteState.byName[name] then
                        local entry = {
                            Name = name,
                            Id = object.Name,
                            Animation = object,
                            Attributes = object:GetAttributes(),
                        }
                        emoteState.catalog[#emoteState.catalog + 1] = entry
                        emoteState.byName[name] = entry
                    end
                end
            end
        end
        table.sort(emoteState.catalog, function(left, right)
            return left.Name:lower() < right.Name:lower()
        end)
        local names = {}
        for _, entry in ipairs(emoteState.catalog) do
            names[#names + 1] = entry.Name
        end
        getgenv().emoteNames = names
        return names
    end

    local function resolveEntry(value)
        if not value then return nil end
        if emoteState.byName[value] then return emoteState.byName[value] end
        local wanted = normalizeEmote(value)
        for _, entry in ipairs(emoteState.catalog) do
            if normalizeEmote(entry.Name) == wanted or normalizeEmote(entry.Id) == wanted then
                return entry
            end
        end
        return nil
    end

    local function stopEmote()
        emoteState.playToken = emoteState.playToken + 1
        local track = emoteState.activeTrack
        emoteState.activeTrack = nil
        if track then
            pcall(function()
                track.Looped = false
                track:Stop(0)
            end)
        end
        for _, sound in ipairs(emoteState.activeSounds) do
            pcall(function()
                sound:Stop()
                sound:Destroy()
            end)
        end
        table.clear(emoteState.activeSounds)
        for _, object in ipairs(emoteState.activeVFX) do
            if typeof(object) == "Instance" then
                pcall(function() object:Destroy() end)
            end
        end
        table.clear(emoteState.activeVFX)
    end

    local function playEmote(name)
        stopEmote()
        if #emoteState.catalog == 0 then refreshCatalog() end
        local entry = resolveEntry(name or getgenv().selectedEmote)
        if not entry then return false, "Emote not found" end
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            return false, "Character is not ready"
        end
        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
        local ok, track = pcall(function()
            return animator:LoadAnimation(entry.Animation)
        end)
        if not ok or not track then return false end
        emoteState.playToken = emoteState.playToken + 1
        emoteState.activeTrack = track
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play(0.15)
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, object in ipairs(entry.Animation:GetDescendants()) do
                if object:IsA("Sound") then
                    local sound = object:Clone()
                    sound.Parent = root
                    pcall(function() sound:Play() end)
                    emoteState.activeSounds[#emoteState.activeSounds + 1] = sound
                end
            end
        end
        if getgenv().emoteVFXEnabled then
            local shared = ReplicatedStorage:FindFirstChild("Shared")
            local replicated = ReplicatedStorage:FindFirstChild("ReplicatedInstances") or (shared and shared:FindFirstChild("ReplicatedInstances"))
            local vfxRoot = replicated and (replicated:FindFirstChild("EmoteVFX") or replicated:FindFirstChild("Emotes"))
            if vfxRoot then
                local payload = vfxRoot:FindFirstChild(entry.Id) or vfxRoot:FindFirstChild(entry.Name)
                if payload and not payload:IsA("Animation") then
                    local clone = payload:Clone()
                    clone.Parent = character
                    emoteState.activeVFX[#emoteState.activeVFX + 1] = clone
                end
            end
        end
        return true
    end

    getgenv().refreshBladeBallEmotes = refreshCatalog
    getgenv().playEmote = playEmote
    getgenv().stopEmote = stopEmote
    getgenv().setBladeBallEmoteUnlock = function(enabled)
        getgenv().emoteVFXEnabled = enabled == true
        emoteState.emoteWheelEnabled = enabled == true
        if enabled then
            if #emoteState.catalog == 0 then refreshCatalog() end
        else
            stopEmote()
        end
    end
    getgenv().installBladeBallEmoteWheel = function()
        getgenv().setBladeBallEmoteUnlock(true)
        return true
    end

local function setShopButtonText(button, text)
    if not button then return end
    for _, object in ipairs(button:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            object.Text = text
        end
    end
    if button:IsA("TextButton") then button.Text = text end
end

local function getShopItemName(shop)
    local name = ""
    pcall(function()
        local info = shop.Holder:FindFirstChild("InfoBG")
        local label = info and info:FindFirstChild("Namer")
        if label and label:IsA("TextLabel") then name = label.Text end
    end)
    if name == "" then name = getgenv()._usCurrentInfoItem or "" end
    return name
end

local function getShopItemKind(name)
    local clean = type(name) == "string" and (name:match("^%s*(.-)%s*$") or "") or ""
    if clean ~= "" then
        local canonical = nil
        pcall(function()
            local container = ReplicatedStorage.Shared.ReplicatedInstances.Swords
            local swords = (require :: any)(container)
            if type(swords.GetSword) == "function" and swords:GetSword(clean) ~= nil then
                canonical = clean
            else
                for _, child in ipairs(container:GetChildren()) do
                    if type(child.Name) == "string" and child.Name:lower() == clean:lower() then
                        canonical = child.Name
                        break
                    end
                end
            end
        end)
        if type(canonical) == "string" and canonical ~= "" then
            return "Sword", canonical
        end
        if #emoteState.catalog == 0 then
            pcall(refreshCatalog)
        end
        if resolveEntry(clean) ~= nil then
            return "Emote", clean
        end
        return "Explosion", clean
    end
    return "Explosion", ""
end

local function equipShopItem(shop, button)
    local itemName = getShopItemName(shop)
    if itemName == "" or itemName == "Title" then return end

    local kind, fixedName = getShopItemKind(itemName)
    if type(fixedName) == "string" and fixedName ~= "" then
        itemName = fixedName
    end
    setShopButtonText(button, "Equipped")

    if kind == "Emote" then
        getgenv().selectedEmote = itemName
        getgenv().emoteVFXEnabled = true
        if getgenv().playEmote then task.spawn(getgenv().playEmote, itemName) end
    elseif kind == "Explosion" then
        getgenv().explosionFX = itemName
        getgenv().explosionChanger = true
        if getgenv().updateExplosion then task.spawn(getgenv().updateExplosion) end
    else
        getgenv().swordModel = itemName
        getgenv().swordAnimations = itemName
        getgenv().swordFX = itemName
        getgenv().swordSound = itemName
        getgenv().skinChanger = true
        if getgenv().updateSword then task.spawn(getgenv().updateSword) end
    end

    task.spawn(function()
        local untilTime = os.clock() + 2.5
        while button.Parent and os.clock() < untilTime and getgenv().UnlockAllSwords do
            setShopButtonText(button, "Equipped")
            task.wait(0.05)
        end
    end)
end

local function unlockShopCards(shop)
    if getgenv()._usStandaloneUnlockLoop then return end
    getgenv()._usStandaloneUnlockLoop = true
    getgenv().skinChanger = true
    getgenv().explosionChanger = true

    task.spawn(function()
        while getgenv().UnlockAllSwords do
            local liveShop = (shop and shop.Parent and shop) or LocalPlayer.PlayerGui:FindFirstChild("Shop")
            if not liveShop then
                task.wait(0.5)
            else
                shop = liveShop
                local holder = liveShop:FindFirstChild("Holder")
                local pages = holder and holder:FindFirstChild("Pages")

            local pageList = {}
            if pages then
                for _, page in ipairs(pages:GetChildren()) do
                    if page:IsA("GuiObject") then
                        pageList[#pageList + 1] = page
                    end
                end
            end

            for _, page in ipairs(pageList) do
                local header = page:FindFirstChild("HeaderTitle")
                if header then header.Visible = false end

                for _, child in ipairs(page:GetDescendants()) do
                    if child.Name == "Lock" and child:IsA("GuiObject") then
                        child.Visible = false
                        local card = child.Parent
                        if card and card:IsA("GuiObject") then
                            card.LayoutOrder = 0
                            if card.Parent and card.Parent.Name == "Unowned" then
                                local owned = page:FindFirstChild("Owned", true)
                                if owned and owned:IsA("GuiObject") then card.Parent = owned end
                            end

                            if not card:FindFirstChild("UnlockSuiteStandaloneItemHook") then
                                local tag = Instance.new("BoolValue")
                                tag.Name = "UnlockSuiteStandaloneItemHook"
                                tag.Parent = card

                                local itemName = card.Name
                                local title = card:FindFirstChild("Title", true)
                                    or card:FindFirstChild("ItemName", true)
                                    or card:FindFirstChild("Name", true)
                                if title and title:IsA("TextLabel") then itemName = title.Text end

                                card.InputEnded:Connect(function(input)
                                    if input.UserInputType == Enum.UserInputType.MouseButton1
                                        or input.UserInputType == Enum.UserInputType.Touch then
                                        getgenv()._usCurrentInfoItem = itemName
                                    end
                                end)
                            end
                        end
                    end
                end
            end

            local info = holder and holder:FindFirstChild("InfoBG")
            local button = info and (info:FindFirstChild("BuyButton") or info:FindFirstChild("EquipButton"))
            if not button and info then
                for _, child in ipairs(info:GetChildren()) do
                    if (child:IsA("TextButton") or child:IsA("ImageButton"))
                        and not child.Name:lower():find("close", 1, true) then
                        button = child
                        break
                    end
                end
            end

            if button then
                button.Visible = true
                if not button:FindFirstChild("UnlockSuiteStandaloneEquipHook") then
                    local tag = Instance.new("BoolValue")
                    tag.Name = "UnlockSuiteStandaloneEquipHook"
                    tag.Parent = button
                    button.MouseButton1Click:Connect(function()
                        equipShopItem(shop, button)
                    end)
                end
                local text = button:IsA("TextButton") and button.Text or ""
                if text ~= "Equipped" then setShopButtonText(button, "Equip") end
            end

                task.wait(0.15)
            end
        end
        getgenv()._usStandaloneUnlockLoop = false
    end)
end

local function enableEverything()
    getgenv().skinChanger = true
    getgenv().explosionChanger = true
    local shop = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Shop")
    if shop then
        unlockShopCards(shop)
    else
        task.spawn(function()
            local found = LocalPlayer.PlayerGui:WaitForChild("Shop", 15)
            if found and getgenv().UnlockAllSwords then unlockShopCards(found) end
        end)
    end

    if getgenv().setBladeBallEmoteUnlock then
        getgenv().setBladeBallEmoteUnlock(true)
    else
        getgenv().emoteVFXEnabled = true
    end

    task.spawn(function()
        task.wait(0.2)
        if getgenv().refreshBladeBallEmotes then
            pcall(getgenv().refreshBladeBallEmotes)
        end
        task.wait(0.3)
        if getgenv().refreshBladeBallEmotes then
            pcall(getgenv().refreshBladeBallEmotes)
        end
        if getgenv().installBladeBallEmoteWheel then
            pcall(getgenv().installBladeBallEmoteWheel)
        end
    end)
end

    getgenv()._usEnableUnlockAll = enableEverything
    getgenv()._usStopUnlockAll = function()
        getgenv().UnlockAllSwords = false
        getgenv().explosionChanger = false
        local originalSword = getgenv()._usStartupSword
        if type(originalSword) == "string" and originalSword ~= "" then
            getgenv().swordModel = originalSword
            getgenv().swordAnimations = originalSword
            getgenv().swordFX = originalSword
            getgenv().swordSound = originalSword
            getgenv().skinChanger = true
            if type(getgenv().updateSword) == "function" then
                pcall(getgenv().updateSword)
            end
            task.delay(0.6, function()
                if getgenv().UnlockAllSwords ~= true then
                    getgenv().skinChanger = false
                end
            end)
        else
            getgenv().skinChanger = false
        end
        getgenv().emoteVFXEnabled = false
        if type(getgenv().setBladeBallEmoteUnlock) == "function" then
            pcall(getgenv().setBladeBallEmoteUnlock, false)
        end
        if type(getgenv().stopEmote) == "function" then
            pcall(getgenv().stopEmote)
        end
    end
    if getgenv().UnlockAllSwords then
        enableEverything()
    end
end

-- Unlock All removed

-- Skin Changer (ported from Vanish Private.lua, adapted to SwordTab UI)
if getgenv().skinChangerEnabled == nil then getgenv().skinChangerEnabled = false end
if type(getgenv().swordModel) ~= "string" then getgenv().swordModel = "" end
if type(getgenv().swordAnimations) ~= "string" then getgenv().swordAnimations = getgenv().swordModel end
if type(getgenv().swordFX) ~= "string" then getgenv().swordFX = getgenv().swordModel end
if type(getgenv().slashName) ~= "string" or getgenv().slashName == "" then getgenv().slashName = "SlashEffect" end
if type(getgenv()._realEquippedSword) ~= "string" or getgenv()._realEquippedSword == "" then getgenv()._realEquippedSword = "Default" end

local VSK_swordInstances
local function VSK_getSwordInstances()
    if VSK_swordInstances then return VSK_swordInstances end
    local shared = ReplicatedStorage:FindFirstChild("Shared")
    if not shared then return nil end
    local rep = shared:FindFirstChild("ReplicatedInstances")
    if not rep then return nil end
    local swords = rep:FindFirstChild("Swords")
    if not swords then return nil end
    local ok, mod = pcall(require, swords)
    if ok then VSK_swordInstances = mod end
    return VSK_swordInstances
end

local VSK_swordsController
task.spawn(function()
    while task.wait() and not VSK_swordsController do
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local fireInfo = remotes and remotes:FindFirstChild("FireSwordInfo")
        if not (fireInfo and getconnections) then
            task.wait(0.5)
            continue
        end
        local ok, conns = pcall(getconnections, fireInfo.OnClientEvent)
        if ok and conns then
            for _, v in ipairs(conns) do
                if v.Function and islclosure and islclosure(v.Function) then
                    local ok2, upvalues = pcall(getupvalues, v.Function)
                    if ok2 and #upvalues == 1 and type(upvalues[1]) == "table" then
                        VSK_swordsController = upvalues[1]
                        break
                    end
                end
            end
        end
    end
end)

local function VSK_getSlashName(swordName)
    local instances = VSK_getSwordInstances()
    if not instances then return "SlashEffect" end
    local ok, s = pcall(function() return instances:GetSword(swordName) end)
    return (ok and s and s.SlashName) or "SlashEffect"
end

local function VSK_isOfficialSword(swordName)
    if type(swordName) ~= "string" or swordName == "" then return false end
    local instances = VSK_getSwordInstances()
    if not instances then return false end
    local ok, s = pcall(function() return instances:GetSword(swordName) end)
    return (ok and s) and true or false
end

local function VSK_refreshSlashName()
    local fx = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
    getgenv().slashName = fx ~= "" and VSK_getSlashName(fx) or "SlashEffect"
end

local function VSK_getRealEquippedSword()
    local attr = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
    local custom = getgenv().swordModel
    if type(attr) == "string" and attr ~= "" and attr ~= custom then return attr end
    if type(getgenv()._realEquippedSword) == "string" and getgenv()._realEquippedSword ~= "" then return getgenv()._realEquippedSword end
    return "Default"
end

local function VSK_cacheRealSword()
    if getgenv().skinChangerEnabled then return end
    local real = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
    if type(real) == "string" and real ~= "" then getgenv()._realEquippedSword = real end
end

local function VSK_equipSwordOnCharacter(swordName)
    if not LocalPlayer.Character or type(swordName) ~= "string" or swordName == "" then return end
    local instances = VSK_getSwordInstances()
    if not instances then return end
    pcall(function()
        local f = rawget(instances, "EquipSwordTo")
        if type(f) == "function" and getupvalues and setupvalue then
            for i, v in ipairs(getupvalues(f)) do
                if type(v) == "boolean" then setupvalue(f, i, false); break end
            end
        end
        instances:EquipSwordTo(LocalPlayer.Character, swordName)
    end)
end

local function VSK_applyControllerSword(name)
    task.spawn(function()
        local att = 0
        while not VSK_swordsController and att < 20 do task.wait(0.5); att = att + 1 end
        if not VSK_swordsController then return end
        pcall(function()
            if VSK_swordsController.SetSword then VSK_swordsController:SetSword(name) end
            if ReplicatedStorage.Remotes:FindFirstChild("FireSwordInfo") then
                ReplicatedStorage.Remotes.FireSwordInfo:FireServer(name)
            end
            if VSK_swordsController.currentSword ~= nil then VSK_swordsController.currentSword = name end
            if VSK_swordsController.SwordFX ~= nil then VSK_swordsController.SwordFX = name end
        end)
    end)
end

local function VSK_removeCustomSwordModel(keepName)
    local custom = getgenv().swordModel
    local char = LocalPlayer.Character
    if not char or type(custom) ~= "string" or custom == "" then return end
    if keepName and custom == keepName then return end
    pcall(function()
        local model = char:FindFirstChild(custom)
        if model then model:Destroy() end
    end)
end

local function VSK_setCustomSword()
    if not getgenv().skinChangerEnabled or not LocalPlayer.Character then return end
    local name = getgenv().swordModel
    if name == "" then return end
    VSK_cacheRealSword()
    VSK_refreshSlashName()
    VSK_equipSwordOnCharacter(name)
    VSK_applyControllerSword(name)
end

local function VSK_equipBaseSword()
    local char = LocalPlayer.Character
    if not char then return end
    local base = VSK_getRealEquippedSword()
    getgenv().slashName = VSK_getSlashName(base)
    VSK_equipSwordOnCharacter(base)
    VSK_applyControllerSword(base)
    task.wait(0.15)
    VSK_removeCustomSwordModel(base)
    if not char:FindFirstChild(base) then
        VSK_equipSwordOnCharacter(base)
        VSK_applyControllerSword(base)
    end
end

getgenv().updateSword = function()
    if getgenv().skinChangerEnabled and getgenv().swordModel ~= "" then
        VSK_setCustomSword()
    else
        VSK_equipBaseSword()
    end
end

pcall(function()
    LocalPlayer:GetAttributeChangedSignal("CurrentlyEquippedSword"):Connect(function() VSK_cacheRealSword() end)
end)
task.defer(VSK_cacheRealSword)

local VSK_fxHookedFuncs = {}
task.spawn(function()
    while task.wait(1) do
        if getgenv().skinChangerEnabled and getgenv().swordModel ~= "" and getconnections then
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local parrySuccessAll = remotes and remotes:FindFirstChild("ParrySuccessAll")
            if parrySuccessAll then
                local ok, conns = pcall(getconnections, parrySuccessAll.OnClientEvent)
                if ok and type(conns) == "table" then
                    for _, v in ipairs(conns) do
                        local func = v.Function
                        if func and not VSK_fxHookedFuncs[func] then
                            if isourclosure and isourclosure(func) then
                                VSK_fxHookedFuncs[func] = true
                            else
                                VSK_fxHookedFuncs[func] = true
                                pcall(function() v:Disable() end)
                                local tf = func
                                local of
                                of = function(...)
                                    local args = {...}
                                    local is_me = false
                                    local n = select("#", ...)
                                    if n >= 4 and typeof(args[4]) == "Instance" and args[4]:IsA("Player") then
                                        is_me = args[4] == LocalPlayer
                                    elseif tostring(args[4]) == LocalPlayer.Name then
                                        is_me = true
                                    end
                                    if not is_me then
                                        local char = LocalPlayer.Character
                                        if char and typeof(args[2]) == "Instance" then
                                            is_me = args[2] == char or args[2].Parent == char
                                        end
                                    end
                                    if is_me and getgenv().skinChangerEnabled then
                                        VSK_refreshSlashName()
                                        args[1] = getgenv().slashName
                                        local customFX = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                                        if VSK_isOfficialSword(customFX) then
                                            args[3] = customFX
                                        end
                                    end
                                    if setthreadidentity then pcall(setthreadidentity, 2) end
                                    pcall(tf, unpack(args))
                                end
                                VSK_fxHookedFuncs[of] = true
                                parrySuccessAll.OnClientEvent:Connect(of)
                            end
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        local char = LocalPlayer.Character
        if char then
            if getgenv().skinChangerEnabled and getgenv().swordModel ~= "" then
                if LocalPlayer:GetAttribute("CurrentlyEquippedSword") ~= getgenv().swordModel or not char:FindFirstChild(getgenv().swordModel) then
                    VSK_setCustomSword()
                end
                for _, v in char:GetChildren() do
                    if v:IsA("Model") and v.Name ~= getgenv().swordModel then
                        local base = VSK_getRealEquippedSword()
                        if v.Name ~= base then v:Destroy() end
                    end
                end
            else
                local base = VSK_getRealEquippedSword()
                local custom = getgenv().swordModel
                if custom ~= "" and custom ~= base and char:FindFirstChild(custom) then
                    VSK_removeCustomSwordModel(base)
                end
                if base ~= "" and not char:FindFirstChild(base) then
                    VSK_equipBaseSword()
                end
            end
        end
    end
end)

pcall(function()
    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid", 10)
        task.wait(2)
        if not LocalPlayer.Character or LocalPlayer.Character ~= char then return end
        if getgenv().skinChangerEnabled and getgenv().swordModel ~= "" then
            VSK_setCustomSword()
        else
            VSK_equipBaseSword()
        end
    end)
end)

local function VSK_applySwordNameInput(rawText)
    local name = tostring(rawText or ""):gsub("^%s+", ""):gsub("%s+$", "")
    getgenv().swordModel = name
    getgenv().swordAnimations = name
    getgenv().swordFX = name
    VSK_refreshSlashName()
    if getgenv().skinChangerEnabled and name ~= "" then getgenv().updateSword() end
    return name
end

local function VSK_setSkinChangerEnabled(enabled)
    if enabled then
        VSK_cacheRealSword()
        getgenv().skinChangerEnabled = true
        getgenv().updateSword()
    else
        local attr = LocalPlayer:GetAttribute("CurrentlyEquippedSword")
        local custom = getgenv().swordModel
        if type(attr) == "string" and attr ~= "" and attr ~= custom then getgenv()._realEquippedSword = attr end
        getgenv().skinChangerEnabled = false
        VSK_equipBaseSword()
    end
end

pcall(raise_plugin)

getgenv()._VSK_BuildingUI = true
local skin_changer_module
for _ = 1, 3 do
    pcall(raise_plugin)
    pcall(function()
        if not skin_changer_module then
            skin_changer_module = SwordTab:create_module({
                title = "Skin Changer",
                description = "Equip a different sword.",
                flag = "SkinChangerModule",
                section = "left",
                callback = function(state)
                    VSK_setSkinChangerEnabled(toggle_state(state))
                end,
            })
        end
    end)
    if skin_changer_module then break end
    task.wait(0.5)
end
if skin_changer_module then
    local skin_box_built = false
    for _ = 1, 3 do
        pcall(raise_plugin)
        pcall(function()
            local box = skin_changer_module:create_textbox({
                title = "Model Name",
                flag = "SkinChangerSwordBox",
                placeholder = "Enter model name...",
                default = getgenv().swordModel or "",
                callback = function(text)
                    if getgenv()._VSK_BuildingUI then
                        task.defer(function()
                            task.wait(2)
                            pcall(VSK_applySwordNameInput, text)
                        end)
                        return
                    end
                    VSK_applySwordNameInput(text)
                end
            })
            if box then skin_box_built = true end
        end)
        if skin_box_built then break end
        task.wait(0.5)
    end
end
getgenv()._VSK_BuildingUI = false

pcall(function()
    local headless_module = VisualsTab:create_module({
        title = "Cosmetics",
        description = "Apply Headless and Korblox",
        flag = "HeadlessKorbloxModule",
        section = "left",
        callback = function(state)
            state = toggle_state(state)
            getgenv().HeadlessKorbloxEnabled = state
            local char = LocalPlayer.Character
            if char then
                if state then
                    pcall(function() Byte_Library.Headless(char); Byte_Library.Korblox(char) end)
                else
                    pcall(function() Byte_Library.Restore_Head(char); Byte_Library.Restore_Leg(char) end)
                end
            end
            pcall(headlessKorblox_updateConn)
        end
    })
end)

pcall(function()
    local no_render_module = VisualsTab:create_module({
        title = "No Render",
        description = "Disables rendering of effects",
        flag = "NoRenderModule",
        section = "right",
        callback = function(state)
            state = toggle_state(state)
            if getgenv()._Vanish_SetNoRender then
                getgenv()._Vanish_SetNoRender(state)
            else
                getgenv().NoRender = state
            end
        end
    })
end)

pcall(function()
    local immortality_module = BlatantTab:create_module({
        title = "Desync Character",
        description = "Makes your rig unkillable",
        flag = "SemiImmortalityModule",
        section = "left",
        callback = function(state)
            state = toggle_state(state)
            getgenv().SemiImmortalityEnabled = state
            if getgenv().SemiImmortalitySetEnabled then
                local ok = getgenv().SemiImmortalitySetEnabled(state)
                if state and not ok then
                    getgenv().SemiImmortalityEnabled = false
                end
            end
        end
    })
    if Library._config and Library._config._flags and Library._config._flags.SemiImmortalitySpeedBypass == nil then
        Library._config._flags.SemiImmortalitySpeedBypass = true
        if getgenv().SemiImmortalityConfig then
            getgenv().SemiImmortalityConfig.SpeedBypassEnabled = true
        end
    end
    immortality_module:create_checkbox({
        title = "Bypass Speed",
        flag = "SemiImmortalitySpeedBypass",
        callback = function(state)
            if type(getgenv().SemiImmortalityConfig) ~= "table" then
                getgenv().SemiImmortalityConfig = {}
            end
            getgenv().SemiImmortalityConfig.SpeedBypassEnabled = toggle_state(state)
        end
    })
    immortality_module:create_slider({
        title = "Desync Height",
        flag = "SemiImmortalityHeight",
        minimum_value = 1,
        maximum_value = 10,
        value = math.clamp(tonumber((getgenv().SemiImmortalityConfig and getgenv().SemiImmortalityConfig.Height) or 8) or 8, 1, 10),
        round_number = true,
        callback = function(value)
            if type(getgenv().SemiImmortalityConfig) ~= "table" then
                getgenv().SemiImmortalityConfig = {}
            end
            getgenv().SemiImmortalityConfig.Height = math.clamp(tonumber(value) or 8, 1, 10)
        end
    })
end)

pcall(function()
    local fov_module = MiscTab:create_module({
        title = "Field of View",
        description = "changes camera field of view",
        flag = "FovModule",
        section = "left",
        callback = function(state)
            if getgenv()._Vanish_ApplyFov then
                getgenv()._Vanish_ApplyFov(toggle_state(state), getgenv().CustomFov)
            else
                getgenv().FovEnabled = toggle_state(state)
            end
        end
    })
    fov_module:create_slider({
        title = "FOV",
        flag = "CustomFov",
        maximum_value = 120,
        minimum_value = 40,
        value = 70,
        round_number = true,
        callback = function(value)
            local fov = tonumber(value) or 70
            getgenv().CustomFov = fov
            if getgenv().FovEnabled and getgenv()._Vanish_ApplyFov then
                getgenv()._Vanish_ApplyFov(true, fov)
            elseif getgenv().FovEnabled then
                local cam = workspace.CurrentCamera
                if cam then
                    cam.FieldOfView = fov
                end
            end
        end
    })

    local move_module = MiscTab:create_module({
        title = "Walkspeed",
        description = "Sets your walk speed",
        flag = "WalkspeedModule",
        section = "left",
        callback = function(state)
            getgenv().WalkspeedEnabled = toggle_state(state)
            pcall(getgenv()._Vanish_ApplyMovement)
        end
    })
    move_module:create_slider({
        title = "Speed",
        flag = "CustomWalkSpeed",
        maximum_value = 250,
        minimum_value = 16,
        value = 36,
        round_number = true,
        callback = function(value)
            getgenv().CustomWalkSpeed = tonumber(value) or 36
            pcall(getgenv()._Vanish_ApplyMovement)
        end
    })

    local jump_module = MiscTab:create_module({
        title = "Jump Power",
        description = "Sets your jump power",
        flag = "JumpPowerModule",
        section = "left",
        callback = function(state)
            getgenv().JumpPowerEnabled = toggle_state(state)
            pcall(getgenv()._Vanish_ApplyMovement)
        end
    })
    jump_module:create_slider({
        title = "Power",
        flag = "CustomJumpPower",
        maximum_value = 400,
        minimum_value = 50,
        value = 50,
        round_number = true,
        callback = function(value)
            getgenv().CustomJumpPower = tonumber(value) or 50
            pcall(getgenv()._Vanish_ApplyMovement)
        end
    })

    local infjump_module = MiscTab:create_module({
        title = "Infinite Jump",
        description = "Jump again while in the air",
        flag = "InfJumpModule",
        section = "right",
        callback = function(state)
            getgenv().InfJumpEnabled = toggle_state(state)
        end
    })

    local soundOptions = {
        Eeyuh = "rbxassetid://16190782181",
        ["Sour Grapes"] = "rbxassetid://117820392172291",
        Erwachen = "rbxassetid://124853612881772",
        ["Grasp the Light"] = "rbxassetid://89549155689397",
        ["Beyond the Shadows"] = "rbxassetid://120729792529978",
        ["Rise to the Horizon"] = "rbxassetid://72573266268313",
        ["Lo-fi Chill A"] = "rbxassetid://9043887091",
        ["Lo-fi Ambient"] = "rbxassetid://129775776987523",
        ["Tears in the Rain"] = "rbxassetid://129710845038263",
    }
    local soundOptionNames = {
        "Eeyuh",
        "Sour Grapes",
        "Erwachen",
        "Grasp the Light",
        "Beyond the Shadows",
        "Rise to the Horizon",
        "Lo-fi Chill A",
        "Lo-fi Ambient",
        "Tears in the Rain",
    }

    getgenv().sound_controller = getgenv().sound_controller == true
    getgenv().LoopSong = getgenv().LoopSong == true
    getgenv().SoundControllerVolume = tonumber(getgenv().SoundControllerVolume) or 3
    getgenv().SelectedSound = getgenv().SelectedSound or soundOptionNames[1]

    pcall(function()
        local old = SoundService:FindFirstChild("VanishSoundController")
        if old then old:Destroy() end
    end)

    local currentSound = Instance.new("Sound")
    currentSound.Name = "VanishSoundController"
    currentSound.Volume = getgenv().SoundControllerVolume
    currentSound.Looped = getgenv().LoopSong
    currentSound.Parent = SoundService

    local selectedSound = getgenv().SelectedSound
    if not soundOptions[selectedSound] then
        selectedSound = soundOptionNames[1]
        getgenv().SelectedSound = selectedSound
    end

    local function get_sound_id(optionName)
        optionName = dropdown_value(optionName) or optionName
        if type(optionName) == "string" and soundOptions[optionName] then
            return soundOptions[optionName]
        end
        return soundOptions[selectedSound] or soundOptions.Eeyuh
    end

    local function play_sound_by_id(soundId)
        if not soundId then
            return
        end
        pcall(function()
            currentSound:Stop()
            currentSound.SoundId = soundId
            currentSound:Play()
        end)
    end

    getgenv()._Vanish_StopSoundController = function()
        pcall(function()
            currentSound:Stop()
        end)
        getgenv().sound_controller = false
    end

    local sound_controller_module = MiscTab:create_module({
        title = "Sound Controller",
        description = "Control background music and sounds",
        flag = "SoundControllerModule",
        section = "right",
        callback = function(state)
            state = toggle_state(state)
            getgenv().sound_controller = state
            if state then
                play_sound_by_id(get_sound_id(selectedSound))
            else
                pcall(function()
                    currentSound:Stop()
                end)
            end
        end
    })

    sound_controller_module:create_checkbox({
        title = "Loop Song",
        flag = "LoopSong",
        callback = function(value)
            getgenv().LoopSong = toggle_state(value)
            currentSound.Looped = getgenv().LoopSong
        end
    })

    sound_controller_module:create_slider({
        title = "Volume",
        flag = "SoundControllerVolume",
        minimum_value = 1,
        maximum_value = 10,
        value = getgenv().SoundControllerVolume or 3,
        round_number = true,
        callback = function(value)
            value = math.clamp(tonumber(value) or 3, 1, 10)
            getgenv().SoundControllerVolume = value
            currentSound.Volume = value
        end
    })

    sound_controller_module:create_dropdown({
        title = "Select Music",
        flag = "SoundSelection",
        options = soundOptionNames,
        maximum_options = #soundOptionNames,
        callback = function(value)
            value = dropdown_value(value) or value
            if type(value) ~= "string" or not soundOptions[value] then
                return
            end
            getgenv().SelectedSound = value
            selectedSound = value
            if getgenv().sound_controller then
                play_sound_by_id(get_sound_id(value))
            end
        end
    })


    local ping_spoofer_connection = nil
    local ping_spoofer_enabled = false
    getgenv().FakePingValue = tonumber(getgenv().FakePingValue) or 999

    local function ensure_fake_ping_label(robloxGui)
        local label = robloxGui:FindFirstChild("FakePingLabel")
        if label then
            return label
        end
        label = Instance.new("TextLabel")
        label.Name = "FakePingLabel"
        label.AnchorPoint = Vector2.new(1, 0)
        label.Position = UDim2.new(1, -16, 0, 52)
        label.Size = UDim2.new(0, 126, 0, 30)
        label.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
        label.BackgroundTransparency = 0.1
        label.BorderSizePixel = 0
        label.Font = Enum.Font.GothamMedium
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.ZIndex = 999999
        label.Parent = robloxGui
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = label
        return label
    end

    local function spoof_ping_display()
        if not ping_spoofer_enabled then
            return
        end
        local fake_ping = tonumber(getgenv().FakePingValue)
            or tonumber(Library._config and Library._config._flags and Library._config._flags.PingSpoofValue)
            or 999
        fake_ping = tostring(math.max(0, math.floor(fake_ping)))

        local robloxGui = CoreGui:FindFirstChild("RobloxGui")
        if not robloxGui then
            return
        end

        local fakePingLabel = ensure_fake_ping_label(robloxGui)
        fakePingLabel.Text = "Ping " .. fake_ping .. " ms"

        local perfStats = robloxGui:FindFirstChild("PerformanceStats", true)
        if not perfStats then
            return
        end
        for _, descendant in ipairs(perfStats:GetDescendants()) do
            if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                local text = tostring(descendant.Text or "")
                local name = string.lower(descendant.Name or "")
                local parentName = descendant.Parent and string.lower(descendant.Parent.Name or "") or ""
                if name:find("ping", 1, true)
                    or parentName:find("ping", 1, true)
                    or text:match("^%s*%d+%.?%d*%s*ms%s*$") then
                    descendant.Text = fake_ping .. " ms"
                end
            end
        end
    end

    getgenv()._Vanish_StopPingSpoofer = function()
        ping_spoofer_enabled = false
        if ping_spoofer_connection then
            pcall(function()
                ping_spoofer_connection:Disconnect()
            end)
            ping_spoofer_connection = nil
        end
        pcall(function()
            local robloxGui = CoreGui:FindFirstChild("RobloxGui")
            local label = robloxGui and robloxGui:FindFirstChild("FakePingLabel")
            if label then
                label:Destroy()
            end
        end)
    end

    local ping_spoofer_module = MiscTab:create_module({
        title = "Ping Spoofer",
        description = "Locks your Ping Display to a Fake Number",
        flag = "PingSpooferModule",
        section = "left",
        callback = function(state)
            state = toggle_state(state)
            ping_spoofer_enabled = state
            getgenv().PingSpooferEnabled = state
            if state then
                if not ping_spoofer_connection then
                    ping_spoofer_connection = RunService.RenderStepped:Connect(spoof_ping_display)
                end
                spoof_ping_display()
            else
                if getgenv()._Vanish_StopPingSpoofer then
                    getgenv()._Vanish_StopPingSpoofer()
                end
            end
        end
    })

    ping_spoofer_module:create_textbox({
        title = "Ping Value",
        placeholder = "Enter Fake Ping Number",
        flag = "PingSpoofValue",
        callback = function(value)
            local fake_ping = tonumber(value)
            if fake_ping and fake_ping >= 0 then
                fake_ping = math.floor(fake_ping)
                getgenv().FakePingValue = fake_ping
                if Library._config and Library._config._flags then
                    Library._config._flags.PingSpoofValue = tostring(fake_ping)
                end
                if ping_spoofer_enabled then
                    spoof_ping_display()
                end
            end
        end
    })


    local name_spoof_running = false
    local name_spoof_config = {
        FakeName = ".gg/ROMU",
        FakeDisplay = ".gg/ROMU",
        Badge = utf8.char(0xE000),
        Separator = " ",
    }
    getgenv().NameSpoofEnabled = false
    getgenv()._ZX_NameSpoofEnabled = false

    local name_spoof_real_name = LocalPlayer.Name
    local name_spoof_real_display = LocalPlayer.DisplayName
    local name_spoof_target_name = name_spoof_config.FakeName
    local name_spoof_target_display = name_spoof_config.FakeDisplay
        .. name_spoof_config.Separator
        .. name_spoof_config.Badge

    local function name_spoof_and_badge(obj)
        if not getgenv().NameSpoofEnabled then
            return
        end
        if not obj.Text or obj.Text == "" then
            return
        end
        local text = obj.Text
        if text:find(name_spoof_config.FakeDisplay .. name_spoof_config.Separator .. name_spoof_config.Badge, 1, true) then
            return
        end
        if text == name_spoof_config.FakeDisplay then
            obj.Text = name_spoof_target_display
            return
        end
        if text == name_spoof_config.FakeName then
            return
        end
        local new_text = text
        if new_text:find(name_spoof_real_display, 1, true) then
            new_text = new_text:gsub(name_spoof_real_display, name_spoof_target_display)
        end
        if new_text:find(name_spoof_real_name, 1, true) then
            new_text = new_text:gsub(name_spoof_real_name, name_spoof_target_name)
        end
        if new_text ~= obj.Text then
            obj.Text = new_text
        end
    end

    local function name_spoof_monitor_object(obj)
        if not getgenv().NameSpoofEnabled then
            return
        end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            name_spoof_and_badge(obj)
            obj:GetPropertyChangedSignal("Text"):Connect(function()
                name_spoof_and_badge(obj)
            end)
        end
    end

    local function name_spoof_monitor_billboard(billboard)
        if not getgenv().NameSpoofEnabled then
            return
        end
        for _, text_obj in pairs(billboard:GetDescendants()) do
            if text_obj:IsA("TextLabel") then
                local txt = text_obj.Text
                if txt:find(name_spoof_real_display, 1, true)
                    or txt:find(name_spoof_config.FakeDisplay, 1, true)
                    or txt:find(name_spoof_real_name, 1, true)
                    or txt:find(name_spoof_config.FakeName, 1, true) then
                    text_obj.Text = name_spoof_target_display
                end
                text_obj:GetPropertyChangedSignal("Text"):Connect(function()
                    if getgenv().NameSpoofEnabled and text_obj.Text ~= name_spoof_target_display then
                        text_obj.Text = name_spoof_target_display
                    end
                end)
            end
        end
        billboard.DescendantAdded:Connect(function(obj)
            if not getgenv().NameSpoofEnabled then
                return
            end
            if obj:IsA("TextLabel") then
                obj.Text = name_spoof_target_display
                obj:GetPropertyChangedSignal("Text"):Connect(function()
                    if getgenv().NameSpoofEnabled and obj.Text ~= name_spoof_target_display then
                        obj.Text = name_spoof_target_display
                    end
                end)
            end
        end)
    end

    local function name_spoof_monitor_character(char)
        if not getgenv().NameSpoofEnabled then
            return
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 2)
        if humanoid then
            humanoid.DisplayName = name_spoof_target_display
            humanoid:GetPropertyChangedSignal("DisplayName"):Connect(function()
                if getgenv().NameSpoofEnabled and humanoid.DisplayName ~= name_spoof_target_display then
                    humanoid.DisplayName = name_spoof_target_display
                end
            end)
        end
        task.wait(0.5)
        for _, billboard in pairs(char:GetDescendants()) do
            if billboard:IsA("BillboardGui") then
                name_spoof_monitor_billboard(billboard)
            end
        end
    end

    local function name_spoof_start_loop()
        if name_spoof_running then
            return
        end
        name_spoof_running = true
        task.spawn(function()
            while name_spoof_running do
                task.wait(2)
                if getgenv().NameSpoofEnabled then
                    pcall(function()
                        for _, v in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
                            name_spoof_monitor_object(v)
                        end
                    end)
                    pcall(function()
                        for _, v in ipairs(CoreGui:GetDescendants()) do
                            name_spoof_monitor_object(v)
                        end
                    end)
                    if LocalPlayer.Character then
                        pcall(function()
                            name_spoof_monitor_character(LocalPlayer.Character)
                        end)
                    end
                    pcall(function()
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BillboardGui") then
                                for _, text_obj in pairs(obj:GetDescendants()) do
                                    if text_obj:IsA("TextLabel") then
                                        local txt = text_obj.Text
                                        if txt:find(name_spoof_real_name, 1, true)
                                            or txt:find(name_spoof_real_display, 1, true)
                                            or txt:find(name_spoof_config.FakeName, 1, true)
                                            or txt:find(name_spoof_config.FakeDisplay, 1, true) then
                                            name_spoof_monitor_billboard(obj)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end

    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.OnIncomingMessage = function(message)
                if not getgenv().NameSpoofEnabled then
                    return nil
                end
                local props = Instance.new("TextChatMessageProperties")
                if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
                    props.PrefixText = name_spoof_target_display
                end
                return props
            end
        end
    end)

    getgenv()._Vanish_StopNameSpoof = function()
        getgenv().NameSpoofEnabled = false
        getgenv()._ZX_NameSpoofEnabled = false
        name_spoof_running = false
        pcall(function()
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.DisplayName = name_spoof_real_display
            end
        end)
    end

    local name_spoof_module = MiscTab:create_module({
        title = "Name Spoof",
        description = "Spoof your display name with verified badge",
        flag = "NameSpoofModule",
        section = "left",
        callback = function(state)
            state = toggle_state(state)
            getgenv().NameSpoofEnabled = state
            getgenv()._ZX_NameSpoofEnabled = state
            if state then
                name_spoof_start_loop()
                if LocalPlayer.Character then
                    pcall(function()
                        name_spoof_monitor_character(LocalPlayer.Character)
                    end)
                end
            else
                if getgenv()._Vanish_StopNameSpoof then
                    getgenv()._Vanish_StopNameSpoof()
                end
            end
        end
    })

    name_spoof_module:create_textbox({
        title = "Spoofed Name",
        placeholder = "Enter fake name...",
        flag = "NameSpoofValue",
        callback = function(value)
            value = tostring(value or "")
            if value == "" then
                return
            end
            name_spoof_config.FakeName = value
            name_spoof_config.FakeDisplay = value
            name_spoof_target_name = value
            name_spoof_target_display = value .. name_spoof_config.Separator .. name_spoof_config.Badge
            if Library._config and Library._config._flags then
                Library._config._flags.NameSpoofValue = value
            end
        end
    })

end)

pcall(function()
    local ability_esp_module = VisualsTab:create_module({
        title = "Ability ESP",
        description = "Displays equipped abilities over players",
        flag = "AbilityESPModule",
        section = "left",
        callback = function(state)
            if not ability_esp then
                return
            end
            if toggle_state(state) then
                ability_esp.start()
            else
                ability_esp.stop()
            end
        end
    })
    ability_esp_module:create_checkbox({
        title = "Show Platform",
        flag = "ShowPlatformESP",
        callback = function(state)
            getgenv().ShowPlatformESP = toggle_state(state)
        end
    })
    ability_esp_module:create_checkbox({
        title = "Ability Visualizer",
        flag = "AbilityVisualizer",
        callback = function(state)
            getgenv().AbilityVisualizer = toggle_state(state)
        end
    })
    ability_esp_module:create_checkbox({
        title = "Show Cooldown",
        flag = "AbilityESPShowCooldown",
        callback = function(state)
            getgenv().AbilityESPShowCooldown = toggle_state(state)
        end
    })
end)

pcall(function()
    local ball_trail_module = VisualsTab:create_module({
        title = "Ball Trail",
        description = "trails on the ball",
        flag = "BallTrailModule",
        section = "left",
        callback = function(state)
            if toggle_state(state) then
                if getgenv()._VanishBallTrailStart then
                    getgenv()._VanishBallTrailStart()
                end
            else
                if getgenv()._VanishBallTrailStop then
                    getgenv()._VanishBallTrailStop()
                end
            end
        end
    })
    ball_trail_module:create_slider({
        title = "Trail Count",
        flag = "BallTrailCount",
        value = 5,
        minimum_value = 1,
        maximum_value = 5,
        round_number = true,
        callback = function(value)
            getgenv().BallTrailCount = tonumber(value) or 5
            if getgenv()._VanishBallTrailSetCount then
                getgenv()._VanishBallTrailSetCount(value)
            end
        end
    })
end)

pcall(function()
    local ball_indicator_module = VisualsTab:create_module({
        title = "Ball Indicator",
        description = "shows ball direction on screen",
        flag = "BallIndicatorModule",
        section = "right",
        callback = function(state)
            if toggle_state(state) then
                if getgenv()._VanishBallIndicatorStart then
                    getgenv()._VanishBallIndicatorStart()
                end
            else
                if getgenv()._VanishBallIndicatorStop then
                    getgenv()._VanishBallIndicatorStop()
                end
            end
        end
    })
end)

pcall(function()
    local ranked_esp = {
        enabled = false,
        conn = nil,
        labels = {},
    }
    local RANK_LADDER = {
        { min = 2000, name = "Champion", color = Color3.fromRGB(255, 214, 120) },
        { min = 1500, name = "Grandmaster", color = Color3.fromRGB(255, 80, 80) },
        { min = 1250, name = "Master", color = Color3.fromRGB(176, 96, 255) },
        { min = 1000, name = "Diamond", color = Color3.fromRGB(90, 170, 255) },
        { min = 750, name = "Platinum", color = Color3.fromRGB(80, 214, 196) },
        { min = 500, name = "Gold", color = Color3.fromRGB(255, 196, 64) },
        { min = 250, name = "Silver", color = Color3.fromRGB(196, 200, 208) },
        { min = 0, name = "Bronze", color = Color3.fromRGB(184, 122, 72) },
    }
    local ELO_KEYS = { "ELO", "Elo", "elo", "RankedElo", "RankedELO", "RankedRating", "Rating", "MMR", "RankPoints" }
    local RANK_KEYS = { "Rank", "RankName", "RankedRank", "RankTitle" }
    local MODE_KEYS = { "Gamemode", "GameMode", "Mode", "CurrentMode", "MatchType", "Queue", "CurrentGamemode" }

    local function read_string(inst, key)
        if not inst then
            return nil
        end
        local attr = inst:GetAttribute(key)
        if type(attr) == "string" and attr ~= "" then
            return attr
        end
        local child = inst:FindFirstChild(key)
        if child and child:IsA("StringValue") and child.Value ~= "" then
            return child.Value
        end
        return nil
    end

    local function read_number(inst, key)
        if not inst then
            return nil
        end
        local attr = inst:GetAttribute(key)
        if type(attr) == "number" then
            return attr
        end
        local child = inst:FindFirstChild(key)
        if child and (child:IsA("NumberValue") or child:IsA("IntValue")) then
            return child.Value
        end
        return nil
    end

    local function current_mode()
        local roots = { workspace, ReplicatedStorage }
        for _, root in ipairs(roots) do
            for _, key in ipairs(MODE_KEYS) do
                local value = read_string(root, key)
                if value then
                    return value
                end
            end
            for _, child in ipairs(root:GetChildren()) do
                for _, key in ipairs(MODE_KEYS) do
                    local value = read_string(child, key)
                    if value then
                        return value
                    end
                end
                if child:IsA("StringValue") then
                    local name = string.lower(child.Name)
                    if string.find(name, "mode", 1, true) or string.find(name, "queue", 1, true) then
                        if child.Value ~= "" then
                            return child.Value
                        end
                    end
                end
            end
        end
        return ""
    end

    local function is_ranked_game()
        local mode = string.lower(current_mode())
        return mode ~= "" and string.find(mode, "rank", 1, true) ~= nil
    end

    local function player_elo(player)
        local bags = { player, player:FindFirstChild("leaderstats"), player:FindFirstChild("Data"), player.Character }
        for _, bag in ipairs(bags) do
            for _, key in ipairs(ELO_KEYS) do
                local value = read_number(bag, key)
                if value then
                    return value
                end
            end
        end
        return nil
    end

    local function player_rank_name(player, elo)
        local bags = { player, player:FindFirstChild("leaderstats"), player:FindFirstChild("Data") }
        for _, bag in ipairs(bags) do
            for _, key in ipairs(RANK_KEYS) do
                local value = read_string(bag, key)
                if value and not tonumber(value) then
                    return value
                end
            end
        end
        local rank = RANK_LADDER[#RANK_LADDER]
        for _, entry in ipairs(RANK_LADDER) do
            if elo >= entry.min then
                rank = entry
                break
            end
        end
        return rank.name
    end

    local function rank_color(name)
        local folded = string.lower(name or "")
        for _, entry in ipairs(RANK_LADDER) do
            if string.find(folded, string.lower(entry.name), 1, true) then
                return entry.color
            end
        end
        return Color3.new(1, 1, 1)
    end

    local function clear_labels()
        for player, label in pairs(ranked_esp.labels) do
            local gui = label and label.Parent
            if gui then
                pcall(function()
                    gui:Destroy()
                end)
            end
            ranked_esp.labels[player] = nil
        end
    end

    local function ensure_label(player, character)
        local head = character and character:FindFirstChild("Head")
        if not head then
            return nil
        end
        local existing = ranked_esp.labels[player]
        if existing and existing.Parent and existing:IsDescendantOf(head) then
            return existing
        end
        local old = head:FindFirstChild("RankedEloGui")
        if old then
            old:Destroy()
        end
        local gui = Instance.new("BillboardGui")
        gui.Name = "RankedEloGui"
        gui.Size = UDim2.fromOffset(220, 28)
        gui.StudsOffset = Vector3.new(0, 4.4, 0)
        gui.AlwaysOnTop = true
        gui.Adornee = head
        gui.Parent = head
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextStrokeTransparency = 0.35
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Parent = gui
        ranked_esp.labels[player] = label
        return label
    end

    local function refresh()
        if not ranked_esp.enabled or not is_ranked_game() then
            clear_labels()
            return
        end
        local seen = {}
        for _, player in ipairs(Players:GetPlayers()) do
            local character = player.Character
            local elo = player_elo(player)
            if character and elo then
                seen[player] = true
                local label = ensure_label(player, character)
                if label then
                    local rank = player_rank_name(player, elo)
                    label.Text = string.format("%s  %d", rank, math.floor(elo + 0.5))
                    label.TextColor3 = rank_color(rank)
                end
            end
        end
        for player, label in pairs(ranked_esp.labels) do
            if not seen[player] then
                local gui = label and label.Parent
                if gui then
                    pcall(function()
                        gui:Destroy()
                    end)
                end
                ranked_esp.labels[player] = nil
            end
        end
    end

    function ranked_esp.start()
        ranked_esp.enabled = true
        if ranked_esp.conn then
            return
        end
        local last = 0
        ranked_esp.conn = RunService.Heartbeat:Connect(function()
            local now = tick()
            if now - last < 0.25 then
                return
            end
            last = now
            refresh()
        end)
    end

    function ranked_esp.stop()
        ranked_esp.enabled = false
        if ranked_esp.conn then
            ranked_esp.conn:Disconnect()
            ranked_esp.conn = nil
        end
        clear_labels()
    end

    VisualsTab:create_module({
        title = "Ranked",
        description = "Elo and rank above players in ranked",
        flag = "RankedESPModule",
        section = "right",
        callback = function(state)
            if toggle_state(state) then
                ranked_esp.start()
            else
                ranked_esp.stop()
            end
        end
    })
end)

pcall(function()
    local ability_exploit_module = CombatTab:create_module({
        title = "Ability Exploit",
        description = "Ability no cooldowns",
        flag = "AbilityExploit",
        section = "left",
        callback = function(value)
            getgenv().AbilityExploit = toggle_state(value)
            if getgenv()._Vanish_AbilityExploit_Apply then
                getgenv()._Vanish_AbilityExploit_Apply()
            elseif not getgenv().AbilityExploit and getgenv()._Vanish_AbilityExploit_Stop then
                getgenv()._Vanish_AbilityExploit_Stop()
            end
        end
    })
    ability_exploit_module:create_checkbox({
        title = "Thunder Dash",
        flag = "ThunderDashNoCooldown",
        callback = function(value)
            getgenv().ThunderDashNoCooldown = toggle_state(value)
            if getgenv()._Vanish_AbilityExploit_Apply then
                getgenv()._Vanish_AbilityExploit_Apply()
            end
        end
    })
    ability_exploit_module:create_checkbox({
        title = "Super Jump",
        flag = "SuperJumpNoCooldown",
        callback = function(value)
            getgenv().SuperJumpNoCooldown = toggle_state(value)
            if getgenv()._Vanish_AbilityExploit_Apply then
                getgenv()._Vanish_AbilityExploit_Apply()
            end
        end
    })
    ability_exploit_module:create_checkbox({
        title = "Dash",
        flag = "DashNoCooldown",
        callback = function(value)
            getgenv().DashNoCooldown = toggle_state(value)
            if getgenv()._Vanish_AbilityExploit_Apply then
                getgenv()._Vanish_AbilityExploit_Apply()
            end
        end
    })
end)

pcall(function() RunService:UnbindFromRenderStep("VanishDesyncRestore") end)
pcall(function() RunService:UnbindFromRenderStep("ZXDesyncRestore") end)

local function build_late_modules()
local PerformanceState = {
    saved = false,
    lighting = {},
    terrain = {},
    effects = {},
    atmosphere = nil,
    quality = nil,
    savedQuality = nil,
    boostConn = nil,
    fpsConn = nil,
    fpsFn = nil,
    unlockOn = false,
    savedFpsCap = nil,
    liveFps = 60,
}

local function performance_on()
    return getgenv().PerformanceEnabled == true
end

local function performance_save()
    if PerformanceState.saved then
        return
    end
    PerformanceState.saved = true
    pcall(function()
        PerformanceState.lighting.GlobalShadows = Lighting.GlobalShadows
        PerformanceState.lighting.FogEnd = Lighting.FogEnd
        PerformanceState.lighting.FogStart = Lighting.FogStart
        PerformanceState.lighting.Brightness = Lighting.Brightness
        PerformanceState.lighting.OutdoorAmbient = Lighting.OutdoorAmbient
        PerformanceState.lighting.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
        PerformanceState.lighting.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
        PerformanceState.lighting.ShadowSoftness = Lighting.ShadowSoftness
    end)
    pcall(function()
        local terrain = workspace.Terrain
        if not terrain then return end
        PerformanceState.terrain.WaterWaveSize = terrain.WaterWaveSize
        PerformanceState.terrain.WaterWaveSpeed = terrain.WaterWaveSpeed
        PerformanceState.terrain.WaterReflectance = terrain.WaterReflectance
        PerformanceState.terrain.WaterTransparency = terrain.WaterTransparency
    end)
    pcall(function()
        PerformanceState.quality = settings().Rendering.QualityLevel
    end)
    pcall(function()
        PerformanceState.savedQuality = UserSettings().GameSettings.SavedQualityLevel
    end)
    pcall(function()
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect.Name == "AcrylicBlur" then
                continue
            end
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("Atmosphere") or effect:IsA("Clouds") then
                PerformanceState.effects[effect] = {
                    enabled = effect.Enabled,
                    density = effect:IsA("Atmosphere") and effect.Density or nil,
                }
            end
        end
    end)
end

local function performance_restore_lighting()
    local saved = PerformanceState.lighting
    pcall(function()
        if saved.GlobalShadows ~= nil then Lighting.GlobalShadows = saved.GlobalShadows end
        if saved.FogEnd ~= nil then Lighting.FogEnd = saved.FogEnd end
        if saved.FogStart ~= nil then Lighting.FogStart = saved.FogStart end
        if saved.Brightness ~= nil then Lighting.Brightness = saved.Brightness end
        if saved.OutdoorAmbient ~= nil then Lighting.OutdoorAmbient = saved.OutdoorAmbient end
        if saved.EnvironmentDiffuseScale ~= nil then Lighting.EnvironmentDiffuseScale = saved.EnvironmentDiffuseScale end
        if saved.EnvironmentSpecularScale ~= nil then Lighting.EnvironmentSpecularScale = saved.EnvironmentSpecularScale end
        if saved.ShadowSoftness ~= nil then Lighting.ShadowSoftness = saved.ShadowSoftness end
    end)
    pcall(function()
        for effect, data in pairs(PerformanceState.effects) do
            if effect and effect.Parent then
                if effect:IsA("Atmosphere") then
                    if data.density ~= nil then effect.Density = data.density end
                elseif data.enabled ~= nil then
                    effect.Enabled = data.enabled
                end
            end
        end
    end)
end

local function performance_restore_quality()
    pcall(function()
        if PerformanceState.quality ~= nil then
            settings().Rendering.QualityLevel = PerformanceState.quality
        end
    end)
    pcall(function()
        if PerformanceState.savedQuality ~= nil then
            UserSettings().GameSettings.SavedQualityLevel = PerformanceState.savedQuality
        end
    end)
    pcall(function()
        local terrain = workspace.Terrain
        local saved = PerformanceState.terrain
        if not terrain or not saved then return end
        if saved.WaterWaveSize ~= nil then terrain.WaterWaveSize = saved.WaterWaveSize end
        if saved.WaterWaveSpeed ~= nil then terrain.WaterWaveSpeed = saved.WaterWaveSpeed end
        if saved.WaterReflectance ~= nil then terrain.WaterReflectance = saved.WaterReflectance end
        if saved.WaterTransparency ~= nil then terrain.WaterTransparency = saved.WaterTransparency end
    end)
end

local function get_fps_cap_fn()
    if typeof(PerformanceState.fpsFn) == "function" then
        return PerformanceState.fpsFn
    end
    local found
    pcall(function()
        local env = getgenv()
        found = env.setfpscap or env.setmaxfps or env.set_fps_cap
        if typeof(found) ~= "function" and syn and typeof(syn.setfpscap) == "function" then
            found = syn.setfpscap
        end
        if typeof(found) ~= "function" then
            found = env.setfpscap or env.setmaxfps
        end
    end)
    if typeof(found) == "function" then
        PerformanceState.fpsFn = found
        return found
    end
    return nil
end

local function apply_fps_cap(cap)
    local fn = get_fps_cap_fn()
    if not fn then
        return
    end
    pcall(fn, cap)
end

local function read_roblox_fps_cap()
    local gs
    pcall(function()
        gs = UserSettings():GetService("UserGameSettings")
    end)
    if not gs then
        pcall(function()
            gs = UserSettings().GameSettings
        end)
    end
    if not gs then
        return nil
    end
    local cap
    if typeof(gethiddenproperty) == "function" then
        pcall(function()
            cap = gethiddenproperty(gs, "FramerateCap")
        end)
    end
    if typeof(cap) ~= "number" then
        pcall(function()
            cap = gs.FramerateCap
        end)
    end
    if typeof(cap) == "number" and cap == cap then
        return cap
    end
    return nil
end

local function snap_fps_cap(fps)
    local caps = {60, 120, 144, 165, 240}
    local best, dist = 60, math.huge
    for i = 1, #caps do
        local d = math.abs(fps - caps[i])
        if d < dist then
            dist = d
            best = caps[i]
        end
    end
    return best
end

local function capture_fps_cap()
    local cap = read_roblox_fps_cap()
    if typeof(cap) == "number" then
        if cap <= 0 then
            return 0
        end
        return math.clamp(math.floor(cap + 0.5), 30, 10000)
    end
    local live = PerformanceState.liveFps
    if typeof(live) == "number" and live >= 30 then
        return snap_fps_cap(live)
    end
    return 60
end

local function setUnlockFPS(on)
    if on then
        if not PerformanceState.unlockOn then
            PerformanceState.savedFpsCap = capture_fps_cap()
            apply_fps_cap(0)
        end
        PerformanceState.unlockOn = true
        if not PerformanceState.fpsConn then
            local acc = 0
            PerformanceState.fpsConn = RunService.Heartbeat:Connect(function(dt)
                acc += dt
                if acc < 1 then
                    return
                end
                acc = 0
                apply_fps_cap(0)
            end)
        end
        return
    end
    if PerformanceState.fpsConn then
        PerformanceState.fpsConn:Disconnect()
        PerformanceState.fpsConn = nil
    end
    if PerformanceState.unlockOn then
        local restore = PerformanceState.savedFpsCap
        if typeof(restore) ~= "number" then
            restore = 60
        end
        apply_fps_cap(restore)
    end
    PerformanceState.unlockOn = false
end

local function applyLowGraphics(on)
    if not on then
        return
    end
    performance_save()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 0
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ShadowSoftness = 0
    end)
    pcall(function()
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect.Name == "AcrylicBlur" then
                continue
            end
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            elseif effect:IsA("Atmosphere") then
                effect.Density = 0
            elseif effect:IsA("Clouds") then
                effect.Enabled = false
            end
        end
    end)
end

local function stopFPSBoost()
    if PerformanceState.boostConn then
        PerformanceState.boostConn:Disconnect()
        PerformanceState.boostConn = nil
    end
end

local function applyFPSBoost(on)
    if not on then
        stopFPSBoost()
        return
    end
    performance_save()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    pcall(function()
        UserSettings().GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        local terrain = workspace.Terrain
        if not terrain then return end
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
    end)
    local function flatten_fx(inst)
        if not inst then return end
        if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles") then
            inst.Enabled = false
        end
    end
    if not PerformanceState.boostConn then
        PerformanceState.boostConn = workspace.DescendantAdded:Connect(flatten_fx)
    end
    task.spawn(function()
        for _, inst in ipairs(workspace:GetDescendants()) do
            if not (getgenv().FPSBoost and performance_on()) then
                break
            end
            flatten_fx(inst)
        end
    end)
end

local function apply_performance()
    local unlock = performance_on() and getgenv().UnlockFPS == true
    local boost = performance_on() and getgenv().FPSBoost == true
    local low = performance_on() and getgenv().LowGraphics == true
    setUnlockFPS(unlock)
    if boost or low then
        performance_save()
    end
    applyFPSBoost(boost)
    applyLowGraphics(low)
    if not boost and not low then
        performance_restore_lighting()
        performance_restore_quality()
    elseif not low and boost then
        performance_restore_lighting()
        pcall(function() Lighting.GlobalShadows = false end)
    elseif not boost and low then
        performance_restore_quality()
    end
end
getgenv()._Vanish_StopPerformance = function()
    getgenv().PerformanceEnabled = false
    apply_performance()
end
getgenv()._Vanish_ApplyPerformance = apply_performance

pcall(function()
    if getgenv()._Vanish_ManualSpamHotkey then
        getgenv()._Vanish_ManualSpamHotkey:Disconnect()
        getgenv()._Vanish_ManualSpamHotkey = nil
    end
end)
getgenv()._Vanish_ManualSpamHotkey = UserInputService.InputBegan:Connect(function(input, process)
    if getgenv()._VanishAlive == false then return end
    if process then return end
    if input.KeyCode == Enum.KeyCode.E then
        if not getgenv().ManualSpamModuleEnabled then return end
        if not System or not System.manual_spam then return end
        local running = not (System.__properties.__manual_spam_enabled == true)
        set_manual_spam_running(running)
        if section_notify_on("ManualSpamModule") then
            Notify({ title = "Manual Spam", text = running and "ON (Hotkey)" or "OFF (Hotkey)", duration = 2 })
        end
    end
end)

pcall(function()
System.protections = {
    __phantomConn = nil,
    __hellHookHeartbeat = nil,
    __hellHookConns = {},
    __pulseConn = nil,
}

function System.protections.fireAbilityButton()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local abilityPress = remotes and remotes:FindFirstChild("AbilityButtonPress")
    if abilityPress then
        pcall(function() abilityPress:Fire() end)
        return true
    end
    return false
end

function System.protections.startAntiPhantom()
    if System.protections.__phantomConn then return end
    task.spawn(function()
        local runtimeFolder = workspace:FindFirstChild("Runtime") or workspace:WaitForChild("Runtime", 120)
        if not runtimeFolder or not getgenv().AntiPhantom then return end
        Runtime = runtimeFolder
        System.protections.__phantomConn = runtimeFolder.ChildAdded:Connect(function(Object)
            if not getgenv().AntiPhantom then return end
            if Object.Name == "maxTransmission" or Object.Name == "transmissionpart" then
                local Weld = Object:FindFirstChildWhichIsA("WeldConstraint")
                if Weld then
                    local Character = LocalPlayer.Character
                    if not Character then
                        local t0 = os.clock()
                        while not LocalPlayer.Character and os.clock() - t0 < 10 do
                            task.wait(0.1)
                        end
                        Character = LocalPlayer.Character
                    end
                    if not Character then return end
                    if Character and Weld.Part1 == Character.HumanoidRootPart then
                        local currentBall = System.ball.get()
                        Weld:Destroy()
                        if currentBall then
                            local FocusConnection
                            FocusConnection = RunService.RenderStepped:Connect(function()
                                local Highlighted = currentBall:GetAttribute("highlighted")
                                if Highlighted == true then
                                    System.protections.fireAbilityButton()
                                elseif Highlighted == false then
                                    FocusConnection:Disconnect()
                                end
                            end)
                            task.delay(3, function()
                                if FocusConnection and FocusConnection.Connected then
                                    FocusConnection:Disconnect()
                                end
                            end)
                        end
                    end
                end
            end
        end)
    end)
end

function System.protections.stopAntiPhantom()
    if System.protections.__phantomConn then
        System.protections.__phantomConn:Disconnect()
        System.protections.__phantomConn = nil
    end
end

function System.protections.stopAntiHellHookHeartbeat()
    if System.protections.__hellHookHeartbeat then
        System.protections.__hellHookHeartbeat:Disconnect()
        System.protections.__hellHookHeartbeat = nil
    end
end

function System.protections.stopAntiHellHook()
    System.protections.stopAntiHellHookHeartbeat()
    for _, conn in ipairs(System.protections.__hellHookConns) do
        pcall(function() conn:Disconnect() end)
    end
    System.protections.__hellHookConns = {}
end

function System.protections.startAntiHellHook()
    if #System.protections.__hellHookConns > 0 then return end
    task.spawn(function()
        if not getgenv().AntiHellHook then return end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 60)
        if not remotes or not getgenv().AntiHellHook then return end
        local hookedRemote = remotes:FindFirstChild("PlrHellHooked") or remotes:WaitForChild("PlrHellHooked", 30)
        local completedRemote = remotes:FindFirstChild("PlrHellHookCompleted") or remotes:WaitForChild("PlrHellHookCompleted", 30)
        if hookedRemote and getgenv().AntiHellHook then
            table.insert(System.protections.__hellHookConns, hookedRemote.OnClientEvent:Connect(function(_, victim)
                if not getgenv().AntiHellHook then return end
                if not victim or victim.Name ~= LocalPlayer.Name then return end
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local savedCFrame = root.CFrame
                System.protections.stopAntiHellHookHeartbeat()
                System.protections.__hellHookHeartbeat = RunService.Heartbeat:Connect(function()
                    if not getgenv().AntiHellHook then return end
                    local liveChar = LocalPlayer.Character
                    local hrp = liveChar and liveChar:FindFirstChild("HumanoidRootPart")
                    if hrp and typeof(savedCFrame) == "CFrame" then hrp.CFrame = savedCFrame end
                end)
            end))
        end
        if completedRemote and getgenv().AntiHellHook then
            table.insert(System.protections.__hellHookConns, completedRemote.OnClientEvent:Connect(function()
                task.delay(1, System.protections.stopAntiHellHookHeartbeat)
            end))
        end
    end)
end

function System.protections.stopAntiPulse()
    if System.protections.__pulseConn then
        System.protections.__pulseConn:Disconnect()
        System.protections.__pulseConn = nil
    end
end

function System.protections.startAntiPulse()
    if System.protections.__pulseConn then return end
    System.protections.__pulseConn = RunService.Heartbeat:Connect(function()
        if not getgenv().AntiPulse then return end
        local char = LocalPlayer.Character
        if char and char:GetAttribute("Pulsed") then
            pcall(function() char:SetAttribute("Pulsed", false) end)
        end
    end)
end

function System.protections.setAntiPhantom(value)
    getgenv().AntiPhantom = toggle_state(value)
    if getgenv().AntiPhantom and getgenv().ProtectionsEnabled then
        System.protections.startAntiPhantom()
    else
        System.protections.stopAntiPhantom()
    end
end

function System.protections.setAntiHellHook(value)
    getgenv().AntiHellHook = toggle_state(value)
    if getgenv().AntiHellHook and getgenv().ProtectionsEnabled then
        System.protections.startAntiHellHook()
    else
        System.protections.stopAntiHellHook()
    end
end

function System.protections.setAntiPulse(value)
    getgenv().AntiPulse = toggle_state(value)
    if getgenv().AntiPulse and getgenv().ProtectionsEnabled then
        System.protections.startAntiPulse()
    else
        System.protections.stopAntiPulse()
    end
end

local protections_module = CombatTab:create_module({
    title = "Anti Abilities",
    description = "These abilities won't affect you",
    flag = "ProtectionsModule",
    section = "right",
    callback = function(state)
        getgenv().ProtectionsEnabled = toggle_state(state)
        if not System or not System.protections then return end
        if getgenv().ProtectionsEnabled then
            if getgenv().AntiHellHook then pcall(System.protections.startAntiHellHook) end
            if getgenv().AntiPhantom then pcall(System.protections.startAntiPhantom) end
            if getgenv().AntiPulse then pcall(System.protections.startAntiPulse) end
        else
            pcall(System.protections.stopAntiHellHook)
            pcall(System.protections.stopAntiPhantom)
            pcall(System.protections.stopAntiPulse)
        end
    end
})

protections_module:create_checkbox({
    title = "Anti HellHook",
    flag = "AntiHellHookToggle",
    callback = function(value)
        if System and System.protections then pcall(function() System.protections.setAntiHellHook(value) end) end
    end
})

protections_module:create_checkbox({
    title = "Anti Phantom",
    flag = "AntiPhantomToggle",
    callback = function(value)
        if System and System.protections then pcall(function() System.protections.setAntiPhantom(value) end) end
    end
})

protections_module:create_checkbox({
    title = "Anti Pulse",
    flag = "AntiPulseToggle",
    callback = function(value)
        if System and System.protections then pcall(function() System.protections.setAntiPulse(value) end) end
    end
})

end)

pcall(function()
    if getgenv()._Vanish_MoveConn then
        getgenv()._Vanish_MoveConn:Disconnect()
        getgenv()._Vanish_MoveConn = nil
    end
    if getgenv()._Vanish_JumpConn then
        getgenv()._Vanish_JumpConn:Disconnect()
        getgenv()._Vanish_JumpConn = nil
    end
end)

getgenv().CustomWalkSpeed = getgenv().CustomWalkSpeed or 36
getgenv().CustomJumpPower = getgenv().CustomJumpPower or 50

local function remember_game_move(hum)
    if hum:GetAttribute("_VanishGameWalk") == nil then
        hum:SetAttribute("_VanishGameWalk", hum.WalkSpeed)
    end
    if hum:GetAttribute("_VanishGameJump") == nil then
        hum:SetAttribute("_VanishGameJump", hum.JumpPower)
    end
    if hum:GetAttribute("_VanishGameJumpHeight") == nil then
        hum:SetAttribute("_VanishGameJumpHeight", hum.JumpHeight)
    end
    if hum:GetAttribute("_VanishGameUseJump") == nil then
        hum:SetAttribute("_VanishGameUseJump", hum.UseJumpPower and 1 or 0)
    end
    if hum:GetAttribute("_VanishMoveHooked") then return end
    hum:SetAttribute("_VanishMoveHooked", true)
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if getgenv()._VanishWritingMove then return end
        hum:SetAttribute("_VanishGameWalk", hum.WalkSpeed)
    end)
    hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if getgenv()._VanishWritingMove then return end
        hum:SetAttribute("_VanishGameJump", hum.JumpPower)
    end)
    hum:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        if getgenv()._VanishWritingMove then return end
        hum:SetAttribute("_VanishGameJumpHeight", hum.JumpHeight)
    end)
    hum:GetPropertyChangedSignal("UseJumpPower"):Connect(function()
        if getgenv()._VanishWritingMove then return end
        hum:SetAttribute("_VanishGameUseJump", hum.UseJumpPower and 1 or 0)
    end)
end

local function restore_game_move(hum)
    getgenv()._VanishWritingMove = true
    local walk = hum:GetAttribute("_VanishGameWalk")
    local power = hum:GetAttribute("_VanishGameJump")
    local height = hum:GetAttribute("_VanishGameJumpHeight")
    local use_jump = hum:GetAttribute("_VanishGameUseJump")
    if not getgenv().WalkspeedEnabled and walk ~= nil then
        hum.WalkSpeed = walk
    end
    if not getgenv().JumpPowerEnabled then
        if use_jump ~= nil then
            hum.UseJumpPower = use_jump == 1
        end
        if power ~= nil then
            hum.JumpPower = power
        end
        if height ~= nil then
            hum.JumpHeight = height
        end
    end
    getgenv()._VanishWritingMove = false
end

getgenv()._Vanish_ApplyMovement = function()
    if getgenv()._VanishAlive == false then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    remember_game_move(hum)
    if getgenv().WalkspeedEnabled then
        getgenv()._VanishWritingMove = true
        hum.WalkSpeed = tonumber(getgenv().CustomWalkSpeed) or 36
        getgenv()._VanishWritingMove = false
    end
    if getgenv().JumpPowerEnabled then
        getgenv()._VanishWritingMove = true
        hum.UseJumpPower = true
        hum.JumpPower = tonumber(getgenv().CustomJumpPower) or 50
        getgenv()._VanishWritingMove = false
    end
    restore_game_move(hum)
end

getgenv()._Vanish_StopMovement = function()
    getgenv().WalkspeedEnabled = false
    getgenv().JumpPowerEnabled = false
    getgenv().InfJumpEnabled = false
    getgenv().FovEnabled = false
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            cam.FieldOfView = 70
        end
    end)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            remember_game_move(hum)
            restore_game_move(hum)
        end
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = root:FindFirstChild("VanishFlyBV")
            local bg = root:FindFirstChild("VanishFlyBG")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end)
end

getgenv()._Vanish_MoveConn = RunService.Heartbeat:Connect(function()
    pcall(getgenv()._Vanish_ApplyMovement)
end)

getgenv()._Vanish_JumpConn = UserInputService.JumpRequest:Connect(function()
    if getgenv()._VanishAlive == false or not getgenv().InfJumpEnabled then
        return
    end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

getgenv().FovEnabled = getgenv().FovEnabled == true
getgenv().CustomFov = tonumber(getgenv().CustomFov) or 70

local function apply_fov(enabled, value)
    enabled = enabled == true
    value = tonumber(value) or tonumber(getgenv().CustomFov) or 70
    value = math.clamp(value, 40, 120)
    getgenv().FovEnabled = enabled
    getgenv().CustomFov = value
    if getgenv()._VanishFovConn then
        pcall(function()
            getgenv()._VanishFovConn:Disconnect()
        end)
        getgenv()._VanishFovConn = nil
    end
    local cam = workspace.CurrentCamera
    if not enabled then
        if cam then
            cam.FieldOfView = 70
        end
        return
    end
    if cam then
        cam.FieldOfView = value
    end
    getgenv()._VanishFovConn = RunService.RenderStepped:Connect(function()
        if getgenv()._VanishAlive == false or getgenv().FovEnabled ~= true then
            return
        end
        local current = workspace.CurrentCamera
        if current then
            current.FieldOfView = tonumber(getgenv().CustomFov) or value
        end
    end)
end

getgenv()._Vanish_ApplyFov = apply_fov
if getgenv().FovEnabled then
    apply_fov(true, getgenv().CustomFov)
end


pcall(function()
do
    local winstreak = {
        enabled = false,
        streak = "1",
        conn = nil,
        enabled_conn = nil,
        char_conn = nil,
        original_text = nil,
        original_icon = nil,
        original_enabled = nil,
    }
    getgenv()._VanishWinStreak = winstreak

    local function winstreak_update()
        if not winstreak.enabled then
            if winstreak.conn then
                winstreak.conn:Disconnect()
                winstreak.conn = nil
            end
            if winstreak.enabled_conn then
                winstreak.enabled_conn:Disconnect()
                winstreak.enabled_conn = nil
            end
            return
        end

        local char = LocalPlayer.Character
        if not char then
            return
        end

        local display = char:FindFirstChild("WinStreakDisplay")
        if not display then
            display = char:WaitForChild("WinStreakDisplay", 5)
        end
        if not display then
            return
        end

        local main = display:FindFirstChild("Main")
        if not main then
            return
        end

        local icon = main:FindFirstChild("Icon")
        local value = main:FindFirstChild("Value")
        if not icon or not value then
            return
        end

        if winstreak.original_enabled == nil then
            winstreak.original_enabled = display.Enabled
        end
        if not winstreak.original_text or winstreak.original_text == "" then
            winstreak.original_text = value.Text
        end
        if not winstreak.original_icon or winstreak.original_icon == "" then
            winstreak.original_icon = icon.Image
        end

        if winstreak.conn then
            winstreak.conn:Disconnect()
            winstreak.conn = nil
        end
        if winstreak.enabled_conn then
            winstreak.enabled_conn:Disconnect()
            winstreak.enabled_conn = nil
        end

        local streak = tostring(winstreak.streak or "1")
        local num = tonumber(streak)
        local rich = string.format("<b><stroke color='rgb(0, 0, 0)' thickness='2'>%s</stroke></b>", streak)
        local writing = false

        icon.Image = (num and num >= 10) and "rbxassetid://75598166115655" or "rbxassetid://89658127170771"
        value.Text = rich
        display.Enabled = true

        winstreak.conn = value:GetPropertyChangedSignal("Text"):Connect(function()
            if writing then
                return
            end
            winstreak.original_text = value.Text
            writing = true
            local s = tostring(winstreak.streak or "1")
            local n = tonumber(s)
            icon.Image = (n and n >= 10) and "rbxassetid://75598166115655" or "rbxassetid://89658127170771"
            value.Text = string.format("<b><stroke color='rgb(0, 0, 0)' thickness='2'>%s</stroke></b>", s)
            writing = false
        end)

        winstreak.enabled_conn = display:GetPropertyChangedSignal("Enabled"):Connect(function()
            if writing then
                return
            end
            winstreak.original_enabled = display.Enabled
            writing = true
            display.Enabled = true
            writing = false
        end)
    end

    local function winstreak_start()
        winstreak.enabled = true
        if not winstreak.char_conn then
            winstreak.char_conn = LocalPlayer.CharacterAdded:Connect(function()
                winstreak.original_text = nil
                winstreak.original_icon = nil
                winstreak.original_enabled = nil
                task.wait(1.5)
                task.spawn(winstreak_update)
            end)
        end
        task.spawn(winstreak_update)
    end

    local function winstreak_stop()
        winstreak.enabled = false
        if winstreak.char_conn then
            winstreak.char_conn:Disconnect()
            winstreak.char_conn = nil
        end
        if winstreak.conn then
            winstreak.conn:Disconnect()
            winstreak.conn = nil
        end
        if winstreak.enabled_conn then
            winstreak.enabled_conn:Disconnect()
            winstreak.enabled_conn = nil
        end

        local char = LocalPlayer.Character
        if char then
            local display = char:FindFirstChild("WinStreakDisplay")
            if display then
                local main = display:FindFirstChild("Main")
                if main then
                    local icon = main:FindFirstChild("Icon")
                    local value = main:FindFirstChild("Value")
                    if icon and value then
                        if winstreak.original_text and winstreak.original_text ~= "" then
                            value.Text = winstreak.original_text
                        end
                        if winstreak.original_icon and winstreak.original_icon ~= "" then
                            icon.Image = winstreak.original_icon
                        end
                    end
                end
                if winstreak.original_enabled ~= nil then
                    display.Enabled = winstreak.original_enabled
                end
            end
        end

        winstreak.original_text = nil
        winstreak.original_icon = nil
        winstreak.original_enabled = nil
    end

    getgenv()._VanishWinStreakStart = winstreak_start
    getgenv()._VanishWinStreakStop = winstreak_stop

    local ws_module = MiscTab:create_module({
        title = "Custom WinStreak",
        description = "Customize your client-side win streak display",
        flag = "CustomWinStreakModule",
        section = "right",
        callback = function(state)
            if toggle_state(state) then
                winstreak_start()
            else
                winstreak_stop()
            end
        end
    })

    ws_module:create_textbox({
        title = "Streak Amount",
        flag = "CustomWinStreakAmount",
        placeholder = "Enter streak value (e.g. 999)...",
        default = "1",
        callback = function(text)
            winstreak.streak = tostring(text or "1")
            if winstreak.enabled then
                task.spawn(winstreak_update)
            end
        end
    })

    local custom_win = {
        enabled = false,
        win_message = "Vanish",
        kill_message = "Vanish",
        connections = {},
    }
    getgenv()._VanishCustomWin = custom_win

    local function custom_win_update()
        if not custom_win.enabled then
            return
        end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local announcer = pg and pg:FindFirstChild("announcer")
        if not announcer then
            return
        end
        local kill_msg = custom_win.kill_message
        if kill_msg ~= nil and kill_msg ~= "" then
            local killed = announcer:FindFirstChild("Killed")
            if killed and (killed:IsA("TextLabel") or killed:IsA("TextBox")) and killed.Text ~= kill_msg then
                killed.Text = kill_msg
            end
        end
        local win_msg = custom_win.win_message
        if win_msg ~= nil and win_msg ~= "" then
            local winner = announcer:FindFirstChild("Winner")
            if winner and (winner:IsA("TextLabel") or winner:IsA("TextBox")) and winner.Text ~= win_msg then
                winner.Text = win_msg
            end
        end
    end

    local function bind_announcer_label(label, getter)
        if not label then
            return
        end
        table.insert(custom_win.connections, label:GetPropertyChangedSignal("Text"):Connect(function()
            if not custom_win.enabled then
                return
            end
            local msg = getter()
            if msg ~= nil and msg ~= "" and label.Text ~= msg then
                label.Text = msg
            end
        end))
        local msg = getter()
        if msg ~= nil and msg ~= "" and label.Text ~= msg then
            label.Text = msg
        end
    end

    local function custom_win_stop()
        custom_win.enabled = false
        for _, conn in ipairs(custom_win.connections) do
            pcall(function()
                conn:Disconnect()
            end)
        end
        table.clear(custom_win.connections)
    end

    local function custom_win_start()
        custom_win_stop()
        custom_win.enabled = true
        task.spawn(function()
            local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
            if not pg or not custom_win.enabled then
                return
            end
            local announcer = pg:WaitForChild("announcer", 10)
            if not announcer or not custom_win.enabled then
                return
            end

            bind_announcer_label(announcer:FindFirstChild("Killed") or announcer:WaitForChild("Killed", 10), function()
                return custom_win.kill_message
            end)
            bind_announcer_label(announcer:FindFirstChild("Winner"), function()
                return custom_win.win_message
            end)

            table.insert(custom_win.connections, announcer.ChildAdded:Connect(function(child)
                if child.Name == "Winner" then
                    bind_announcer_label(child, function()
                        return custom_win.win_message
                    end)
                elseif child.Name == "Killed" then
                    bind_announcer_label(child, function()
                        return custom_win.kill_message
                    end)
                end
            end))

            custom_win_update()
        end)
    end

    getgenv()._VanishCustomWinStart = custom_win_start
    getgenv()._VanishCustomWinStop = custom_win_stop

    local announce_module = MiscTab:create_module({
        title = "Custom Announcement",
        description = "Customize announcer messages for win and kills",
        flag = "CustomAnnouncementModule",
        section = "right",
        callback = function(state)
            if toggle_state(state) then
                custom_win_start()
            else
                custom_win_stop()
            end
        end
    })

    announce_module:create_textbox({
        title = "Win Message",
        flag = "CustomWinMessage",
        placeholder = "Enter win message...",
        default = "Vanish",
        callback = function(text)
            custom_win.win_message = tostring(text or "")
            if custom_win.enabled then
                custom_win_update()
            end
        end
    })

    announce_module:create_textbox({
        title = "Kill Message",
        flag = "CustomKillMessage",
        placeholder = "Enter kill message...",
        default = "Vanish",
        callback = function(text)
            custom_win.kill_message = tostring(text or "")
            if custom_win.enabled then
                custom_win_update()
            end
        end
    })
end
end)

pcall(function()
do
    local ball_trail = {
        active = false,
        color = Color3.fromRGB(0, 0, 0),
        num_trails = 5,
        attachments = {},
        connection = nil,
        ball = nil,
    }
    getgenv()._VanishBallTrail = ball_trail

    local function build_color_sequence()
        local color = ball_trail.color
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(0.5, Color3.new(math.min(color.R * 1.3, 1), math.min(color.G * 1.3, 1), math.min(color.B * 1.3, 1))),
            ColorSequenceKeypoint.new(1, color),
        })
    end

    local function detach()
        for _, item in ipairs(ball_trail.attachments) do
            if item.a0 and item.a0.Parent then
                pcall(function() item.a0:Destroy() end)
            end
            if item.a1 and item.a1.Parent then
                pcall(function() item.a1:Destroy() end)
            end
            if item.trail and item.trail.Parent then
                pcall(function() item.trail:Destroy() end)
            end
        end
        ball_trail.attachments = {}
        ball_trail.ball = nil
    end

    local function get_ball()
        local balls = workspace:FindFirstChild("Balls")
        if balls then
            for _, child in ipairs(balls:GetChildren()) do
                if child:IsA("BasePart") then
                    return child
                end
            end
        end
        local training = TrainingBallsFolder or workspace:FindFirstChild("TrainingBalls")
        if training then
            for _, child in ipairs(training:GetChildren()) do
                if child:IsA("BasePart") then
                    return child
                end
                if child:IsA("Model") then
                    local part = child:FindFirstChild("Corpo") or child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                    if part then
                        return part
                    end
                end
            end
        end
        if System and System.ball and System.ball.get then
            return System.ball.get()
        end
        return nil
    end

    local function attach(ball)
        detach()
        if not ball then
            return
        end
        ball_trail.ball = ball
        local count = math.clamp(math.floor(ball_trail.num_trails or 5), 1, 5)
        for i = 1, count do
            local base_angle = i / count * math.pi * 2
            local radius = math.random(150, 250) / 100
            local height = math.random(-150, 150) / 100
            local a0 = Instance.new("Attachment")
            a0.Position = Vector3.new(math.cos(base_angle) * radius, height, math.sin(base_angle) * radius)
            a0.Parent = ball
            local a1 = Instance.new("Attachment")
            a1.Position = Vector3.new(math.cos(base_angle + math.pi * 0.7) * radius * 1.3, -height, math.sin(base_angle + math.pi * 0.7) * radius * 1.3)
            a1.Parent = ball
            local trail = Instance.new("Trail")
            trail.Attachment0 = a0
            trail.Attachment1 = a1
            trail.Lifetime = 0.6
            trail.MinLength = 0
            trail.FaceCamera = true
            trail.LightEmission = 0
            trail.LightInfluence = 0
            trail.Texture = "rbxassetid://5029929719"
            trail.TextureMode = Enum.TextureMode.Stretch
            trail.Color = build_color_sequence()
            trail.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.8),
                NumberSequenceKeypoint.new(0.3, 0),
                NumberSequenceKeypoint.new(0.7, 0.3),
                NumberSequenceKeypoint.new(1, 1),
            })
            trail.WidthScale = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.3, 0.5),
                NumberSequenceKeypoint.new(0.7, 0.15),
                NumberSequenceKeypoint.new(1, 0),
            })
            trail.Parent = ball
            table.insert(ball_trail.attachments, {
                a0 = a0,
                a1 = a1,
                trail = trail,
                baseAngle = base_angle,
                angle = 0,
                speed = math.random(15, 30) / 10,
                spiralSpeed = math.random(25, 45) / 10,
                radiusMultiplier = math.random(80, 120) / 100,
                pulseOffset = math.random() * math.pi * 2,
                baseRadius = radius,
                baseHeight = height,
                chaosSpeed = math.random(10, 20) / 10,
            })
        end
    end

    local function animate(dt)
        if not ball_trail.active then
            return
        end
        local now = tick()
        for _, item in ipairs(ball_trail.attachments) do
            if not item.a0 or not item.a0.Parent then
                continue
            end
            item.angle = item.angle + item.speed * dt
            local spiral = item.angle * item.spiralSpeed
            local pulse = math.sin(now * 4 + item.pulseOffset) * 0.4 + 1
            local wobble = math.sin(item.angle * 3) * 0.7
            local chaos = math.sin(now * item.chaosSpeed + item.pulseOffset) * 0.5
            local radius0 = item.baseRadius * item.radiusMultiplier * pulse
            local radius1 = item.baseRadius * 1.3 * item.radiusMultiplier * pulse
            item.a0.Position = Vector3.new(
                math.cos(item.baseAngle + item.angle) * radius0 + math.cos(spiral) * 0.6,
                item.baseHeight + math.sin((item.baseAngle + item.angle) * 3) * 0.8 + wobble + chaos + math.sin(spiral * 2) * 0.6,
                math.sin(item.baseAngle + item.angle) * radius0 + math.sin(spiral) * 0.6
            )
            item.a1.Position = Vector3.new(
                math.cos(item.baseAngle + item.angle + math.pi * 0.7) * radius1 + math.sin(spiral * 1.3) * 0.5,
                -item.baseHeight + math.cos((item.baseAngle + item.angle) * 2.5) * 0.8 - wobble - chaos + math.cos(spiral * 1.7) * 0.5,
                math.sin(item.baseAngle + item.angle + math.pi * 0.7) * radius1 + math.cos(spiral * 1.1) * 0.5
            )
            if item.trail then
                item.trail.LightEmission = 0
            end
        end
    end

    local function update_color(color)
        ball_trail.color = color
        for _, item in ipairs(ball_trail.attachments) do
            if item.trail and item.trail.Parent then
                item.trail.Color = build_color_sequence()
            end
        end
    end

    local function start_trail()
        if ball_trail.active then
            return
        end
        ball_trail.active = true
        local ball = get_ball()
        if ball then
            attach(ball)
        end
        ball_trail.connection = RunService.Heartbeat:Connect(function(dt)
            if not ball_trail.active or getgenv()._VanishAlive == false then
                return
            end
            local ball_now = get_ball()
            if not ball_now then
                detach()
                return
            end
            if ball_now ~= ball_trail.ball or #ball_trail.attachments == 0 then
                attach(ball_now)
            end
            animate(dt)
        end)
    end

    local function stop_trail()
        ball_trail.active = false
        if ball_trail.connection then
            pcall(function()
                ball_trail.connection:Disconnect()
            end)
            ball_trail.connection = nil
        end
        detach()
    end

    getgenv()._VanishBallTrailStop = stop_trail
    getgenv()._VanishBallTrailStart = start_trail
    getgenv()._VanishBallTrailSetCount = function(value)
        ball_trail.num_trails = math.clamp(math.floor(tonumber(value) or 5), 1, 5)
        if not ball_trail.active then
            return
        end
        local ball = get_ball()
        if ball then
            attach(ball)
        end
    end
    if getgenv().BallTrailCount then
        getgenv()._VanishBallTrailSetCount(getgenv().BallTrailCount)
    end
end
end)


pcall(function()
do
    pcall(function()
        if getgenv()._Vanish_AbilityExploit_Stop then
            getgenv()._Vanish_AbilityExploit_Stop()
            getgenv()._Vanish_AbilityExploit_Stop = nil
        end
    end)

    local exploit_loops = {}
    local exploit_mods = {}

    local function get_ability_module(name)
        local cached = exploit_mods[name]
        if cached and cached.mod then
            return cached.mod
        end
        local shared = ReplicatedStorage:FindFirstChild("Shared")
        local abilities = shared and shared:FindFirstChild("Abilities")
        local module = abilities and abilities:FindFirstChild(name)
        if not module then
            return nil
        end
        local ok, result = pcall(require, module)
        if not ok or type(result) ~= "table" then
            return nil
        end
        exploit_mods[name] = {
            mod = result,
            cooldown = result.cooldown,
            cooldownReductionPerUpgrade = result.cooldownReductionPerUpgrade,
        }
        return result
    end

    local function apply_ability_exploit(name)
        local cached = exploit_mods[name]
        local mod = cached and cached.mod or get_ability_module(name)
        if not mod then
            return
        end
        pcall(function()
            mod.cooldown = 0
            mod.cooldownReductionPerUpgrade = 0
        end)
    end

    local function restore_ability_exploit(name)
        local cached = exploit_mods[name]
        if not cached or not cached.mod then
            return
        end
        pcall(function()
            cached.mod.cooldown = cached.cooldown
            cached.mod.cooldownReductionPerUpgrade = cached.cooldownReductionPerUpgrade
        end)
    end

    local function start_ability_exploit(name)
        if exploit_loops[name] then
            return
        end
        apply_ability_exploit(name)
        exploit_loops[name] = true
        task.spawn(function()
            while exploit_loops[name] and getgenv()._VanishAlive ~= false do
                apply_ability_exploit(name)
                task.wait(UserInputService.TouchEnabled and 1 or 0.6)
            end
        end)
    end

    local function stop_ability_exploit(name)
        exploit_loops[name] = nil
        restore_ability_exploit(name)
    end

    local function stop_all_ability_exploits()
        stop_ability_exploit("Thunder Dash")
        stop_ability_exploit("Super Jump")
        stop_ability_exploit("Dash")
    end

    local function ability_exploit_on()
        return getgenv().AbilityExploit == true
    end

    getgenv()._Vanish_AbilityExploit_Stop = stop_all_ability_exploits
    getgenv()._Vanish_AbilityExploit_Apply = function()
        if not ability_exploit_on() then
            stop_all_ability_exploits()
            return
        end
        if getgenv().ThunderDashNoCooldown then
            start_ability_exploit("Thunder Dash")
        else
            stop_ability_exploit("Thunder Dash")
        end
        if getgenv().SuperJumpNoCooldown then
            start_ability_exploit("Super Jump")
        else
            stop_ability_exploit("Super Jump")
        end
        if getgenv().DashNoCooldown then
            start_ability_exploit("Dash")
        else
            stop_ability_exploit("Dash")
        end
    end
end
end)

local noRenderConn = nil
local noRenderWatch = nil

local function findClientFX()
    local fx
    pcall(function()
        local ps = LocalPlayer and LocalPlayer:FindFirstChild("PlayerScripts")
        if not ps then return end
        local effectScripts = ps:FindFirstChild("EffectScripts")
        if effectScripts then
            fx = effectScripts:FindFirstChild("ClientFX")
        end
        if not fx then
            fx = ps:FindFirstChild("ClientFX", true)
        end
    end)
    return fx
end

local function applyClientFXDisabled(disabled)
    pcall(function()
        local clientFX = findClientFX()
        if clientFX then
            clientFX.Disabled = disabled == true
        end
    end)
end

local function stopNoRenderRuntime()
    if noRenderConn then
        pcall(function() noRenderConn:Disconnect() end)
        noRenderConn = nil
    end
    if noRenderWatch then
        pcall(function() task.cancel(noRenderWatch) end)
        noRenderWatch = nil
    end
end

local function destroyRuntimeChild(value)
    pcall(function()
        if Debris then
            Debris:AddItem(value, 0)
        end
    end)
    pcall(function()
        if value and value.Parent then
            value:Destroy()
        end
    end)
end

local function bindNoRenderRuntime()
    stopNoRenderRuntime()
    task.spawn(function()
        local runtime = workspace:FindFirstChild("Runtime")
        if not runtime then
            local ok, result = pcall(function()
                return workspace:WaitForChild("Runtime", 30)
            end)
            if ok then runtime = result end
        end
        if not runtime or not getgenv().NoRender then return end
        noRenderConn = runtime.ChildAdded:Connect(function(value)
            if getgenv().NoRender then
                destroyRuntimeChild(value)
            end
        end)
        for _, child in ipairs(runtime:GetChildren()) do
            destroyRuntimeChild(child)
        end
    end)
    noRenderWatch = task.spawn(function()
        while getgenv().NoRender do
            applyClientFXDisabled(true)
            task.wait(0.5)
        end
    end)
end

local function setNoRender(on)
    getgenv().NoRender = on == true or on == 1 or on == "true" or on == "on" or on == "On"
    if getgenv().NoRender then
        applyClientFXDisabled(true)
        bindNoRenderRuntime()
    else
        stopNoRenderRuntime()
        applyClientFXDisabled(false)
    end
end
getgenv()._Vanish_SetNoRender = setNoRender
getgenv()._Vanish_StopNoRender = function()
    setNoRender(false)
end

pcall(function()
do
    local is_mobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    local indicator = {
        active = false,
        gui = nil,
        frame = nil,
        connection = nil,
        size = is_mobile and 30 or 40,
        distance = is_mobile and 70 or 90,
    }
    getgenv()._VanishBallIndicator = indicator

    local function get_indicator_ball()
        local function resolve_ball_part(child)
            if not child then
                return nil
            end
            if child:GetAttribute("realBall") then
                if child:IsA("BasePart") then
                    return child
                end
                if child:IsA("Model") then
                    return child:FindFirstChild("Corpo") or child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                end
                return child:IsA("BasePart") and child or child:FindFirstChildWhichIsA("BasePart")
            end
            if child:IsA("BasePart") then
                return child
            end
            if child:IsA("Model") then
                return child:FindFirstChild("Corpo") or child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
            end
            return nil
        end

        local function pick_from_folder(folder, prefer_target)
            if not folder then
                return nil
            end
            local my_name = LocalPlayer.Name
            local fallback = nil
            for _, child in ipairs(folder:GetChildren()) do
                local part = resolve_ball_part(child)
                if not part then
                    continue
                end
                local target = part:GetAttribute("target")
                if target == nil and child ~= part then
                    target = child:GetAttribute("target")
                end
                if prefer_target and target == my_name then
                    return part
                end
                if target == my_name then
                    return part
                end
                if not fallback then
                    fallback = part
                end
            end
            return fallback
        end

        local training = TrainingBallsFolder or workspace:FindFirstChild("TrainingBalls")
        local training_ball = pick_from_folder(training, true)
        if training_ball then
            return training_ball
        end

        if System and System.ball then
            local targeted = System.ball.get_targeted and System.ball.get_targeted()
            if type(targeted) == "table" then
                for _, entry in ipairs(targeted) do
                    if entry and entry.part then
                        return entry.part
                    end
                end
            end
        end

        local match_ball = pick_from_folder(workspace:FindFirstChild("Balls"), true)
        if match_ball then
            return match_ball
        end

        if System and System.ball and System.ball.get then
            return System.ball.get()
        end
        return nil
    end

    local function indicator_stop()
        indicator.active = false
        if indicator.connection then
            pcall(function()
                indicator.connection:Disconnect()
            end)
            indicator.connection = nil
        end
        if indicator.gui then
            pcall(function()
                indicator.gui:Destroy()
            end)
            indicator.gui = nil
            indicator.frame = nil
        end
    end

    local function indicator_start()
        if indicator.active then
            return
        end
        indicator_stop()
        indicator.active = true

        local gui = Instance.new("ScreenGui")
        gui.Name = "VanishBallIndicator"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.DisplayOrder = 100
        pcall(UIACProtection, gui)
        pcall(function()
            if typeof(gethui) == "function" then
                gui.Parent = gethui()
            end
        end)
        if not gui.Parent then
            pcall(function()
                gui.Parent = CoreGui
            end)
        end
        if not gui.Parent then
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                gui.Parent = pg
            end
        end
        if getgenv()._VanishGuis then
            table.insert(getgenv()._VanishGuis, gui)
        end

        local frame = Instance.new("Frame")
        frame.Size = UDim2.fromOffset(indicator.size, indicator.size)
        frame.Position = UDim2.fromScale(0.5, 0.5)
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.BackgroundTransparency = 1
        frame.Visible = false
        frame.Parent = gui

        local arrow = Instance.new("ImageLabel")
        arrow.BackgroundTransparency = 1
        arrow.Size = UDim2.fromScale(1, 1)
        arrow.Position = UDim2.fromScale(0.5, 0.5)
        arrow.AnchorPoint = Vector2.new(0.5, 0.5)
        arrow.Image = "rbxassetid://18604510750"
        arrow.ImageColor3 = Color3.new(0, 0, 0)
        arrow.Parent = frame

        indicator.gui = gui
        indicator.frame = frame

        indicator.connection = RunService.RenderStepped:Connect(function()
            if not indicator.active or getgenv()._VanishAlive == false then
                return
            end
            local cam = workspace.CurrentCamera
            local ball = get_indicator_ball()
            if not cam or not ball or not frame.Parent then
                frame.Visible = false
                return
            end

            local screen, _onScreen = cam:WorldToViewportPoint(ball.Position)
            local center = cam.ViewportSize * 0.5
            local dir = Vector2.new(screen.X - center.X, screen.Y - center.Y)
            if screen.Z < 0 then
                dir = -dir
            end
            if dir.Magnitude < 1 then
                frame.Visible = false
                return
            end
            dir = dir.Unit
            local pos = center + dir * indicator.distance
            frame.Position = UDim2.fromOffset(pos.X, pos.Y)
            frame.Rotation = math.deg(math.atan2(dir.Y, dir.X)) + 90
            frame.Visible = true
        end)
    end

    getgenv()._VanishBallIndicatorStart = indicator_start
    getgenv()._VanishBallIndicatorStop = indicator_stop
end
end)

pcall(function()
do
    pcall(function()
        if getgenv().SemiImmortalityUnload then
            getgenv().SemiImmortalityUnload()
        end
    end)

    if type(getgenv().SemiImmortalityConfig) ~= "table" then
        getgenv().SemiImmortalityConfig = {}
    end
    local Config = getgenv().SemiImmortalityConfig
    if Config.SpeedBypassEnabled == nil then Config.SpeedBypassEnabled = true end
    if Config.Angle == nil then Config.Angle = 72 end
    if Config.Height == nil then Config.Height = 8 end
    Config.Height = math.clamp(tonumber(Config.Height) or 8, 1, 10)
    if Config.Depth == nil then Config.Depth = -8 end
    if Config.SquareRadius == nil then Config.SquareRadius = 7 end
    getgenv().SemiImmortalityConfig = Config
    getgenv().SemiImmortalityEnabled = getgenv().SemiImmortalityEnabled == true

    local Desync = {}
    local heartbeatConn
    local hookInstalled = false
    local enabled = false

    local function IsSupported()
        return setfflag and hookmetamethod and newcclosure and checkcaller
    end

    local function GetCharacter()
        return LocalPlayer.Character
    end

    local function InActiveMatch()
        local alive = Alive or workspace:FindFirstChild("Alive")
        if not alive then
            return false
        end
        local char = GetCharacter()
        if not char then
            return false
        end
        if char:IsDescendantOf(alive) then
            return true
        end
        return alive:FindFirstChild(char.Name) == char
    end

    local function InstallHook()
        if hookInstalled or not IsSupported() then
            return
        end
        hookInstalled = true
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
            if not enabled or checkcaller() then
                return oldIndex(self, key)
            end
            if key ~= "CFrame" then
                return oldIndex(self, key)
            end
            if not InActiveMatch() then
                return oldIndex(self, key)
            end
            local character = GetCharacter()
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then
                return oldIndex(self, key)
            end
            if self == hrp then
                return Desync[1] or CFrame.new()
            end
            if self == character:FindFirstChild("Head") then
                local base = Desync[1]
                if not base then
                    return CFrame.new()
                end
                local half = (typeof(hrp.Size) == "Vector3" and hrp.Size.Y or tonumber(hrp.Size) or 2) / 2
                return base + Vector3.new(0, half + 0.5, 0)
            end
            return oldIndex(self, key)
        end))
    end

    local function Start()
        if not IsSupported() then
            return false
        end
        InstallHook()
        if heartbeatConn then
            return true
        end
        heartbeatConn = RunService.Heartbeat:Connect(function()
            if not enabled then
                return
            end
            if not InActiveMatch() then
                return
            end
            local character = GetCharacter()
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then
                return
            end
            if Config.SpeedBypassEnabled then
                pcall(function()
                    setfflag("S2PhysicsSenderRate", "1333335")
                end)
            end
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.01, 0)
            Desync[1] = hrp.CFrame
            Desync[2] = hrp.AssemblyLinearVelocity
            local currentTime = tick()
            local angle = currentTime * math.pi * 2 * Config.Angle / 5
            local cycle = math.floor(currentTime * 29) % 2
            local yOffset = (cycle == 0) and Config.Depth or Config.Height
            local offset = Vector3.new(
                math.cos(angle) * Config.SquareRadius,
                yOffset,
                math.sin(angle) * Config.SquareRadius
            )
            hrp.CFrame = Desync[1] + offset
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            RunService.RenderStepped:Wait()
            hrp.CFrame = Desync[1]
            hrp.AssemblyLinearVelocity = Desync[2]
        end)
        return true
    end

    local function Stop()
        enabled = false
        getgenv().SemiImmortalityEnabled = false
        if heartbeatConn then
            heartbeatConn:Disconnect()
            heartbeatConn = nil
        end
    end

    local function SetEnabled(value)
        enabled = value == true
        getgenv().SemiImmortalityEnabled = enabled
        if not enabled then
            Stop()
            return true
        end
        if not Start() then
            enabled = false
            getgenv().SemiImmortalityEnabled = false
            return false
        end
        return true
    end

    getgenv().SemiImmortalityModule = { Config = Config, SetEnabled = SetEnabled, Stop = Stop }
    getgenv().SemiImmortalitySetEnabled = SetEnabled
    getgenv().SemiImmortalityUnload = function()
        Stop()
        getgenv().SemiImmortalityModule = nil
        getgenv().SemiImmortalitySetEnabled = nil
        getgenv().SemiImmortalityUnload = nil
    end

    if getgenv().SemiImmortalityEnabled then
        pcall(function()
            SetEnabled(true)
        end)
    end
end
end)

local watermark_holder = nil
local watermark_text = nil
local watermark_frames, watermark_fps = 0, 0
local watermark_acc = 0
local watermark_started = tick()
local watermark_dragging = false
local watermark_drag_start = nil
local watermark_start_pos = nil

local function ensure_watermark()
    if watermark_holder and watermark_holder.Parent then
        return
    end
    local parent = library and library._ui
    if not parent then return end
    local holder = Instance.new("Frame")
    holder.Name = "VanishWatermark"
    holder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    holder.BackgroundTransparency = 0.15
    holder.AutomaticSize = Enum.AutomaticSize.X
    holder.AnchorPoint = Vector2.new(0.5, 0)
    holder.Position = UDim2.new(0.5, 0, 0, 8)
    holder.Size = UDim2.fromOffset(0, 32)
    holder.BorderSizePixel = 0
    holder.Active = true
    holder.ZIndex = 50
    holder.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = holder
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 90, 90)
    stroke.Transparency = 0.45
    stroke.Parent = holder
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = holder
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    label.TextSize = 14
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Size = UDim2.new(0, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.RichText = true
    label.BorderSizePixel = 0
    label.ZIndex = 51
    label.Active = false
    label.Parent = holder
    holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            watermark_dragging = true
            watermark_drag_start = input.Position
            watermark_start_pos = holder.Position
        end
    end)
    if getgenv()._VanishWatermarkDrag then
        pcall(function() getgenv()._VanishWatermarkDrag:Disconnect() end)
    end
    if getgenv()._VanishWatermarkRelease then
        pcall(function() getgenv()._VanishWatermarkRelease:Disconnect() end)
    end
    getgenv()._VanishWatermarkDrag = UserInputService.InputChanged:Connect(function(input)
        if not watermark_dragging or not watermark_holder then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local delta = input.Position - watermark_drag_start
        watermark_holder.Position = UDim2.new(
            watermark_start_pos.X.Scale,
            watermark_start_pos.X.Offset + delta.X,
            watermark_start_pos.Y.Scale,
            watermark_start_pos.Y.Offset + delta.Y
        )
    end)
    getgenv()._VanishWatermarkRelease = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            watermark_dragging = false
        end
    end)
    watermark_holder = holder
    watermark_text = label
end

local cached_game_name = "Blade Ball"
task.spawn(function()
    pcall(function()
        local ms = game:GetService("MarketplaceService")
        local info = ms:GetProductInfo(game.PlaceId)
        if info and info.Name then
            cached_game_name = info.Name
        end
    end)
end)

RunService.Heartbeat:Connect(function(dt)
    if getgenv()._VanishAlive == false then
        return
    end
    watermark_frames += 1
    watermark_acc += dt or 0
    if watermark_acc < 1 then
        return
    end
    watermark_fps = watermark_frames
    watermark_frames = 0
    watermark_acc = 0
    PerformanceState.liveFps = watermark_fps
    if getgenv().UIWatermark == false then
        if watermark_holder then
            watermark_holder.Visible = false
        end
        return
    end
    ensure_watermark()
    if not watermark_holder or not watermark_text then
        return
    end
    watermark_holder.Visible = true
    local ping = 0
    pcall(function()
        ping = math.floor(get_data_ping())
    end)
    local elapsed = math.max(0, math.floor(tick() - watermark_started))
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = elapsed % 60
    local uptime
    if hours > 0 then
        uptime = string.format("%d:%02d:%02d", hours, minutes, seconds)
    else
        uptime = string.format("%02d:%02d", minutes, seconds)
    end
    local char = LocalPlayer and LocalPlayer.Character
    local alive_folder = Alive or workspace:FindFirstChild("Alive")
    local state = (char and alive_folder and char.Parent == alive_folder) and "In Match" or "In Lobby"
    local state_color = state == "In Match" and "#7CFF9A" or "#B4B4B4"
    local got_remote = remote_found_notified == true
        or (type(captured) == "table" and captured.remote ~= nil and captured.sessionKey ~= nil and key ~= nil)
        or (type(revertedRemotes) == "table" and next(revertedRemotes) ~= nil)
        or pry_parry_signal ~= nil
        or (_PARRY_REMOTE and _PARRY_REMOTE.ready == true)
    local remote_status = got_remote and "Found" or "Waiting"
    local remote_color = got_remote and "#7CFF9A" or "#FF7C7C"
    local platform = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled) and "Mobile" or "PC"
    watermark_text.Text = string.format("Vanish Premium | %s | %s | <font color=\"%s\">%s</font> | Remote: <font color=\"%s\">%s</font> | %s | %d FPS", cached_game_name, uptime, state_color, state, remote_color, remote_status, platform, watermark_fps)
end)
end
pcall(build_late_modules)
pcall(function()
    if library and library.select_tab_index then
        library:select_tab_index(1)
    end
    if library and library._ui then
        local container = library._ui:FindFirstChild("Container")
        if container then
            container.Visible = true
        end
    end
end)

pcall(function()
    if library and not library._ui_loaded then
        library:load()
    elseif library and library._ui_open == false then
        library._ui_open = true
        library:change_visiblity(true)
    end
end)
if library and library.Update1Run then
    pcall(function()
        library:Update1Run("0")
    end)
end

do
    local AT_TOKEN = tostring({}) .. tostring(os.clock())
    local snaps = {}
    local last_warn = 0
    local at_conn = nil

    local function warn_once(msg)
        if tick() - last_warn < 8 then return end
        last_warn = tick()
        pcall(function()
            if Notify then
                Notify({ title = "Anti Tamper", text = msg, duration = 3 })
            end
        end)
    end

    local function take_snaps()
        if not System then return end
        snaps.execute = System.parry and System.parry.execute
        snaps.execute_action = System.parry and System.parry.execute_action
        snaps.ap_frame = System.autoparry and System.autoparry.frame
        snaps.ap_start = System.autoparry and System.autoparry.start
        snaps.spam_frame = System.auto_spam and System.auto_spam.frame
        snaps.spam_start = System.auto_spam and System.auto_spam.start
        snaps.curve = System.curve and System.curve.get_cframe
        snaps.ball_get = System.ball and System.ball.get
        snaps.ball_all = System.ball and System.ball.get_all
        snaps.is_curved = System.detection and System.detection.is_curved
    end

    local function restore_fn(tbl, key, snap)
        if type(snap) ~= "function" then return false end
        if not tbl then return false end
        if tbl[key] ~= snap then
            tbl[key] = snap
            return true
        end
        return false
    end

    local function sweep()
        if not getgenv()._VanishAlive then return end
        if getgenv()._VanishAntiTamper ~= AT_TOKEN then
            getgenv()._VanishAntiTamper = AT_TOKEN
            getgenv()._VanishSystem = System
            warn_once("Env restored")
        end
        if getgenv()._VanishSystem ~= System then
            getgenv()._VanishSystem = System
        end
        local hit = false
        if System then
            hit = restore_fn(System.parry, "execute", snaps.execute) or hit
            hit = restore_fn(System.parry, "execute_action", snaps.execute_action) or hit
            hit = restore_fn(System.autoparry, "frame", snaps.ap_frame) or hit
            hit = restore_fn(System.autoparry, "start", snaps.ap_start) or hit
            hit = restore_fn(System.auto_spam, "frame", snaps.spam_frame) or hit
            hit = restore_fn(System.auto_spam, "start", snaps.spam_start) or hit
            hit = restore_fn(System.curve, "get_cframe", snaps.curve) or hit
            hit = restore_fn(System.ball, "get", snaps.ball_get) or hit
            hit = restore_fn(System.ball, "get_all", snaps.ball_all) or hit
            hit = restore_fn(System.detection, "is_curved", snaps.is_curved) or hit
        end
        if hit then
            warn_once("Functions restored")
        end
        pcall(function()
            local ui = getgenv()._VanishUI
            if ui and ui.Parent == nil and getgenv()._VanishAlive then
                warn_once("UI removed")
            end
        end)
    end

    take_snaps()
    getgenv()._VanishAntiTamper = AT_TOKEN
    getgenv()._VanishSystem = System

    local last_sweep = 0
    at_conn = RunService.Heartbeat:Connect(function()
        local t = tick()
        if t - last_sweep < 1 then
            return
        end
        last_sweep = t
        pcall(sweep)
    end)
    if getgenv()._VanishConns then
        table.insert(getgenv()._VanishConns, at_conn)
    end

    getgenv()._VanishAntiTamperStop = function()
        if at_conn then
            pcall(function() at_conn:Disconnect() end)
            at_conn = nil
        end
        getgenv()._VanishAntiTamper = nil
        getgenv()._VanishAntiTamperStop = nil
    end
end

getgenv()._VanishUnload = function()
    if getgenv()._VanishUnloading then
        return
    end
    getgenv()._VanishUnloading = true
    getgenv()._VanishAlive = false
    pcall(function()
        if getgenv()._Vanish_StopSoundController then
            getgenv()._Vanish_StopSoundController()
        end
    end)
    pcall(function()
        local snd = SoundService and SoundService:FindFirstChild("VanishSoundController")
        if snd then snd:Destroy() end
    end)
    pcall(function()
        if getgenv()._Vanish_StopPingSpoofer then
            getgenv()._Vanish_StopPingSpoofer()
        end
    end)
    pcall(function()
        if getgenv()._Vanish_StopNameSpoof then
            getgenv()._Vanish_StopNameSpoof()
        end
    end)
    pcall(function()
        if getgenv()._VanishAntiTamperStop then
            getgenv()._VanishAntiTamperStop()
        end
    end)
    pcall(function()
        if getgenv()._Vanish_StopAntiExploit then
            getgenv()._Vanish_StopAntiExploit()
        end
    end)
    pcall(function()
        if getgenv()._Vanish_StopCC then
            getgenv()._Vanish_StopCC()
        end
    end)
    getgenv()._VanishOnFire = nil
    pcall(function()
        if mouse1release then mouse1release() end
    end)
    pcall(function()
        local oldFire = getgenv()._VanishOldFire
        local hookfn = hookfunction or getgenv().hookfunction
        if type(oldFire) == "function" and type(hookfn) == "function" then
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            local sample = remotes and remotes:FindFirstChildWhichIsA("RemoteEvent")
            if sample then
                pcall(hookfn, sample.FireServer, oldFire)
            end
        end
        getgenv()._VanishOldFire = nil
    end)
    pcall(function()
        getgenv().NoRender = false
        getgenv().PerformanceEnabled = false
        getgenv().UnlockAllSwords = false
        getgenv().InfinityDetection = false
        getgenv().DeathSlashDetection = false
        getgenv().SlashOfFuryDetection = false
        getgenv().TimeHoleDetection = false
        getgenv().SingularityDetection = false
        getgenv().PulsedDetection = false
        getgenv().ForcefieldDetection = false
        getgenv().DualityDetection = false
        getgenv().DetectionsEnabled = false
        getgenv().ProtectionsEnabled = false
        getgenv().AntiExploit = false
        getgenv().AntiContentCreator = false
        getgenv().AbilityExploit = false
        getgenv().HeadlessKorbloxEnabled = false
        pcall(headlessKorblox_forgetConn)
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                Byte_Library.Restore_Head(char)
                Byte_Library.Restore_Leg(char)
            end
        end)
        getgenv().WalkspeedEnabled = false
        getgenv().JumpPowerEnabled = false
        getgenv().InfJumpEnabled = false
        getgenv().FovEnabled = false
        if getgenv()._VanishFovConn then
            pcall(function()
                getgenv()._VanishFovConn:Disconnect()
            end)
            getgenv()._VanishFovConn = nil
        end
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.FieldOfView = 70
            end
        end)
        getgenv().MobileCurve = false
        getgenv().ManualSpamModuleEnabled = false
        getgenv().SemiImmortalityEnabled = false
        getgenv().UIWatermark = false
    end)
    pcall(function()
        if getgenv()._VanishTriggerbotStop then
            getgenv()._VanishTriggerbotStop()
        end
    end)
    pcall(function()
        if getgenv()._VanishBallIndicatorStop then
            getgenv()._VanishBallIndicatorStop()
        end
        if getgenv()._VanishBallTrailStop then
            getgenv()._VanishBallTrailStop()
        end
    end)
    pcall(function()
        if getgenv()._VanishWinStreakStop then
            getgenv()._VanishWinStreakStop()
        end
    end)
    pcall(function()
        if getgenv()._VanishCustomWinStop then
            getgenv()._VanishCustomWinStop()
        end
    end)
    pcall(function()
        if getgenv().SemiImmortalityUnload then
            getgenv().SemiImmortalityUnload()
        end
        if getgenv()._VanishDesyncV2Stop then
            getgenv()._VanishDesyncV2Stop()
            getgenv()._VanishDesyncV2Stop = nil
            getgenv()._VanishDesyncV2 = nil
        end
    end)
    pcall(function()
        local s = getgenv()._VanishSystem
        if s then
            if s.__properties then
                s.__properties.__autoparry_enabled = false
                s.__properties.__auto_spam_enabled = false
                s.__properties.__manual_spam_enabled = false
            end
            if s.autoparry and s.autoparry.stop then s.autoparry.stop() end
            if s.auto_spam and s.auto_spam.stop then s.auto_spam.stop() end
            if s.manual_spam and s.manual_spam.stop then s.manual_spam.stop() end
            if s.protections then
                if s.protections.stopAntiHellHook then s.protections.stopAntiHellHook() end
                if s.protections.stopAntiPhantom then s.protections.stopAntiPhantom() end
                if s.protections.stopAntiPulse then s.protections.stopAntiPulse() end
            end
            if s.__properties and s.__properties.__connections then
                for _, conn in pairs(s.__properties.__connections) do
                    pcall(function()
                        if conn and conn.Disconnect then conn:Disconnect() end
                    end)
                end
            end
            if s.__properties and s.__properties.__mobile_guis then
                for _, gui_data in pairs(s.__properties.__mobile_guis) do
                    pcall(function()
                        if gui_data and gui_data.gui then gui_data.gui:Destroy() end
                    end)
                end
            end
        end
    end)
    pcall(function()
        local list = getgenv()._VanishConns
        if type(list) == "table" then
            for _, conn in ipairs(list) do
                pcall(function()
                    if conn and conn.Disconnect then conn:Disconnect() end
                end)
            end
        end
        getgenv()._VanishConns = {}
    end)
    pcall(function()
        if getgenv()._Vanish_StaffDet_Stop then getgenv()._Vanish_StaffDet_Stop() end
    end)
    pcall(function()
        if getgenv()._Vanish_AbilityExploit_Stop then getgenv()._Vanish_AbilityExploit_Stop() end
    end)
    pcall(function()
        if ability_esp and ability_esp.stop then ability_esp.stop() end
    end)
    pcall(function()
        if getgenv()._Vanish_StopNoRender then getgenv()._Vanish_StopNoRender() end
    end)
    pcall(function()
        if getgenv()._Vanish_StopPerformance then getgenv()._Vanish_StopPerformance() end
    end)
    pcall(function()
        if getgenv()._Vanish_StopMovement then getgenv()._Vanish_StopMovement() end
        if getgenv()._Vanish_MoveConn then
            getgenv()._Vanish_MoveConn:Disconnect()
            getgenv()._Vanish_MoveConn = nil
        end
        if getgenv()._Vanish_JumpConn then
            getgenv()._Vanish_JumpConn:Disconnect()
            getgenv()._Vanish_JumpConn = nil
        end
    end)
    pcall(headlessKorblox_forgetConn)
    pcall(function()
        if getgenv()._Vanish_ManualSpamHotkey then
            getgenv()._Vanish_ManualSpamHotkey:Disconnect()
            getgenv()._Vanish_ManualSpamHotkey = nil
        end
    end)
    pcall(function()
        if destroy_curve_overlay then destroy_curve_overlay() end
    end)
    pcall(function()
        local guis = getgenv()._VanishGuis
        if type(guis) == "table" then
            for _, gui in ipairs(guis) do
                pcall(function() if gui then gui:Destroy() end end)
            end
        end
        getgenv()._VanishGuis = {}
    end)
    pcall(function()
        if library and library._ui then
            library._ui:Destroy()
        end
    end)
    pcall(function()
        if getgenv()._VanishUI then getgenv()._VanishUI:Destroy() end
    end)
    getgenv()._VanishUI = nil
    getgenv()._VanishSystem = nil
    pcall(function()
        local libConns = getgenv()._VanishLibConnections
        if libConns and libConns.disconnect_all then
            libConns:disconnect_all()
        end
    end)
    getgenv()._VanishLibConnections = nil
    pcall(function()
        local parents = { CoreGui }
        pcall(function()
            if typeof(gethui) == "function" then
                table.insert(parents, gethui())
            end
        end)
        if LocalPlayer then
            table.insert(parents, LocalPlayer:FindFirstChild("PlayerGui"))
        end
        for _, parent in ipairs(parents) do
            if parent then
                for _, name in ipairs({ "VanishCurveOverlay", "ManualSpamPanel" }) do
                    local obj = parent:FindFirstChild(name)
                    if obj then pcall(function() obj:Destroy() end) end
                end
                for _, child in ipairs(parent:GetChildren()) do
                    if typeof(child.Name) == "string" and child.Name:find("Sigma", 1, true) == 1 then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end
        local cam = workspace.CurrentCamera
        if cam then
            local folder = cam:FindFirstChild("AcrylicBlur")
            if folder then pcall(function() folder:Destroy() end) end
        end
        local dof = Lighting:FindFirstChild("AcrylicBlur")
        if dof then pcall(function() dof:Destroy() end) end
    end)
    pcall(function()
        local oldFire = getgenv()._VanishOldFire
        local hookfn = hookfunction or getgenv().hookfunction
        if type(oldFire) ~= "function" or type(hookfn) ~= "function" then return end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local sample = remotes and remotes:FindFirstChildWhichIsA("RemoteEvent")
        if sample then
            hookfn(sample.FireServer, oldFire)
        end
        getgenv()._VanishOldFire = nil
    end)
    getgenv()._VanishUnload = nil
    getgenv()._VanishUnloading = nil
end
