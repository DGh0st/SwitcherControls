#import "headers.h"

@implementation ControlCenterMediaSectionView
-(id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self setTintColor:[UIColor whiteColor]];
		mediaViewController = [[%c(MPUControlCenterMediaControlsViewController) alloc] initWithNibName:nil bundle:nil];
		[mediaViewController _initControlCenterMediaControlsViewController];
		[mediaViewController setDelegate:self];
		MPUControlCenterMediaControlsView *controlsView = [mediaViewController _mediaControlsView];
		controlsView.frame = CGRectMake(0, 0, frame.size.width * 2 + 10, frame.size.height);
		[controlsView setLayoutStyle:1];

		[self setLayoutInterpolatorWithValues:20 secondValue:20 firstMetric:300 secondMetric:360 forKey:@"_marginLayoutInterpolator"];
		[self setLayoutInterpolatorWithValues:frame.size.height secondValue:frame.size.height firstMetric:300 secondMetric:340 forKey:@"_contentSizeInterpolator"];
		[self setLayoutInterpolatorWithValues:20 secondValue:20 firstMetric:552 secondMetric:600 forKey:@"_landscapeMarginLayoutInterpolator"];
		[self setLayoutInterpolatorWithValues:frame.size.height / 3 secondValue:frame.size.height / 3 firstMetric:300 secondMetric:360 forKey:@"_artworkNormalContentSizeLayoutInterpolator"];
		[self setLayoutInterpolatorWithValues:frame.size.height / 3 secondValue:frame.size.height / 3 firstMetric:300 secondMetric:360 forKey:@"_artworkLargeContentSizeLayoutInterpolator"];
		[self setLayoutInterpolatorWithValues:frame.size.height / 3 secondValue:frame.size.height / 3 firstMetric:552 secondMetric:600 forKey:@"_artworkLandscapePhoneLayoutInterpolator"];
		[self setLayoutInterpolatorWithValues:0 secondValue:7 firstMetric:568 secondMetric:667 forKey:@"_labelsLeadingHeightPhoneLayoutInterpolator"];
		[self setLayoutInterpolatorWithValues:MAX(frame.size.width / 3, 152) secondValue:MAX(frame.size.width / 3, 152) firstMetric:256 secondMetric:300 forKey:@"_transportControlsWidthStandardLayoutInterpolator"];
		
		MPULayoutInterpolator *_transportControlsWidthCompactLayoutInterpolator = [%c(MPULayoutInterpolator) new];
		[_transportControlsWidthCompactLayoutInterpolator addValue:MAX(frame.size.width / 3, 152) forReferenceMetric:360];
		[controlsView setValue:_transportControlsWidthCompactLayoutInterpolator forKey:@"_transportControlsWidthCompactLayoutInterpolator"];
		[_transportControlsWidthCompactLayoutInterpolator release];

		[self addSubview:controlsView];
	}
	return self;
}

-(void)setupRoutingPageWithFrame:(CGRect)frame {
	routingPageFrame = frame;
}

-(void)dealloc {
	[mediaViewController release];
	[super dealloc];
}

-(void)setLayoutInterpolatorWithValues:(CGFloat)firstValue secondValue:(CGFloat)secondValue firstMetric:(CGFloat)firstMetric secondMetric:(CGFloat)secondMetric forKey:(NSString *)key {
	MPULayoutInterpolator *interpolator = [%c(MPULayoutInterpolator) new];
	[interpolator addValue:firstValue forReferenceMetric:firstMetric];
	[interpolator addValue:secondValue forReferenceMetric:secondMetric];
	[[mediaViewController _mediaControlsView] setValue:interpolator forKey:key];
	[interpolator release];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	if (CGRectContainsPoint(self.frame, point) || CGRectContainsPoint(routingPageFrame, point))
		return YES;
	return [super pointInside:point withEvent:event];
}
@end

%hook MPUControlCenterMediaControlsView
%new
-(void)setupLabelsIfNeeded {
	MPUControlCenterMetadataView* _titleLabel = MSHookIvar<MPUControlCenterMetadataView *>(self, "_titleLabel");
	MPUControlCenterMetadataView* _artistLabel = MSHookIvar<MPUControlCenterMetadataView *>(self, "_artistLabel");
	MPUControlCenterMetadataView* _albumLabel = MSHookIvar<MPUControlCenterMetadataView *>(self, "_albumLabel");
	MPUControlCenterMetadataView* _artistAlbumConcatenatedLabel = MSHookIvar<MPUControlCenterMetadataView *>(self, "_artistAlbumConcatenatedLabel");

	if (_titleLabel != nil) {
		_titleLabel.numberOfLines = 1;
		_titleLabel.marqueeEnabled = YES;
		[_titleLabel layoutSubviews];
	}

	if (_artistLabel != nil) {
		_artistLabel.hidden = YES;
		[_artistLabel layoutSubviews];
	}

	if (_albumLabel != nil) {
		_albumLabel.hidden = YES;
		[_albumLabel layoutSubviews];
	}

	if (_artistAlbumConcatenatedLabel != nil) {
		_artistAlbumConcatenatedLabel.numberOfLines = 1;
		_artistAlbumConcatenatedLabel.marqueeEnabled = YES;
		_artistAlbumConcatenatedLabel.hidden = _titleLabel.hidden;
		[_artistAlbumConcatenatedLabel layoutSubviews];
	}
}

