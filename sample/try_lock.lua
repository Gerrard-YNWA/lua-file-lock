---------------------------------------------------------------------------
--
--     Filename:  try_lock.lua
--
--  Description:  
--
--      Version:  1.0
--      Created:  10/19/2018 11:26:22 AM
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

--try lock
while true do
    local ok, errmsg, errno = lock:try_read_lock()
--local ok, errmsg, errno = lock:try_write_lock()
    if not ok then
        print(os.time(), ": locked, retry after 1s")
        sleep(1)
    else
        print(os.time(), ": lockable")
        break
    end
end

lock:delete()

