# Win32Exts.dll 功能清单：

1、支持 Lua, VBS, JavaScript, Python, Java 任意调用 Win32 API 以及其它第三方DLL扩展

2、方便的各种网络请求、下载库支持, 集成 libcurl 网络库功能

3、集成 Firebird, mysql, sqlite, access, WMI，以及其它提供了 OLDB连接的数据库，使用统一接口访问，并自带方便的 shell； 支持内存数据库并可 duplicate buffer， 支持内存虚拟文件系统

4、集成各种实用的模块注入接口，以及 API hook 接口，以及模块隐藏等 Spy 能力

5、集成反汇编能力

6、支持解释其它 类 C/uBASIC 语言

7、集成 zlib 等压缩解压缩库

8、集成 crc32, md4, md5， sha-1, rc4 等哈希库算法

9、集成各种浏览器(如：webkit, miniblink, cef, IE) 功能， 并支持 js 脚本中直接使用 ActiveX 控件

10、扩展各种正则表达式库

11、实现 WinDbg, ExStudPE, CefViewPlugin, libcef, VisualDbViewer, x64dbg 等插件接口

12、集成屏幕抓图功能

13、集成方便的自动化 dump分析功能

14、支持屏幕取点取色

15、集成 Dll2Hpp 标识符反修饰功能

16、集成CheckFileHandle 文件解锁工具功能

17、集成 base64 编码解码库

18、集成虚拟机

19、支持32位调用 64 代码

20、集成 cJSON json 库

21、实现 Win XP ~ Win10 下 shell32.dll 模块全部接口

22、集成 eval32 for MatLab 功能


======================================

# ver 48.2020.3.27 更新：

1、大大扩充了对于多线程、多进程 应用开发的能力支持

     （见文档： https://blog.csdn.net/tan_kaishuai/article/details/104393576  ）
     
2、扩充了枚举 进程、线程、服务、注册表、Dll模块、用户、窗口、工作站、导入表、导出表、目录、磁盘卷、内存堆、窗口属性、句柄信息、文件流  等等系统环境信息的接口： list_****()
        
     （见文档：https://blog.csdn.net/tan_kaishuai/article/details/104507255   ）
     
3、扩充了对于位运算、数学运算的支持

     （见文档：暂缺）
     
4、提供给的 win32exts.print()、win32exts.println() 更加灵活方便，尤其是直接输出 table 类型可谓一步到位。

     （见文档：暂缺）

5、完善win32基础交互API：

     （见文档： https://blog.csdn.net/tan_kaishuai/article/details/100019191  ）

6、其它一些实用 API 的支持（如模块注入、目录监控、管道输入输出、WMI 等等）

     （见文档：暂缺）
     
7、扩展 lua_next_v3() 等几个接口，支持按序遍历 Lua table 结构！！！ 用法：

lua_pushnil(L);

while(lua_next_v3(L, i， 0)){

。   //按序获取每一项
   
。   lua_pop_v3(L);
   
}



======================================

# win32exts 多语言 外部编程接口扩展

**脚本语言通用 Win32 FFI调用引擎简介**


