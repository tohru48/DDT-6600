package totem.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TotemLeftWindowTotemCell extends Sprite implements Disposeable
   {
      
      public var level:int;
      
      public var index:int;
      
      public var isCurCanClick:Boolean;
      
      public var isHasLighted:Boolean;
      
      private var _halo:MovieClip;
      
      private var _bgIconSprite:Sprite;
      
      private var _ligthCross:MovieClip;
      
      public function TotemLeftWindowTotemCell(bg:Bitmap, icon:Bitmap)
      {
         super();
         this.mouseEnabled = false;
         this._bgIconSprite = new Sprite();
         icon.x = bg.x + 22;
         icon.y = bg.y + 3;
         this._bgIconSprite.addChild(bg);
         this._bgIconSprite.addChild(icon);
         addChild(this._bgIconSprite);
         this._halo = ComponentFactory.Instance.creat("asset.totem.totemPointHalo");
         this._halo.gotoAndStop(1);
         this._halo.x = 46;
         this._halo.y = 78;
         this._halo.scaleX = 0.8;
         this._halo.scaleY = 0.8;
         this._halo.mouseChildren = false;
         this._halo.mouseEnabled = false;
         this._halo.alpha = 0.2;
         this._halo.mc.gotoAndStop(1);
         addChildAt(this._halo,0);
         this._ligthCross = ComponentFactory.Instance.creat("asset.totem.lightCross");
         this._ligthCross.gotoAndStop(1);
         this._ligthCross.alpha = 0;
         this._ligthCross.x = 44;
         this._ligthCross.y = 78;
         this._ligthCross.mouseChildren = false;
         this._ligthCross.mouseEnabled = false;
         this._ligthCross.scaleX = 1.6;
         this._ligthCross.scaleY = 2;
         addChild(this._ligthCross);
      }
      
      public function showLigthCross() : void
      {
         if(Boolean(this._ligthCross))
         {
            TweenLite.to(this._ligthCross,0.5,{"alpha":1});
         }
      }
      
      public function hideLigthCross() : void
      {
         if(Boolean(this._ligthCross))
         {
            TweenLite.to(this._ligthCross,0.5,{"alpha":0});
         }
      }
      
      public function get bgIconWidth() : Number
      {
         return this._bgIconSprite.width;
      }
      
      public function setBgIconSpriteFilter(filter:Array) : void
      {
         this._bgIconSprite.filters = filter;
      }
      
      public function dimOutHalo() : void
      {
         if(Boolean(this._halo))
         {
            TweenLite.to(this._halo,0.5,{
               "alpha":0.2,
               "scaleX":0.8,
               "scaleY":0.8,
               "onComplete":this.dimOutHaloCompleteHandler
            });
         }
      }
      
      private function dimOutHaloCompleteHandler() : void
      {
         if(Boolean(this._halo))
         {
            this._halo.mc.gotoAndStop(1);
         }
      }
      
      public function brightenHalo() : void
      {
         if(Boolean(this._halo))
         {
            TweenLite.to(this._halo,0.5,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1,
               "onComplete":this.brightenHaloCompleteHandler
            });
         }
      }
      
      private function brightenHaloCompleteHandler() : void
      {
         if(Boolean(this._halo))
         {
            this._halo.mc.gotoAndPlay(1);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._halo))
         {
            this._halo.gotoAndStop(2);
            if(Boolean(this._halo.parent))
            {
               this._halo.parent.removeChild(this._halo);
            }
            this._halo = null;
         }
         if(Boolean(this._ligthCross))
         {
            this._ligthCross.gotoAndStop(2);
            if(Boolean(this._ligthCross.parent))
            {
               this._ligthCross.parent.removeChild(this._ligthCross);
            }
            this._ligthCross = null;
         }
      }
   }
}

