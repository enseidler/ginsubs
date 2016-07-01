io.input("media/subs/video.srt")

function handler (evt)
    canvas:clear()
    canvas:attrColor('yellow')
    canvas:attrFont('Tiresias', 15, 'bold')
    canvas:drawText(0,0,io.read())
    canvas:attrColor('black')
    canvas:flush()
end


event.register(handler)