![markdown](https://www.mdeditor.com/images/logos/markdown.png "markdown")


    一直希望有这样的一种统一江湖的脚本语言：
    
既拥有脚本语言的动态解释执行能力，又拥有接近如C/C++般高效的执行效率，同时还具有如C/C++甚至汇编语言般强大的功能，可以直接调用系统功能。语言干净简练、子功能模块库丰富多彩，同时作为嵌入式脚本也能得心应手。

**可惜没有！**

    常见的语言如lua, js, vbs, Python, PowerShell 都或多或少存在一些问题。PowerShell 语法过于诡异，
    
    更接近于一种增强版的批处理脚本。Js/vbs/lua 使用方便，但原生功能较弱。Python拥有强大的第三方库，但打包部署麻烦。
    
    于是，才有了大千世界、芸芸众生，各种语言的各领风骚。


## 言归正传。

    笔者在开发过程中各种语言均有接触（当然更亲赖Python和Lua，毕竟作为嵌入式脚本非常合适）。经常摆在面前的问题是，
    
    某语言在特定平台上需要直接调用系统API才能实现某些功能的问题。
    
    当然，各种语言都有提供一些外部函数扩展（FFI）的方式。通常是需要自己编写一个模块(DLL)或者额外的脚本，难免有点愚拙。
    
    所以此处只考虑一种无须额外写太多第三方库，实现统一调用任意系统API的机制。
    
**目前主要流行的语言中，已有一些FFI支持库：**


![Pandao editor.md](https://pandao.github.io/editor.md/images/logos/editormd-logo-180x180.png "Pandao editor.md")

    各种扩展库语法差异极大，并且有些需要带上庞大数量的支持库，有些功能又极为简略，不能适应较为复杂的函数调用
    
    （典型的如EnumWindows类带回调的，以及匿名函数、变参数目等的调用）。

    因此，笔者开发的win32exts扩展框架旨在谋求一种 【发布简单】的(一个模块)，【统一的】(各种脚本中语法基本一致)，
    
    【高效的】、【功能强大】 的(原生API,COM,C++非COM接口成员均支持)模式。

**一句话，有了 win32exts，真正实现 Do whatever you want，放之四海而皆准是也。**


### 以Python为例(其他语言其实差不多长一个样吧)，

### win32exts调用的基本用法如下：

（1）常规具名函数（以MessageBoxA/W为例）调用：

导入模块符号。第一个参数为待加载的模块名，可以带路径，传入"*"表示当前进程的所有模块；

第二个参数表示函数符号名称，传入"\*"表示该模块的所有符号。

win32exts.load_sym("\*", "\*")

或 win32exts.load_sym("C:\\windows\\system32\\user32.dll", "MessageBoxW")

或 win32exts.load_sym("user32", "MessageBoxA")

或 win32exts.load_sym("user32", "\*")

win32exts.MessageBoxA(0, "call MessageBoxA", "", 1)

宽字符需要用 win32exts.L() 包装，与C/C++雷同。

win32exts.MessageBoxW(0, win32exts.L("call MessageBoxW"), None, 1)


（2）带回调的函数（以EnumWindows为例）调用：

先分配一块内存后面用：

	g_buf = win32exts.malloc(2*260)

定义一个回调函数：
	
	
	def EnumWndProc(args):   
		【args为参数包，以下取参数】
		hWnd = win32exts.arg(args, 1)
		lParam = win32exts.arg(args, 2)
		
		win32exts.GetWindowTextW(hWnd, g_buf, 260)
		【读取内存中的宽字符串】
		【read_***系列接口读内存，write_***系列接口写内存】
		strText = win32exts.read_wstring(g_buf, 0, -1)
	
		win32exts.MessageBoxW(0, win32exts.L(strText), g_buf, 1)

		strRetVal = "1, 8"
		g_index = g_index + 1
		if g_index > 3:   【假设只弹框三次】
			strRetVal = "0, 8"
	
		【返回值是形如这样的字符串: "回调返回值, 参数字节数",
		对于 cdecl 调用约定，参数字节数总是取 0 】
		return strRetVal

然后调用：

	win32exts.EnumWindows(win32exts.callback("EnumWndProc"), 0)

win32exts.callback（）用于包装一个Python回调函数。

对于js/lua 等等语言来说，没有提供该函数，直接传入即可，亦即：

	win32exts.EnumWindows(EnumWndProc, 0)

（3）匿名（非具名）函数调用：

假设通过某个接口获取了某函数的地址 lFuncAddr，然后可以类似下述方式调用：

	win32exts.push_value(arg1)     【参数是整数】
	win32exts.push_wstring("arg2") 【参数是宽字符串】
	win32exts.push_astring(arg3)   【参数是多字节字符串】
	win32exts.push_double(arg4)    【参数是双精度浮点数】
	win32exts.push_float(arg5)     【参数是单精度浮点数】
	iRetVal = win32exts.call( lFuncAddr )

当然具名函数也可以类似调用，例如：

	win32exts.push_value(0)
	
	win32exts.push_astring("Py_MessageBoxA_V1")
	
	win32exts.push_value(0)
	
	win32exts.push_value(0)
	
	iRetVal = win32exts.sym_call("MessageBoxA")  【或用 func_call】



# 实在编不下去了（←___←b'），下面是 win32exts 提供的接口分类清单, 至于典型用法请参考git上的 win32exts_for_Xxxx 仓库的demo 示例。

![win32exts](https://github.com/tankaishuai/win32exts_for_Python/blob/master/API/b1.jpg)
![win32exts](https://github.com/tankaishuai/win32exts_for_Python/blob/master/API/b2.jpg)

当然，也可以通过 VS的对象查看器 或者 Python 的 win32exts.help() 命令查看详细API信息：

![win32exts](https://github.com/tankaishuai/win32exts_for_Python/blob/master/API/a1.jpg)
![win32exts](https://github.com/tankaishuai/win32exts_for_Python/blob/master/API/a2.jpg)
![win32exts](https://github.com/tankaishuai/win32exts_for_Python/blob/master/API/a3.jpg)
