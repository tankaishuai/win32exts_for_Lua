--
-- 测试 COM 组件, 打开计算器
--

require "win32exts"
--初始化代码页
win32exts.set_acp(0)
--初始化组件库
win32exts.co_init(true)

wsh = win32exts.create_object("Wscript.Shell")

--wsh.Run("calc")
wsh.invoke("Run", "calc")

wsh.release()
