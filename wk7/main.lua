print("===== Main =====")

-- in you init.lua:
if adc.force_init_mode(adc.INIT_ADC)
then
  node.restart()
  return -- don't bother continuing, the restart is scheduled
end

tmr.create():alarm(1000, tmr.ALARM_AUTO, function()
  print("ADC: ", adc.read(0))
  print("System voltage (mV):", adc.readvdd33(0))
end)



