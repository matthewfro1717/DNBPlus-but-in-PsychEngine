function onCreate()
  for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'recursed' and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_recursed')
  		setPropertyFromGroup('unspawnNotes', i, 'noAnimation', false)
  		setPropertyFromGroup('unspawnNotes', i, 'offset.x', -4)
		end
	end
end