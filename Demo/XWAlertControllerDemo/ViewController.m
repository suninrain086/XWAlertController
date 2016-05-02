//
//  ViewController.m
//  XWAlertControllerDemo
//
//  Created by suninrain086 on 5/2/16.
//  Copyright © 2016 FishSheepStudio. All rights reserved.
//

#import "ViewController.h"
#import <XWAlertController/XWAlertController.h>

static NSString *const kStyleKey = @"style";
static NSString *const kNamekey = @"name";
static NSString *const kTableViewCellIdentifier = @"kTableViewCellIdentifier";

@interface ViewController ()

@property(nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *alertStyles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
    self.alertStyles = @[@{kStyleKey: @(XWAlertControllerStyleActionSheet), kNamekey: @"System ActionSheet"},
                         @{kStyleKey: @(XWAlertControllerStyleAlert), kNamekey: @"System Alert"},
                         @{kStyleKey: @(XWAlertControllerStyleCustomAlert), kNamekey: @"Custom Alert"}];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.alertStyles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    NSDictionary<NSString *, id> *alertInfo = self.alertStyles[indexPath.row];
    cell.textLabel.text = alertInfo[kNamekey];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary<NSString *, id> *alertInfo = self.alertStyles[indexPath.row];
    XWAlertControllerStyle style = [alertInfo[kStyleKey] integerValue];
    
    XWAlertController *alert = [XWAlertController alertControllerWithTitle:@"Title" message:@"This is message for AlertController, and message should be long, long, long, long, long, very very long..." preferredStyle:style];
    [alert addAction:[XWAlertAction actionWithTitle:@"OK" style:XWAlertActionStyleDefault handler:^(XWAlertAction * _Nonnull action) {
        NSLog(@"Action1");
    }]];
    
    [alert addAction:[XWAlertAction actionWithTitle:@"Cancel" style:XWAlertActionStyleDestructive handler:^(XWAlertAction * _Nonnull action) {
        NSLog(@"Action2");
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

@end
