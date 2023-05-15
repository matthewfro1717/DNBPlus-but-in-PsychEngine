function onCreate()
  for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'phone-zardy' and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_phone')
  		setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
  		setPropertyFromGroup('unspawnNotes', i, 'offset.x', -4)
		end
	end
end
function goodNoteHit(id, data, type, sus)
  if type == 'phone-zardy' then
    playAnim('boyfriend', 'singSmash', true)
    setProperty('boyfriend.specialAnim', true)
  end
end