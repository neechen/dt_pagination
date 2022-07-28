A Pagination Widget for Flutter.

## Features

![vw2ch-fskhr.gif](https://github.com/neechen/dt_pagination/blob/master/normal.gif)

当前页码保持居中：
![gmteo-wlbnb.gif](https://github.com/neechen/dt_pagination/blob/master/alwayscenter.gif)

## Getting started

```
dependencies:
  dt_pagination: ^0.0.1
```

## Usage

```
WebPagination(
  pageSize: 6,
  total: 20,
  curPageAlwaysCenter: true,
  pageChanged: (int page) {
    debugPrint('$page');
  },
)

final int initPage;
final int pageSize;
final int total;
final double itemSize; 
final double textFont; 
final Color selectTextColor; 
final Color unselectTextColor; 
final Color selectItemColor;
final Color unselectItemColor; 
final Color arrowItemColor; 
final Color arrowItemTextColor; 
final bool curPageAlwaysCenter;
final Function(int)? pageChanged; 
```

