--
-- 测试 COM 组件, 打开计算器
--

wsh = win32exts.create_object("Wscript.Shell")

--wsh.Run("calc")
wsh.invoke("Run", "calc")

wsh.release()
