---------------------------------------------------------------------------
--
--     Filename:  file_lock.lua
--
--  Description:  file lock for lua by fcntl
--
--      Version:  1.0
--      Created:  10/19/2018 11:23:53 AM
--     Revision:  None
--
--       Author:  gerrard (gerrard), <gyc.ssdut@gmail.com>
--      Company:  
--
---------------------------------------------------------------------------


local fcntl = require('posix.fcntl')
local stat = require('posix.sys.stat')
local unistd = require('posix.unistd')

local _M = {}
_M.version = '0.0.1'

function _M.new(self, opts)
    if not opts.name then
        return nil, 'file name required'
    end
    local fd = fcntl.open(
        opts.name,
        opts.flags or fcntl.O_CREAT + fcntl.O_WRONLY + fcntl.O_TRUNC,
        opts.mode or stat.S_IRUSR + stat.S_IWUSR + stat.S_IRGRP + stat.S_IROTH
    )
    local lock = {
        l_type = fcntl.F_WRLCK,
        l_whence = fcntl.SEEK_SET,
        l_start = 0,
        l_len = 0
    }
    t = {
        fd = fd,
        lock = lock
    }
    return setmetatable(t, {__index = _M})
end

function _M.get_fd(self)
    return self.fd
end

function _M.get_lock(self)
    return self.lock
end

function _M.set_lock_type(self, l_type)
    local lock = self:get_lock()
    lock.l_type = l_type
    self.lock = lock
end

function _M.fcntl(self, cmd)
    local fd = self:get_fd()
    local lock = self:get_lock()
    return fcntl.fcntl(fd, cmd, lock)
end

function _M.get_lock_type(self)
    local lock = self:get_lock()
    return lock.l_type
end

function _M.read_lock(self)
    self:set_lock_type(fcntl.F_RDLCK)
    return self:fcntl(fcntl.F_SETLK)
end

function _M.write_lock(self)
    self:set_lock_type(fcntl.F_WRLCK)
    return self:fcntl(fcntl.F_SETLK)
end

function _M.unlock(self)
    self:set_lock_type(fcntl.F_UNLCK)
    return self:fcntl(fcntl.F_SETLK)
end

function _M.try_read_lock(self)
    self:set_lock_type(fcntl.F_RDLCK)
    local status, errmsg, errno = self:fcntl(fcntl.F_GETLK)
    if status and self:get_lock_type() == fcntl.F_UNLCK then
        return true
    end
    return false, errmsg, errno
end

function _M.try_write_lock(self)
    self:set_lock_type(fcntl.F_WRLCK)
    local status, errmsg, errno = self:fcntl(fcntl.F_GETLK)
    if status and self:get_lock_type() ~= fcntl.F_UNLCK then
        return true
    end
    return false, errmsg, errno
end

function _M.delete(self)
    self:unlock()
    local fd = self:get_fd()
    unistd.close(fd)
end

return _M

