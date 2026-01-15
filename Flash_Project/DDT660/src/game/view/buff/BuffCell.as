package game.view.buff
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.BuffType;
   import ddt.data.FightBuffInfo;
   import ddt.data.FightContainerBuff;
   import ddt.display.BitmapLoaderProxy;
   import ddt.display.BitmapObject;
   import ddt.display.BitmapSprite;
   import ddt.manager.BitmapManager;
   import ddt.manager.PathManager;
   import ddt.view.tips.PropTxtTipInfo;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class BuffCell extends BitmapSprite implements ITipedDisplay
   {
      
      private var _info:FightBuffInfo;
      
      private var _bitmapMgr:BitmapManager;
      
      private var _tipData:PropTxtTipInfo = new PropTxtTipInfo();
      
      private var _txt:FilterFrameText;
      
      private var _loaderProxy:BitmapLoaderProxy;
      
      private var _buffAnimation:MovieClip;
      
      public function BuffCell(bitmap:BitmapObject = null, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false)
      {
         super(bitmap,matrix,false,true);
         this._bitmapMgr = BitmapManager.getBitmapMgr("GameView");
         this._tipData = new PropTxtTipInfo();
         this._tipData.color = 15790320;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("game.petskillBuff.numTxt");
         addChild(this._txt);
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(Boolean(this._loaderProxy))
         {
            this._loaderProxy.dispose();
         }
         this._loaderProxy = null;
         this._info = null;
         this._tipData = null;
         this._bitmapMgr.dispose();
         this._bitmapMgr = null;
         this._info = null;
         this.deleteBuffAnimation();
         super.dispose();
      }
      
      private function deleteBuffAnimation() : void
      {
         if(Boolean(this._buffAnimation))
         {
            this.removeChild(this._buffAnimation);
            this._buffAnimation = null;
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function clearSelf() : void
      {
         ShowTipManager.Instance.removeTip(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         if(Boolean(this._loaderProxy))
         {
            this._loaderProxy.dispose();
         }
         this._loaderProxy = null;
         bitmapObject = null;
         this._info = null;
         this.deleteBuffAnimation();
      }
      
      public function setInfo(val:FightBuffInfo) : void
      {
         if(Boolean(this._loaderProxy))
         {
            this._loaderProxy.dispose();
         }
         this._loaderProxy = null;
         bitmapObject = null;
         this.deleteBuffAnimation();
         this._info = val;
         this._tipData.property = this._info.buffName;
         this._tipData.detail = this._info.description;
         if(BuffType.isContainerBuff(this._info))
         {
            if(this._info.type == BuffType.Pay)
            {
               bitmapObject = this._bitmapMgr.getBitmap("asset.core.payBuffAsset");
            }
            else if(this._info.type == BuffType.CONSORTIA)
            {
               bitmapObject = this._bitmapMgr.getBitmap("asset.game.buffConsortia");
            }
            else
            {
               bitmapObject = this._bitmapMgr.getBitmap("asset.game.buffCard");
            }
         }
         else if(val.type == BuffType.PET_BUFF)
         {
            this._loaderProxy = new BitmapLoaderProxy(PathManager.solvePetBuff(val.buffPic),new Rectangle(0,0,32 / this.scaleX,32 / this.scaleY));
            addChild(this._loaderProxy);
            ShowTipManager.Instance.addTip(this);
         }
         else if(BuffType.isActivityDunBuff(this._info))
         {
            this._buffAnimation = ComponentFactory.Instance.creat("asset.game.buff" + this._info.displayid);
            addChild(this._buffAnimation);
         }
         else
         {
            bitmapObject = this._bitmapMgr.getBitmap("asset.game.buff" + this._info.displayid);
         }
         if(this._info.displayid == 99)
         {
         }
         if(this._info.Count > 1)
         {
            addChild(this._txt);
            this._txt.text = this._info.Count.toString();
         }
         else if(contains(this._txt))
         {
            removeChild(this._txt);
         }
         if(BuffType.isLocalBuffByID(this._info.id) || BuffType.isContainerBuff(this._info))
         {
            ShowTipManager.Instance.addTip(this);
         }
      }
      
      public function get tipData() : Object
      {
         if(BuffType.isContainerBuff(this._info))
         {
            return FightContainerBuff(this._info).tipData;
         }
         return this._tipData;
      }
      
      public function set tipData(value:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "7,6,5,1,6,4";
      }
      
      public function set tipDirctions(value:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 6;
      }
      
      public function set tipGapH(value:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 6;
      }
      
      public function set tipGapV(value:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         if(BuffType.isContainerBuff(this._info))
         {
            return "core.PayBuffTip";
         }
         return "core.FightBuffTip";
      }
      
      public function set tipStyle(value:String) : void
      {
      }
   }
}

