//
//  MyUserDefault.h
//  91WashGold
//
//  Created by keyrun on 14-4-11.
//  Copyright (c) 2014年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RefreshTime                                             3600

@interface MyUserDefault : NSObject


+(id)standardUserDefaults;

-(BOOL)synchronize;

//设置和获取UserNickname
-(void)setUserNickname:(NSString *)userNickname;
-(NSString *)getUserNickname;

//设置和获取sid
-(void)setSid:(NSString *)sid;
-(NSString *)getSid;

//设置和获取Update
-(void)setUpdate:(NSDictionary *)update;
-(NSDictionary *)getUpdate;

//设置和获取appVersion
-(void)setAppVersion:(NSString *)appVersion;
-(NSString *)getAppVersion;

//设置和获取UserLocking
-(void)setUserLocking:(int )userLocking;
-(NSNumber *)getUserLocking;

//设置和获取userBeanNum
-(void)setUserBeanNum:(long)userBeanNum;
-(NSNumber *)getUserBeanNum;

//设置和获取UserSetNameGold
-(void)setUserSetNameGold:(int )userSetNameGold;
-(NSNumber *)getUserSetNameGold;

//设置和获取UserId
-(void)setUserId:(NSString *)userId;
-(NSString *)getUserId;

//设置和获取JFQIsCheck
-(void)setJFQIsCheck:(int)JFQIsCheck;
-(NSNumber *)getJFQIsCheck;

//设置和获取token
-(void)setToken:(NSString *)token;
-(NSString *)getToken;

//设置和获取InviteGold
-(void)setInviteGold:(int )inviteGold;
-(NSNumber *)getInviteGold;

//设置和获取updateDelayTime
-(void)setUpdateDelayTime:(int )updateDelayTime;
-(NSNumber *)getUpdateDelayTime;

//设置和获取LoginTime
-(void)setLoginTime:(NSNumber *)loginTime;
-(NSNumber *)getLoginTime;

//设置和获取Logined
-(void)setLogined:(BOOL )Logined;
-(NSNumber *)getLogined;

//设置和获取AppUseTime
-(void)setAppUseTime:(int )appUseTime;
-(NSNumber *)getAppUseTime;

//设置和获取NetWork
-(void)setNetWork:(int )netWork;
-(NSNumber *)getNetWork;

//设置和获取Did
-(void)setDid:(int)did;
-(NSNumber *)getDid;

//设置和获取userDeviceToken
-(void)setUserDeviceToken:(NSString *)userDeviceToken;
-(NSString *)getUserDeviceToken;

//设置和获取isRegistRemotion
-(void)setIsRegistRemotion:(BOOL )isRegistRemotion;
-(NSNumber *)getIsRegistRemotion;

//设置和获取RewardContent
-(void)setRewardContent:(NSString *)rewardContent;
-(NSString *)getRewardContent;

//设置和获取userQNum
-(void)setUserQNum:(NSString *)userQNum;
-(NSString *)getUserQNum;

//设置和获取userZFB
-(void)setUserZFB:(NSString *)userZFB;
-(NSString *)getUserZFB;

//设置和获取userCFT
-(void)setUserCFT:(NSString *)userCFT;
-(NSString *)getUserCFT;

//设置和获取userPhoneNum
-(void)setUserPhoneNum:(NSString *)userPhoneNum;
-(NSString *)getUserPhoneNum;

//设置和获取回复输入框的内容
-(void)setReplyContent:(NSString *)replyContent time:(NSString *)time;
-(NSString *)getReplyContent:(NSString *)time;

//设置和获取
-(void)setTopIdReplyContent:(NSDictionary *)dic topicId:(int)topicId addedReplyCellTag:(int)addedReplyCellTag indexNum:(int)indexNum;
-(NSDictionary *)getTopIdReplyContent:(int)topicId addedReplyCellTag:(int)addedReplyCellTag indexNum:(int)indexNum;

//设置和获取UserTopicText
-(void)setUserTopicText:(NSString *)userTopicText topicType:(topicTypeEnum)topicType;
-(NSString *)getUserTopicText:(topicTypeEnum)topicType;

//设置和获取lasttime
-(void)setLasttime:(int)lasttime;
-(NSNumber *)getLasttime;

