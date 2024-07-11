# 项目说明
本项目是依据[华为动态引擎](https://developer.huawei.com/consumer/cn/doc/content/themes-engine-overview-0000001054588463)相关文档编写的若干xsd文件
## 想要解决的问题
解决华为自带的Theme Studio 动态锁屏开发者模式没有语法提示，造成的编写不便
## 当前存在的问题
1. 规则/属性不匹配
由于华为相关文档不全，有些地方读起来会有些难懂加上作者接触的时间比较短，会存在规则/属性不匹配的情况，欢迎提Issue
2. 无法支持函数、变量名的提示
3. 类型定义比较严格，不支持表达式类型
4. 当前只支持LockScreen
# 如何使用
下载一个支持xml语法提示的编辑器，如[IDEA](https://www.jetbrains.com/idea/download/)，目的是让编辑器进行语法提示，下面以IDEA的使用为例子
1. 创建一个xml文件，如demo.xml
2. 键入以下语句，会发现键入<Lockscreen> 等时会有相应的语法提示
```xml
<Project xmlns="https://www.satcblue.cn/XMLSchema/HuaWeiCreative"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://www.satcblue.cn/XMLSchema/HuaWeiCreative https://schema-huawei-creative.oss-cn-guangzhou.aliyuncs.com/SCHEMA/Project.xsd">

    <Lockscreen frameRate="30">
        <!-- 任意上滑解锁 -->
        <Unlocker name="unlocker" bounceInitSpeed="2000" bounceAcceleration="3000">
            <StartPoint x="0" y="0" w="#screen_width" h="#screen_height">
            </StartPoint>
            <EndPoint x="0" y="-300" w="#screen_width" h="200">
                <Path x="0" y="0" w="#screen_width" h="#screen_height">
                    <Position x="0" y="0"/>
                    <Position x="0" y="-150"/>
                </Path>
            </EndPoint>
        </Unlocker>
        <Wallpaper/>
    </Lockscreen>
</Project>
```
3. 复制Project标签内内容，复制到ThemeStudio中使用
## 其他问题
1. 没有语法提示，并且在编辑器中`xsi:schemaLocation="https://www.satcblue.cn/XMLSchema/HuaWeiCreative https://hua-wei-creatives-chema.oss-cn-shenzhen.aliyuncs.com/SCHEMA/Project.xsd"` 报红

解决方案：鼠标/光标移到报红位置，（选择修复建议(鼠标操作)/ALT+回车(windows)/option+回车(MAC)）选择![手动提取外部资源](doc%2Fmanual_download_xsd.png)待下载完即可

2. 规则/属性不匹配的情况

解决方案：可以下载本仓库，对xsd进行修改，然后引用本地xsd。或者使用deploy脚本自行发布使用

3. 使用表达式，提示类型错误

解决方案：暂时不支持表达式的类型推导，忽略错误即可

# 后续计划
1. 支持 变量提示/函数，可能会通过另外的声明式方式生成xml支持
2. 补全规则
3. 生成项目所需结构、其他文件


