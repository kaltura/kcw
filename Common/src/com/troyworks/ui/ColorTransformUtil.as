/**
*   AS3.0 port of http://www.robertpenner.com/scripts/color_extensions.txt,
* that mimics the Flash Properties > Color  IDE. Useful for applying a style on stage
* and then turning that into code, and tweening it to those values.
*
* There are a few different ways to use it:
*
* 1) Statically
*   a) for those with absolute values
*     var ct:ColorTransform =  ColorTransformUtil.getTintTransform(r,g,b);
*   b) relative to existing values
*     var ct:ColorTransform =  ColorTransformUtil.getTintTransformFor(clip, r,g,b);
*   c) relative to existing transform
*     var ct:ColorTransform =  ColorTransformUtil.getTintTransformFrom(colorTransform, r,g,b);
*
*  2) as a wrapper that keeps relative to original (
*    var colUtil:ColorTransformUtil = new ColorTransformUtil(displayObj);
*    colUtil.setRgb(0x444444);
*
*
*
*
*
* Note you can always clone ColorTranforms from items on the IDE too.
*
*  new Features 12/02/07,
*  - ability to get the transform in order to tween it using TweenLite,
*  - relative color offsets (for brightness) to control clips already tinted.
*
*               // SAMPLE1:
                 import com.troyworks.ui.ColorTransformUtil;
                 import flash.display.DisplayObject;
                 var cui3:ColorTransformUtil = new ColorTransformUtil(d);
                 cui3.setBrightOffsetRelative(20); //increase brightness by 20%, -20 is relative
               
                 SAMPLE2:
                import gs.TweenLite;
                import com.troyworks.ui.ColorTransformUtil;
                import fl.transitions.easing.*;

                var cui4:ColorTransformUtil = new ColorTransformUtil(photo);


                //pass color transform instead of number
                var ct:ColorTransform = cui4.getBrightOffsetRelativeTransform(90);
                TweenLite.to(photo, 4, {mccolor:ct, ease:Elastic.easeOut});
               
        For reference these are the default values for ColorTransform
        //redMultiplier:Number = 1.0, greenMultiplier:Number = 1.0, blueMultiplier:Number = 1.0, alphaMultiplier:Number = 1.0, redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0

*   ORIGINAL COMMENT:
*       Lots of fun with colors. Read the comments and
*    figure out how to use the code. Look up the Color
*    object in the Actionscript Dictionary if
*    necessary (or just do it anyway). =]  Enjoy.
*                             -- Robert Penner
*                                www.robertpenner.com
*                                June 2001
*                                                              
* @author Robert Penner, Troy Gardner, Brandyn Hall
* @version 0.1
*/

