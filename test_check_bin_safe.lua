
--
-- 检查二进制程序文件是否开启 /DEP, /ASLR 选项
--

require "win32exts"
--初始化代码页
--win32exts.set_acp(0)
win32exts.load_sym("*", "*")
win32exts.setlocale(0, "chs")

function GetSafeStatus(args)
	hdll = win32exts.LoadLibraryExA(args, nil, 2)
	strRet = ""
	if(hdll > 0) then
		hdll = win32exts.bit_command(hdll, "&", 0xFFFFFF00)
		lVal = win32exts.read_value(hdll, 0x3c, 4)
		lVal = win32exts.read_value(hdll, lVal + 0x18 + 0x46, 2)
		if win32exts.bit_command(lVal, "&", 0x40) == 0x40 then
			strRet = strRet .. "ASLR已开启，"
		else
			strRet = strRet .. "ASLR未开启，"
		end
		if win32exts.bit_command(lVal, "&", 0x0100) == 0x0100 then
			strRet = strRet .. "DEP已开启，"
		else
			strRet = strRet .. "DEP未开启，"
		end
	else
		strRet = "文件读取失败！！！"
	end
	return strRet
end

while true do
win32exts.println("请输入需要检查的目标文件全路径（可直接拖动至该窗口）：")
path = win32exts.get_input()
if path:sub(1, 1)=="\"" and path:sub(#path, #path)=="\"" then
	path = path:sub(2, #path-1)
end
if win32exts.PathFileExistsA(path) > 0 then
	win32exts.MessageBoxA(0, GetSafeStatus(path), path, 0);
else
	win32exts.MessageBoxA(nil, "输入文件非法！", "错误", 0)
end
end
