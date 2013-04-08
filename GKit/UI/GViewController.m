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
#import "GViewController.h"
#import "GCore.h"

@implementation GViewController

#pragma mark - Init
- (id)init
{
	self = [super init];
	if (self)
	{
		[self initialize];
	}
	return self;
}

- (void)initialize{}

#pragma mark - View Life Cycle

- (void)loadView
{
    GView *view = [[GView alloc] initWithFrame:GScreenBounds];
    view.backgroundColor = [UIColor whiteColor];
    view.viewController = self;
    self.view = view;
    
    _topView = view.topView;
    _contentView = view.contentView;
    _bottomView = view.bottomView;
}

- (void)setTopViewHeight:(CGFloat)topViewHeight
{
    [(GView *)[self view] setTopViewHeight:topViewHeight];
}
- (void)setContentViewHeight:(CGFloat)contentViewHeight
{
    [(GView *)[self view] setContentViewHeight:contentViewHeight];
}
- (void)setBottomViewHeight:(CGFloat)bottomViewHeigh
{
    [(GView *)[self view] setBottomViewHeight:bottomViewHeigh];
}

@end
