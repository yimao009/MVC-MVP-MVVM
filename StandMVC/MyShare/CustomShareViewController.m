//
//  CustomShareViewController.m
//  MyShare
//
//  Created by guoruize on 2020/9/4.
//  Copyright © 2020 guoruize. All rights reserved.
//

#import "CustomShareViewController.h"
static int count = 0;
@interface CustomShareViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *prvimg;
@property (nonatomic, strong, readwrite) NSUserDefaults *groupUserDefaults;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *imgStr;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSArray *inputs;

@property (nonatomic, strong, readwrite) UIActivityIndicatorView *indicator ;
@end

@implementation CustomShareViewController
-(NSUserDefaults *)groupUserDefaults
{
    if (!_groupUserDefaults)
    {
        _groupUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.exam.StandMVC"];
    }
    return _groupUserDefaults;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    count = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    _datas = [[NSMutableArray alloc] init];
    [self.groupUserDefaults setValue:@"other" forKey:@"newkey"];
    NSString *title = [self.groupUserDefaults objectForKey:@"title"];
    NSLog(@"%@", title);
    
    NSExtensionContext *myExtensionContext = self.extensionContext;
    NSArray *inputItems = myExtensionContext.inputItems;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    [self.view addSubview:indicator];
    self.indicator = indicator;
    indicator.center = self.view.center;
    [indicator startAnimating];
    for (NSExtensionItem *item in inputItems) {
        NSLog(@"attributedTitle %@",item.attributedTitle);
        NSDictionary *dict = item.userInfo;
        NSLog(@"userInfo %@",item.userInfo);
        NSLog(@"attributedContentText %@", item.attributedContentText);
        
        NSArray *attachments = item.attachments;
        self.inputs = attachments;
        [attachments enumerateObjectsUsingBlock:^(NSItemProvider *provider, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *ideftifier = [self returnIdentifier:provider];
            [self process:provider identifier:ideftifier];
        }];
    }
}
// 获取UTI
- (NSString *)returnIdentifier:(NSItemProvider *)provider
{
    if ([provider hasItemConformingToTypeIdentifier:@"public.file-url"] )
    {
        return @"public.file-url";
    }
    if ([provider hasItemConformingToTypeIdentifier:@"public.jpeg"])
    {
        return @"public.jpeg";
    }
    if ([provider hasItemConformingToTypeIdentifier:@"public.png"])
    {
        return @"public.png";
    }
    return nil;
}
// 处理provider
- (void)process:(NSItemProvider *)provider identifier:(NSString *)identifier
{
    [provider loadItemForTypeIdentifier:identifier options:nil completionHandler:^(id item, NSError * _Null_unspecified error) {
        NSObject *obj = (NSObject *)item;
        if ([obj isKindOfClass:[NSString class]])
        {
            NSString *string = (NSString *)obj;
            NSData *data = [NSData dataWithContentsOfFile:string];
        }
        if ([obj isKindOfClass:[NSURL class]])
        {
            NSURL *url = (NSURL *)obj;
            [self processURL:url];
//            self.imgStr = [self UIImageToBase64Str:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];

        }
        if ([obj isKindOfClass:[NSData class]]) {
            [self showImage:item name:self.name];
        }
        count += 1;
        if (self.inputs.count == count) {
            [self.indicator stopAnimating];
        }
    }];
    NSLog(@"");
}

- (void)processURL:(NSURL *)url
{
//    NSLog(@"absoluteString %@", url.absoluteString);
//    NSLog(@"relativeString %@", url.relativeString);
//    NSLog(@"baseURL %@", url.baseURL);
//    NSLog(@"absoluteURL %@", url.absoluteURL);
//    NSLog(@"absoluteString %@", url.absoluteString);
//    NSLog(@"scheme %@", url.scheme);
//    NSLog(@"resourceSpecifier %@", url.resourceSpecifier);
//    NSLog(@"absoluteString %@", url.absoluteString);
//
//    NSLog(@"host %@", url.host);
//    NSLog(@"port %@", url.port);
//    NSLog(@"user %@", url.user);
//    NSLog(@"password %@", url.password);
//    NSLog(@"path %@", url.path);
//    NSLog(@"fragment %@", url.fragment);
//    NSLog(@"parameterString %@", url.parameterString);
//    NSLog(@"query %@", url.query);
//    NSLog(@"relativePath %@", url.relativePath);
//    NSLog(@"host %@", url.host);
//    NSLog(@"host %@", url.host);
//    NSLog(@"host %@", url.host);
    NSString *path = url.path;
    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    NSString *lastStrOfPath = [pathArray lastObject];
    NSArray *lastArray = [path componentsSeparatedByString:@"."];
    NSString *name = lastStrOfPath;
    NSString *format = [lastArray lastObject];
    self.format = format;
    self.name = name;
    self.urlString = [url absoluteString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [_datas addObject:data];
    [self showImage:data name:self.name];
}
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}
- (void)showImage:(NSData *)data name:(NSString *)name
{
    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.nameLab setText:name];
        [self.prvimg setImage:image];
    });
}
- (IBAction)openApp:(id)sender
{
//    NSURL *fileURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.exam.StandMVC"];
    NSArray *datas = @[@{@"name":self.name, @"format":self.format,@"URL":self.urlString, @"imgStr":self.imgStr, @"imgData":self.datas.firstObject}];
    [self.groupUserDefaults setValue:datas forKey:@"ShareDataKey"];
    [self openApp];
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];

}

- (NSString *)name
{
    if (_name == nil) {
        return @"";
    }
    return _name;
}

- (NSString *)format
{
    if (_format == nil) {
        return @"";
    }
    return _format;
}
- (NSString *)imgStr
{
    if (_imgStr == nil) {
        return @"";
    }
    return _imgStr;
}


- (void)openApp
{
    NSString *scheme = @"StandMVC://";
    NSURL *url = [NSURL URLWithString:scheme];
    UIResponder *responder = self;
    while (responder)
    {
        SEL openSelector = NSSelectorFromString(@"openURL:");
        if ([responder respondsToSelector: openSelector])
        {
            [responder performSelector:openSelector withObject:url afterDelay:1.0];
            break;
        }
        responder = [responder nextResponder];
    }
}


@end
