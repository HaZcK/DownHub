-- [[ KHAFIDZKTP PRIVATE LOADER ]] --
loadstring(game:HttpGet(" https://raw.githubusercontent.com/HaZcK/DownHub/refs/heads/main/Ultimate.lua "))()
local player = game.Players.LocalPlayer

-- 1. Siapa yang diperbolehkan (Loader Whitelist)
local allowedUsers = {
    ["KHAFIDZKTP"] = true,
    ["zeros7299"] = true
}

if not allowedUsers[player.Name] then
    player:Kick("Gak boleh masuk! Ini cuma buat KHAFIDZKTP & zeros7299")
    return
end

-- 2. Jalankan Script Utama (Ultimate.lua yang sudah kamu edit jalurnya)
-- Pastikan kamu simpan Ultimate.lua yang sudah diedit ke lokasi baru 
-- atau masukkan kodenya langsung di bawah sini.

print("Welcome " .. player.Name .. "! Plot otomatis terdeteksi.")

-- [ Masukkan semua kode Ultimate.lua yang sudah kamu edit di sini ] --
