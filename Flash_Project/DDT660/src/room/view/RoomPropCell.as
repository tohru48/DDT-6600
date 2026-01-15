package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import horse.HorseManager;
   import horse.view.HorseSkillCell;
   
   public class RoomPropCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _container:HorseSkillCell;
      
      private var _skillId:int;
      
      private var _isself:Boolean;
      
      private var _place:int;
      
      private var _xyz:FilterFrameText;
      
      public function RoomPropCell(isself:Boolean, place:int, isHorse:Boolean = false)
      {
         this._isself = isself;
         this._place = place;
         if(this._isself)
         {
            if(isHorse)
            {
               this._bg = ComponentFactory.Instance.creatBitmap("asset.horse.skillFrame.selfCellBgAsset");
               this._xyz = ComponentFactory.Instance.creatComponentByStylename("horse.skillFrame.cellZXC");
            }
            else
            {
               this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.selfCellBgAsset");
               this._xyz = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.cellZXC");
            }
            switch(place)
            {
               case 0:
                  this._xyz.text = "z";
                  break;
               case 1:
                  this._xyz.text = "x";
                  break;
               case 2:
                  this._xyz.text = "c";
            }
            addChild(this._bg);
            addChild(this._xyz);
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.storeCellBgAsset");
            addChild(this._bg);
         }
         super();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function set skillId(skillId:int) : void
      {
         if(Boolean(this._container))
         {
            ObjectUtils.disposeObject(this._container);
            this._container = null;
         }
         buttonMode = false;
         this._skillId = skillId;
         if(this._skillId == 0)
         {
            return;
         }
         buttonMode = true;
         this._container = new HorseSkillCell(this._skillId,false,true);
         this._container.x = -3;
         this._container.y = -3;
         addChild(this._container);
      }
      
      private function __mouseClick(evt:MouseEvent) : void
      {
         var tmpPlace:int = 0;
         if(this._skillId == 0)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this._isself)
         {
            SocketManager.Instance.out.sendHorseTakeUpDownSkill(this._skillId,0);
         }
         else
         {
            if(HorseManager.instance.isSkillHasEquip(this._skillId))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.skillCannotEquipSame"));
               return;
            }
            tmpPlace = HorseManager.instance.takeUpSkillPlace;
            if(tmpPlace == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("horse.skillEquipMax"));
               return;
            }
            SocketManager.Instance.out.sendHorseTakeUpDownSkill(this._skillId,tmpPlace);
         }
      }
      
      private function __mouseOver(evt:MouseEvent) : void
      {
      }
      
      private function __mouseOut(evt:MouseEvent) : void
      {
      }
      
      override public function get width() : Number
      {
         return 40;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._xyz))
         {
            ObjectUtils.disposeObject(this._xyz);
         }
         this._xyz = null;
         if(Boolean(this._container))
         {
            this._container.dispose();
         }
         this._container = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