//设置和获取TopicReplyNumber
-(void)setTopicReplyNumber:(int )topicReplyNumber;
-(NSNumber *)getTopicReplyNumber;

//设置和获取MyCommentNumber
-(void)setMyCommentNumber:(int )commentNumber;
-(NSNumber *)getMyCommentNumber;

//设置和获取oldReplyNum
-(void)setOldReplyNum:(int)oldReplyNum tid:(int)tid;
-(NSNumber *)getOldReplyNum:(int)tid;

//设置和获取userPic
-(void)setUserPic:(NSData *)userPic;
-(NSData *)getUserPic;

//设置和获取UserLog
-(void)setUserLog:(int)userLog;
-(NSNumber *)getUserLog;

//设置和获取userInviteCount
-(void)setUserInviteCount:(int)userInviteCount;
-(NSNumber *)getUserInviteCount;

//设置和获取userMsgNum
-(void)setUserMsgNum:(int)userMsgNum;
-(NSNumber *)getUserMsgNum;

//设置和获取daTingRefreshTime
-(void)setDaTingRefreshTime:(NSNumber *)daTingRefreshTime;
-(NSNumber *)getDaTingRefreshTime;

//设置和获取rewordRefreshTime
-(void)setRewordRefreshTime:(NSNumber *)rewordRefreshTime;
-(NSNumber *)getRewordRefreshTime;

//设置和获取hotTopicRefreshTime
-(void)setHotTopicRefreshTime:(NSNumber *)hotTopicRefreshTime;
-(NSNumber *)getHotTopicRefreshTime;

//设置和获取newestTopicRefreshTime
-(void)setNewestTopicRefreshTime:(NSNumber *)newestTopicRefreshTime;
-(NSNumber *)getNewestTopicRefreshTime;

//设置和获取UserSubmitOpinionText
-(void)setUserSubmitOpinionText:(NSString *)userSubmitOpinionText;
-(NSString *)getUserSubmitOpinionText;

//设置和获取 userIconUrl
-(void)setUserIconUrlStr:(NSString *)userIconUrl;
-(NSString *)getUserIconUrl;

//设置和获取 提问内容
-(void) setUserAskStr: (NSDictionary *)userAskStr;
-(NSDictionary *) getuserAskStr;

//设置和获取【晒单有奖】是否已经下拉晒单广场
-(void)setIsHavePullShowPosts:(NSNumber *)isHavePullShowPosts;
-(NSNumber *)getIsHavePullShowPosts;

//设置和获取【晒单有奖】是否已经下拉我的晒单
-(void)setIsHavePullMyPosts:(NSNumber *)isHavePullMyPosts;
-(NSNumber *)getIsHavePullMyPosts;

//设置和获取【摇一摇】当前是否已经摇过(value的格式为：yyyyMMdd)
-(void)setYaoYiYaoDateStr:(NSString *)dateStr;
-(NSString *)getYaoYiYaoDateStr;

//设置和获取 免责声明 是否已经显示
-(void)setIsShowDutyView:(NSNumber *) isShow;   // 0代表未显示  1代表显示了
-(NSNumber *)getIsShowDutyView;


//设置和获取  由兑换列表返回到兑换中心 重新请求数据   // 0 不刷新 1刷新
-(void) setIsNeedReloadRV:(NSNumber *)isNeed ;
-(NSNumber *)getIsNeedReloadRV;


//设置和获取 评论活动成功保存 评论内容
-(void) setPinLunLocationData:( NSDictionary *)dic;
-(NSDictionary *)getPinLunLocationData;


//设置和获取appstore 地址
-(void) setAppStoreAdress :(NSString *)adress;
-(NSString *)getAppStoreAdress ;

//设置和获取是否需要显示【免责声明】
-(void)setIsNeedDutyView:(NSNumber *)isNeed;
-(NSNumber *)getIsNeedDutyView;


//设置和获取 活动中心免责显示
-(void) setActiveCenterDutyShow :(NSNumber *) show;
-(NSNumber *)getActiveCenterDutyShow;

//设置和获取晒单有奖 免责显示
-(void) setShaiDanCenterDutyShow :(NSNumber *) show;
-(NSNumber *)getShaiDanCenterDutyShow;

//设置和获取 分享有奖 免责显示
-(void) setShareCenterDutyShow :(NSNumber *) show;
-(NSNumber *)getShareCenterDutyShow;


