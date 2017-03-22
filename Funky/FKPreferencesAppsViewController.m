//
//  FKPreferencesAppsViewController.m
//  Funky
//
//  Created by Cătălin Stan on 05/03/2017.
//  Copyright © 2017 Cătălin Stan. All rights reserved.
//

#import "FKPreferencesAppsViewController.h"
#import "FKAppDelegate.h"
#import "FKBundle.h"

@interface FKPreferencesAppsViewController () <NSTableViewDelegate>

@property (strong) IBOutlet NSArrayController *appsListController;

- (IBAction)addBundle:(id)sender;

@end

@implementation FKPreferencesAppsViewController

- (void)awakeFromNib {
    self.appsListController.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FKBundleNameKey ascending:YES], [NSSortDescriptor sortDescriptorWithKey:FKBundlePathKey ascending:YES]];
}

- (IBAction)addBundle:(id)sender {
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    panel.directoryURL = [[NSFileManager defaultManager] URLsForDirectory:NSAllApplicationsDirectory inDomains:NSAllDomainsMask].lastObject;
    panel.allowedFileTypes = @[@"app"];
    panel.allowsMultipleSelection = YES;
    panel.canChooseDirectories = YES;
    panel.treatsFilePackagesAsDirectories = NO;
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if ( result != NSFileHandlingPanelOKButton ) {
            return;
        }
        [panel.URLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) { @autoreleasepool {
            FKBundle *bundle = [FKBundle bundleWithURL:obj];
            if ( [[self.appsListController.arrangedObjects valueForKeyPath:FKBundleIdentifierKey] containsObject:bundle.identifier] ) {
                return;
            }
            [self.appsListController addObject:bundle];
        }}];
        [self.appsListController commitEditing];
    }];
}

#pragma mark - NSTableViewDelegate

- (NSArray<NSTableViewRowAction *> *)tableView:(NSTableView *)tableView rowActionsForRow:(NSInteger)row edge:(NSTableRowActionEdge)edge {
    if ( edge != NSTableRowActionEdgeTrailing ) {
        return nil;
    }
    
    NSTableViewRowAction *deleteAction = [NSTableViewRowAction rowActionWithStyle:NSTableViewRowActionStyleDestructive title:@"Delete" handler:^(NSTableViewRowAction * _Nonnull action, NSInteger row) {
        [self.appsListController removeObjectAtArrangedObjectIndex:row];
    }];
    
    return @[deleteAction];
}

@end
