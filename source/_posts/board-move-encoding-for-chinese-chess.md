---
title: 中国象棋相关编码
date: 2024-11-04 08:51:22
tags:
---

# 中国象棋相关编码


## 棋盘编码

	https://www.xqbase.com/protocol/cchess_move.htm

![](/img/2024/board.png)

**棋盘的编号：从左到右为a-i，从下到上为0-9**


## 棋子编码

	https://www.xqbase.com/protocol/pgnfen2.htm
	https://www.xqbase.com/protocol/cchess_move.htm

```
白方(红色)棋子以大写字母表示
黑方棋子以小写字母表示

红方以大写字元来表达兵种。
PABNCRK分别代表兵、仕、相、马、炮、车、帅；

黑方以小写字元表达。
pabncrk分别代表卒、士、象、马、炮、车、将

```



## FEN编码

```
按白方(红色)视角，描述由上至下、由左至右的盘面，以/符号来分隔相邻横列。横列的连续空格以阿拉伯数字表示，例如5即代表连续5个空格。

白方(红色)大写字母、黑方小写字母。

棋盘的编号：从左到右为a-i，从下到上为0-9。

FEN棋子位置编码为：

a9-i9/a8-i8/ .../a1-i1/a0-i0
```


## 着法编码

	https://www.xqbase.com/protocol/cchess_fen.htm
	https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation
	

## 着法描述

象棋的着法表示，简而言之就是某个棋子从什么位置走到什么位置。

目前主要由两种描述方法：

* 中文纵线格式
* 坐标格式



![](/img/2024/chess-move.png)

中文纵线格式方便人看。

坐标格式普遍应用于象棋程序间，尤其是象棋程序界面和象棋引擎间。

## 着法描述的生成

这里用Move.java来封装跟着法相关的代码。

	https://raw.githubusercontent.com/zfdang/chinese-chess-android/refs/heads/master/app/src/main/java/com/zfdang/chess/gamelogic/Move.java
	
在程序内部，着法是由（起始位置坐标， 结束位置坐标）来表示的。


```
    public Position fromPosition;
    public Position toPosition;
```

这个需要跟当前棋盘的状态结合，才能够生成着法的描述。

### 生成坐标格式的着法描述

这个很简单，不需要考虑棋盘上棋子的状态，直接转换内部位置到棋盘编码坐标里即可。

```
    public String getUCCIString(){
        char s, e;
        s = (char)('a' + fromPosition.x);
        e = (char)('a' + toPosition.x);
        String result = String.format("%c%d%c%d", s, 9 - fromPosition.y, e, 9 - toPosition.y);
        return result;
    }
```


```
    public boolean fromUCCIString(String ucciString){
        if(ucciString.length() != 4){
            return false;
        }

        char s, e;
        s = ucciString.charAt(0);
        e = ucciString.charAt(2);
        Position pos = new Position(s - 'a', 9 - (ucciString.charAt(1) - '0'));

        return true;
    }

```

### 生成中文纵线的着法描述

这个需要考虑的因素就很多了。参看如下代码：


```
    /*
    * 从一个位置移动到另一个位置的中文描述
    * 例如：车一进六, 炮七退七, 相七进九, 帅四平五, 帅五进一, 将五退一, 未知动作
    * 这个函数的设计比较复杂，需要考虑的因素很多：
    * 1. 对于横轴来讲，红方是从右到左数的，黑方是从左到右数的
    * 2. 对于纵轴来讲，红方是从下到上是进，黑方是从下到上是退
    * 3. 对于走直线的棋子，需要考虑是进退（最后一个数字是纵坐标的差值），还是平移（最后一个数字是目标位置的横坐标）
    * 4. 对于走斜线的棋子（马、相、士），需要考虑是进退，最后一个数字是目标位置的横坐标
    * 5. 对于红字移动，使用中文的数字；对于黑子移动，使用阿拉伯数字
    * 6. 还需要处理同一列有相同的棋子，使用前后来区分，比如前炮退二，后炮进二？？
    * https://www.xqbase.com/protocol/cchess_move.htm
     */
    public String getChineseStyleString(){
        if(board == null){
            // depends on board status
            return "未知动作";
        }
        int piece = board.getPieceByPosition(fromPosition);
        if(Piece.isValid(piece)) {
            char name = Piece.pieceNameMap.get(piece);
            String num1, action, num2;

            if(Piece.isRed(piece)) {
                num1 = arabicToChineseMap.get(9 - fromPosition.x);

                action = "平";
                // 3.对于走直线的棋子，需要考虑是进退（最后一个数字是纵坐标的差值），还是平移（最后一个数字是目标位置的横坐标）
                num2 = arabicToChineseMap.get(abs(toPosition.y - fromPosition.y));
                if(toPosition.y > fromPosition.y){
                    action = "退";
                } else if(toPosition.y < fromPosition.y){
                    action = "进";
                } else {
                    // 3.对于走直线的棋子，需要考虑是进退（最后一个数字是纵坐标的差值），还是平移（最后一个数字是目标位置的横坐标）
                    num2 = arabicToChineseMap.get(9 - toPosition.x);
                }

                if(Piece.isDiagonalPiece(piece)) {
                    // 4. 对于走斜线的棋子（马、相、士），需要考虑是进退，最后一个数字是目标位置的横坐标
                    num2 = arabicToChineseMap.get(9 - toPosition.x);
                }

                return name + num1 + action + num2;
            } else if(Piece.isBlack(piece)) {
                num1 = String.format("%d", fromPosition.x + 1);

                action = "平";
                // 3.对于走直线的棋子，需要考虑是进退（最后一个数字是纵坐标的差值），还是平移（最后一个数字是目标位置的横坐标）
                num2 = String.format("%d", abs(toPosition.y - fromPosition.y));
                if(toPosition.y > fromPosition.y){
                    action = "进";
                } else if(toPosition.y < fromPosition.y){
                    action = "退";
                } else {
                    // 3.对于走直线的棋子，需要考虑是进退（最后一个数字是纵坐标的差值），还是平移（最后一个数字是目标位置的横坐标）
                    num2 = String.format("%d", toPosition.x + 1);
                }

                if(Piece.isDiagonalPiece(piece)) {
                    // 4. 对于走斜线的棋子（马、相、士），需要考虑是进退，最后一个数字是目标位置的横坐标
                    num2 = String.format("%d", toPosition.x + 1);
                }

                return name + num1 + action + num2;
            }
        }
        return "未知动作";
    }

```



## 参考资料

	https://www.xqbase.com/protocol/cchess_move.htm
	
