//
//  CityDetailViewController.m
//  CitiesTestTask
//
//  Created by Daniil Novoselov on 19.03.17.
//  Copyright © 2017 Daniil Novoselov. All rights reserved.
//

#import "CityDetailViewController.h"

@interface CityDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *foundationDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation CityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpMainAppereance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    _aboutTextView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)setUpMainAppereance {
    if (_city) {
        _aboutTextView.scrollEnabled = NO;
        _titleLabel.text = _city.title;
        if (_city.area) {
            _areaLabel.text = _city.area;
        } else {
            [_areaLabel removeFromSuperview];
        }
        if (_city.region) {
            _regionLabel.text = _city.region;
        } else {
            [_regionLabel removeFromSuperview];
        }
        if (_city.foundationDate) {
            NSString *dateString =[NSDateFormatter localizedStringFromDate:_city.foundationDate
                                                                 dateStyle:NSDateFormatterShortStyle
                                                                 timeStyle:NSDateFormatterNoStyle];
            _foundationDateLabel.text = [NSString stringWithFormat:@"Дата основания: %@", dateString];
        } else {
            [_foundationDateLabel removeFromSuperview];
        }
        if (_city.about) {
            _aboutTextView.text = _city.about;
        } else if ([_city.title isEqualToString:@"Москва"]) {
            _aboutTextView.text = [self cityMoscowDescriptionString];
        } else {
            _aboutTextView.text = nil;
            _aboutTextView.userInteractionEnabled = NO;
        }
        if (_city.areaImageURL) {
            [_imgView setImage:[self getImageWithURL:_city.areaImageURL]];
        }
    }
}

- (UIImage *)getImageWithURL:(NSURL *)url {
    //TODO
    return nil;
}

- (NSString *)cityMoscowDescriptionString {
    return @"Столица Российской Федерации, город федерального значения, административный центр Центрального федерального округа и центр Московской области, в состав которой не входит. Крупнейший по численности населения город России и её субъект — 12 380 664[2] чел. (2017), самый населённый из городов, полностью расположенных в Европе, входит в первую десятку городов мира по численности населения[5]. Центр Московской городской агломерации.\n\nИсторическая столица Великого княжества Московского, Русского царства, Российской империи (в 1728—1730 годах), Советской России и СССР. Город-герой. В Москве находятся федеральные органы государственной власти Российской Федерации (за исключением Конституционного суда), посольства иностранных государств, штаб-квартиры большинства крупнейших российских коммерческих организаций и общественных объединений.\n\nРасположена на реке Москве в центре Восточно-Европейской равнины, в междуречье Оки и Волги. Как субъект федерации Москва граничит с Московской и Калужской областями.\n\nМосква — важный туристический центр России. Московский Кремль, Красная площадь, Новодевичий монастырь и Церковь Вознесения в Коломенском входят в список Всемирного наследия ЮНЕСКО[6]. Она является важнейшим транспортным узлом. Город обслуживают 5 аэропортов, 9 железнодорожных вокзалов, 3 речных порта (имеется речное сообщение с морями бассейнов Атлантического и Северного Ледовитого океанов). С 1935 года в Москве работает метрополитен.";
}

@end
