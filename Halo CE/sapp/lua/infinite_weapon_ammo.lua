api_version = "1.12.0.0"

ONE_GRENADE_SIG, DECREMENTING_SIG = 0,0
ONE_GRENADE_CODE, DECREMENTING_CODE = {},{}

function read_bytes(Address, Count)
	local bytes = {}
	for i=0,Count-1 do
		table.insert(bytes, read_byte(Address+i))
	end
	return bytes
end

function write_bytes(Address, Bytes)
	safe_write(true)
	for k,v in pairs(Bytes) do
		write_byte(Address+k-1, v)
	end
	safe_write(false)
end

function OnScriptLoad()
	ONE_GRENADE_SIG = sig_scan("7F05B9010000008808404E")
	DECREMENTING_SIG = sig_scan("84C975408B0D????????85C9")
	
	if(ONE_GRENADE_SIG ~=0 and DECREMENTING_SIG ~= 0) then
		ONE_GRENADE_CODE = read_bytes(ONE_GRENADE_SIG+0x7, 2)
		DECREMENTING_CODE = read_bytes(DECREMENTING_SIG, 4)
		write_bytes(ONE_GRENADE_SIG + 0x7, {0x90, 0x90})
		write_bytes(DECREMENTING_SIG, {0x90, 0x90, 0x90, 0x90})
	end
	
	execute_command("cheat_infinite_ammo true")
end

function OnScriptUnload()
	if(ONE_GRENADE_SIG ~=0 and DECREMENTING_SIG ~= 0) then
		write_bytes(ONE_GRENADE_SIG+0x7, ONE_GRENADE_CODE)
		write_bytes(DECREMENTING_SIG, DECREMENTING_CODE)
	end
	
	execute_command("cheat_infinite_ammo false")
end