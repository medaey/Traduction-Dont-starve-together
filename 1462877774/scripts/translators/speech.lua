local function Split(str, separator)
  	local fields = {}
	local chr = 1
	
	str = str..separator
	for i = 1, #str do
		if str:sub(i, i) == separator then
			table.insert(fields, str:sub(chr, i - 1))
			chr = i + 1
		end
	end
	
	return fields
end

--[[local function isChar(x)
	return (x>='a' and x<='z') or (x>='A' and x<='Z') or (x>='0' and x<='9')
end--]]

local function isAcceptableAfterNick(x)
	return (x==' ') or (x==',' ) or (x=='.') or (x=='!')  or (x=='?') or (x=='\'')
end

local function translateFromDictionary(s)
	if not s then
		return ""
	end

	if DICTIONARY[s] then
		return DICTIONARY[s]
	end

	-- szukamy napisow z jednym %s
	local n = s:len()
	local ret, nickLen = nil, n+1
	for i=1,n do
		if i==1 or s:sub(i-1,i-1)==' ' then
			for j = math.min(n,i+nickLen-2),i,-1 do
				if j==n or isAcceptableAfterNick(s:sub(j+1,j+1)) then
					-- napis [i,j] moze byc nickiem gracza
					local x = s:sub(1,i-1).."%s"..s:sub(j+1)
--					print("x1=", x)
					x = DICTIONARY[x]
--					print("x2=", x) ;
					if x then
--						print("cand=", x)
						x = x:gsub("%%s", s:sub(i,j))
						if j-i+1 < nickLen then
							nickLen = j-i+1
							ret = x
						end
					end
				end
			end
		end
	end
	
	if ret ~= nil then
		return ret
	end

	-- szukamy napisow z dwoma %s
	ret, nickLen = nil, n+1
	for i=1,n do
		if i==1 or s:sub(i-1,i-1)==' ' then
			for j = math.min(n,i+nickLen-2),i,-1 do
				if j==n or isAcceptableAfterNick(s:sub(j+1,j+1)) then
					-- napis [i,j] moze byc nickiem gracza
					for k=j+2,n do
						if s:sub(k-1,k-1)== ' ' then
							for l=k,n do
								if l==n or isAcceptableAfterNick(s:sub(l+1,l+1)) then
									-- napis [k,l] moze byc atakujacym
									local x = s:sub(1,i-1).."%s"..s:sub(j+1,k-1).."%s"..s:sub(l+1)
--									print("x1=", x)
									x = DICTIONARY[x]
--									print("x2=", x) ;
									if x then
--										print("cand=", x)
										local attacker = s:sub(k,l)
										attacker = DICTIONARY[attacker] or attacker
										x = x:gsub("%%s", s:sub(i,j), 1)
										x = x:gsub("%%s", attacker)
										if j-i+1 < nickLen then
											nickLen = j-i+1
											ret = x
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	if ret then
		return ret
	end

	return s or ""
end


function translateMessage(message)
	local messages = Split(message,"\n") or {message}
	local ret = ""
	for i = 1, #messages do
		local translated = translateFromDictionary(messages[i])
				
		if i == 1 then
			ret = translated
		elseif translated ~= messages[i] then
			ret = ret.."\n"..translated
		else
			ret = ret..translateFromDictionary("\n"..messages[i])
		end
	end
	return ret
end

local OldNetworking_Talk = GLOBAL.Networking_Talk
local function Networking_Talk(guid, message, ...)
	message = translateMessage(message)
	OldNetworking_Talk(guid, message, ...)
end

---------------------------------------------------
--// Save Variables
---------------------------------------------------
GLOBAL.scheduler:ExecuteInTime(0, function()
	GLOBAL.Networking_Talk = Networking_Talk
end)