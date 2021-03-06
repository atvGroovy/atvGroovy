/**
 * This header is generated by class-dump-z 0.2a.
 * class-dump-z is Copyright (C) 2009 by KennyTM~, licensed under GPLv3.
 *
 * Source: /System/Library/PrivateFrameworks/BackRow.framework/BackRow
 */

#import "BackRow-Structs.h"
#import "BRControl.h"

@class BRProviderGroup;

@interface BRGridControl : BRControl {
@private
	BRProviderGroup *_group;	// 40 = 0x28
	BRControl *_requester;	// 44 = 0x2c
	NSRange _range;	// 48 = 0x30
	float _lastGapHeight;	// 56 = 0x38
	double _heightToRange;	// 60 = 0x3c
	double _allRowsHeight;	// 68 = 0x44
	float _singleControlHeight;	// 76 = 0x4c
	BOOL _allRowsAreSameHeight;	// 80 = 0x50
	float _allColumnWidths;	// 84 = 0x54
	long _columnCount;	// 88 = 0x58
	float _horizontalGap;	// 92 = 0x5c
	float _verticalGap;	// 96 = 0x60
	float _leftMargin;	// 100 = 0x64
	float _rightMargin;	// 104 = 0x68
	float _bottomMargin;	// 108 = 0x6c
	float _bottomMarginFactor;	// 112 = 0x70
	float _topMargin;	// 116 = 0x74
	float _topMarginFactor;	// 120 = 0x78
	BOOL _wrapsNavigation;	// 124 = 0x7c
	BOOL _explicitlyAcceptsFocus;	// 125 = 0x7d
}
@property(assign) BOOL allRowsAreSameHeight;	// G=0x3166ea71; S=0x3166ea61; converted property
@property(assign) long columnCount;	// G=0x315b0059; S=0x315af82d; converted property
@property(assign) float horizontalGap;	// G=0x3166e9f1; S=0x315af7a1; converted property
@property(assign) float leftMargin;	// G=0x3166ea01; S=0x3166ee75; converted property
@property(retain) id providerRequester;	// G=0x3166ea31; S=0x3166ea21; converted property
@property(retain) id providers;	// G=0x3166ef11; S=0x3166ef31; converted property
@property(assign) float rightMargin;	// G=0x3166ea11; S=0x3166ee25; converted property
@property(assign) float verticalGap;	// G=0x315b03e5; S=0x315af7e1; converted property
@property(assign) BOOL wrapsNavigation;	// G=0x3166ea51; S=0x3166ea41; converted property
- (id)init;	// 0x315af6c9
- (id)_controlAtIndex:(long)index controls:(id)controls;	// 0x31670ed1
- (long)_controlsInHeight:(double)height startingAt:(long)at actualHeight:(double *)height3;	// 0x31670091
- (long)_controlsInHeightBackwards:(double)heightBackwards startingAt:(long)at actualHeight:(double *)height;	// 0x3167016d
- (id)_controlsInRange:(NSRange)range;	// 0x316709e5
- (id)_createControlsInRange:(NSRange)range;	// 0x3166f8b1
- (CGRect)_frameForControlAtIndex:(long)index controls:(id)controls;	// 0x31670751
- (CGRect)_frameForControlAtIndex:(long)index rowFrame:(CGRect)frame controls:(id)controls;	// 0x3166f715
- (void)_frameRowInRange:(NSRange)range rowFrame:(CGRect)frame controls:(id)controls;	// 0x316708ad
- (float)_heightOfControlAtIndex:(long)index controls:(id)controls;	// 0x3166f545
- (double)_heightOfRowsInRange:(NSRange)range includeVerticalGap:(BOOL)gap controls:(id)controls;	// 0x3166ffdd
- (double)_heightToRange;	// 0x3166fee5
- (float)_horizontalGapValue;	// 0x3166f66d
- (long)_indexOfFocusedControl;	// 0x3166eb89
- (float)_positionOfColumn:(long)column inRowWidth:(float)rowWidth cellWidth:(float *)width;	// 0x3166f7c1
- (void)_providerDataSetChanged:(id)changed;	// 0x3166eb25
- (void)_providerModified:(id)modified;	// 0x3166f979
- (float)_rowHeightForControlsInRange:(NSRange)range controls:(id)controls;	// 0x31670935
- (void)_sceneBoundsChanged:(id)changed;	// 0x3166ea81
- (id)_setControlRange:(NSRange)range withHeightToRange:(double)range2;	// 0x31670f41
- (double)_totalHeight;	// 0x3166fde1
- (void)_updateControlsInRange:(NSRange)range controls:(id)controls;	// 0x3166f0bd
- (float)_verticalGapValue;	// 0x3166f6c1
// converted property getter: - (BOOL)allRowsAreSameHeight;	// 0x3166ea71
- (BOOL)brEventAction:(id)action;	// 0x3166ec99
// converted property getter: - (long)columnCount;	// 0x315b0059
- (BOOL)controlAcceptsFocusAtIndex:(long)index;	// 0x3166ec45
- (CGRect)controlFocusFrameAtIndex:(long)index;	// 0x3166f1b5
- (CGRect)controlFrameAtIndex:(long)index;	// 0x3166f269
- (long)dataCount;	// 0x3166eef1
- (void)dealloc;	// 0x315b3b91
- (void)focusControlAtIndex:(long)index;	// 0x31670db9
- (id)focusedControlForEvent:(id)event focusPoint:(CGPoint *)point;	// 0x31670bb5
- (float)heightOfControlAtIndex:(long)index;	// 0x3166edb5
- (float)heightToMaximum:(float)maximum;	// 0x3166fa95
// converted property getter: - (float)horizontalGap;	// 0x3166e9f1
- (id)initialFocus;	// 0x3166fb61
- (void)layoutSubcontrols;	// 0x3167022d
// converted property getter: - (float)leftMargin;	// 0x3166ea01
- (float)positionOfColumn:(long)column;	// 0x3166f509
// converted property getter: - (id)providerRequester;	// 0x3166ea31
// converted property getter: - (id)providers;	// 0x3166ef11
- (void)reloadData;	// 0x3166fc31
// converted property getter: - (float)rightMargin;	// 0x3166ea11
- (long)rowCount;	// 0x315b0069
- (void)setAcceptsFocus:(BOOL)focus;	// 0x3166ebd9
- (void)setAllColumnWidths:(float)widths;	// 0x3166e9e1
// converted property setter: - (void)setAllRowsAreSameHeight:(BOOL)height;	// 0x3166ea61
- (void)setBottomMargin:(float)margin;	// 0x3166f495
// converted property setter: - (void)setColumnCount:(long)count;	// 0x315af82d
// converted property setter: - (void)setHorizontalGap:(float)gap;	// 0x315af7a1
// converted property setter: - (void)setLeftMargin:(float)margin;	// 0x3166ee75
- (void)setProvider:(id)provider;	// 0x315b0025
// converted property setter: - (void)setProviderRequester:(id)requester;	// 0x3166ea21
// converted property setter: - (void)setProviders:(id)providers;	// 0x3166ef31
// converted property setter: - (void)setRightMargin:(float)margin;	// 0x3166ee25
- (void)setTopMargin:(float)margin;	// 0x3166f421
// converted property setter: - (void)setVerticalGap:(float)gap;	// 0x315af7e1
- (void)setVerticalMargins:(float)margins;	// 0x3166eec5
// converted property setter: - (void)setWrapsNavigation:(BOOL)navigation;	// 0x3166ea41
- (CGSize)sizeThatFits:(CGSize)fits;	// 0x3166f341
// converted property getter: - (float)verticalGap;	// 0x315b03e5
- (id)visibleControlAtIndex:(long)index;	// 0x31670b71
- (id)visibleControlsWithRange:(NSRange *)range;	// 0x3166ede5
- (void)visibleScrollRectChanged;	// 0x3166ec85
// converted property getter: - (BOOL)wrapsNavigation;	// 0x3166ea51
@end