package com.troyworks.ui {
        import flash.display.DisplayObject;
        import flash.geom.ColorTransform;

        public class ColorTransformUtil {
                private var _view:DisplayObject;
                private var _trans:ColorTransform;
               
                public function ColorTransformUtil(spriteToWrap:DisplayObject) {
                                _view = spriteToWrap;
                                _trans = _view.transform.colorTransform;
                }

                public static function getTintTransform(r:Number, g:Number, b:Number, amount:Number) :ColorTransform{
                        var trans:ColorTransform = new ColorTransform();
                        trans.redMultiplier = trans.greenMultiplier = trans.blueMultiplier = 1 - amount/100;
                        var ratio:Number = amount / 100;
                        trans.redOffset = r * ratio;
                        trans.greenOffset = g * ratio;
                        trans.blueOffset = b * ratio;
                        return trans;
                }
                // tint an object with a color just like Effect panel
                // r, g, b between 0 and 255; amount between 0 and 100
                public function setTint (r:Number, g:Number, b:Number, amount:Number) :ColorTransform{
                        var trans:ColorTransform = getTintTransform(r,g,b,amount);
                        _view.transform.colorTransform = trans;
                        return trans;
                } // Robert Penner June 2001 - www.robertpenner.com

               
                public static function getBrightnessTransform(bright:Number = 0):ColorTransform{
                        var offset:Number = 0;
                        if(bright > 0) offset = 256 * (bright / 100);
                        //if brightness is dark, offset is 0
                        var trans:ColorTransform = new ColorTransform();
                        trans.redMultiplier = trans.greenMultiplier = trans.blueMultiplier = 1 - (Math.abs(bright)/100);
                        trans.redOffset= trans.greenOffset = trans.blueOffset = offset;
                        return trans;
                }
                // brighten an object just like Effect panel
                // bright between -100 and 100
                // offset is -255 to 255, normally 0
                // multiple, normally1 1
                public function setBrightness (bright:Number = 0):ColorTransform{
                        var trans:ColorTransform = getBrightnessTransform(bright);
                        _view.transform.colorTransform = trans;
                        return trans;
                } //rp


                        // push an object's colors around - interesting fx
                // r, g, b between -255 and 255
                public static function getTintOffsetTransform (r:Number, g:Number, b:Number) :ColorTransform {
                //      var trans = {rb:r, gb:g, bb:b};
                        var trans:ColorTransform = new ColorTransform();
                        trans.redOffset =r;
                        trans.greenOffset =g;
                        trans.blueOffset =b;
                        return trans;
                } //rp
               
                // push an object's colors around - interesting fx
                // r, g, b between -255 and 255
                public function setTintOffset (r:Number, g:Number, b:Number) :ColorTransform {
                        var trans:ColorTransform = getTintOffsetTransform(r,g,b);
                        _view.transform.colorTransform = trans;
                        return trans;
                } //rp


                // push an object's brightness around - fx like eneri.net
                // offset between -255 and 255
                //
                // SAMPLE:
                // import com.troyworks.ui.ColorTransformUtil;
                // var cui3:ColorTransformUtil = new ColorTransformUtil(d);
                // cui3.setBrightnessOffsetRelative(20); //increase brightness by 20, -20 is relative
                //
                public function getBrightnessOffsetRelativeTransform(offset:Number) :ColorTransform {
                        var trans:ColorTransform = new ColorTransform();
                        trans.redOffset = _trans.redOffset + offset;
                        trans.greenOffset = _trans.greenOffset + offset;
                        trans.blueOffset = _trans.blueOffset + offset;
                        return trans;
                }
                public function setBrightnessOffsetRelative (offset:Number) :ColorTransform {
                        var trans:ColorTransform = getBrightnessOffsetRelativeTransform(offset);
                        _view.transform.colorTransform = trans;
                        return trans;
                } //rp + tg


                public function getResetTransform (clean:Boolean = false):ColorTransform{
                        var trans:ColorTransform = (clean)?new ColorTransform(1,1,1,1,0,0,0,0): _trans;
                        return trans;
                }
                // reset the color object to normal
                //updated to AS3.0 by tg to revert to default optional default color
                public function reset (clean:Boolean = false):ColorTransform{
                        var trans:ColorTransform = getResetTransform(clean);
                        _view.transform.colorTransform = trans;
                        return trans;
                } //rp

        /*      public static function getNegativizeTransformFor (dO:DisplayObject, clean:Boolean = false):ColorTransform{
                         var trans:ColorTransform = (clean)?new ColorTransform(-1, -1, -1, 1, 255, 255, 255,0): new ColorTransform(-1 * dO.transform.c.redMultiplier, -1* _trans.greenMultiplier, -1* _trans.blueMultiplier, 1, 255, 255, 255,0);
                        return trans;
                }*/
                public function getNegativizeTransform (clean:Boolean = false):ColorTransform{
                         var trans:ColorTransform = (clean)?new ColorTransform(-1, -1, -1, 1, 255, 255, 255,0): new ColorTransform(-1 * _trans.redMultiplier, -1* _trans.greenMultiplier, -1* _trans.blueMultiplier, 1, 255, 255, 255,0);
                        return trans;
                }
                // create a negative image - invert all colors
                public function negativize (clean:Boolean = false):ColorTransform  {
                        var trans:ColorTransform = getNegativizeTransform(clean);
                        _view.transform.colorTransform = trans;
                        return trans;
                } //rp


                // set red, green, and blue with normal numbers
                // r, g, b between 0 and 255
                //updated to AS3.0 by tg
                public static function getRGBTransform (r:Number, g:Number, b:Number):ColorTransform{
                        var trans:ColorTransform = new ColorTransform();
                        trans.color = r << 16 | g << 8 | b;
                        return trans;
                }

                public function setRGB (r:Number, g:Number, b:Number):ColorTransform {
                        var trans:ColorTransform = getRGBTransform(r, g, b);
                        _view.transform.colorTransform = trans;
                        return trans;
                } // Branden Hall - www.figleaf.com
        }
       
}

