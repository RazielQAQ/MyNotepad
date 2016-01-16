//
//  MainScreenController.m
//  MyNotepad
//
//  Created by nju on 16/1/16.
//  Copyright (c) 2016年 nju. All rights reserved.
//

#import "MainScreenController.h"

@interface MainScreenController ()

@end

@implementation MainScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    NSString *identifier = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    AddNewController* source = [segue sourceViewController];
    MyNote *note = source.note;
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




@end
