function onCreate()
  for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'phone-filterless' and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_phone')
  		setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
  		setPropertyFromGroup('unspawnNotes', i, 'offset.x', -4)
		end
	end
end
function goodNoteHit(id, data, type, sus)
  if type == 'phone-filterless' then
    playAnim('boyfriend', 'dodge', false)
    setProperty('boyfriend.specialAnim', false)
    playAnim('dad', 'singThrow', false)
    setProperty('dad.specialAnim', false)
  end
end
function noteMiss(id, data, type, sus)
  if type == 'phone-filterless' then
    playAnim('boyfriend', 'hurt', true)
    setProperty('boyfriend.specialAnim', true)
    playAnim('dad', 'singThrow', false)
    setProperty('dad.specialAnim', false)
    
    setPropertyFromGroup('playerStrums', data, 'alpha', 0)
    noteTweenAlpha('comeBack'..data, data+4, 1, 8, 'cubeIn')
  end
end
function opponentNoteHit(id, data, type, sus)
  if type == 'phone-filterless' then
    playAnim('dad', 'singSmash', false)
    setProperty('dad.specialAnim', false)
  end
end