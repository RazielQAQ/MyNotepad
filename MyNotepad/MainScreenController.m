//
//  MainScreenController.m
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import "MainScreenController.h"


@interface MainScreenController ()

@property NSInteger selected;
@property BOOL isSelected;
@property NSInteger deleteSelected;
@property UITextField *addNewSubject;
@property BOOL isNewTitle;
@property BOOL isLongPressed;

@end

@implementation MainScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _isSelected = false;
    _isNewTitle = false;
    _isLongPressed = false;
    
    if(self.notes == nil) {
        self.notes = [[NSMutableArray alloc] init];
        
        //从归档中读取存储的日志
        NSString *pathDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)objectAtIndexedSubscript:0];
        NSString *saveDir = [NSString stringWithFormat:@"%@/notes",pathDocument];

        NSArray *noteFiles = [[NSFileManager defaultManager]subpathsOfDirectoryAtPath:saveDir error:nil];
        for(int i = 0; i < noteFiles.count; i++) {
            //NSLog(@"%@", noteFiles[i]);
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", saveDir, noteFiles[i]];
            if([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                MyNote *note = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
                [self.notes addObject:note];
            }
        }
    }
    
    //设置长按删除日志的事件
    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    //设置长按至少1秒才算长按事件
    longRecognizer.minimumPressDuration = 1.0;
    [self.view addGestureRecognizer:longRecognizer];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.notes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"note"];
    
    cell.textLabel.text = ((MyNote *)[self.notes objectAtIndexedSubscript:(self.notes.count - 1 - indexPath.row)]).subject;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *destVC = (UINavigationController *)[segue destinationViewController];
    if(self.notes.count != 0 && _isSelected) {
        ((ShowDetailViewController *)(destVC.topViewController)).showNote = (MyNote *)[self.notes objectAtIndexedSubscript:(self.notes.count - 1 - _selected)];
        _isSelected = false;
    } else if([destVC.topViewController isKindOfClass:[AddNewController class]]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"新建笔记"
                                                        message:@"请输入新笔记的标题"
                                                       delegate:self
                                              cancelButtonTitle:@"默认标题"
                                              otherButtonTitles:@"确认标题", nil];
        // 基本输入框，显示实际输入的内容
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        //设置输入框的键盘类型
        _addNewSubject = [alert textFieldAtIndex:0];
        
        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selected = indexPath.row;
    _isSelected = true;
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && !_isLongPressed) {
        _isNewTitle = false;
    }else if(buttonIndex == 1 && !_isLongPressed){
        _isNewTitle = true;
    } else if(_isLongPressed) {
        if(buttonIndex == 0) {
            //取消删除
        } else {
            //确定删除
            
            MyNote *note = [self.notes objectAtIndexedSubscript:_deleteSelected];
            NSString *pathDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)objectAtIndexedSubscript:0];
            NSString *saveDir = [NSString stringWithFormat:@"%@/notes",pathDocument];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@.archiver", saveDir, note.createDate];
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

            
            [self.notes removeObjectAtIndex:_deleteSelected];
            
            
            [self.tableView reloadData];
        }
        
        _isLongPressed = false;
    }
}


- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    if([[segue sourceViewController] isKindOfClass:[AddNewController class]]) {
        AddNewController* source = [segue sourceViewController];
        MyNote *note = source.note;
        if(_isNewTitle) {
            note.subject = _addNewSubject.text;
        } else {
            note.subject = @"新建笔记";
        }
        if (note != nil) {
            [self.notes addObject:note];
            [self.tableView reloadData];
            
            //将note直接归档
            NSString *pathDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)objectAtIndexedSubscript:0];
            NSString *saveDir = [NSString stringWithFormat:@"%@/notes",pathDocument];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@.archiver", saveDir, note.createDate];
            NSFileManager *fileManager = [[NSFileManager alloc]init];
            
            if(![[NSFileManager defaultManager]fileExistsAtPath:saveDir]) {
                [fileManager createDirectoryAtPath:saveDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            [NSKeyedArchiver archiveRootObject:note toFile:filePath];
            //NSLog(@"%@, %d", filePath, success);
            
            
        }
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.view];
    NSIndexPath *indexPath = [(UITableView *)self.view indexPathForRowAtPoint: p];
    _deleteSelected = indexPath.row;
    if(self.notes.count != 0) {
        _deleteSelected = self.notes.count - 1 - _deleteSelected;
    }
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertView *deletePrompt = [[UIAlertView alloc] initWithTitle:@"删除笔记" message:@"你确定要删除这条信息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _isLongPressed = true;
        [deletePrompt show];
    }
}



@end
