//
//  ViewController.m
//  DMSexyTablesExample
//
//  Created by Daniel McCarthy on 1/1/15.
//  Copyright (c) 2015 Daniel McCarthy. All rights reserved.
//

#import "ViewController.h"
#import "DMSexyTable.h"
#import "DMTableSwiperView.h"
#import "Celly.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DMSexyTable *table1;
@property (strong, nonatomic) DMSexyTable *table2;
@property (strong, nonatomic) DMSexyTable *table3;
@property (strong, nonatomic) DMTableSwiperView *tableSwiper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTheTableStuff];
}

- (void)setupTheTableStuff {
    self.table1 = [[DMSexyTable alloc] initWithFrame:self.view.frame andBackgroundImage:[UIImage imageNamed:@"tempBg2"]];
    [self.table1 registerNib:[UINib nibWithNibName:@"Celly" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Celly"];
    self.table1.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table1.delegate = self;
    self.table1.dataSource = self;
    
    self.table2 = [[DMSexyTable alloc] initWithFrame:self.view.frame andBackgroundImage:[UIImage imageNamed:@"tempBg3"]];
    [self.table2 registerNib:[UINib nibWithNibName:@"Celly" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Celly"];
    self.table2.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table2.delegate = self;
    self.table2.dataSource = self;
    
    self.table3 = [[DMSexyTable alloc] initWithFrame:self.view.frame andBackgroundImage:[UIImage imageNamed:@"tempBg4"]];
    [self.table3 registerNib:[UINib nibWithNibName:@"Celly" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Celly"];
    self.table3.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table3.delegate = self;
    self.table3.dataSource = self;

    self.tableSwiper = [[DMTableSwiperView alloc] initWithTableViews:@[self.table1, self.table2, self.table3]
                                                          tableFrame:self.view.frame
                                                    inViewController:self];
    [self.view addSubview:self.tableSwiper];
}

#pragma mark - TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 175.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Celly *cell = [tableView dequeueReusableCellWithIdentifier:@"Celly"];
    if (!cell)
        cell = [[Celly alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Celly"];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == self.table1)
        cell.cellyLabel.text = @"Swipe for Table 2 >";
    else if (tableView == self.table2)
        cell.cellyLabel.text = @"< Swipe for Table 1 or 3 >";
    else
        cell.cellyLabel.text = @"< Swipe for Table 2";
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
