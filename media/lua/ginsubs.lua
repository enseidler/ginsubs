subs = {}
current = 1

offset = 0
clock = 0

w,h = canvas:attrSize()

function handler (evt)
  if evt.key == "RED" then rewindSubs()
  elseif evt.key == "GREEN" then forwardSubs()
  elseif evt.key == "YELLOW" then resetSubs()
  end
  if evt.type == "release" then
    canvas:attrColor('white')
    canvas:drawText(0, 0, offset*0.001)
    canvas:attrColor('transparent')
    canvas:flush()
  end
end

function resetSubs()
  offset = 0
end

function rewindSubs()
  offset = offset - 50
end

function forwardSubs()
  offset = offset + 50
end


function startSubs()
  loadFile("media/subs/subseng.srt")
  proccessFile()
  updateSub()
end

function updateSub()
  
  if subs[current] then
    if clock + offset > subs[current].finish then
      current = current + 1
    elseif current > 1 and clock + offset < subs[current].start then
      current = current - 1
    end
  else
    canvas:attrColor('transparent')
    canvas:clear()
  end
  
  showSub()
  clock = clock + 1000
  event.timer(1000, updateSub)
end

function showSub()
  local sub = subs[current]
  if clock + offset >= sub.start and clock + offset <= sub.finish then
    canvas:attrColor('transparent')
    canvas:clear()
    canvas:attrColor('white')
    canvas:attrFont('Tiresias', 20, 'bold')
    line1W, line1H = canvas:measureText(sub.line1)
    line2W, line2H = canvas:measureText(sub.line2)
    canvas:drawText(w/2 - line1W/2, 0, sub.line1)
    canvas:drawText(w/2 - line2W/2, 22, sub.line2)
  else
    canvas:attrColor('transparent')
    canvas:clear()
  end
  canvas:flush()
end

function toMilliseconds(time)
  local h, m, s, c = string.match(time, "(%d*):(%d*):(%d*),(%d*)")
  return h*3600000 + m*60000 + s*1000 + c
end

function loadFile (filepath)
  io.input(filepath)
end

function proccessFile()
  local index = 1
  while true do
    if not io.read() then break end
    local sub = {}
    local interval = io.read()
    sub.start = toMilliseconds(string.sub(interval, 1, 12))
    sub.finish = toMilliseconds(string.sub(interval, 18, 29))
    sub.line1 = io.read()
    sub.line2 = io.read()
    if sub.line2 then
      if string.len(sub.line2) > 1 then io.read() end
    end
    subs[index] = sub
    index = index + 1
  end
end

event.register(handler)
startSubs()