---------------------------------------------------------------------------
--
--     Filename:  set_lock.lua
--
--  Description:  
--
--      Version:  1.0
--      Created:  10/19/2018 11:27:19 AM
--     Revision:  None
--
--       Author:  gerrard (gerrard), <gyc.ssdut@gmail.com>
--      Company:  
--
---------------------------------------------------------------------------

local file_lock = require('file_lock')

local lock, err = file_lock:new({
    name = 'file.lock'
})

local function sleep(n)
    local t0 = os.clock()
    while os.clock() - t0 <= n do end
end

local status, errmsg, errno = lock:write_lock()
if status then
    print(os.time(), ' : locked')
end
sleep(3)

lock:delete()
print(os.time(), ' : unlocked')

