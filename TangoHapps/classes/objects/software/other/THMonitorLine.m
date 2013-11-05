/*
 THMonitorLine.m
 Interactex Designer
 
 Created by Juan Haladjian on 05/11/2013.
 
 Interactex Designer is a configuration tool to easily setup, simulate and connect e-Textile hardware with smartphone functionality. Interactex Client is an app to store and replay projects made with Interactex Designer.
 
 www.interactex.org
 
 Copyright (C) 2013 TU Munich, Munich, Germany; DRLab, University of the Arts Berlin, Berlin, Germany; Telekom Innovation Laboratories, Berlin, Germany
 
 Contacts:
 juan.haladjian@cs.tum.edu
 katharina.bredies@udk-berlin.de
 opensource@telekom.de
 
 
 The first version of the software was designed and implemented as part of "Wearable M2M", a joint project of UdK Berlin and TU Munich, which was founded by Telekom Innovation Laboratories Berlin. It has been extended with funding from EIT ICT, as part of the activity "Connected Textiles".
 
 Interactex is built using the Tango framework developed by TU Munich.
 
 In the Interactex software, we use the GHUnit (a test framework for iOS developed by Gabriel Handford) and cocos2D libraries (a framework for building 2D games and graphical applications developed by Zynga Inc.).
 www.cocos2d-iphone.org
 github.com/gabriel/gh-unit
 
 Interactex also implements the Firmata protocol. Its software serial library is based on the original Arduino Firmata library.
 www.firmata.org
 
 All hardware part graphics in Interactex Designer are reproduced with kind permission from Fritzing. Fritzing is an open-source hardware initiative to support designers, artists, researchers and hobbyists to work creatively with interactive electronics.
 www.frizting.org
 
 
 This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "THMonitorLine.h"

@implementation THMonitorLine

float const kMonitorLeftBorder = -1.0f;
float const kMonitorPixelsToSeconds = 3.0f / 50.0f;

-(id) initWithColor:(GLKVector4) aColor{
    
    self = [super init];
    
    if(self){
        
        self.color = aColor;
        
        _effect = [[GLKBaseEffect alloc] init];
        
        self.effect.useConstantColor = YES;
        self.effect.constantColor = self.color;
        
        verticesStart = 4;

        memset(vertices, 0, sizeof(GLKVector3) * kMonitorVerticesLength);
    }
    return self;
}

-(void) addPointWithX:(float) x y:(float) y z:(float) z{
    if(numVertices < kMonitorVerticesLength){
        //NSLog(@"adds %f %f %f",x,y,z);
        NSInteger currentIdx = (verticesStart + numVertices) % kMonitorVerticesLength;
        
        vertices[currentIdx].x = x;
        vertices[currentIdx].y = y;
        vertices[currentIdx].z = z;
        
        numVertices++;
    }
}

-(void) removeAllPoints{
    
}

-(void) render{
    
    if(numVertices > 1){
        
        [self.effect prepareToDraw];
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        
        if(verticesStart + numVertices < kMonitorVerticesLength){
            
            glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices + verticesStart);
            
        } else{
            
            NSInteger lastPartLength = kMonitorVerticesLength - verticesStart;
            NSInteger firstPartLength = numVertices - lastPartLength;
            
            memcpy(verticesAux, vertices + verticesStart,  sizeof(GLKVector3) * lastPartLength);
            
            if(firstPartLength > 0){
                memcpy(verticesAux + lastPartLength, vertices, sizeof(GLKVector3) * firstPartLength);
            }
            
            glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, verticesAux);
        }
        
        glDrawArrays(GL_LINE_STRIP, 0, numVertices);
        
        glDisableVertexAttribArray(GLKVertexAttribPosition);
    }
}

-(NSInteger) moveVerticesLeftBy:(float) dx{
    
    NSInteger firstIdx = verticesStart;
    BOOL selectedFirstIdx = NO;
    
    for (int i = verticesStart; i < MIN(verticesStart + numVertices,kMonitorVerticesLength); i++) {
        vertices[i].x -= dx;
        
        if(!selectedFirstIdx && vertices[i].x > kMonitorLeftBorder){
            firstIdx = i;
            selectedFirstIdx = YES;
        }
    }
    
    if(verticesStart + numVertices >= kMonitorVerticesLength){
        for (int i = 0; i < numVertices - (kMonitorVerticesLength - verticesStart); i++) {
            vertices[i].x -= dx;
            if(!selectedFirstIdx && vertices[i].x > kMonitorLeftBorder){
                firstIdx = i;
                selectedFirstIdx = YES;
            }
        }
    }
    return firstIdx;
}

-(void) removeVerticesUntilIndex:(NSInteger) index{
    
    if(index > verticesStart){
        
        NSInteger removeAmount = index - verticesStart;
        
        verticesStart = index;
        
        numVertices -= removeAmount;
        
    } else if(index < verticesStart) {
        
        NSInteger removeAmount = (kMonitorVerticesLength - verticesStart) + index;
        
        verticesStart = index;
        
        numVertices -= removeAmount;
    }
}

-(void) update:(float) dt{
    
    float dx = dt * kMonitorPixelsToSeconds;

    NSInteger removeUntilIndex = [self moveVerticesLeftBy:dx];
    [self removeVerticesUntilIndex:removeUntilIndex];
    
    /*
    for (int i = 0; i < kMonitorVerticesLength; i++) {
        printf("(%.1f %.1f %.1f)  ",vertices[i].x,vertices[i].y,vertices[i].z);
    }
    printf("\n");*/
}

@end