-(void)_reloadNowPlayingInfoLabels {
	%orig();

	if ([self superview] != nil && [[[self superview] class] isEqual:[ControlCenterMediaSectionView class]]) {
		[self setupLabelsIfNeeded];
		[self layoutSubviews];
	}
}

-(void)layoutSubviews {
	if ([self superview] != nil && [[[self superview] class] isEqual:[ControlCenterMediaSectionView class]]) {
		[self setupLabelsIfNeeded];

		%orig();

		MPUNowPlayingArtworkView* _artworkView = [self artworkView];
		MPUControlCenterMetadataView* _titleLabel = MSHookIvar<MPUControlCenterMetadataView *>(self, "_titleLabel");
		MPUControlCenterMetadataView* _artistLabel = MSHookIvar<MPUControlCenterMetadataView *>(self, "_artistLabel");
		MPUControlCenterMetadataView* _albumLabel = MSHookIvar<MPUControlCenterMetadataView *>(self, "_albumLabel");
		MPUControlCenterMetadataView* _artistAlbumConcatenatedLabel = MSHookIvar<MPUControlCenterMetadataView *>(self, "_artistAlbumConcatenatedLabel");

		CGFloat parentHeight = [self superview].frame.size.height;
		#define twoSectionHeight 152
		#define threeSectionHeight 226

		if (_artworkView != nil && [self superview] != nil) {
			CGRect frame = _artworkView.frame;
			frame.size = CGSizeMake(parentHeight / 3, parentHeight / 3);
			_artworkView.frame = frame;
			[_artworkView layoutSubviews];
		}

		if (_titleLabel != nil) {
			CGRect frame = _titleLabel.frame;
			if (_artworkView != nil)
				frame.origin.y = _artworkView.frame.size.height - frame.size.height - 1;
			_titleLabel.frame = frame;
			[_titleLabel layoutSubviews];
		}
		
		if (_artistLabel != nil) {
			[_artistLabel removeFromSuperview];
			[_artistLabel layoutSubviews];
		}

		if (_albumLabel != nil) {
			[_albumLabel removeFromSuperview];
			[_albumLabel layoutSubviews];
		}

		if (_artistAlbumConcatenatedLabel != nil) {
			CGRect frame = CGRectMake(89, 0, 250, 24);
			if (_titleLabel != nil) {
				frame = _titleLabel.frame;
				frame.origin.y -= frame.size.height + 1;
			}
			_artistAlbumConcatenatedLabel.frame = frame;
			UILabel *_label = MSHookIvar<UILabel *>(_artistAlbumConcatenatedLabel, "_label");
			if ([SCPreferences sharedInstance].blurStyle == UIBlurEffectStyleExtraLight)
				[_label setTextColor:[UIColor blackColor]];
			else
				[_label setTintColor:[UIColor whiteColor]];
			[_artistAlbumConcatenatedLabel layoutSubviews];
		}

		MPUTransportControlsView* _transportControls = [self transportControls];
		MPUControlCenterTimeView *_timeView = [self timeView];
		MPUMediaControlsVolumeView *_volumeView = [self volumeView];

		if (_transportControls != nil) {
			MPUEmptyNowPlayingView *_emptyNowPlayingView = [self emptyNowPlayingView];
			if (_emptyNowPlayingView != nil && !_emptyNowPlayingView.hidden) {
				CGRect frame = _transportControls.frame;
				if (parentHeight <= twoSectionHeight)
					frame.origin.y = 60;
				else if (parentHeight <= threeSectionHeight)
					frame.origin.y = 97;
				_transportControls.frame = frame;
			} else if (_timeView != nil && !_timeView.hidden) {
				CGRect frame = _transportControls.frame;
				if (_timeView.alwaysLive) {
					if (parentHeight <= twoSectionHeight)
						frame.origin.y = 63;
					else if (parentHeight <= threeSectionHeight)
						frame.origin.y = 100;
				} else {
					if (parentHeight <= twoSectionHeight)
						frame.origin.y = 70;
				}
				_transportControls.frame = frame;
			}
			[_transportControls layoutSubviews];
		}

		if (_timeView != nil) {
			CGRect frame = _timeView.frame;
			if (parentHeight <= twoSectionHeight)
				frame.origin.y = 50;
			else if (parentHeight <= threeSectionHeight)
				frame.origin.y = 87;
			_timeView.frame = frame;
			[_timeView layoutSubviews];

			if (_volumeView != nil && !_timeView.hidden && !_timeView.alwaysLive) {
				CGRect frame = _volumeView.frame;
				if (parentHeight <= twoSectionHeight)
					frame.origin.y = 105;
				_volumeView.frame = frame;
				[_volumeView layoutSubviews];
			}
		}
	} else {
		%orig();
	}
}

-(void)setNowPlayingMetadata:(id)arg1 {
	%orig(arg1);

	[self _reloadNowPlayingInfoLabels];
}
%end