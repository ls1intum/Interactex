/*
 * TangoFramework
 *
 * Copyright (c) 2012 Juan Haladjian
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <Foundation/Foundation.h>

#import "TFConstants.h"
#import "TFMethodSelectionPopup.h"
#import "TFPalette.h"
#import "TFTabbarViewController.h"
#import "TFTabbarSection.h"
#import "TFProject.h"
#import "TFPaletteViewController.h"

#import "TFDragView.h"
#import "TFTabbarView.h"
#import "TFDirector.h"

#import "TFEditor.h"
#import "TFSimulator.h"

#import "TFFileUtils.h"
#import "TFEditableObject.h"
#import "TFSimulableObject.h"

#import "TFProperty.h"
#import "TFMethod.h"
#import "TFEvent.h"
#import "TFPropertyInvocation.h"

#import "TFEditableObjectProperties.h"
#import "TFExtension.h"
#import "TFHelper.h"

#import "TFConnectionLine.h"
#import "TFProjectDelegate.h"

#import "TFMethodInvokeAction.h"

#import "TFEventActionPair.h"

#import "TFPaletteItem.h"
#import "TFCustomPaletteItem.h"
#import "TFImagePickerController.h"

#import "TFPropertiesViewController.h"
