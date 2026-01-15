package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.EnthrallManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import game.GameManager;
   import room.model.RoomInfo;
   
   public class ExpTotalItem extends Sprite implements Disposeable
   {
      
      public var value:Number;
      
      private var _expTxt:Bitmap;
      
      private var _exploitTxt:Bitmap;
      
      private var _expNumTxt:ExpTotalNums;
      
      private var _exploitNumTxt:ExpTotalNums;
      
      private var _bg:Bitmap;
      
      private var _bitmap:Bitmap;
      
      private var _speed:Number;
      
      private var _enthrallBit:Bitmap;
      
      public function ExpTotalItem()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._speed = 0.05;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewTotalBg");
         this._bitmap = ComponentFactory.Instance.creatBitmap("asset.experience.rightViewTotalTxt");
         this._enthrallBit = ComponentFactory.Instance.creatBitmap("asset.core.EnthrallIcon");
         this._expTxt = ComponentFactory.Instance.creatBitmap("asset.experience.TotalExpTxt");
         if(GameManager.Instance.Current.roomType != RoomInfo.MATCH_ROOM && GameManager.Instance.Current.roomType != RoomInfo.CHALLENGE_ROOM && GameManager.Instance.Current.roomType != RoomInfo.ENCOUNTER_ROOM)
         {
            this._expTxt.y += 17;
         }
         else
         {
            this._exploitTxt = ComponentFactory.Instance.creatBitmap("asset.experience.TotalExploitTxt");
         }
         PositionUtils.setPos(this,"experience.RightViewTotalPos");
         addChild(this._bg);
         addChild(this._bitmap);
         addChild(this._expTxt);
         if(Boolean(this._exploitTxt))
         {
            addChild(this._exploitTxt);
         }
      }
      
      private function addExploitTxt() : void
      {
         this._exploitNumTxt = new ExpTotalNums(ExpTotalNums.EXPLOIT);
         PositionUtils.setPos(this._exploitNumTxt,"experience.TotalItemNumTxtPos");
         this._exploitNumTxt.maxValue = 200000;
         this._exploitNumTxt.y += 34;
         addChild(this._exploitNumTxt);
      }
      
      protected function addTxt() : void
      {
         this._expNumTxt = new ExpTotalNums(ExpTotalNums.EXPERIENCE);
         PositionUtils.setPos(this._expNumTxt,"experience.TotalItemNumTxtPos");
         this._expNumTxt.maxValue = 200000;
         if(GameManager.Instance.Current.roomType != RoomInfo.MATCH_ROOM && GameManager.Instance.Current.roomType != RoomInfo.CHALLENGE_ROOM && GameManager.Instance.Current.roomType != RoomInfo.ENCOUNTER_ROOM)
         {
            this._expNumTxt.y += 17;
         }
         addChild(this._expNumTxt);
         if(EnthrallManager.getInstance().isEnthrall && TimeManager.Instance.totalGameTime >= EnthrallManager.STATE_3)
         {
            addChild(this._enthrallBit);
         }
      }
      
      public function playGreenLight() : void
      {
         if(this._exploitNumTxt != null)
         {
            this._exploitNumTxt.playLight();
            SoundManager.instance.play("146");
         }
      }
      
      public function playRedLight() : void
      {
         if(this._expNumTxt != null)
         {
            this._expNumTxt.playLight();
            SoundManager.instance.play("146");
         }
      }
      
      public function updateTotalExp(newValue:Number) : void
      {
         if(this._expNumTxt == null)
         {
            this.addTxt();
         }
         this._expNumTxt.setValue(newValue);
      }
      
      public function updateTotalExploit(newValue:Number) : void
      {
         if(GameManager.Instance.Current && GameManager.Instance.Current.roomType != RoomInfo.MATCH_ROOM && GameManager.Instance.Current.roomType != RoomInfo.CHALLENGE_ROOM)
         {
            return;
         }
         if(!this._exploitNumTxt)
         {
            this.addExploitTxt();
         }
         this._exploitNumTxt.setValue(newValue);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._expTxt))
         {
            ObjectUtils.disposeObject(this._expTxt);
            this._expTxt = null;
         }
         if(Boolean(this._exploitTxt))
         {
            ObjectUtils.disposeObject(this._exploitTxt);
            this._exploitTxt = null;
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._bitmap))
         {
            ObjectUtils.disposeObject(this._bitmap);
            this._bitmap = null;
         }
         if(Boolean(this._expNumTxt))
         {
            this._expNumTxt.dispose();
            this._expNumTxt = null;
         }
         if(Boolean(this._exploitNumTxt))
         {
            this._exploitNumTxt.dispose();
            this._exploitNumTxt = null;
         }
         if(Boolean(this._enthrallBit))
         {
            ObjectUtils.disposeObject(this._enthrallBit);
         }
         this._enthrallBit = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

