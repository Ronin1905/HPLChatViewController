//
//  HPLChatData.m
//
//  Created by Alex Barinov
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import "HPLChatData.h"
#import <QuartzCore/QuartzCore.h>

@implementation HPLChatData

#pragma mark - Properties

@synthesize date = _date;
@synthesize type = _type;
@synthesize view = _view;
@synthesize insets = _insets;
@synthesize avatar = _avatar;
@synthesize statusView = _statusView;
@synthesize avatarImageView = _avatarImgV;

#pragma mark - Lifecycle

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [_date release];
	_date = nil;
    [_view release];
    _view = nil;
    
    self.avatar = nil;
    self.avatarImageView = nil;
    [super dealloc];
}
#endif

#pragma mark - Text chat

const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(HPLChatType)type
{
#if !__has_feature(objc_arc)
    return [[[HPLChatData alloc] initWithText:text date:date type:type] autorelease];
#else
    return [[HPLChatData alloc] initWithText:text date:date type:type];
#endif    
}

- (id)initWithText:(NSString *)text date:(NSDate *)date type:(HPLChatType)type
{
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(220, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
#if !__has_feature(objc_arc)
    [label autorelease];
#endif
    
    UIEdgeInsets insets = (type == ChatTypeMine ? textInsetsMine : textInsetsSomeone);
    return [self initWithView:label date:date type:type insets:insets];
}

#pragma mark - Image chat

const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};

+ (id)dataWithImage:(UIImage *)image date:(NSDate *)date type:(HPLChatType)type
{
#if !__has_feature(objc_arc)
    return [[[HPLChatData alloc] initWithImage:image date:date type:type] autorelease];
#else
    return [[HPLChatData alloc] initWithImage:image date:date type:type];
#endif    
}

- (id)initWithImage:(UIImage *)image date:(NSDate *)date type:(HPLChatType)type
{
    CGSize size = image.size;
    if (size.width > 220)
    {
        size.height /= (size.width / 220);
        size.width = 220;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = image;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;

    
#if !__has_feature(objc_arc)
    [imageView autorelease];
#endif
    
    UIEdgeInsets insets = (type == ChatTypeMine ? imageInsetsMine : imageInsetsSomeone);
    return [self initWithView:imageView date:date type:type insets:insets];       
}

#pragma mark - Custom view chat

+ (id)dataWithView:(UIView *)view date:(NSDate *)date type:(HPLChatType)type insets:(UIEdgeInsets)insets
{
#if !__has_feature(objc_arc)
    return [[[HPLChatData alloc] initWithView:view date:date type:type insets:insets] autorelease];
#else
    return [[HPLChatData alloc] initWithView:view date:date type:type insets:insets];
#endif    
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(HPLChatType)type insets:(UIEdgeInsets)insets  
{
    self = [super init];
    if (self)
    {
#if !__has_feature(objc_arc)
        _view = [view retain];
        _date = [date retain];
#else
        _view = view;
        _date = date;
#endif
        _type = type;
        _insets = insets;
    }
    return self;
}


- (id)initWithText:(NSString *)text date:(NSDate *)date type:(HPLChatType)type messageStatus:(HPLChatMessageStatus)messageStatus {
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(220, 9999) lineBreakMode:UILineBreakModeWordWrap];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = (text ? text : @"");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];

#if !__has_feature(objc_arc)
    [label autorelease];
#endif

    UIEdgeInsets insets = (type == ChatTypeMine ? textInsetsMine : textInsetsSomeone);

    UIView *statusView;

        statusView = [[UIView alloc] initWithFrame:CGRectZero];
        statusView.backgroundColor = [UIColor clearColor];

        switch (messageStatus) {
            case ChatStatusSending: {
                UIActivityIndicatorView *msgSendingStatus = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                msgSendingStatus.frame = CGRectMake(1.0f, 1.0f, 18.0f, 18.0f);
                [msgSendingStatus startAnimating];
                [statusView addSubview:msgSendingStatus];
            }
                break;

            case ChatStatusFailed: {
                UIImageView *errorAlert = [[UIImageView alloc] initWithFrame:CGRectMake(1.0f, 1.0f, 18.0f, 18.0f)];
                errorAlert.image = [UIImage imageNamed:@"fail.png"];
                [statusView addSubview:errorAlert];
            }
                break;
            

            default:
                break;
        }


    return [self initWithView:label date:date type:type insets:insets status:statusView];
}

+ (id)dataWithText:(NSString *)text date:(NSDate *)date type:(HPLChatType)type messageStatus:(HPLChatMessageStatus)messageStatus {
#if !__has_feature(objc_arc)
    return [[[HPLChatData alloc] initWithText:text date:date type:type messageStatus:messageStatus] autorelease];
#else
    return [[HPLChatData alloc] initWithText:text date:date type:type messageStatus:messageStatus]
#endif
}

- (id)initWithView:(UIView *)view date:(NSDate *)date type:(HPLChatData*)type insets:(UIEdgeInsets)insets status:(UIView *)statusView
{
    self = [super init];
    if (self)
    {
#if !__has_feature(objc_arc)
        _view = [view retain];
        _date = [date retain];
        _statusView = [statusView retain];
#else
        _view = view;
        _date = date;
        _statusView = statusView;
#endif
        _type = type;
        _insets = insets;
    }
    return self;
}



@end
