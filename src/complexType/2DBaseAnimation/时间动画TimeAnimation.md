### 时间动画功能概述

时间动画功能基于全局变量`#time`，当使用`#time`变量时，系统会按帧率刷新该变量，实现时间元素的动态更新。

### XML规范

#### 示例一：显示当前系统时间

```xml
<Text x="100" y="200" align="center" color="#ffffff" size="50" format="time: %d" paras="#time"/>
```

#### 示例二：直接显示时间

```xml
<Text x="100" y="200" size="50" color="#ffffff" text="#time"/>
```

### 参数说明

- **time**：数值型，必填，当前系统时间，范围为[0-~]。

### 示例代码展示

以下是一个完整的示例，其中实现了秒针、分针和时针根据当前时间进行旋转的效果。

```xml
<?xml version="1.0" encoding="utf-8"?>
<Lockscreen version="1" screenWidth="1080" frameRate="30" vibrate="false" displayDesktop="true">

    <!-- 设置秒针每秒旋转6度 -->
    <Var name="t1" expression="#time/1000*6"/>
    <Var name="m_angle" expression="#minute*6" threshold="6"/>

    <!-- 背景图片 -->
    <Image x="0" y="0" src="bg.png"/>
    
    <!-- 分针 -->
    <Image x="529" y="545" centerX="15" centerY="198" src="fen.png" angle="#m_angle"/>
    
    <!-- 秒针 -->
    <Image x="532" y="525" centerX="11" centerY="224" src="miao.png" angle="#t1"/>
    
    <!-- 时针 -->
    <Image x="503" y="611" centerX="41" centerY="150" src="shi.png" angle="#hour12*30+#minute/2"/>
    
</Lockscreen>
```

### 详细解释

1. **Var 标签**：
    - `t1`：表示秒针的角度，计算公式为`#time/1000*6`，即每秒旋转6度。
    - `m_angle`：表示分针的角度，计算公式为`#minute*6`，每分钟旋转6度。

2. **Image 标签**：
    - **背景图片**：设置背景图`bg.png`。
    - **分针**：设置中心点（`centerX`, `centerY`）和角度（`angle`）。
    - **秒针**：设置中心点（`centerX`, `centerY`）和角度（`angle`）。
    - **时针**：设置中心点（`centerX`, `centerY`）和角度（`angle`），计算公式为`#hour12*30+#minute/2`，即每小时旋转30度，同时根据分钟进行微调。

### 实现效果

1. **秒针**：每秒旋转6度，基于当前系统时间`#time`。
2. **分针**：每分钟旋转6度，基于分钟数`#minute`。
3. **时针**：每小时旋转30度，同时每分钟旋转0.5度，基于小时数`#hour12`和分钟数`#minute`。

通过这种方式，可以实现一个动态的时钟，随着时间的变化自动更新秒针、分针和时针的角度，提供真实的时间动画效果。