//
//  TakePartTableView.m
//  91TaoJin
//
//  Created by keyrun on 14-5-29.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TakePartTableView.h"
#import "TakePartCell.h"
#import "TakePart.h"
#import "AsynURLConnection.h"
#import "LoadingView.h"
#import "MyUserDefault.h"
#import "TablePullToLoadingView.h"
#import "TakePartDetailViewController.h"

@implementation TakePartTableView{
    int timeOutCount;                                               //连接超时次数
    int localPageNumber;                                            //本地请求页
    int temporaryLocalPageNumner;                                   //临时本地请求页
    int maxPage;                                                    //服务器的最大页数
    int localRow;                                                   //加载到第几行
    
    NSMutableArray *temporaryTakePartAry;                           //临时【天天参与】数据
    UINavigationController* nc;
//    dispatch_queue_t queue;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self setSeparatorColor:[UIColor clearColor]];
        [self initObjects];
        TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kTableLoadingViewHeight2_0)];
        self.tableFooterView = loadingView;
        self.tableFooterView.hidden = YES;
        self.isRequesting = NO;
//        queue = dispatch_queue_create("com.91Taojin.TakePartTableView", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

-(void)initObjects{
    localPageNumber = 1;
    [_takePartAry removeAllObjects];
    localRow = 0;
    [self requestToGetTakePart];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return temporaryTakePartAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TaskPartIdentifier = @"TaskPartCell";
    TakePartCell *cell = (TakePartCell *)[tableView dequeueReusableCellWithIdentifier:TaskPartIdentifier];
    if(cell == nil){
        cell = [[TakePartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TaskPartIdentifier];
    }
    TakePart *takePart = [temporaryTakePartAry objectAtIndex:indexPath.row];
    [cell setTakePartCellContent:takePart.takePart_title imageUrl:takePart.takePart_image commentCountStr:[NSString stringWithFormat:@"%d",takePart.takePart_commentCount] takeType:takePart.takePart_type isPinLun:takePart.takePart_ispl];

    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    TakePart *takePart = [temporaryTakePartAry objectAtIndex:indexPath.row];
    TakePartDetailViewController *detail = [[TakePartDetailViewController alloc] initWithTakePartId:[NSString stringWithFormat:@"%d",takePart.takePart_id] andTakePartItem:takePart];
    detail.isNeedReload = YES;
    if(nc == nil)
        nc = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [nc pushViewController:detail animated:YES];
}

/**
 *  请求获取参与列表
 */
-(void)requestToGetTakePart{
    _isRequesting = YES;
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"GetActList1"];
    NSString *page = [NSString stringWithFormat:@"%d",localPageNumber];
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"PageNum": page, @"sid":sid};
    NSLog(@"获取活动列表【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *errStr =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"  error ==%@ ",errStr);
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"获取活动列表【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                maxPage = [[body objectForKey:@"MaxPage"] intValue];
                NSArray *atys = [body objectForKey:@"Atys"];
                
                if(localPageNumber == 1 && _takePartAry == nil){
                    _takePartAry = [[NSMutableArray alloc] initWithArray:[self reinitActAryObjects:atys]];
                }else{
                    [_takePartAry insertObjects:[self reinitActAryObjects:atys] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_takePartAry.count, atys.count)]];
                }
                localPageNumber ++;
                temporaryLocalPageNumner = localPageNumber;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(temporaryTakePartAry == nil){
                        //第一次空白加载
                        temporaryTakePartAry = [[NSMutableArray alloc] initWithArray:_takePartAry];
                        [self reloadData];
                    }else{
                        if(localRow == 0){
                            //切换加载
                            [temporaryTakePartAry removeAllObjects];
                            [temporaryTakePartAry insertObjects:_takePartAry atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _takePartAry.count)]];
                            [self reloadData];
                        }else{
                            //向下加载
                            NSMutableArray *paths = [[NSMutableArray alloc] init];
                            for (int i = localRow; i < _takePartAry.count; i++) {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                [paths addObject:indexPath];
                                [temporaryTakePartAry insertObject:[_takePartAry objectAtIndex:i] atIndex:temporaryTakePartAry.count];
                            }
                            [self insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationFade];
                            NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:localRow inSection:0];
                            [UIView animateWithDuration:0.5f animations:^{
//                                [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                            }];
                        }
                    }
                    localRow = temporaryTakePartAry.count;
                    _isRequesting = NO;
                    self.tableFooterView.hidden = YES;
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"获取活动列表【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestToGetTakePart];
            }else{
                timeOutCount = 0;
                _isRequesting = NO;
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
    }];
}

/**
 *  转换服务器数据为对象数据
 *
 *  @param atys 服务器的diction数据数组
 *
 */
-(NSMutableArray *)reinitActAryObjects:(NSArray *)atys{
    NSMutableArray *localTakePartAry = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in atys){
        int takePartId = [[dic objectForKey:@"AtyId"] intValue];
        int takePartCommentCount = [[dic objectForKey:@"AtyReply"] intValue];
        TakePart *takePart = [[TakePart alloc] initWithId:takePartId takePartTitle:[dic objectForKey:@"AtyName"] takePartImage:[dic objectForKey:@"AtyPic"] takePartCommentCount:takePartCommentCount takePartType:[[dic objectForKey:@"AtyType"] intValue] takePartIsPL:[[dic objectForKey:@"is_pl"] intValue] takePartURL:[dic objectForKey:@"AtyUrl"]];
        [localTakePartAry addObject:takePart];
    }
    return localTakePartAry;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float y_float = self.contentOffset.y;
    if (y_float < 0)
        return;
    if(_takePartAry.count != 0 && temporaryLocalPageNumner <= maxPage && self.tableFooterView.hidden == YES){
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        if(y > h - 1) {
            self.tableFooterView.hidden = NO;
            [self requestToGetTakePart];
        }else{
            self.tableFooterView.hidden = YES;
        }
    }
}
@end








