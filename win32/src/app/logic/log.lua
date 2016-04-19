
local filePath = ""
local function log( ... )
	if filePath == "" then
		filePath = os.date("%Y-%m-%d %H_%M_%S")..".log"
    	print (filePath)
	end
    local params = {...}
    local c = #params
    local str = "["..os.date().."]"
    for i=1,c do

    	str = str..params[i]..(i<c and "," or "")
    end
    str = str.."\r\n"
    local file = io.open(filePath,"a+")
    file:write(str)
    file:close()
end

cc.exports.log = log