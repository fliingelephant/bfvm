# bfvm

File.inc 和 File.asm 提供了处理命令行命令

**现在实现了的功能是：**
- 读入命令行参数，
  - 如果只有一个（即“BFVM.exe”）则输出提示信息
  - 如果除了还有第二个命令行参数且是“-h” （即“BFVM.exe -h”）则输出提示信息
  - 如果除了还有第二个命令行参数且不是“-h” （即“BFVM.exe %filename%”）则读取名为filename的文件，
  
    如果不存在或者无法读取则报错，如果可以读取则返回文件的handle（File.asm中定义的FileHandle）
    
- 根据FileHandle读取文件中的一行（可以重复使用直到文件结束，File.asm中定义的FileEndFlag对应是否到了最后一行）

  读取的内容放于File.asm中定义的变量FileLine中
  
---
**需要实现的：**
  - 根据读取的FileLine的内容parse出对应的中间表示，即BFIR （BFIR作为结构体定义于Parse.inc中）并存储起来，
  
    得到一系列BFIR
    
  - 搞一个CodeGen.inc和CodeGen.asm，从前面得到的一系列BFIR产生出机器码
  
  - 将生成的码写入文件
  
  
---
**比较急的是：**
  - 定义一下中间表示，即IR，我去参考下一些别人的写法