//设置和获取 md5userDeveiceToken
-(void) setUserMd5DeveiceToken :(NSString *)token;
-(NSString *)getUserMd5DeveiceToken ;

//设置和获取 百度push id
-(void) setBDUserPushId:(NSString *)pushid;
-(NSString *)getBDUserPushId ;

//设置和获取 当前进入app的schemes
-(void)setAppSchemes:(NSString *)schemes;
-(NSString *)getAppSchemes;

//设置和获取 schemes对应的appId
-(void)setAppSchemesAppId:(NSString *)appId schemes:(NSString *)schemes;
-(NSString *)getAppAppIdWithSchemes:(NSString *)schemes;

//设置和获取 某一个app的后台签到时间长度
-(void) setAppSchemesTime:(NSString *)schemes time:(NSNumber *)time;
-(NSNumber *)getAppSchemesTime:(NSString *)schemes;

//设置和获取 某一个app是否已经签到
-(void) setAppSchemesStatus:(int)status appSchemes:(NSString *)appSchemes;
-(NSNumber *)getAppSchemesStatus:(NSString *)appSchemes;

//设置和获取 是否需要显示【活动中心】的4个按钮
-(void) setIsNeedActivityView:(NSNumber *)isNeed;
-(NSNumber *) getIsNeedActivityView;

//设置和获取 保存晒单详情评论的输入框内容
-(void) setShowPostsComment:(NSString *)comment;
-(NSString *)getShowPostsComment;

//设置和获取 筛选好的相片
-(void) setUserSortedPhoto:(NSMutableArray *)array;
-(NSMutableArray *)getUserSortedPhoto;

// 设置和获取 用户邀请码
-(void) setUserInvcode:(NSString *)userInvcode;
-(NSString *)getUserInvcode;

// 设置和获取 当前晒单活动是显示【我的晒单】还是【晒单广场】
-(void) setShowPostsType:(int)type;
-(NSNumber *) getShowPostsType;

// 设置和获取 签到时间
-(void) setSignFreshTime:(NSNumber *)signFreshTime;
-(NSNumber *) getSignFreshTime;

// 设置和获取 主界面切换的刷新间隔时间
-(void) setViewFreshTime:(NSNumber *)viewFreshTime;
-(NSNumber *) getViewFreshTime;

// 设置和获取 是否点击【安装/打开】按钮
-(void) setIsOpenApp:(BOOL) isOpenApp;
-(BOOL) getIsOpenApp;


// 设置和获取 乐透竞彩 所有图片对象
-(void) setLotteryImgsObj:(NSMutableArray *)array;
-(NSMutableArray *)getLotteryImgsObj;

// 设置和获取 乐透竞猜 图片数据
-(void) setLotteryImgsData:(NSMutableArray *)datas;
-(NSMutableArray *) getLotteryImgsData;


//2.0.1
// 设置获取cookieSid
-(void) setCookieSid:(NSString *)cookieSid;
-(NSString *) getCookieSid ;

//设置和获取 上次自动链接的时间
-(void)setLastSuperLinkTime:(NSString *)time;
-(NSString *)getLastSuperLinkTime;

// 设置和获取 欢迎页图片数据
-(void) setWelcomeImgData:(NSData *)data;
-(NSData *)getWelcomeImgData ;


//设置和获取 欢迎页所以数据
-(void) setWelcomeImgDic:(NSDictionary *)dic;
-(NSDictionary *) getWelcomImgDic;

//设置和获取 欢迎页图片地址
-(void) setWelcomeImgUrl:(NSString *)url;
-(NSString *) getWelcomeImgUrl;


//设置和获取 执行过超链接的app 数组
-(void) setHaveDoneSuperLinked:(NSMutableArray *)array;
-(NSMutableArray *) getHaveDoneSuperLinked;

//设置和获取 请求中的编码key
-(void) setRequestCodeKey:(NSString *)key ;
-(NSString *)getRequestCodeKey;

//设置和获取  是否已经展示欢迎页
-(void) setIsShowedWelcome:(NSNumber *) isShowed;
-(NSNumber *)getIsShowWelcome;


//设置和获取 sandbox里面的用户标示
-(void) setSandBoxUserToken:(NSString *)userToken;
-(NSString *) getSandBoxUserToken;
@end
















