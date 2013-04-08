//
// Created by Cao Hua <glare.ch@gmail.com> on 2012
// Copyright 2012 GKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "GMath.h"

//向上取整(包含)
double gceil(double x)
{
	return ceil(x);
}
//向上取整(不包含) gceilne(2.0) = 3.0
double gceilne(double x)
{
	return gfloor(x)+1;
}

//向下取整(包含)
double gfloor(double x)
{
	return floor(x);
}
//向下取整(不包含) gfloorne(2.0) = 1.0
double gfloorne(double x)
{
	return gceil(x)-1;
}

//四舍五入
double ground(double x)
{
	return round(x);
}

//角度转化为弧度
CGFloat GRadiansFromDegrees(CGFloat degrees)
{
    return degrees * M_PI / 180;
}
//弧度转化为角度
CGFloat GDegreesFromRadians(CGFloat radians)
{
    return radians * 180 / M_PI;
}
//获取数的正负号
NSInteger GSignOfIntegerNumber(NSInteger x)
{
    if (x==0) {
        return 0;
    }else if (x>0) {
        return 1;
    }else{
        return -1;
    }
}
//计算移动的距离
CGFloat GDistanceMoved(CGFloat dx, CGFloat dy)
{
	//返回直角三角形斜边的长度
	return hypotf(dx, dy);
}
