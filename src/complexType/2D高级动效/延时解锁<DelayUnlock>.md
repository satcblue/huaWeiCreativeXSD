### 延时解锁功能概述

延时解锁功能基于Slider和ExternCommand功能实现，允许用户在执行解锁操作后，经过一定的延迟时间再执行系统解锁命令。这一功能可以通过添加延时参数`delay`来控制解锁前的等待时间，实现趣味解锁效果。

### 应用场景举例

1. **俄罗斯方块小游戏**：用户完成游戏后延时解锁。
2. **点击燃放鞭炮**：鞭炮燃放完毕后延时解锁。
3. **喂食宠物**：宠物吃完食物后延时解锁。

### XML规范

#### ExternCommand标签

```xml
<ExternCommand command="unlock" delay=""/>
```

#### 参数说明

- **command**：字符串，必填，执行的命令。
- **delay**：数值，必填，延迟解锁时间，单位为毫秒(ms)。

### 示例应用

#### 示例一：点击燃放鞭炮

```xml
<Lockscreen version="1" frameRate="30" displayDesktop="true" screenWidth="1080">
    <!-- 背景图片 -->
    <Image x="0" y="0" src="background.png"/>
    
    <!-- 鞭炮图片 -->
    <Image x="100" y="400" src="firecracker.png" />
    
    <!-- 按钮 -->
    <Button x="100" y="400" w="200" h="200">
        <Trigger action="click">
            <!-- 播放燃放鞭炮动画 -->
            <Animation name="firecrackerAnim">
                <Frame duration="100" src="firecracker_1.png"/>
                <Frame duration="100" src="firecracker_2.png"/>
                <Frame duration="100" src="firecracker_3.png"/>
                <Frame duration="100" src="firecracker_4.png"/>
            </Animation>
            <!-- 延时解锁 -->
            <ExternCommand command="unlock" delay="400"/>
        </Trigger>
    </Button>
</Lockscreen>
```

#### 示例二：俄罗斯方块小游戏

```xml
<Lockscreen version="1" frameRate="30" displayDesktop="true" screenWidth="1080">
    <!-- 背景图片 -->
    <Image x="0" y="0" src="background.png"/>
    
    <!-- 俄罗斯方块游戏区域 -->
    <Game x="100" y="200" w="880" h="1280" type="tetris" />
    
    <!-- 按钮 -->
    <Button x="100" y="1600" w="880" h="200">
        <Trigger action="click">
            <!-- 检查游戏是否完成 -->
            <ExternCommand command="checkGameStatus" />
            <!-- 如果游戏完成，延时解锁 -->
            <ExternCommand command="unlock" delay="2000" condition="eq(#gameStatus, 'complete')"/>
        </Trigger>
    </Button>
</Lockscreen>
```

#### 示例三：喂食宠物

```xml
<Lockscreen version="1" frameRate="30" displayDesktop="true" screenWidth="1080">
    <!-- 背景图片 -->
    <Image x="0" y="0" src="background.png"/>
    
    <!-- 宠物图片 -->
    <Image x="100" y="400" src="pet.png" />
    
    <!-- 食物图片 -->
    <Image x="300" y="700" src="food.png" />
    
    <!-- 按钮 -->
    <Button x="300" y="700" w="200" h="200">
        <Trigger action="click">
            <!-- 播放喂食动画 -->
            <Animation name="feedAnim">
                <Frame duration="200" src="food_1.png"/>
                <Frame duration="200" src="food_2.png"/>
                <Frame duration="200" src="food_3.png"/>
            </Animation>
            <!-- 延时解锁 -->
            <ExternCommand command="unlock" delay="600"/>
        </Trigger>
    </Button>
</Lockscreen>
```

### 详细解释

1. **<ExternCommand> 标签**：用于执行外部命令。
    - `command="unlock"`：表示执行解锁命令。
    - `delay="400"`：表示延时400毫秒执行解锁命令。

2. **<Button> 标签**：用于定义按钮区域和触发操作。
    - `<Trigger action="click">`：表示当用户点击按钮时触发动作。

3. **<Animation> 标签**：用于定义动画播放。
    - `<Frame duration="100" src="firecracker_1.png"/>`：定义动画帧的持续时间和图片源。

通过这些示例和说明，可以实现各种创意的延时解锁效果，提升用户体验和趣味性。