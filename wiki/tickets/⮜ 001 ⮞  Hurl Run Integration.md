---
created: 2026-11-10T10:46
finished: 2026-11-10T22:19
---
#ticket/closed

## Tasks
- [x] Write output to buffer
- [x] Open buffer to the right (like [[compile mode]])
- [x] Create Run Command

## Description

Just map the run command to the current file.

```lua
local file = nivm.getbuf(...)
local checkEnvFile = nvim.get(".env|.env.gpg")

if envFile.isEncrypted then
    nvim.cmd("hurl --variable-file <(gpg -d .env.gpg) %")
else
    nvim.cmd("hurl --variable-file .env %")
end
```

## Conclusion
- This was a horrible choice, to use the nvim api
    -> It's just a trash api, which makes everything difficult
    => Just don't use it anymore, rather write a small c binary or smth

