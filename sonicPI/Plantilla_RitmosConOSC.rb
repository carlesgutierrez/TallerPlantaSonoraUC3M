# Definimos la variable de ritmo inicial
myRate = 1.0
myMainDelay = 1.0
myRemoteValue = 0.0
bStopAll = false



live_loop :looongPlayOSC do
  puts "******************** OSC looongPlayOSC **********************"
  use_real_time
  a = sync "/osc*/Temp"
  sample  :ambi_choir, rate: 0.4
end

live_loop :addKalimbaloopOSC do
  puts "******************** OSC Kalimbaloop **********************"
  use_real_time
  a = sync "/osc*/Moist"
  use_bpm 120
  use_synth  :kalimba #:mod_fm
  bStopAll = false
  
  live_loop :kalimbaloop do
    a = rrand_i(0,2)
    puts a
    if a == 0
      play 60
      sleep 1
    elsif a == 1
      play 62
      sleep 1
    else
      play 64
      sleep 1
    end
    if bStopAll == true
      stop
    end
    
  end
end

live_loop :stopOSC do
  puts "******************** OSC STOP **********************"
  use_real_time
  a = sync "/osc*/stopAll"
  
  bStopAll = true
end


live_loop :osc8TatasRitmo do
  puts "******************** OSC 8 Tatas**********************"
  use_real_time
  a = sync "/osc*/Hum"
  sampleVar = :ambi_choir
  
  sample sampleVar, sustain: 15
  4.times do |i|
    if i == 0
      sample sampleVar, amp: (line 2, 1, steps: 8).tick
      sleep 2
    else
      sample sampleVar, amp: (line 2, 1, steps: 8).tick
      sleep 1
    end
  end
  
  8.times do |i|
    if i == 0
      sample sampleVar, amp: 2
    else
      sample sampleVar, amp: 1
    end
    sleep 0.25
  end
  
  
  
end


