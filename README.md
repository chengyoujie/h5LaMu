# h5LaMu
use as3 air make out json tools

#version.ver
[version]
1.0.0
[desc]
创建新的应用
[version]
1.0.1
[desc]
修复任务列表新增后重置的bug
[version]
1.0.2
[desc]
修复怪物id重置的bug
版本更新时增加更新按钮
[url]
\\192.168.2.50\ftp\tool\H5拉幕工具v1.0.2.rar

[version]
1.0.3
[desc]
修复NPC id记录成int型导致的bug
[url]
\\192.168.2.50\ftp\tool\H5拉幕工具v1.0.3.rar



[version]
1.0.4
[desc]
项目数据迁移至50， 并把数据编译到cfgs.bin文件中
以后测试直接连50测试。
[url]
\\192.168.2.50\ftp\tool\H5拉幕工具v1.0.4.rar



---projects.config
<config>
<project 
	name="H5—观海策"
	id="ghc"
	path="D:/workspace_h5_git/ghc/client/resource/story_2.json"
	baseurl="http://192.168.2.50:60200/"
	gameurl="http://192.168.2.50:60290/"
	jsoncopyto="\\192.168.2.50\h5_{$id}\cfgs\cn\raw\client\story.json"
	bindata = "\\192.168.2.50\h5_{$id}\cfgs\cn\cfgs\client\cfgs.bin"
	
	resurl="{$baseurl}res/cn/"
	monstercfg="{$baseurl}cfgs/cn/cfgs/server/GuaiWu.jat"
	chengjiucfg="{$baseurl}cfgs/cn/cfgs/server/ChengJiu.jat"
	mappath="{$baseurl}res/cn/m/"
	facepath="{$baseurl}res/cn/face/"
	mainroleindex="1"
	mainface="big_0"
	actionlist="0.站立,1.行走,2.怪物攻击1,3.怪物攻击2,4.死亡,5.受伤,7.剑上飞行,8.攻击动作1,9.攻击动作2,10.攻击动作3(前刺),11.攻击动作4,12.起跳,13.冲刺,14.降落,15.跳跃2"
/>

</config>