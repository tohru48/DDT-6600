package totem.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemLeftWindowOpenCartoonView extends Sprite implements Disposeable
   {
      
      private var _pointBomb:MovieClip;
      
      private var _lightBomb:MovieClip;
      
      private var _failPointBomb:MovieClip;
      
      private var _failTipTxtBitmap:Bitmap;
      
      private var _moveLightList:Vector.<MovieClip>;
      
      private var _openUsedNextPointInfo:TotemDataVo;
      
      private var _openUsedCallback:Function;
      
      private var _failOpenNextPointInfo:TotemDataVo;
      
      private var _failOpenCallback:Function;
      
      private var _totemPointLocationList:Array;
      
      private var __refreshGlowFilter:Function;
      
      private var __refreshTotemPoint:Function;
      
      private var _addTxt:FilterFrameText;
      
      private var _propertyTxtList:Array;
      
      private var _failBombCount:int;
      
      private var _bombCount:int;
      
      private var _moveTxtCount:int;
      
      private var _moveTxtEndCallbackTag:int;
      
      private var _moveLightCount:int;
      
      public function TotemLeftWindowOpenCartoonView(totemPointLocationList:Array, refreshGlowFilter:Function, refreshTotemPoint:Function)
      {
         super();
         this._totemPointLocationList = totemPointLocationList;
         this.__refreshGlowFilter = refreshGlowFilter;
         this.__refreshTotemPoint = refreshTotemPoint;
         this._pointBomb = ComponentFactory.Instance.creat("asset.totem.open.pointBomb");
         this._lightBomb = ComponentFactory.Instance.creat("asset.totem.open.lightBomb");
         this._pointBomb.gotoAndStop(2);
         this._lightBomb.gotoAndStop(2);
         this._failPointBomb = ComponentFactory.Instance.creat("asset.totem.failOpen.pointBomb");
         this._failPointBomb.gotoAndStop(2);
         this._failTipTxtBitmap = ComponentFactory.Instance.creatBitmap("asset.totem.failOpen.tipTxt");
         this._addTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemOpenCartoon.moveTxt");
         this._addTxt.alpha = 0;
         this._propertyTxtList = LanguageMgr.GetTranslation("ddt.totem.sevenProperty").split(",");
      }
      
      public function failRefreshView(nextPointInfo:TotemDataVo, callback:Function = null) : void
      {
         this._failOpenNextPointInfo = nextPointInfo;
         this._failOpenCallback = callback;
         this.showFailOpenCartoon();
      }
      
      private function showFailOpenCartoon() : void
      {
         var locationPoint:Object = null;
         locationPoint = this._totemPointLocationList[this._failOpenNextPointInfo.Page - 1][this._failOpenNextPointInfo.Location - 1];
         this._lightBomb.gotoAndStop(1);
         this._failPointBomb.x = locationPoint.x;
         this._failPointBomb.y = locationPoint.y - 25;
         this._lightBomb.x = locationPoint.x;
         this._lightBomb.y = locationPoint.y + 17;
         addChild(this._lightBomb);
         this._failTipTxtBitmap.x = locationPoint.x - 26;
         this._failTipTxtBitmap.y = locationPoint.y - 15;
         this._failBombCount = 0;
         this._lightBomb.addEventListener(Event.ENTER_FRAME,this.lightBombFrameHandler,false,0,true);
      }
      
      private function lightBombFrameHandler(event:Event) : void
      {
         ++this._failBombCount;
         if(this._failBombCount == 8)
         {
            this._lightBomb.removeEventListener(Event.ENTER_FRAME,this.lightBombFrameHandler);
            this._lightBomb.gotoAndStop(2);
            removeChild(this._lightBomb);
            this._failPointBomb.gotoAndStop(1);
            addChild(this._failPointBomb);
            this._failBombCount = 0;
            this._failPointBomb.addEventListener(Event.ENTER_FRAME,this.pointBombFrameHandler,false,0,true);
         }
      }
      
      private function pointBombFrameHandler(event:Event) : void
      {
         ++this._failBombCount;
         if(this._failBombCount == 6)
         {
            addChild(this._failTipTxtBitmap);
            TweenLite.to(this._failTipTxtBitmap,0.6,{
               "y":this._failTipTxtBitmap.y - 56,
               "onComplete":this.moveFailTxtCompleteHandler
            });
         }
         else if(this._failBombCount == 14)
         {
            if(Boolean(this._failPointBomb))
            {
               this._failPointBomb.removeEventListener(Event.ENTER_FRAME,this.pointBombFrameHandler);
               this._failPointBomb.gotoAndStop(2);
               removeChild(this._failPointBomb);
            }
         }
      }
      
      private function moveFailTxtCompleteHandler() : void
      {
         if(Boolean(this._failTipTxtBitmap))
         {
            removeChild(this._failTipTxtBitmap);
         }
         if(this._failOpenCallback != null)
         {
            this._failOpenCallback();
            this._failOpenCallback = null;
         }
         this._failOpenNextPointInfo = null;
      }
      
      public function refreshView(nextPointInfo:TotemDataVo, callback:Function = null) : void
      {
         this._openUsedNextPointInfo = nextPointInfo;
         this._openUsedCallback = callback;
         this.showOpenCartoon();
      }
      
      private function showOpenCartoon() : void
      {
         var page:int = 0;
         var location:int = 0;
         if(!this._openUsedNextPointInfo)
         {
            page = 5;
            location = 7;
         }
         else if(this._openUsedNextPointInfo.Location == 1)
         {
            if(this._openUsedNextPointInfo.Layers == 1)
            {
               page = this._openUsedNextPointInfo.Page - 1;
            }
            else
            {
               page = this._openUsedNextPointInfo.Page;
            }
            location = 7;
         }
         else
         {
            page = this._openUsedNextPointInfo.Page;
            location = this._openUsedNextPointInfo.Location - 1;
         }
         this.addTotemPointCartoon(this._totemPointLocationList[page - 1][location - 1]);
      }
      
      private function addTotemPointCartoon(locationPoint:Object) : void
      {
         this._pointBomb.gotoAndStop(1);
         this._lightBomb.gotoAndStop(1);
         this._pointBomb.x = locationPoint.x;
         this._pointBomb.y = locationPoint.y - 25;
         this._lightBomb.x = locationPoint.x;
         this._lightBomb.y = locationPoint.y + 17;
         addChild(this._lightBomb);
         addChild(this._pointBomb);
         this._addTxt.x = locationPoint.x - 26;
         this._addTxt.y = locationPoint.y - 15;
         this._bombCount = 0;
         this._pointBomb.addEventListener(Event.ENTER_FRAME,this.bombFrameHandler,false,0,true);
      }
      
      private function bombFrameHandler(event:Event) : void
      {
         ++this._bombCount;
         if(this._bombCount == 8)
         {
            this._lightBomb.gotoAndStop(2);
            removeChild(this._lightBomb);
         }
         if(this._bombCount == 24)
         {
            this._pointBomb.removeEventListener(Event.ENTER_FRAME,this.bombFrameHandler);
            this._pointBomb.gotoAndStop(2);
            removeChild(this._pointBomb);
            this._moveTxtEndCallbackTag = 0;
            if(Boolean(this._openUsedNextPointInfo) && this._openUsedNextPointInfo.Location != 1)
            {
               this.__refreshGlowFilter(this._openUsedNextPointInfo.Page,this._openUsedNextPointInfo);
               this.showMoveLigthCartoon();
            }
            else if(this._openUsedNextPointInfo && this._openUsedNextPointInfo.Page != 1 && this._openUsedNextPointInfo.Layers == 1 && this._openUsedNextPointInfo.Location == 1)
            {
               this._moveTxtEndCallbackTag = 1;
            }
            else
            {
               this._moveTxtEndCallbackTag = 2;
            }
            this.showMoveTxt();
         }
      }
      
      private function showMoveTxt() : void
      {
         var tmp:int = 0;
         if(Boolean(this._openUsedNextPointInfo))
         {
            tmp = this._openUsedNextPointInfo.Point - 1;
         }
         else
         {
            tmp = 350;
         }
         var tmpDataVo:TotemDataVo = TotemManager.instance.getCurInfoByLevel(tmp);
         this._addTxt.text = this._propertyTxtList[tmpDataVo.Location - 1] + " +" + tmpDataVo.addValue;
         this._moveTxtCount = 0;
         this._addTxt.addEventListener(Event.ENTER_FRAME,this.moveTxtHandler,false,0,true);
         addChild(this._addTxt);
      }
      
      private function moveTxtHandler(event:Event) : void
      {
         var page:int = 0;
         ++this._moveTxtCount;
         if(this._moveTxtCount >= 0 && this._moveTxtCount <= 8)
         {
            this._addTxt.y -= 4;
            this._addTxt.alpha += 1 / 8;
         }
         else if(this._moveTxtCount > 8 && this._moveTxtCount <= 16)
         {
            this._addTxt.alpha = 1;
         }
         else if(this._moveTxtCount > 16 && this._moveTxtCount < 22)
         {
            this._addTxt.y -= 6;
            this._addTxt.alpha -= 1 / 5;
         }
         else if(this._moveTxtCount >= 22)
         {
            this._addTxt.removeEventListener(Event.ENTER_FRAME,this.moveTxtHandler);
            this._addTxt.alpha = 0;
            if(this._moveTxtEndCallbackTag == 1)
            {
               this._openUsedNextPointInfo = null;
               if(this._openUsedCallback != null)
               {
                  this._openUsedCallback.apply();
               }
               this._openUsedCallback = null;
            }
            else if(this._moveTxtEndCallbackTag == 2)
            {
               if(!this._openUsedNextPointInfo)
               {
                  page = 5;
               }
               else
               {
                  page = this._openUsedNextPointInfo.Page;
               }
               this.__refreshTotemPoint(page,this._openUsedNextPointInfo,true);
               this._openUsedNextPointInfo = null;
            }
         }
      }
      
      private function showMoveLigthCartoon() : void
      {
         var tmpArray:Array = this._totemPointLocationList[this._openUsedNextPointInfo.Page - 1];
         var forward:Object = tmpArray[this._openUsedNextPointInfo.Location - 2];
         var next:Object = tmpArray[this._openUsedNextPointInfo.Location - 1];
         var tmpY:Number = next.y - forward.y;
         var tmpX:Number = next.x - forward.x;
         var tmp:Number = tmpY / tmpX;
         var rotation:Number = 0;
         if(next.x == forward.x)
         {
            if(next.y > forward.y)
            {
               rotation = 90;
            }
            else
            {
               rotation = -90;
            }
         }
         else if(next.x < forward.x)
         {
            if(next.y > forward.y)
            {
               rotation = Math.atan(tmp) * (180 / Math.PI) + 180;
            }
            else
            {
               rotation = Math.atan(tmp) * (180 / Math.PI) - 180;
            }
         }
         else
         {
            rotation = Math.atan(tmp) * (180 / Math.PI);
         }
         var distance:Number = Math.pow(Math.pow(tmpY,2) + Math.pow(tmpX,2),1 / 2);
         var rest:Number = distance % 89.2;
         var count:int = distance / 89.2;
         if(rest > 10)
         {
            count += 1;
         }
         this._moveLightList = new Vector.<MovieClip>();
         this.createMoveLight(forward.x,forward.y,rotation);
         if(count >= 2)
         {
            this.createMoveLight((distance - 89.2) / distance * tmpX + forward.x,(distance - 89.2) / distance * tmpY + forward.y,rotation);
         }
         for(var i:int = 1; i < count - 1; i++)
         {
            this.createMoveLight(89.2 * i / distance * tmpX + forward.x,89.2 * i / distance * tmpY + forward.y,rotation);
         }
         this._moveLightCount = 0;
         this._moveLightList[0].addEventListener(Event.ENTER_FRAME,this.moveLightFrameHandler,false,0,true);
      }
      
      private function createMoveLight(x:Number, y:Number, rotation:Number) : void
      {
         var mc:MovieClip = null;
         mc = ClassUtils.CreatInstance("asset.totem.open.moveLight");
         mc.gotoAndStop(1);
         mc.x = x;
         mc.y = y;
         mc.rotation = rotation;
         addChild(mc);
         this._moveLightList.push(mc);
      }
      
      private function moveLightFrameHandler(event:Event) : void
      {
         var tmp:MovieClip = null;
         ++this._moveLightCount;
         if(this._moveLightCount == 22)
         {
            this._moveLightList[0].removeEventListener(Event.ENTER_FRAME,this.moveLightFrameHandler);
            for each(tmp in this._moveLightList)
            {
               tmp.gotoAndStop(2);
               if(Boolean(tmp.parent))
               {
                  tmp.parent.removeChild(tmp);
               }
            }
            this._moveLightList = null;
            this.__refreshTotemPoint(this._openUsedNextPointInfo.Page,this._openUsedNextPointInfo,true);
            this._openUsedNextPointInfo = null;
         }
      }
      
      public function dispose() : void
      {
         var tmp4:MovieClip = null;
         if(Boolean(this._moveLightList) && this._moveLightList.length > 0)
         {
            this._moveLightList[0].removeEventListener(Event.ENTER_FRAME,this.moveLightFrameHandler);
            for each(tmp4 in this._moveLightList)
            {
               tmp4.gotoAndStop(2);
               if(Boolean(tmp4.parent))
               {
                  tmp4.parent.removeChild(tmp4);
               }
            }
         }
         this._moveLightList = null;
         if(Boolean(this._pointBomb))
         {
            this._pointBomb.removeEventListener(Event.ENTER_FRAME,this.bombFrameHandler);
            this._pointBomb.gotoAndStop(2);
         }
         this._pointBomb = null;
         if(Boolean(this._lightBomb))
         {
            this._lightBomb.removeEventListener(Event.ENTER_FRAME,this.lightBombFrameHandler);
            this._lightBomb.gotoAndStop(2);
         }
         this._lightBomb = null;
         this._openUsedNextPointInfo = null;
         this._openUsedCallback = null;
         this._totemPointLocationList = null;
         this.__refreshGlowFilter = null;
         this.__refreshTotemPoint = null;
         if(Boolean(this._addTxt))
         {
            this._addTxt.removeEventListener(Event.ENTER_FRAME,this.moveTxtHandler);
            ObjectUtils.disposeObject(this._addTxt);
         }
         this._addTxt = null;
         if(Boolean(this._failPointBomb))
         {
            this._failPointBomb.removeEventListener(Event.ENTER_FRAME,this.pointBombFrameHandler);
            this._failPointBomb.gotoAndStop(2);
            if(Boolean(this._failPointBomb.parent))
            {
               this._failPointBomb.parent.removeChild(this._failPointBomb);
            }
         }
         this._failPointBomb = null;
         if(Boolean(this._failTipTxtBitmap))
         {
            TweenLite.killTweensOf(this._failTipTxtBitmap,true);
            if(Boolean(this._failTipTxtBitmap.parent))
            {
               this._failTipTxtBitmap.parent.removeChild(this._failTipTxtBitmap);
            }
         }
         this._failTipTxtBitmap = null;
         this._failOpenNextPointInfo = null;
         this._failOpenCallback = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

