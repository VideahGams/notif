local notif = {}
notif.stack = {}

function notif.print(text)

	local tbl = {text = text, typ = "print"}

	table.insert(notif.stack, tbl)

end

function notif.warning(text)

	local tbl = {text = text, typ = "warning"}

	table.insert(notif.stack, tbl)

end

function notif.error(text)

	local tbl = {text = text, typ = "error"}

	table.insert(notif.stack, tbl)

end

function notif.draw()

	local font = love.graphics.newFont(16)

	local w, h = love.graphics.getWidth(), love.graphics.getHeight()

	for i=1, #notif.stack do

		local text = notif.stack[i].text

		local width = font:getWidth(text)
		local height = 75

		local x = w - width
		local y = (h - height)
		y = y - (height * (#notif.stack - i))

		love.graphics.setFont(font)

		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", x, y, width, height)

		love.graphics.setColor(0,0,0)
		love.graphics.print(text, x, y)

	end

end

notif.print("This is a test notification")
notif.print("This is a test notification 2")
notif.print("This is a test notification 3")

return notif
