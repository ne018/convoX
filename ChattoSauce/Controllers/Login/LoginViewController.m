//
//  ViewController.m
//  ChattoSauce
//
//  Created by Drey Mill on 17/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "LoginViewController.h"
#import "FriendsViewController.h"
#import "Firebase.h"
#import "CustomAlertView.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIView *inputContainerView;
@property (nonatomic, strong) UIButton *loginRegisterButton;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIView *nameSeparatorView;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UIView *emailSeparatorView;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIView *passwordSeparatorView;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UISegmentedControl *loginRegisterSegmentedControl;
@property (nonatomic, strong) NSLayoutConstraint *inputContainerViewHeightAnchor;
@property (nonatomic, strong) NSLayoutConstraint *nameTextFieldHeightAnchor;
@property (nonatomic, strong) NSLayoutConstraint *emailTextFieldHeightAnchor;
@property (nonatomic, strong) NSLayoutConstraint *passwordTextFieldHeightAnchor;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation LoginViewController{
    BOOL changedPic;
}


-(UIView *)inputContainerView{
    if(!_inputContainerView){
        _inputContainerView = [[UIView alloc] init];
        _inputContainerView.backgroundColor = [UIColor whiteColor];
        _inputContainerView.translatesAutoresizingMaskIntoConstraints = false;
        _inputContainerView.layer.cornerRadius = 5;
        _inputContainerView.layer.masksToBounds = true;
    }
    return _inputContainerView;
}

-(UIButton *)loginRegisterButton{
    if(!_loginRegisterButton){
        _loginRegisterButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginRegisterButton.backgroundColor = [UIColor colorWithRed:80/255 green:101/255 blue:161/255 alpha:1];
        [_loginRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginRegisterButton setTitle:@"Register" forState:UIControlStateNormal];
        _loginRegisterButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false;
        
        [_loginRegisterButton addTarget:self action:@selector(handleLoginRegister) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginRegisterButton;
}

-(void)handleLoginRegister{
    if(self.loginRegisterSegmentedControl.selectedSegmentIndex == 0){
        [self handleLogin];
    }else{
        [self handleRegister];
    }
}

-(void)handleLogin{
    if(!(self.emailTextField.text.length > 0) && !(self.passwordTextField.text.length > 0)){
        NSLog(@"Form is not valid");
        [CustomAlertView csAlertView:self withTitle:@"Error!" withMessage:@"Please fill up the fields"];
    }
    [FIRAuth.auth signInWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"error: %@", error);
            [CustomAlertView csAlertView:self withTitle:@"Error!" withMessage:[[error userInfo] valueForKey:@"NSLocalizedDescription"]];
            return;
        }
        // successfully logged in
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

-(void)handleRegister{
    if(!(self.emailTextField.text.length > 0) && !(self.passwordTextField.text.length > 0) && !(self.nameTextField.text.length > 0)){
        NSLog(@"Form is not valid");
        [CustomAlertView csAlertView:self withTitle:@"Error!" withMessage:@"Please fill up all fields"];
        return;
    }
    [FIRAuth.auth createUserWithEmail:self.emailTextField.text password:self.passwordTextField.text completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"error: %@", error);
            [CustomAlertView csAlertView:self withTitle:@"Error!" withMessage:[[error userInfo] valueForKey:@"NSLocalizedDescription"]];
        }
        
        NSString *uid = authResult.user.uid;
        if (!(uid.length > 0)) {
            return;
        }
        
        NSString *imageName = [[NSUUID UUID] UUIDString];
        
        //storage reference
        FIRStorage *storage = [FIRStorage storage];
        FIRStorageReference *storeRef = [storage reference];
        FIRStorageReference *imageRef = [[storeRef child:@"images"] child:[NSString stringWithFormat:@"%@.jpg", imageName]];
        
        NSData *uploadData = UIImageJPEGRepresentation(self.profileImageView.image, 0.1);
        
        if(uploadData != nil){
            [imageRef putData:uploadData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                if(error != nil){
                    NSLog(@"error: %@", error);
                    return;
                }
                
                [imageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                    if(error != nil){
                        NSLog(@"error: %@", error);
                        return;
                    }
                    
                    if(URL.absoluteString.length == 0){
                        return;
                    }
                    NSString *imageProfileURL = changedPic ? URL.absoluteString : @"placeholder";
                    NSDictionary *values = @{@"name":self.nameTextField.text, @"email":self.emailTextField.text, @"profileimagename":imageProfileURL};
                    [self registerUserIntoDatabaseWithUID:uid withValues:values];
                }];
            }];
        }
    }];
}

