//
//  TMSChatViewController.h
//  TestMessenger
//
//  Created by Yulia Shakhavnina on 11/07/2017.
//  Copyright © 2017 yuliashakhavnina. All rights reserved.
//

#import "TMSBaseViewController.h"
#import "Conversation+CoreDataClass.h"

@interface TMSChatViewController : TMSBaseViewController

@property (weak, nonatomic) Participant *speaker;
@property (weak, nonatomic) Conversation *conversation;

@end
