# lua-file-lock
simple file lock for lua by posix fcntl

### sample
sample dir shows one process set a write lock and anthor process try to get lock failed
after write lock unlocked, the trying process can successfully get lock.
```
[lua-file-lock]$ lua sample/set_lock.lua 
1539930102   : locked
1539930107   : unlocked

[lua-file-lock]$ lua sample/try_lock.lua 
1539930103  : locked, retry after 1s
1539930105  : locked, retry after 1s
1539930107  : lockable
```

### new(opts) 

**syntax**
```
local flock = require('file_lock')
local lock = flock:new{
    name = 'file.lock'
}
```
new a file_lock object with the given file name.

return table holds the lock and fd.

in case of error, nil and error message returned.

* opts.name   filename of file lock
* opts.flags (optional) flags of open file set open api in fcntl.h
* opts.mode (optional) mode of open file set open api in fcntl.h

**

### read_lock()
**syntax**
```
local status, errmsg, errno = flock:read_lock()
```
try to get a read lock(F_RDLCK) by fnctl with cmd F_SETLK

return 0 if set lock success, otherwise -1 returned with errmsg and errno

### write_lock()
**syntax**
```
local status, errmsg, errno = flock:write_lock()
```
try to get a write lock(F_WRLCK) by fnctl with cmd F_SETLK 

return 0 if set lock success, otherwise -1 returned with errmsg and errno

### try_read_lock()
**syntax**
```
local status, errmsg, errno = flock:try_read_lock()
```

test if read lock(L_RDLCK) could be set, return true if success or false and errmsg and errno will be returned

### try_write_lock()
**syntax**
```
local status, errmsg, errno = flock:try_write_lock()
```

test if write lock(L_WRLCK) could be set, return true if success or false and errmsg and errno will be returned

### unlock()
**syntax**
```
local status, errmsg, errno = flock:unlock()
```
try to unlock(F_UNLCK) by fnctl with cmd F_SETLK 

return 0 if set success, otherwise -1 returned with errmsg and errno

### delete()
**syntax**
```
flock:delete()
```

unlock and free fd.


