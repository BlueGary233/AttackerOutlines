# AttackerOutlines - 战锤40K：暗潮攻击者轮廓线Mod

[English Version Below](#attackeroutlines---warhammer-40k-darktide-attacker-outlines-mod)

## 📖 概述

AttackerOutlines 是一个为《战锤40K：暗潮》设计的游戏模组，它会在敌人攻击玩家时显示彩色轮廓线，帮助玩家更好地识别和应对敌人的攻击动作。该模组支持本地和在线敌人，能够准确检测各种攻击类型，包括单段攻击、多段攻击、特殊攻击、远程攻击和强力攻击。

## ✨ 主要功能

### 🎯 攻击检测
- **本地敌人攻击检测**：通过动画事件检测本地敌人的攻击动作
- **在线敌人攻击检测**：通过event_index缓存系统检测在线敌人的攻击动作
- **混合缓存机制**：结合预定义缓存和动态收集的event_index数据

### 🎨 轮廓线类型
- **单段攻击**：白色轮廓线
- **多段攻击**：黄色轮廓线
- **特殊攻击**：紫色轮廓线（无法格挡的攻击）
- **远程攻击**：青色轮廓线
- **强力攻击**：橙色轮廓线

### ⚙️ 配置选项
- **轮廓线优先级**：设置轮廓线的显示优先级（1-10）
- **每帧最大队列数**：控制每帧处理的轮廓线数量（1-10）
- **闪避窗口**：设置攻击前的预警时间（0.3-1.0秒）
- **调试模式**：启用详细的调试日志输出
- **颜色自定义**：支持所有攻击类型的颜色自定义

### 🔧 高级功能
- **event_index收集**：可选的event_index数据收集功能
- **游戏状态重置**：自动在任务开始时重置所有数据
- **内存管理**：自动清理死亡单位的轮廓线和跟踪数据

## 🚀 安装方法

### 前置要求
- [Darktide Mod Framework (DMF)](https://www.nexusmods.com/warhammer40kdarktide/mods/8)

### 安装步骤
1. 确保已安装最新版本的DMF
2. 下载最新版本的AttackerOutlines mod
3. 将`AttackerOutlines`文件夹复制到`Warhammer 40,000 DARKTIDE/mods/`目录
4. 启动游戏，在mod设置中启用AttackerOutlines

## ⚙️ 配置说明

### 基本设置
- **debug_mode**：启用调试模式，显示详细的日志信息
- **outline_priority**：轮廓线显示优先级，数值越高显示越靠前
- **max_queue_per_frame**：每帧最大处理的轮廓线数量，影响性能
- **dodge_window**：攻击前的预警时间，帮助玩家及时闪避

### 颜色设置
模组提供了交互式的颜色配置界面：
1. 在颜色选择器中选择要配置的攻击类型
2. 使用RGB滑块调整颜色
3. 颜色会自动保存并应用到游戏中

### 高级设置
- **collect_event_indices_enabled**：启用event_index收集功能（仅用于调试）
- **log_all**：记录所有动画事件到日志文件

## 🛠️ 技术架构

### 模块化设计
```
AttackerOutlines/
├── AttackerOutlines.lua          # 主模块，协调所有功能
├── modules/
│   ├── ui.lua                    # 用户界面和配置管理
│   ├── log.lua                   # 日志记录系统
│   ├── attack_handler.lua        # 攻击检测和处理
│   ├── outline_manager.lua       # 轮廓线管理
│   ├── unit_tracker.lua          # 单位跟踪
│   ├── damage_timings.lua        # 攻击时机数据
│   └── event_index_cache_manager.lua # event_index缓存管理
└── event_index_cache.lua         # 缓存的event_index数据
```

### 核心机制
1. **动画事件检测**：通过Hook `Unit.animation_event`和`Unit.animation_event_by_index`检测攻击动画
2. **攻击时机匹配**：使用预定义的攻击时机数据确定攻击类型和时机
3. **轮廓线管理**：通过游戏内置的轮廓线系统添加和移除轮廓线
4. **数据缓存**：缓存event_index数据以提高在线敌人检测的准确性

## 🔍 调试和故障排除

### 启用调试模式
1. 在mod设置中启用`debug_mode`
2. 查看游戏控制台输出和日志文件

### 日志文件
- `anim_event.log`：记录的动画事件
- `target_change.log`：单位目标变化记录
- `event_index.log`：event_index收集记录

### 常见问题
1. **轮廓线不显示**：检查轮廓线优先级设置，确保没有被其他mod覆盖
2. **在线敌人检测失败**：尝试启用`collect_event_indices_enabled`收集event_index数据
3. **性能问题**：降低`max_queue_per_frame`设置

## 📝 版本历史

### v0.1.0 (当前版本)
- 初始发布版本
- 支持所有主要敌人类型的攻击检测
- 完整的颜色自定义系统
- event_index缓存系统
- 游戏状态自动重置功能

## 🤝 贡献指南

欢迎提交问题和拉取请求！在提交问题前，请：
1. 确认使用的是最新版本
2. 启用调试模式并提供相关日志
3. 描述问题的重现步骤

## 📄 许可证

本项目采用MIT许可证。详见LICENSE文件。

## 🙏 致谢

- Darktide Mod Framework (DMF) 团队
- 所有测试者和贡献者
- 战锤40K：暗潮社区

---

# AttackerOutlines - Warhammer 40K: Darktide Attacker Outlines Mod

## 📖 Overview

AttackerOutlines is a game mod for Warhammer 40K: Darktide that displays colored outlines on enemies when they attack the player, helping players better identify and respond to enemy attacks. The mod supports both local and online enemies, accurately detecting various attack types including single attacks, multi-attacks, special attacks, ranged attacks, and strong attacks.

## ✨ Key Features

### 🎯 Attack Detection
- **Local Enemy Attack Detection**: Detects attack animations of local enemies through animation events
- **Online Enemy Attack Detection**: Detects attack animations of online enemies through event_index caching system
- **Hybrid Cache Mechanism**: Combines predefined cache with dynamically collected event_index data

### 🎨 Outline Types
- **Single Attack**: White outline
- **Multi Attack**: Yellow outline
- **Special Attack**: Purple outline (unblockable attacks)
- **Ranged Attack**: Cyan outline
- **Strong Attack**: Orange outline

### ⚙️ Configuration Options
- **Outline Priority**: Set display priority for outlines (1-10)
- **Max Queue Per Frame**: Control number of outlines processed per frame (1-10)
- **Dodge Window**: Set warning time before attacks (0.3-1.0 seconds)
- **Debug Mode**: Enable detailed debug log output
- **Color Customization**: Support for custom colors for all attack types

### 🔧 Advanced Features
- **Event Index Collection**: Optional event_index data collection feature
- **Game State Reset**: Automatically resets all data when mission starts
- **Memory Management**: Automatically cleans up outlines and tracking data for dead units

## 🚀 Installation

### Prerequisites
- [Darktide Mod Framework (DMF)](https://www.nexusmods.com/warhammer40kdarktide/mods/8)

### Installation Steps
1. Ensure you have the latest version of DMF installed
2. Download the latest version of AttackerOutlines mod
3. Copy the `AttackerOutlines` folder to `Warhammer 40,000 DARKTIDE/mods/` directory
4. Launch the game and enable AttackerOutlines in mod settings

## ⚙️ Configuration

### Basic Settings
- **debug_mode**: Enable debug mode for detailed log information
- **outline_priority**: Outline display priority, higher values appear on top
- **max_queue_per_frame**: Maximum outlines processed per frame, affects performance
- **dodge_window**: Warning time before attacks, helps players dodge in time

### Color Settings
The mod provides an interactive color configuration interface:
1. Select the attack type to configure in the color selector
2. Adjust colors using RGB sliders
3. Colors are automatically saved and applied in-game

### Advanced Settings
- **collect_event_indices_enabled**: Enable event_index collection (for debugging only)
- **log_all**: Log all animation events to log files

## 🛠️ Technical Architecture

### Modular Design
```
AttackerOutlines/
├── AttackerOutlines.lua          # Main module, coordinates all functions
├── modules/
│   ├── ui.lua                    # User interface and configuration management
│   ├── log.lua                   # Logging system
│   ├── attack_handler.lua        # Attack detection and processing
│   ├── outline_manager.lua       # Outline management
│   ├── unit_tracker.lua          # Unit tracking
│   ├── damage_timings.lua        # Attack timing data
│   └── event_index_cache_manager.lua # Event index cache management
└── event_index_cache.lua         # Cached event index data
```

### Core Mechanisms
1. **Animation Event Detection**: Detects attack animations by hooking `Unit.animation_event` and `Unit.animation_event_by_index`
2. **Attack Timing Matching**: Uses predefined attack timing data to determine attack type and timing
3. **Outline Management**: Adds and removes outlines through the game's built-in outline system
4. **Data Caching**: Caches event_index data to improve accuracy of online enemy detection

## 🔍 Debugging and Troubleshooting

### Enabling Debug Mode
1. Enable `debug_mode` in mod settings
2. Check game console output and log files

### Log Files
- `anim_event.log`: Recorded animation events
- `target_change.log`: Unit target change records
- `event_index.log`: Event index collection records

### Common Issues
1. **Outlines not showing**: Check outline priority settings, ensure not overridden by other mods
2. **Online enemy detection failure**: Try enabling `collect_event_indices_enabled` to collect event_index data
3. **Performance issues**: Reduce `max_queue_per_frame` setting

## 📝 Version History

### v0.1.0 (Current Version)
- Initial release version
- Support for attack detection of all major enemy types
- Complete color customization system
- Event index caching system
- Automatic game state reset functionality

## 🤝 Contributing

Issues and pull requests are welcome! Before submitting an issue, please:
1. Confirm you're using the latest version
2. Enable debug mode and provide relevant logs
3. Describe steps to reproduce the issue

## 📄 License

This project is licensed under the MIT License. See LICENSE file for details.

## 🙏 Acknowledgments

- Darktide Mod Framework (DMF) team
- All testers and contributors
- Warhammer 40K: Darktide community
