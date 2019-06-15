local display = require("tm1640")

print("===== Main =====")

display.init(7,5)
display.write({0, 0, 0, 0, 0, 0, 0, 0})

display.write({0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff})
for x=1,2 do
  for i = 0,5 do
    print(i)
    display.brightness(i)
    tmr.delay(1000)
  end
end

print("smile")
c = {0x3c, 0x42 ,0xa5 ,0x81 ,0xa5 ,0x99 ,0x42 ,0x3c}
b = {}
j = 1
for i=#c,1,-1 do
  b[j] = c[i]
  j = j + 1
end
tmr.delay(10 * 1000)
display.write(b)


