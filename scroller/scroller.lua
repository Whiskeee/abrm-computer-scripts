local os = require 'os'
local term = require 'term'
local component = require 'component'
local gpu = component.gpu

local screens = component.list('screen')

local textToWrite = "Hello, this is a testing message"
local textLength = string.len(textToWrite)

local maxResX = 36
local maxResY = 1

--[[
  NOTE: big problem with the current version of this script is that the more monitors you have
  The laggier this will be, so bare that in mind until we rewrite this bad boi.
]]

while true do

  -- Go through each screen, reset cursor to default position and wipe/clear it

  for address, v in pairs(screens) do
    gpu.bind(address, false)
    local resX, resY = gpu.getResolution()
    if (resX ~= maxResX and resY ~= maxResY) then -- if the current monitors resolution is incorrect, fix that shiz
      gpu.setResolution(maxResX, maxResY)
    end
    term.setCursor(1,1)
    term.clear()
  end

  -- Begin spitting bars (translation: write the text)

  for i=1,textLength do
    for address, v in pairs(screens) do
      gpu.bind(address, false) -- false meaning do not reset elements of the monitor i.e. resolution
      local w, h = gpu.getResolution()
      term.setCursor(w-i, 1)
      term.write(string.sub(textToWrite, 1, i))
    end
    os.sleep(0.01)
  end

  os.sleep(5)

end
