local display = require("tm1640")

print("===== Main =====")

display.init(7,5)
display.write({0, 0, 0, 0, 0, 0, 0, 0})

display.write({0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff})
for x=1,2 do
  for i = 0,5 do
    display.brightness(i)
    tmr.delay(1000)
  end
end

local flag = true
display.brightness(5)
tmr.create():alarm(1000, tmr.ALARM_AUTO, function()
  if flag then
    display.write({0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff})
  else
    display.write({0, 0, 0, 0, 0, 0, 0, 0})
  end
  flag = not flag
end)



