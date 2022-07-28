library dt_pagination;

import 'package:flutter/material.dart';

class WebPagination extends StatefulWidget {
  final int initPage; // 初始页码
  final int pageSize; // 每页item个数
  final int total; // 总页数
  final double itemSize; // 页码item大小
  final double textFont; // 页码item文字大小
  final Color selectTextColor; // 页码item文字颜色-选中
  final Color unselectTextColor; // 页码item文字颜色-未选中
  final Color selectItemColor; // 页码item背景颜色-选中
  final Color unselectItemColor; // 页码item背景颜色-未选中
  final Color arrowItemColor; // 翻页item背景颜色
  final Color arrowItemTextColor; // 翻页item文字颜色
  final bool curPageAlwaysCenter; // 当前页码是否保持居中
  final Function(int)? pageChanged; // 页码变化回调

  const WebPagination({
    Key? key,
    this.initPage = 1,
    this.pageSize = 10,
    required this.total,
    this.itemSize = 30,
    this.textFont = 14,
    this.selectTextColor = Colors.white,
    this.unselectTextColor = Colors.black,
    this.selectItemColor = Colors.redAccent,
    this.unselectItemColor = Colors.white,
    this.arrowItemColor = Colors.redAccent,
    this.arrowItemTextColor = Colors.white,
    this.curPageAlwaysCenter = true,
    this.pageChanged,
  }) : super(key: key);

  @override
  State<WebPagination> createState() => _WebPaginationState();
}

class _WebPaginationState extends State<WebPagination> {
  int curPage = 1;
  List<int> paginationList = []; // item列表

  @override
  void initState() {
    super.initState();
    curPage = widget.initPage;
    resetPagination(curPage);
  }

  // 刷新页码item列表
  void resetPagination(int curIndex) {
    if (curIndex <= 0) curIndex = 1;
    if (curIndex > widget.total) curIndex = widget.total;
    curPage = curIndex; // 当前页

    // 回调
    if (widget.pageChanged != null) {
      widget.pageChanged!(curPage);
    }

    paginationList.clear();

    if (widget.curPageAlwaysCenter) {
      // 选中页码保持居中
      int leftLackNum = 0; // curPage左边缺少的item个数
      int rightLackNum = 0; // curPage右边缺少的item个数

      // 左半边需要的item个数，把curPage也算在左半边，个数+1
      int leftCount = (widget.pageSize / 2).floor() + 1;

      if (curPage < leftCount) {
        // curPage小于leftCount，左半边的按钮不够了，记录缺少的个数
        leftLackNum = leftCount - curPage;
      }

      // 右半边需要的item个数，pageSize-leftCount
      int rightCount = widget.pageSize - leftCount;
      if ((widget.total - curPage) < rightCount) {
        // 右半边剩余的按钮不够了，记录缺少的个数
        rightLackNum = rightCount - (widget.total - curPage);
      }

      // 添加左半边的item进列表，个数为 右边缺少的个数+左边原有的个数
      for (int i = rightLackNum + leftCount - 1; i >= 0; i--) {
        if (curPage - i > 0) {
          paginationList.add(curPage - i);
        }
      }

      // 添加右半边的item进列表，个数为 左边缺少的个数+右边原有的个数
      for (int i = 1; i <= leftLackNum + rightCount; i++) {
        if (curPage + i <= widget.total) {
          paginationList.add(curPage + i);
        }
      }

      debugPrint('左边缺少的个数:$leftLackNum 右边缺少的个数:$rightLackNum');
    } else {
      int startIndex = curPage % widget.pageSize == 0
          ? curPage - widget.pageSize
          : (curPage / widget.pageSize).floor() * widget.pageSize;
      for (int i = 1; i <= widget.pageSize; i++) {
        if (startIndex + i <= widget.total) {
          paginationList.add(startIndex + i);
        }
      }
    }

    debugPrint(
        'curPage:$curPage\npageList:${paginationList.toString()}\npageSize:${paginationList.length}');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 第一页
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: widget.itemSize,
            height: widget.itemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.arrowItemColor,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.first_page,
              color: widget.arrowItemTextColor,
            ),
          ),
          onTap: () {
            resetPagination(1);
          },
        ),
        // 上一页
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: widget.itemSize,
            height: widget.itemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.arrowItemColor,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.chevron_left,
              color: widget.arrowItemTextColor,
            ),
          ),
          onTap: () {
            resetPagination(curPage - 1);
          },
        ),
        // 页码列表
        ...List.generate(paginationList.length, (index) {
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: widget.itemSize,
              height: widget.itemSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: curPage == paginationList[index]
                    ? widget.selectItemColor
                    : widget.unselectItemColor,
              ),
              alignment: Alignment.center,
              child: Text(
                paginationList[index].toString(),
                style: TextStyle(
                  fontSize: widget.textFont,
                  color: curPage == paginationList[index]
                      ? widget.selectTextColor
                      : widget.unselectTextColor,
                ),
              ),
            ),
            onTap: () {
              resetPagination(paginationList[index]);
            },
          );
        }),
        // 下一页
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: widget.itemSize,
            height: widget.itemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.arrowItemColor,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.chevron_right,
              color: widget.arrowItemTextColor,
            ),
          ),
          onTap: () {
            resetPagination(curPage + 1);
          },
        ),
        // 最后一页
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: widget.itemSize,
            height: widget.itemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.arrowItemColor,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.last_page,
              color: widget.arrowItemTextColor,
            ),
          ),
          onTap: () {
            resetPagination(widget.total);
          },
        ),
      ],
    );
  }
}
