package drgnBoat.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   import vip.VipController;
   
   public class DrgnBoatNameCell extends Sprite implements Disposeable
   {
      
      private var _selectedLight:Bitmap;
      
      private var _sprite:Sprite;
      
      private var _levelIcon:LevelIcon;
      
      private var _vipName:GradientText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _isVIP:Boolean;
      
      private var _name:String;
      
      private var _level:int;
      
      private var _index:int;
      
      public function DrgnBoatNameCell(i:int)
      {
         super();
         this._index = i;
         this.initView();
         this.addEvents();
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      private function initView() : void
      {
         this._selectedLight = ComponentFactory.Instance.creat("drgnBoat.missile.selectedLight");
         this._selectedLight.visible = false;
         this._sprite = new Sprite();
         this._sprite.graphics.beginFill(0,0);
         this._sprite.graphics.drawRect(0,0,this._selectedLight.width,this._selectedLight.height);
         this._sprite.graphics.endFill();
         this._sprite.x = this._selectedLight.x;
         this._sprite.y = this._selectedLight.y;
         addChild(this._sprite);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.missileFrame.nameTxt");
         this._nameTxt.text = "小妹也带刀";
         addChild(this._nameTxt);
         this._levelIcon = new LevelIcon();
         this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
         addChild(this._levelIcon);
         addChild(this._selectedLight);
      }
      
      public function setData(name:String, level:int = 25, isVIP:Boolean = true) : void
      {
         this._name = name;
         this._level = level;
         this._isVIP = isVIP;
         this.addNickName();
         this._levelIcon.setInfo(this._level,0,0,0,0,0,false,false);
      }
      
      private function addNickName() : void
      {
         var textFormat:TextFormat = null;
         if(Boolean(this._vipName))
         {
            this._vipName.dispose();
            this._vipName = null;
         }
         this._nameTxt.visible = !this._isVIP;
         if(this._isVIP)
         {
            this._vipName = VipController.instance.getVipNameTxt(1,1);
            textFormat = new TextFormat();
            textFormat.align = "center";
            textFormat.bold = true;
            this._vipName.textField.defaultTextFormat = textFormat;
            this._vipName.textSize = 16;
            this._vipName.textField.width = this._nameTxt.width;
            this._vipName.x = this._nameTxt.x;
            this._vipName.y = this._nameTxt.y;
            this._vipName.text = this._name;
            addChild(this._vipName);
         }
         else
         {
            this._nameTxt.text = this._name;
         }
      }
      
      public function set selected(flag:Boolean) : void
      {
         this._selectedLight.visible = flag;
      }
      
      public function get selected() : Boolean
      {
         return this._selectedLight.visible;
      }
      
      private function addEvents() : void
      {
      }
      
      private function removeEvents() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._selectedLight);
         this._selectedLight = null;
         ObjectUtils.disposeObject(this._sprite);
         this._sprite = null;
         ObjectUtils.disposeObject(this._levelIcon);
         this._levelIcon = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
      }
   }
}

