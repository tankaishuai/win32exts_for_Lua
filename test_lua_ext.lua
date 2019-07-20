require("win32exts")

--
-- 加载模块符号信息
--
print("----------")
iii = win32exts.load_sym("kernel32", "*")
iii = win32exts.load_sym("user32", "*")

--
-- 分配内存
--
g_buf = win32exts.malloc(2*260)

--
-- 获取当前进程路径
--
g_exe_handle = win32exts.GetModuleHandleW(nil)
win32exts.GetModuleFileNameW(g_exe_handle, g_buf, 260)
g_exe = win32exts.read_wstring(g_buf, 0, -1)

------------------------------------------------------------------

--
-- 创建一个COM组件对象（这里以加载自己为例）
--
win32atls = win32exts.create_object("win32exts.win32atls")
assert(win32atls)

-- 查询接口
win32atls_sub = win32atls.query_interface("IRunningObjectTable")
assert(not win32atls_sub)
win32atls_sub = win32atls.query_interface("IDispatch")
assert(win32atls_sub)

-- 执行COM方法：list_sym()
local var = win32atls.invoke("list_sym")

-- 执行COM方法：load_sym("ole32.dll", "*")
local var = win32atls.invoke("load_sym", "ole32.dll", "*")

-- 再次执行COM方法：list_sym()
local var = win32atls.invoke("list_sym")
win32atls.release()
if win32atls_sub then
	win32atls_sub.release()
end
print("win32exts.win32atls.list_sym = " .. var .. "\n")

------------------------------------------------------------------

--
-- 弹出消息框
--
win32exts.MessageBoxA(nil, "start你好A", nil, nil)

-- 宽字节API参数用 {} 括起来
win32exts.MessageBoxW(nil, {"start你好W"}, nil, nil)
print("start你好")

------------------------------------------------------------------

--
-- 退出进程
--
win32exts.ExitProcess(-123)
return
