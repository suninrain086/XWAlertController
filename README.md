# XWAlertController

## Description

XWAlertController provides similar API like UIAlertController, you can also use the same API for iOS7.

## <a id="Installation"></a> Installation

### From CocoaPods

```ruby
pod 'XWAlertController'
```

## <a id="Examples"></a> Examples

You can use XWAlertController like the following example:

```objc
    XWAlertController *alert = [XWAlertController alertControllerWithTitle:@"Title"
                                                                   message:@"This is message for AlertController"
                                                            preferredStyle:XWAlertControllerStyleAlert];
    [alert addAction:[XWAlertAction actionWithTitle:@"OK" style:XWAlertActionStyleDefault handler:^(XWAlertAction * _Nonnull action) {
        NSLog(@"Action1");
    }]];
    
    [alert addAction:[XWAlertAction actionWithTitle:@"Cancel" style:XWAlertActionStyleDestructive handler:^(XWAlertAction * _Nonnull action) {
        NSLog(@"Action2");
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
```

## License

The source code is distributed under the nonviral [MIT License](http://opensource.org/licenses/mit-license.php). It's the simplest most permissive license available.

## Version History

* **v0.0.1:** May 2 2016