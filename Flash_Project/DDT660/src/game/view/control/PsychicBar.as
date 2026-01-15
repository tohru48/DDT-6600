package game.view.control
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.utils.PositionUtils;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.model.LocalPlayer;
   import game.objects.SimpleBox;
   
   public class PsychicBar extends Sprite implements Disposeable
   {
      
      private var _self:LocalPlayer;
      
      private var _back:DisplayObject;
      
      private var _localPsychic:int;
      
      private var _numField:PsychicShape;
      
      private var _movie:MovieClip;
      
      private var _ghostBoxCenter:Point;
      
      private var _ghostBitmapPool:Object = new Object();
      
      private var _mouseArea:MouseArea;
      
      public function PsychicBar(self:LocalPlayer)
      {
         this._self = self;
         super();
         this.configUI();
         mouseEnabled = false;
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmap("asset.game.PsychicBar.back");
         addChild(this._back);
         this._ghostBoxCenter = new Point((this._back.width >> 1) - 20,(this._back.height >> 1) - 20);
         this._movie = ClassUtils.CreatInstance("asset.game.PsychicBar.movie");
         this._movie.mouseEnabled = false;
         this._movie.mouseChildren = false;
         PositionUtils.setPos(this._movie,"PsychicBar.MoviePos");
         addChild(this._movie);
         this._numField = new PsychicShape();
         this._numField.setNum(this._self.psychic);
         this._numField.x = this._back.width - this._numField.width >> 1;
         this._numField.y = this._back.height - this._numField.height >> 1;
         addChild(this._numField);
         this._mouseArea = new MouseArea(48);
         addChild(this._mouseArea);
      }
      
      private function addEvent() : void
      {
         this._self.addEventListener(LivingEvent.PSYCHIC_CHANGED,this.__psychicChanged);
         this._self.addEventListener(LivingEvent.BOX_PICK,this.__pickBox);
      }
      
      private function boxTweenComplete(box:DisplayObject) : void
      {
         ObjectUtils.disposeObject(box);
      }
      
      private function __pickBox(event:LivingEvent) : void
      {
         var ghostBox:Shape = null;
         var bounds:Rectangle = null;
         var box:SimpleBox = event.paras[0] as SimpleBox;
         if(box.isGhost)
         {
            ghostBox = this.getGhostShape(box.subType);
            addChild(ghostBox);
            bounds = box.getBounds(this);
            ghostBox.x = bounds.x;
            ghostBox.y = bounds.y;
            TweenLite.to(ghostBox,0.3 + 0.3 * Math.random(),{
               "x":this._ghostBoxCenter.x,
               "y":this._ghostBoxCenter.y,
               "onComplete":this.boxTweenComplete,
               "onCompleteParams":[ghostBox]
            });
         }
      }
      
      private function __psychicChanged(event:LivingEvent) : void
      {
         this._numField.setNum(this._self.psychic);
         this._numField.x = this._back.width - this._numField.width >> 1;
         this._mouseArea.setPsychic(this._self.psychic);
      }
      
      private function removeEvent() : void
      {
         this._self.removeEventListener(LivingEvent.PSYCHIC_CHANGED,this.__psychicChanged);
         this._self.removeEventListener(LivingEvent.BOX_PICK,this.__pickBox);
      }
      
      public function enter() : void
      {
         this.addEvent();
      }
      
      public function leaving() : void
      {
         this.removeEvent();
      }
      
      public function dispose() : void
      {
         var key:String = null;
         var bitmapData:BitmapData = null;
         this.removeEvent();
         TweenLite.killTweensOf(this);
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._numField);
         this._numField = null;
         ObjectUtils.disposeObject(this._mouseArea);
         this._mouseArea = null;
         if(Boolean(this._movie))
         {
            this._movie.stop();
            ObjectUtils.disposeObject(this._movie);
            this._movie = null;
         }
         this._self = null;
         for(key in this._ghostBitmapPool)
         {
            bitmapData = this._ghostBitmapPool[key] as BitmapData;
            if(Boolean(bitmapData))
            {
               bitmapData.dispose();
            }
            delete this._ghostBitmapPool[key];
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function getGhostShape(type:int) : Shape
      {
         var bitmapData:BitmapData = null;
         var ghastBox:MovieClip = null;
         var shape:Shape = new Shape();
         var name:String = "ghost" + type;
         if(this._ghostBitmapPool.hasOwnProperty(name))
         {
            bitmapData = this._ghostBitmapPool[name];
         }
         else
         {
            ghastBox = ClassUtils.CreatInstance("asset.game.GhostBox" + (type - 1)) as MovieClip;
            ghastBox.gotoAndStop("shot");
            bitmapData = new BitmapData(ghastBox.width,ghastBox.height,true,0);
            bitmapData.draw(ghastBox);
            this._ghostBitmapPool[name] = bitmapData;
         }
         var pen:Graphics = shape.graphics;
         pen.beginBitmapFill(bitmapData);
         pen.drawRect(0,0,bitmapData.width,bitmapData.height);
         pen.endFill();
         return shape;
      }
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.LayerManager;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.utils.ObjectUtils;
import ddt.display.BitmapShape;
import ddt.manager.BitmapManager;
import ddt.manager.LanguageMgr;
import ddt.view.tips.ChangeNumToolTip;
import ddt.view.tips.ChangeNumToolTipInfo;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import game.model.Player;

class PsychicShape extends Sprite implements Disposeable
{
   
   private var _nums:Vector.<BitmapShape> = new Vector.<BitmapShape>();
   
   private var _num:int = 0;
   
   private var _bitmapMgr:BitmapManager;
   
   public function PsychicShape()
   {
      super();
      this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
      mouseEnabled = false;
      mouseChildren = false;
      this.draw();
   }
   
   private function draw() : void
   {
      var num:BitmapShape = null;
      this.clear();
      var _numString:String = this._num.toString();
      var len:int = _numString.length;
      for(var i:int = 0; i < len; i++)
      {
         num = this._bitmapMgr.creatBitmapShape("asset.game.PsychicBar.Num" + _numString.substr(i,1));
         if(i > 0)
         {
            num.x = this._nums[i - 1].x + this._nums[i - 1].width;
         }
         addChild(num);
         this._nums.push(num);
      }
   }
   
   private function clear() : void
   {
      var num:BitmapShape = this._nums.shift();
      while(Boolean(num))
      {
         num.dispose();
         num = this._nums.shift();
      }
   }
   
   public function setNum(val:int) : void
   {
      if(this._num != val)
      {
         this._num = val;
         this.draw();
      }
   }
   
   public function dispose() : void
   {
      this.clear();
      ObjectUtils.disposeObject(this._bitmapMgr);
      this._bitmapMgr = null;
      if(Boolean(parent))
      {
         parent.removeChild(this);
      }
   }
}

class MouseArea extends Sprite implements Disposeable
{
   
   private var _tipData:String;
   
   private var _tipPanel:ChangeNumToolTip;
   
   private var _tipInfo:ChangeNumToolTipInfo;
   
   public function MouseArea(radius:int)
   {
      super();
      var pen:Graphics = graphics;
      pen.beginFill(0,0);
      pen.drawCircle(radius,radius,radius);
      pen.endFill();
      this.addTip();
      this.addEvent();
   }
   
   public function setPsychic(val:int) : void
   {
      this._tipInfo.current = val;
      this._tipPanel.tipData = this._tipInfo;
   }
   
   private function addEvent() : void
   {
      addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
      addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
   }
   
   private function removeEvent() : void
   {
      removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
      removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
   }
   
   public function dispose() : void
   {
      this.removeEvent();
      this.__mouseOut(null);
      ObjectUtils.disposeObject(this._tipPanel);
      this._tipPanel = null;
      if(Boolean(parent))
      {
         parent.removeChild(this);
      }
   }
   
   private function addTip() : void
   {
      this._tipPanel = new ChangeNumToolTip();
      this._tipInfo = new ChangeNumToolTipInfo();
      this._tipInfo.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.DanderStrip.currentTxt");
      this._tipInfo.title = LanguageMgr.GetTranslation("tank.game.PsychicBar.Title");
      this._tipInfo.current = 0;
      this._tipInfo.total = Player.MaxPsychic;
      this._tipInfo.content = LanguageMgr.GetTranslation("tank.game.PsychicBar.Content");
      this._tipPanel.tipData = this._tipInfo;
      this._tipPanel.mouseChildren = false;
      this._tipPanel.mouseEnabled = false;
   }
   
   private function __mouseOut(evt:MouseEvent) : void
   {
      if(Boolean(this._tipPanel) && Boolean(this._tipPanel.parent))
      {
         this._tipPanel.parent.removeChild(this._tipPanel);
      }
   }
   
   private function __mouseOver(evt:MouseEvent) : void
   {
      var bounds:Rectangle = null;
      bounds = getBounds(LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER));
      this._tipPanel.x = bounds.right;
      this._tipPanel.y = bounds.top - this._tipPanel.height;
      LayerManager.Instance.addToLayer(this._tipPanel,LayerManager.STAGE_TOP_LAYER,false);
   }
}
