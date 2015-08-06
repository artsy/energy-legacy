#import "ARSortViewController.h"
#import "ARTickedTableViewCell.h"
#import "ARTableHeaderView.h"
#import "ARSortDefinition.h"

#define TABLE_CELL_SIZE 44
#define POPOVER_WIDTH 200


@implementation ARSortViewController {
    NSArray *_sorts;
    NSInteger _selectedIndex;
}

- (instancetype)initWithSorts:(NSArray *)sorts andSelectedIndex:(NSInteger)selectedIndex
{
    self = [super init];
    if (!self) return nil;

    _sorts = sorts;
    _selectedIndex = selectedIndex;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sorts.count;
}

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), [ARTableHeaderView heightOfCell]);
    return [[ARTableHeaderView alloc] initWithFrame:frame title:[@"Sort by" uppercaseString] style:ARTableHeaderViewStyleDark];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [ARTableHeaderView heightOfCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = NSStringFromClass([self class]);
    ARTickedTableViewCell *cell = (ARTickedTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ARTickedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    ARSortDefinition *sort = (ARSortDefinition *)_sorts[indexPath.row];
    cell.textLabel.font = [UIFont serifFontWithSize:ARFontSerifSmall];
    cell.textLabel.text = [sort.name uppercaseString];
    [cell setTickSelected:(sort.order == _selectedIndex)animated:NO];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARSortDefinition *sort = _sorts[indexPath.row];
    id oldCell = nil;
    for (int i = 0; i < _sorts.count; i++) {
        if ([_sorts[i] order] == _selectedIndex) {
            oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    id newCell = [tableView cellForRowAtIndexPath:indexPath];

    if (oldCell != newCell) {
        [oldCell setTickSelected:NO animated:YES];
        [newCell setTickSelected:YES animated:YES];
        [self.delegate performSelector:@selector(newSortWasSelected:) withObject:sort afterDelay:ARAnimationQuickDuration];
    }
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(POPOVER_WIDTH, _sorts.count * TABLE_CELL_SIZE + [ARTableHeaderView heightOfCell]);
}

@end
