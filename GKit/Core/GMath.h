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

//向上取整(包含)
double gceil(double x);
//向上取整(不包含)
double gceilne(double x);

//向下取整(包含)
double gfloor(double x);
//向下取整(不包含)
double gfloorne(double x);

//四舍五入
double ground(double x);

//角度转化为弧度
CGFloat RadiansFromDegrees(CGFloat degrees);
//弧度转化为角度
CGFloat DegreesFromRadians(CGFloat radians);
//获取数的正负号
NSInteger SignOfIntegerNumber(NSInteger x);
//计算移动的距离
CGFloat DistanceMoved(CGFloat dx, CGFloat dy);
