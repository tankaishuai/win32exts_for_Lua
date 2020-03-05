
require "win32exts"
win32exts.set_acp(0)

local pBuffer = win32exts.malloc(2*260)

iii = win32exts.load_sym("*", "*")


--定义一些消息Id
WM_INITDIALOG = tonumber("110", 16)
WM_CLOSE = tonumber("10", 16)
WM_QUIT = tonumber("12", 16)
WM_COMMAND = tonumber("111", 16)
WM_SYSCOMMAND = tonumber("112", 16)
WM_GETTEXT = 13
WM_WINDOWPOSCHANGED = tonumber("47", 16)

--窗口过程
function OnDlgProc(args)
	local hwnd = win32exts.arg(args, 1)
	local uMsg = win32exts.arg(args, 2)
	local wParam = win32exts.arg(args, 3)
	local lParam = win32exts.arg(args, 4)

	print("OnDlgProc: hwnd = " .. hwnd .. ", uMsg = " .. uMsg .. ", wParam = " .. wParam .. ", lParam = " .. lParam)
	
    	if uMsg == WM_INITDIALOG then
		print("OnDlgProc:" .. hwnd .. ", " .. uMsg .. "(WM_INITDIALOG)")

		--设置所关心的消息过滤器（非必须）
		local p = win32exts.malloc(4 * (1 + 1))
		win32exts.write_value(p, 0, 4, 1)
		win32exts.write_value(p, 4, 4, WM_WINDOWPOSCHANGED)
		win32exts.SetPropW(hwnd, {"MessageFilter"}, p)

	elseif uMsg == WM_CLOSE then
		win32exts.DestroyWindow(hwnd)
		win32exts.PostQuitMessage( -233 )

	elseif uMsg == WM_GETTEXT then
		print("WM_GETTEXT")

	elseif uMsg == WM_WINDOWPOSCHANGED then
		print("WM_WINDOWPOSCHANGED")

	elseif uMsg == WM_COMMAND then
		return false, 16

	elseif uMsg == WM_SYSCOMMAND then
		return false, 16

	end

	return true, 16
end


--获取Lua窗口过程地址（使用 DLGPROC 可选属性则对窗口过程进行优化）。
local pfnOnDlgProc = win32exts.global_function("OnDlgProc", "DLGPROC")


--初始化过程
function OnInitRuntine(args)
	if 0 ~= pfnOnDlgProc then
		--创建一个对话框并显示之
		local hwnd = win32exts.CreateDialogParamW(win32exts.current_dll(), 101, nil, pfnOnDlgProc, 0)
		win32exts.ShowWindow(hwnd, true)
	end
	return 0, 4
end


--使用内建消息循环（当然也可以不用）
local ret = win32exts.SysMessageLoop(OnInitRuntine, nil, nil)



win32exts.free(pBuffer)
