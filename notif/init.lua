-- This code is licensed under the MIT Open Source License.

-- Copyright (c) 2015 Ruairidh Carmichael - ruairidhcarmichael@live.co.uk

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

local notif = {}
notif.stack = {}

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function notif.print(text, duration, color)

	color = color or {255, 255, 255}
	duration = duration or 5

	for i=1, #notif.stack do

		local stacktext = notif.stack[i].text

		if text == stacktext then
			notif.stack[i].duration = notif.stack[i].maxduration
			return
		end

	end

	local tbl = {text = text, maxduration = duration, duration = duration, color = color, typ = "print"}

	table.insert(notif.stack, tbl)

end

function notif.warning(text, duration)

	duration = duration or 5

	for i=1, #notif.stack do

		local stacktext = notif.stack[i].text

		if text == stacktext then
			notif.stack[i].duration = notif.stack[i].maxduration
			return
		end

	end

	local tbl = {text = text, maxduration = duration, duration = duration, color = {241, 196, 15}, typ = "warning"}

	table.insert(notif.stack, tbl)

end

function notif.error(text, duration)

	duration = duration or 5

	for i=1, #notif.stack do

		local stacktext = notif.stack[i].text

		if text == stacktext then
			notif.stack[i].duration = notif.stack[i].maxduration
			return
		end

	end

	local tbl = {text = text, maxduration = duration, duration = duration, color = {192, 57, 43}, typ = "error"}

	table.insert(notif.stack, tbl)

end

function notif.draw()

	notif.print("This should not disapear.", 5)

	local font = love.graphics.newFont(16)

	local w, h = love.graphics.getWidth(), love.graphics.getHeight()

	for i=1, #notif.stack do

		local text = notif.stack[i].text

		local width = font:getWidth(text)
		local height = 75

		local x = w - width
		local y = (h - height)
		y = y - ((height + 5) * (#notif.stack - i))

		-- Color bar --
		love.graphics.setColor(notif.stack[i].color)
		love.graphics.rectangle("fill", x - 5, y, 5, height)

		love.graphics.setFont(font)

		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", x, y, width, height)

		love.graphics.setColor(0,0,0)
		love.graphics.print(text, x, y)

	end

end

function notif.update(dt)

	for i=1, #notif.stack do

		if round(notif.stack[i].duration) <= 0 then -- The duration of the notification is over ...

			table.remove(notif.stack, i) -- ... So let's delete the notification.

			return -- Let's not bother setting the duration, there's not duration to set.

		end

		notif.stack[i].duration = notif.stack[i].duration - dt -- Countdown the duration in seconds.

	end

end

notif.print("This is a test notification", 5)
notif.warning("This is a test notification 2", 7)
notif.error("This is a test notification 3", 9)

return notif
