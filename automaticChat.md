Go to default resource chat/cl_chat.lua, line 231, find:

if not isRDR then
  if RegisterKeyMapping then
    RegisterKeyMapping('toggleChat', 'Toggle chat', 'keyboard', 'l')
  end

  RegisterCommand('toggleChat', function()
    if chatHideState == CHAT_HIDE_STATES.SHOW_WHEN_ACTIVE then
      chatHideState = CHAT_HIDE_STATES.ALWAYS_SHOW
    elseif chatHideState == CHAT_HIDE_STATES.ALWAYS_SHOW then
      chatHideState = CHAT_HIDE_STATES.ALWAYS_HIDE
    elseif chatHideState == CHAT_HIDE_STATES.ALWAYS_HIDE then
      chatHideState = CHAT_HIDE_STATES.SHOW_WHEN_ACTIVE
    end

    isFirstHide = false

    SetResourceKvp('hideState', tostring(chatHideState))
  end, false)
end

And replace with this:

if not isRDR then
    chatHideState = CHAT_HIDE_STATES.SHOW_WHEN_ACTIVE

    isFirstHide = false

    SetResourceKvp('hideState', tostring(chatHideState))
end