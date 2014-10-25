//
//  QuestTable.m
//  91TaoJin
//
//  Created by keyrun on 14-5-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "QuestTable.h"
#import "AsynURLConnection.h"
#import "MyUserDefault.h"
#import "LoadingView.h"
#import "UIAlertView+NetPrompt.h"
#import "QuestionCell.h"
@implementation QuestTable
{
    NSMutableArray *questArray;      //问题数组
    int timeOutCount;
    BOOL _isFirst ;
   
}
@synthesize isFirst =_isFirst;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource =self;
        self.delegate =self;
        _isFirst =YES;
        [self setSeparatorColor:[UIColor clearColor]];
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
//        questArray =[[NSMutableArray alloc] init];
//        for (int i=0; i<3; i++) {
//            NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"的撒旦%d",i],@"Title",@"阿瓦达为全额撒的撒打算打算打算打扫打扫打扫的啊实打实的",@"Content", nil];
//            [questArray addObject:dic];
//        }
//        [self reloadData];
        
    }
    return self;
}
-(void)requestCommonQuest{
    if (_isFirst) {
        [[LoadingView showLoadingView] actViewStartAnimation];
        _isFirst =NO;
    }

    NSString *sid =[[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic =@{@"sid": sid};
    NSString *url =[NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"CommonQuestion"];
    [AsynURLConnection requestWithURL:url dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSError *error;
           NSDictionary *dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
           if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
               NSDictionary *body =[dataDic objectForKey:@"body"];
               if (body) {
                NSArray *array  =[body objectForKey:@"Question"];
                   if (array) {
                       questArray =[[NSMutableArray alloc] initWithArray:array];
                   }
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self reloadData];
                  });
               }
           }
            dispatch_async(dispatch_get_main_queue(), ^{
                   [[LoadingView showLoadingView] actViewStopAnimation];
               });
           
       });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestCommonQuest];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
                timeOutCount = 0;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.tag = kTimeOutTag;
                    alertView.delegate = self;
                    [alertView show];
                }
            }
        }else{
            [[LoadingView showLoadingView] actViewStopAnimation];
        }

    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return questArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string =@"questCell";
    QuestionCell *cell =[tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell =[[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    if (questArray.count !=0) {
        NSDictionary *cellDic =[[NSDictionary alloc] initWithDictionary:[questArray objectAtIndex:indexPath.row]];
        cell.dataDic =cellDic;
    }
     [cell initCommonQuestionCellWith:cell.dataDic] ;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionCell *cell =(QuestionCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    float height =[cell getQuestCellHeight];
    NSLog(@" height  %f",height);
    return height;
}

@end