-(void)registerUserIntoDatabaseWithUID:(NSString *)uid withValues:(NSDictionary *)values{
    FIRDatabaseReference *ref = [FIRDatabase.database referenceFromURL:@"https://convox-c659d.firebaseio.com/"];
    FIRDatabaseReference *userRef = [[ref child:@"users"] child:uid];
    [userRef updateChildValues:values withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if(error != nil){
            NSLog(@"error: %@", error);
            [CustomAlertView csAlertView:self withTitle:@"Error!" withMessage:[[error userInfo] valueForKey:@"NSLocalizedDescription"]];
            return;
        }
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

- (UITextField *)nameTextField{
    if(!_nameTextField){
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.placeholder = @"Name";
        _nameTextField.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _nameTextField;
}

- (UIView *)nameSeparatorView{
    if(!_nameSeparatorView){
        _nameSeparatorView = [[UIView alloc] init];
        _nameSeparatorView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];
        _nameSeparatorView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _nameSeparatorView;
}

- (UITextField *)emailTextField{
    if(!_emailTextField){
        _emailTextField = [[UITextField alloc] init];
        _emailTextField.placeholder = @"Email";
        _emailTextField.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _emailTextField;
}

- (UIView *)emailSeparatorView{
    if(!_emailSeparatorView){
        _emailSeparatorView = [[UIView alloc] init];
        _emailSeparatorView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];
        _emailSeparatorView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _emailSeparatorView;
}

- (UITextField *)passwordTextField{
    if(!_passwordTextField){
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"Password";
        _passwordTextField.translatesAutoresizingMaskIntoConstraints = false;
        _passwordTextField.secureTextEntry = true;
    }
    return _passwordTextField;
}

- (UIView *)passwordSeparatorView{
    if(!_passwordSeparatorView){
        _passwordSeparatorView = [[UIView alloc] init];
        _passwordSeparatorView.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1];
        _passwordSeparatorView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _passwordSeparatorView;
}

- (UIImageView *)profileImageView{
    if(!_profileImageView){
        _profileImageView = [[UIImageView alloc] init];
        _profileImageView.image = [UIImage imageNamed:@"chattosauce_logo"];
        _profileImageView.translatesAutoresizingMaskIntoConstraints = false;
        _profileImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelectProfileImageView)];
        [_profileImageView addGestureRecognizer:tapImageView];
        _profileImageView.userInteractionEnabled = true;
    }
    return _profileImageView;
}

-(void)handleSelectProfileImageView{
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.allowsEditing = true;
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *selectedImageFromPicker;
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if(editedImage) {
            selectedImageFromPicker = editedImage;
        } else if (originalImage){
            selectedImageFromPicker = originalImage;
        }
        
        if (selectedImageFromPicker){
            changedPic = true;
            self.profileImageView.image = selectedImageFromPicker;
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(UISegmentedControl *)loginRegisterSegmentedControl{
    if(!_loginRegisterSegmentedControl){
        _loginRegisterSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Login", @"Register"]];
        _loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false;
        _loginRegisterSegmentedControl.tintColor = [UIColor whiteColor];
        _loginRegisterSegmentedControl.selectedSegmentIndex = 1;
        [_loginRegisterSegmentedControl addTarget:self action:@selector(handleLoginRegisterChange) forControlEvents:UIControlEventValueChanged];
    }
    return _loginRegisterSegmentedControl;
}

-(void)handleLoginRegisterChange{
    NSString *title = [self.loginRegisterSegmentedControl titleForSegmentAtIndex:self.loginRegisterSegmentedControl.selectedSegmentIndex];
    [self.loginRegisterButton setTitle:title forState:UIControlStateNormal];
    
    self.inputContainerViewHeightAnchor.constant = self.loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150;
    
    self.nameTextFieldHeightAnchor.active = false;
    self.nameTextFieldHeightAnchor = [self.nameTextField.heightAnchor constraintEqualToAnchor:self.inputContainerView.heightAnchor multiplier:self.loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : (CGFloat)1/3];
    self.nameTextFieldHeightAnchor.active = true;
    
    self.emailTextFieldHeightAnchor.active = false;
    self.emailTextFieldHeightAnchor = [self.emailTextField.heightAnchor constraintEqualToAnchor:self.inputContainerView.heightAnchor multiplier:self.loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? (CGFloat)1/2 : (CGFloat)1/3];
    self.emailTextFieldHeightAnchor.active = true;
    
    self.passwordTextFieldHeightAnchor.active = false;
    self.passwordTextFieldHeightAnchor = [self.passwordTextField.heightAnchor constraintEqualToAnchor:self.inputContainerView.heightAnchor multiplier:self.loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? (CGFloat)1/2 : (CGFloat)1/3];
    self.passwordTextFieldHeightAnchor.active = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    changedPic = false;
    self.view.backgroundColor = [UIColor colorWithRed:96.0f/255.0f green:96.0f/255.0f blue:96.0f/255.0f alpha:1];
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesture:)];
    [self.view addGestureRecognizer:tapView];
    
    [self.view addSubview:self.inputContainerView];
    [self.view addSubview:self.loginRegisterButton];
    [self.view addSubview:self.profileImageView];
    [self.view addSubview:self.loginRegisterSegmentedControl];
    
    [self setupInputContainerView];
    [self setupLoginRegisterButton];
    [self setupProfileImageView];
    [self setupLoginRegisterSegmentedControl];
}

-(void)setupLoginRegisterSegmentedControl{
    [self.loginRegisterSegmentedControl.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [self.loginRegisterSegmentedControl.bottomAnchor constraintEqualToAnchor:self.inputContainerView.topAnchor constant:-12].active = true;
    [self.loginRegisterSegmentedControl.widthAnchor constraintEqualToAnchor:self.inputContainerView.widthAnchor].active = true;
    [self.loginRegisterSegmentedControl.heightAnchor constraintEqualToConstant:36].active = true;
}

-(void)tapgesture:(id)sender{
    [self.view endEditing:true];
}

- (void)setupInputContainerView{
    [self.inputContainerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [self.inputContainerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
    [self.inputContainerView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-24].active = true;
    self.inputContainerViewHeightAnchor = [self.inputContainerView.heightAnchor constraintEqualToConstant:150];
    self.inputContainerViewHeightAnchor.active = true;
    
    [self.inputContainerView addSubview: self.nameTextField];
    [self.inputContainerView addSubview: self.nameSeparatorView];
    [self.inputContainerView addSubview: self.emailTextField];
    [self.inputContainerView addSubview: self.emailSeparatorView];
    [self.inputContainerView addSubview: self.passwordTextField];
    [self.inputContainerView addSubview: self.passwordSeparatorView];
    
    [self.nameTextField.leftAnchor constraintEqualToAnchor:self.inputContainerView.leftAnchor constant:12].active = true;
    [self.nameTextField.topAnchor constraintEqualToAnchor:self.inputContainerView.topAnchor].active = true;
    [self.nameTextField.widthAnchor constraintEqualToAnchor:self.inputContainerView.widthAnchor].active = true;
    self.nameTextFieldHeightAnchor = [self.nameTextField.heightAnchor constraintEqualToAnchor:self.inputContainerView.heightAnchor multiplier:(CGFloat)1/3];
    self.nameTextFieldHeightAnchor.active = true;
    
    [self.nameSeparatorView.leftAnchor constraintEqualToAnchor:self.inputContainerView.leftAnchor].active = true;
    [self.nameSeparatorView.topAnchor constraintEqualToAnchor:self.nameTextField.bottomAnchor].active = true;
    [self.nameSeparatorView.widthAnchor constraintEqualToAnchor:self.inputContainerView.widthAnchor].active = true;
    [self.nameSeparatorView.heightAnchor constraintEqualToConstant:1.0f].active = true;
    
    [self.emailTextField.leftAnchor constraintEqualToAnchor:self.inputContainerView.leftAnchor constant:12].active = true;
    [self.emailTextField.topAnchor constraintEqualToAnchor:self.nameSeparatorView.bottomAnchor].active = true;
    [self.emailTextField.widthAnchor constraintEqualToAnchor:self.inputContainerView.widthAnchor].active = true;
    self.emailTextFieldHeightAnchor = [self.emailTextField.heightAnchor constraintEqualToAnchor:self.inputContainerView.heightAnchor multiplier:(CGFloat)1/3];
    self.emailTextFieldHeightAnchor.active = true;
    
    [self.emailSeparatorView.leftAnchor constraintEqualToAnchor:self.inputContainerView.leftAnchor].active = true;
    [self.emailSeparatorView.topAnchor constraintEqualToAnchor:self.emailTextField.bottomAnchor].active = true;
    [self.emailSeparatorView.widthAnchor constraintEqualToAnchor:self.inputContainerView.widthAnchor].active = true;
    [self.emailSeparatorView.heightAnchor constraintEqualToConstant:1.0f].active = true;
    
    [self.passwordTextField.leftAnchor constraintEqualToAnchor:self.inputContainerView.leftAnchor constant:12].active = true;
    [self.passwordTextField.topAnchor constraintEqualToAnchor:self.emailSeparatorView.bottomAnchor].active = true;
    [self.passwordTextField.widthAnchor constraintEqualToAnchor:self.inputContainerView.widthAnchor].active = true;
    self.passwordTextFieldHeightAnchor = [self.passwordTextField.heightAnchor constraintEqualToAnchor:self.inputContainerView.heightAnchor multiplier:(CGFloat)1/3];
    self.passwordTextFieldHeightAnchor.active = true;

    [self.passwordSeparatorView.leftAnchor constraintEqualToAnchor:self.inputContainerView.leftAnchor].active = true;
    [self.passwordSeparatorView.topAnchor constraintEqualToAnchor:self.passwordTextField.bottomAnchor].active = true;
    [self.passwordSeparatorView.widthAnchor constraintEqualToAnchor:self.inputContainerView.widthAnchor].active = true;
    [self.passwordSeparatorView.heightAnchor constraintEqualToConstant:1.0f].active = true;    
}

- (void)setupLoginRegisterButton{
    [[self.loginRegisterButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:true];
    [[self.loginRegisterButton.topAnchor constraintEqualToAnchor:self.inputContainerView.bottomAnchor constant:12] setActive:true];
    [[self.loginRegisterButton.widthAnchor constraintEqualToAnchor:self.inputContainerView.widthAnchor] setActive:true];
    [[self.loginRegisterButton.heightAnchor constraintEqualToConstant:50] setActive:true];
}

- (void)setupProfileImageView{
    [self.profileImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [self.profileImageView.bottomAnchor constraintEqualToAnchor:self.loginRegisterSegmentedControl.topAnchor constant:-10].active = true;
    [self.profileImageView.widthAnchor constraintEqualToConstant:100].active = true;
    [self.profileImageView.heightAnchor constraintEqualToConstant:100].active = true;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
